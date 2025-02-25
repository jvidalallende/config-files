require("config.lazy")

-- Reduce boilerplate
local opt = vim.opt

-- Setup centralized directories for swap, undo, and backup
local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
opt.directory = { prefix .. "/nvim/.swp//"}
opt.undodir = { prefix .. "/nvim/.undo//"}
opt.backupdir = {prefix .. "/nvim/.backup//"}

-- Show line numbers
opt.number = true

-- Cursor line
opt.cursorline = true
-- opt.cursorlineopt = "number"
opt.colorcolumn = "80,100"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
