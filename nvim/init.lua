require("config.lazy")

-- Setup centralized directories for swap, undo, and backup
local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
vim.opt.directory = { prefix .. "/nvim/.swp//"}
vim.opt.undodir = { prefix .. "/nvim/.undo//"}
vim.opt.backupdir = {prefix .. "/nvim/.backup//"}
