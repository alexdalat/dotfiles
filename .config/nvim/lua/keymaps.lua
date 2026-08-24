
-- must be set before any <leader> mapping is resolved
vim.g.mapleader = ','

local wk = require("which-key")
wk.setup()


-- Leader key (normal + visual)
wk.add({
  mode = { "n", "v" },
  { "<leader>y", '"+y', desc = "Copy to clipboard" },
  { "<leader>Y", '"+yg_', desc = "Copy line without line break" },

  { "<leader>t", group = "Telescope / Terminal" },
  { "<leader>tv", ':vsplit | wincmd l | terminal<CR>', desc = "Terminal (vert)" },
  { "<leader>th", ':split | wincmd j | terminal<CR>', desc = "Terminal (horiz)" },

  { "<leader>s", group = "Split" },
  { "<leader>sh", ':split<CR>', desc = "Split horizontal" },
  { "<leader>sv", ':vsplit<CR>', desc = "Split vertical" },
})

-- 'float' in JumpOpts is deprecated since 0.12; the float is driven from on_jump instead
local function diagnostic_float(_, bufnr)
  vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
end

-- Non-leader (normal mode only)
wk.add({
  mode = "n",
  { "[d", function() vim.diagnostic.jump({ count = -1, on_jump = diagnostic_float }) end, desc = "Previous diagnostic" },
  { "]d", function() vim.diagnostic.jump({ count = 1, on_jump = diagnostic_float }) end, desc = "Next diagnostic" },

  { "<C-s>", ":w<CR>", desc = "Save" },
  { "<C-p>", require('telescope.builtin').find_files, desc = "Find file" },

  -- Movement
  { "<C-h>", "<C-w>h", desc = "Move left" },
  { "<C-j>", "<C-w>j", desc = "Move down" },
  { "<C-k>", "<C-w>k", desc = "Move up" },
  { "<C-l>", "<C-w>l", desc = "Move right" },

  -- Resize
  { "<C-Right>", "<C-w>>", desc = "Increase width" },
  { "<C-Up>", "<C-w>+", desc = "Increase height" },
  { "<C-Down>", "<C-w>-", desc = "Decrease height" },
  { "<C-Left>", "<C-w><", desc = "Decrease width" },
})
