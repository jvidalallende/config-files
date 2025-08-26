-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup centralized directories for swap, undo, and backup
local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
vim.opt.directory = { prefix .. "/nvim/.swp//"}
vim.opt.undodir = { prefix .. "/nvim/.undo//"}
vim.opt.backupdir = {prefix .. "/nvim/.backup//"}

-- Show line numbers
vim.opt.number = true

-- Cursor line
vim.opt.cursorline = true
-- opt.cursorlineopt = "number"
vim.opt.colorcolumn = "80,100"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Disable syntax highlighting (will be handled by tree-sitter)
vim.cmd("syntax off")

-- Bash-to-fish replacement for exports, adds save&exit for quick apply
vim.keymap.set('n', '<F4>', ':%s/export/set -gx/ | :%s/=/ / <CR><CR> | :wq <CR>', {noremap = true})

-- Terraform files
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- Setup lazy.nvim
require("lazy").setup({

    --  Solarized colorscheme
    {
        'maxmx03/solarized.nvim',
	lazy = false,
	opts = {},
	config = function(_, opts)
	    vim.o.background = 'dark'
	    require('solarized').setup(opts)
	    vim.cmd.colorscheme('solarized')
	end,
    },

    -- Treesitter for syntax highlighting (load early)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        priority = 100, -- Load early
	opts = {
            highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	    },
            indent = { enable = true },
            ensure_installed = {
              "bash",
              "c",
              "diff",
              "html",
              "javascript",
              "jsdoc",
              "json",
              "jsonc",
              "lua",
              "luadoc",
              "luap",
              "hcl",
              "markdown",
              "markdown_inline",
              "printf",
              "python",
              "query",
              "regex",
              "toml",
              "tsx",
              "typescript",
              "vim",
              "vimdoc",
              "xml",
              "yaml",
            },
	},
	config = function(_, opts)
	    local configs = require("nvim-treesitter.configs")
            configs.setup(opts)
	end,
    },

    -- Language Server Protocol support
    {
        "neovim/nvim-lspconfig", -- Base LSP configurations
        dependencies = {
            -- Server installation manager
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Trim whitespaces
    {
        "cappyzawa/trim.nvim",
	opts = {
	    trim_on_write = false,
	    trim_last_line = false,
	    highlight = true,
	    highlight_bg = '#8b0000' -- dark red
	},
	config = function(_, opts)
	    require('trim').setup(opts)
	    vim.keymap.set('n', '<F3>', ':Trim<CR>')
	end,
    },
})

-- Terraform lsp
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tflint.setup{}
