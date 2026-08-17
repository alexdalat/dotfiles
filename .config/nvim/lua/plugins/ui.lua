-- Catppuccin
require("catppuccin").setup({
  flavour = "macchiato",
  integrations = {
    cmp = true,
    neotree = true,
    treesitter = true,
    notify = true,
  }
})
vim.cmd.colorscheme "catppuccin"

-- notify
vim.notify = require("notify")

require('gitsigns').setup()  -- resides in %s column, shows line git status

-- statuscol
local builtin = require("statuscol.builtin")
require("statuscol").setup({
  segments = {
    {
      text = { builtin.foldfunc, " " },  -- fold
      condition = { true, builtin.not_empty },
      click = "v:lua.ScFa"
    },
    { text = { "%s" }, click = "v:lua.ScSa" },  -- git line
    {
      text = { builtin.lnumfunc, " " },  -- line number
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    }
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
    { action = "PlugInstall", name = "U: Update Plugins", section = "Plugins" },
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
