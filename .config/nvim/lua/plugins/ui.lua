-- Catppuccin
require("catppuccin").setup({
  flavour = "macchiato",
  integrations = {
    neotree = true,
    treesitter = true,
    notify = true,
  }
})
vim.cmd.colorscheme "catppuccin"

-- notify
vim.notify = require("notify")

require('gitsigns').setup()  -- resides in %s column, shows line git status

require('neoscroll').setup({
  mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  duration_multiplier = 1.0,
  easing = 'linear', -- default linear
  ignored_events = {}, -- apply to all events (I think)
  hide_cursor = false
})

-- statuscol
local builtin = require("statuscol.builtin")
require("statuscol").setup({
  segments = {
    { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
    -- diagnostics and gitsigns each get their own 1-cell column; sharing the
    -- native "%s" sign column makes them overwrite each other on the same line
    {
      sign = { namespace = { "diagnostic" }, maxwidth = 1, colwidth = 1, auto = true },
      click = "v:lua.ScSa",
    },
    {
      sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 1, auto = true, wrap = true },
      click = "v:lua.ScSa",
    },
    {
      text = { builtin.lnumfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
  },
})


-- Mini starter
local starter = require("mini.starter")

local footer_n_seconds = function()
  return function()
    return os.date("%A, %B %d, %Y %I:%M:%S %p")
  end
end

starter.setup({
  content_hooks = {
    starter.gen_hook.adding_bullet(""),
    starter.gen_hook.aligning("center", "center"),
  },
  evaluate_single = true,
  footer = footer_n_seconds(),
  header = table.concat({
    [[  /\ \▔\___  ___/\   /\- _ __ ___  ]],
    [[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
    [[/ /\  /  __/ (_) \ V /| | | | | | |]],
    [[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
    [[───────────────────────────────────]],
  }, "\n"),
  query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
  items = {
    -- Use this if you set up 'mini.sessions'
    starter.sections.sessions(5, true),
    { action = "Telescope find_files", name = "F: Find File", section = "Telescope" },
    { action = "Telescope grep_string", name = "G: Grep String", section = "Telescope" },
    { action = vim.pack.update, name = "U: Update Plugins", section = "Plugins" },
    { action = "enew",        name = "E: New Buffer",     section = "Builtin actions" },
    { action = "qall!",       name = "Q: Quit Neovim",    section = "Builtin actions" },
  },
})

vim.cmd([[
  augroup MiniStarterJK
    au!
    au User MiniStarterOpened nmap <buffer> j <Cmd>lua MiniStarter.update_current_item('next')<CR>
    au User MiniStarterOpened nmap <buffer> k <Cmd>lua MiniStarter.update_current_item('prev')<CR>
    au User MiniStarterOpened nmap <buffer> <C-p> <Cmd>Telescope find_files<CR>
  augroup END
]])
