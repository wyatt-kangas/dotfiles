#!/usr/bin/env bash
# weekly-backup.sh - run as your normal user; it calls sudo for /etc.
#
# ONE-TIME PREP
#   sudo pacman -S --needed etckeeper git rsync
#   sudo etckeeper init && sudo etckeeper commit "initial"
#   Backup drive: ext4 or btrfs (NOT NTFS/exFAT, they drop Linux permissions),
#   mounted at /mnt/backup, then:
#     sudo mkdir -p /mnt/backup/backup && sudo chown "$USER": /mnt/backup/backup
#   Keep /etc/.git local: etckeeper tracks /etc/shadow, so never push it to a public remote.
set -euo pipefail

DRIVE="/mnt/backup"                 # mount point of the second drive
DEST="$DRIVE/backup"
LISTS="$HOME/.config/pkglists"      # inside /home (rsync copies it) and tracked by chezmoi (pushed offsite)
STAMP="$(date +%F)"

# Refuse to run if the drive isn't mounted (otherwise --delete writes onto your root drive)
mountpoint -q "$DRIVE" || { echo "ERROR: $DRIVE is not mounted" >&2; exit 1; }
sudo -v

# 1. Package lists
mkdir -p "$LISTS"
pacman -Qqen > "$LISTS/repo-packages.txt"    # explicitly installed, official repos
pacman -Qqem > "$LISTS/aur-packages.txt"     # explicitly installed, AUR/foreign
flatpak list --app --columns=application > "$LISTS/flatpak-apps.txt"

# 2. /etc history (pacman hooks commit around upgrades; this catches manual edits)
if sudo etckeeper unclean; then sudo etckeeper commit "weekly backup $STAMP"; fi

# 3. /home -> second drive. Files deleted or overwritten since the last run
#    are kept for 60 days in deleted/<date>/. Add other re-downloadable bulk to the excludes.
mkdir -p "$DEST/home" "$DEST/deleted"
rsync -aAX --delete --info=progress2,stats1 \
  --backup --backup-dir="$DEST/deleted/$STAMP" \
  --exclude='/.cache/' \
  --exclude='/.local/share/Trash/' \
  --exclude='/.local/share/Steam/steamapps/common/' \
  --exclude='/.local/share/Steam/steamapps/shadercache/' \
  "$HOME/" "$DEST/home/"
find "$DEST/deleted" -mindepth 1 -maxdepth 1 -type d -mtime +60 -exec rm -rf {} +

# 4. /etc -> second drive (includes etckeeper's /etc/.git)
sudo rsync -aAX --delete /etc/ "$DEST/etc/"

# 5. Dotfiles + package lists -> chezmoi repo -> remote (last, because it needs the network)
chezmoi add "$LISTS"/*.txt
chezmoi re-add   # copies edits made in ~ into the chezmoi source (skips templates).
                 # It overwrites the source with ~, so `chezmoi apply` any pending source edits first.
chezmoi git -- add -A
chezmoi git -- diff --cached --quiet || chezmoi git -- commit -m "weekly $STAMP"
chezmoi git -- push || echo "WARN: chezmoi push failed (network/remote?)" >&2

echo "Backup finished: $(date)"

# ---------------------------------------------------------------------------
# RESTORE ORDER (fresh Arch install, backup drive mounted at /mnt/backup)
#   Create the SAME username as on the old install (the home backup is stored under it).
#   L=/mnt/backup/backup/home/$USER/.config/pkglists
#
#   1. Restore pacman.conf first - it enables [multilib], which Steam and lib32-* need:
#        sudo cp -a /mnt/backup/backup/etc/pacman.conf /etc/pacman.conf && sudo pacman -Syu
#   2. sudo pacman -S --needed base-devel git rsync
#      sudo pacman -S --needed - < $L/repo-packages.txt
#   3. Build yay by hand:
#        git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
#        yay -S --needed $(< $L/aur-packages.txt)
#   4. Flatpak (assumes everything came from Flathub):
#        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#        flatpak install -y flathub $(< $L/flatpak-apps.txt)
#   5. As your user: rsync -aAX /mnt/backup/backup/home/$USER/ ~/
#   6. Services (installing packages does not enable them). Skim for disk-specific units, then:
#        sudo rsync -a /mnt/backup/backup/etc/systemd/system/ /etc/systemd/system/ && sudo systemctl daemon-reload
#   7. Remaining /etc bits - see what you changed over time, then cherry-pick:
#        sudo git -C /mnt/backup/backup/etc log --stat
#        diff -u /mnt/backup/backup/etc/<file> /etc/<file>
#      Do NOT copy fstab, crypttab or machine-id: they belong to the old install.
#      (Restoring from the repo with `git checkout` instead? Run `etckeeper init`
#      afterwards to reapply file permissions.)
#   8. Resume backups (real rebuild only): add the backup drive to /etc/fstab again, then
#        sudo etckeeper init && sudo etckeeper commit "restored"
#      and BEFORE the first weekly run move the old backup's /etc aside, because the
#      script's --delete would overwrite it (and its history):
#        sudo mv /mnt/backup/backup/etc /mnt/backup/backup/etc-old
#
#   Backup drive lost too? sudo pacman -S --needed git chezmoi, then
#        chezmoi init --apply <your-repo-url>
#   This restores dotfiles and ~/.config/pkglists (not personal files). Continue from
#   step 1 with L=~/.config/pkglists and skip the steps that read from the drive.
#
# TESTING THE RESTORE IN A VM (the empty VM is your "PC after total loss")
#   sudo pacman -S --needed qemu-desktop && qemu-img create -f qcow2 vm.qcow2 60G
#   qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 6G \
#     -drive file=vm.qcow2,if=virtio -cdrom archlinux-x86_64.iso -boot d \
#     -virtfs local,path=/mnt/backup,mount_tag=backup,security_model=none,readonly=on
#   In the VM run archinstall (same username, sudo, NetworkManager), reboot WITHOUT
#   -cdrom/-boot d, then mount the shared drive:
#     sudo mkdir -p /mnt/backup && sudo mount -t 9p -o trans=virtio,version=9p2000.L,ro backup /mnt/backup
#   Root-only files (e.g. etc/.git) show "permission denied" there; that is expected.
#   Skip step 8 in the VM. Check `du -sh /mnt/backup/backup/home/$USER` fits the VM disk,
#   or restore only ~/.config for the test.
