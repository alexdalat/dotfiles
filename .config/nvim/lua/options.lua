vim.opt.number = true
vim.opt.wrap = true
vim.opt.undofile = true -- persistent undo

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.timeoutlen = 100 -- faster whichkey

vim.opt.mousescroll = "ver:1,hor:2" -- default ver:3 overshoots with a trackpad

vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Disable recording macros
vim.keymap.set('n', 'q', '<Nop>', { noremap = true, silent = true })

function _G.relative_file_path()
    return vim.fn.substitute(vim.fn.expand('%'), '^' .. vim.fn.getcwd() .. '/', '', '')
end

-- aerial_crumb() is defined in plugins/aerial.lua; plain %{} so symbol names
-- containing '%' are not re-parsed as statusline items
vim.opt.winbar = "%t %m %{v:lua.aerial_crumb()}"

vim.opt.statusline = table.concat({
    "%{v:lua.relative_file_path()} ",
    "%y ",      -- File type
    "%=",       -- Left/right separation
    "%l/%L, %c ", -- Line and column number
})


-- TrueColor stuff
vim.cmd([[
  if !has('gui_running') && &term =~ '\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
]])
vim.opt.termguicolors = true
