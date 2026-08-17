local wk = require("which-key")

require('guess-indent').setup {}

-- disable auto commenting new lines
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")


-- Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })


-- todo-comments
local td = require('todo-comments')
td.setup{}

wk.add({
  mode = "n",
  { "<leader>T", group = "Todo Comments" },
  { "<leader>Tn", function() td.jump_next() end, desc = "Next" },
  { "<leader>Tp", function() td.jump_prev() end, desc = "Prev" },
  { "<leader>TT", ":TodoTelescope keywords=TODO,FIX<CR>", desc = "Todo Telescope" },
  { "<leader>TN", ":TodoTelescope keywords=NOTE<CR>", desc = "Note Telescope" },
})
