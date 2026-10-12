-- Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim and specify plugins
require("lazy").setup({
  -- 1. The Dracula Theme
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme dracula]])
    end,
  },
  -- 2. A beautiful, sleek statusline at the bottom
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = { theme = 'dracula', icons_enabled = true }
      })
    end
  }
})

-- Essential Editor Quality-of-Life Settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Great for quick code jumping
vim.opt.termguicolors = true   -- Enable full 24-bit RGB color support
vim.opt.mouse = 'a'            -- Allow mouse control inside Neovim
vim.opt.shiftwidth = 4         -- Auto-indent spacing
vim.opt.tabstop = 4            -- Tab key spacing




-- Explicitly force Neovim to use Kitty's background color
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local hl_groups = { "Normal", "NonText", "NormalNC", "SignColumn", "StatusLine" }
    for _, group in ipairs(hl_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
  end,
})
-- Trigger the override immediately
vim.cmd([[colorscheme dracula]])

