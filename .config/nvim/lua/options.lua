vim.opt.number = true
vim.opt.wrap = true
vim.opt.undofile = true -- persistent undo

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.timeoutlen = 100 -- faster whichkey

vim.opt.spell = true
vim.opt.spelllang = "en_us"


function _G.relative_file_path()
    return vim.fn.substitute(vim.fn.expand('%'), '^' .. vim.fn.getcwd() .. '/', '', '')
end

vim.opt.winbar = "%t %m"

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
