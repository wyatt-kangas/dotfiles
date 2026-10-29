--== Options
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Great for quick code jumping
vim.opt.termguicolors = true  -- Enable full 24-bit RGB color support
vim.opt.mouse = 'a'           -- Allow mouse control inside Neovim
vim.opt.shiftwidth = 4        -- Auto-indent spacing
vim.opt.tabstop = 4           -- Tab key spacing
vim.g.mapleader = ','         -- Leader key is comma

--== Syntax Colors ==

-- Colors (VS Code Dark+ palette)
local hl = vim.api.nvim_set_hl

hl(0, 'Normal', { bg = 'none' })
hl(0, 'NonText', { bg = 'none' })
hl(0, 'NormalNC', { bg = 'none' })
hl(0, 'SignColumn', { bg = 'none' })

hl(0, 'String', { fg = '#CE9178' })
hl(0, 'Function', { fg = '#DCDCAA' })
hl(0, 'Identifier', { fg = '#9CDCFE' })
hl(0, 'Keyword', { fg = '#569CD6' })
hl(0, 'Boolean', { fg = '#569CD6' })
hl(0, 'Number', { fg = '#B5CEA8' })
hl(0, 'Comment', { fg = '#6A9955', italic = true })
hl(0, 'Type', { fg = '#4EC9B0' })
hl(0, 'Constant', { fg = '#4FC1FF' })
hl(0, 'Operator', { fg = '#D4D4D4' })
hl(0, 'Statement', { fg = '#C586C0' })
hl(0, 'PreProc', { fg = '#C586C0' })
hl(0, 'Special', { fg = '#D4D4D4' })
hl(0, 'Error', { fg = '#F44747' })
hl(0, 'Todo', { fg = '#F44747' })

-- Treesitter highlight groups (modern @-capture names)
hl(0, '@variable',           { fg = '#9CDCFE' })
hl(0, '@variable.builtin',   { fg = '#9CDCFE' })
hl(0, '@variable.parameter', { fg = '#9CDCFE' })
hl(0, '@variable.other',     { fg = '#9CDCFE' })
hl(0, '@field',              { fg = '#9CDCFE' })
hl(0, '@property',           { fg = '#9CDCFE' })

hl(0, '@function',           { fg = '#DCDCAA' })
hl(0, '@function.builtin',   { fg = '#DCDCAA' })
hl(0, '@function.macro',     { fg = '#DCDCAA' })
hl(0, '@method',             { fg = '#DCDCAA' })
hl(0, '@method.call',        { fg = '#DCDCAA' })
hl(0, '@function.call',      { fg = '#DCDCAA' })
hl(0, '@constructor',        { fg = '#DCDCAA' })

hl(0, '@keyword',            { fg = '#569CD6' })
hl(0, '@keyword.conditional',{ fg = '#569CD6' })
hl(0, '@keyword.exception',  { fg = '#569CD6' })
hl(0, '@keyword.function',   { fg = '#C586C0' })
hl(0, '@keyword.operator',   { fg = '#569CD6' })
hl(0, '@keyword.return',     { fg = '#C586C0' })
hl(0, '@repeat',             { fg = '#C586C0' })
hl(0, '@conditional',        { fg = '#C586C0' })
hl(0, '@exception',          { fg = '#C586C0' })

hl(0, '@string',             { fg = '#CE9178' })
hl(0, '@string.special',     { fg = '#CE9178' })
hl(0, '@character',          { fg = '#CE9178' })

hl(0, '@number',             { fg = '#B5CEA8' })
hl(0, '@float',              { fg = '#B5CEA8' })
hl(0, '@constant',           { fg = '#569CD6' })
hl(0, '@constant.builtin',   { fg = '#569CD6' })

hl(0, '@comment',            { fg = '#6A9955', italic = true })

hl(0, '@type',               { fg = '#4EC9B0' })
hl(0, '@type.builtin',       { fg = '#4EC9B0' })
hl(0, '@annotation',         { fg = '#4EC9B0' })
hl(0, '@attribute',          { fg = '#4EC9B0' })

hl(0, '@operator',           { fg = '#D4D4D4' })
hl(0, '@punctuation',        { fg = '#D4D4D4' })
hl(0, '@punctuation.bracket',{ fg = '#D4D4D4' })
hl(0, '@punctuation.delimiter', { fg = '#D4D4D4' })

hl(0, '@label',              { fg = '#DCDCAA' })
hl(0, '@module',             { fg = '#DCDCAA' })
hl(0, '@namespace',          { fg = '#DCDCAA' })
hl(0, '@tag',                { fg = '#569CD6' })
hl(0, '@tag.delimiter',      { fg = '#6A9955' })
hl(0, '@tag.attribute',      { fg = '#9CDCFE' })

hl(0, '@preproc',            { fg = '#C586C0' })
hl(0, '@include',            { fg = '#C586C0' })
hl(0, '@define',             { fg = '#C586C0' })

hl(0, '@error',              { fg = '#F44747' })
hl(0, '@warning',            { fg = '#F44747' })   

-- StatusLine
hl(0, 'StatusLine', { bg = '#2e4c6f', fg = '#c0c0c0' })
hl(0, 'StatusLineNC', { bg = '#2e4c6f', fg = '#606060' })

--== Kitty Background Passthrough ==

hl(0, 'Normal', { bg = 'none' })
hl(0, 'NormalNC', { bg = 'none' })
hl(0, 'NonText', { bg = 'none' })
hl(0, 'SignColumn', { bg = 'none' })

hl(0, 'StatusLine', { bg = '#2e4c6f', fg = '#c0c0c0' })
hl(0, 'StatusLineNC', { bg = '#2e4c6f', fg = '#606060' })

--== Pulling Autocomplete (blink.cmp) ==

vim.opt.packpath:prepend(vim.fn.stdpath('data') .. '/site')

vim.pack.add({
	'https://github.com/saghen/blink.cmp',
	'https://github.com/rafamadriz/friendly-snippets',
	'https://github.com/romus204/tree-sitter-manager.nvim',
})

require('blink.cmp').setup({
	keymap = { preset = 'super-tab' },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
	},
	sources = {
		default = { 'lsp', 'path', 'buffer' },
	},
	fuzzy = { implementation = 'prefer_rust_with_warning' },
})

require('tree-sitter-manager').setup({
	auto_install = true,
	noauto_install = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
})


--== Intellisense (LSP) For All Main Languages ==

-- Default root marker for everything
vim.lsp.config('*', {
	root_markers = { '.git' },
	capabilities = require('blink.cmp').get_lsp_capabilities(), -- ← this line
	on_attach = function(_, bufnr)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
		vim.keymap.set('n', '<leader>xf', function()
			vim.lsp.buf.code_action({ only = { 'source.fixAll.ruff' } })
		end, { buffer = bufnr })
		vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { buffer = bufnr })
	end,
})

-- TypeScript / JavaScript
vim.lsp.config('ts_ls', {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	root_markers = { 'package.json', 'tsconfig.json', '.git' },
})

-- JSON
vim.lsp.config('jsonls', {
	cmd = { 'vscode-json-language-server', '--stdio' },
	filetypes = { 'json', 'jsonc' },
})

-- CSS
vim.lsp.config('cssls', {
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { 'css', 'scss', 'less' },
})

-- HTML
vim.lsp.config('html', {
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { 'html' },
})

-- Python
vim.lsp.config('pyright', {
	cmd = { 'pyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
})

-- Go
vim.lsp.config('gopls', {
	cmd = { 'gopls' },
	filetypes = { 'go' },
	root_markers = { 'go.mod', '.git' },
})

-- Lua
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = { 'lua/?.lua', 'lua/?/init.lua' },
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
})


--== Extra Linters ==

-- Ruff (Python — faster, more opinionated than pyright's diagnostics)
vim.lsp.config('ruff', {
	cmd = { 'ruff', 'server' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', '.git' },
})

-- ESLint (JS/TS — actual lint rules, not just type errors)
vim.lsp.config('eslint', {
	cmd = { 'eslint', '--stdio' },
	filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
	root_markers = { '.eslintrc', '.eslintrc.json', '.eslintrc.js', 'eslint.config.js', 'eslint.config.mjs', '.git' },
})

-- Enable them all
vim.lsp.enable({ 'ts_ls', 'jsonls', 'cssls', 'html', 'pyright', 'gopls', 'lua_ls', 'ruff', 'eslint', })

-- Format on save
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, async = false })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
