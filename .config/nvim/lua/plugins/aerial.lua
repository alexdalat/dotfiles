local aerial = require("aerial")
local wk = require("which-key")

aerial.setup({
  backends = {
    ["_"] = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
    -- clangd resolves macros, templates and out-of-line definitions that the
    -- treesitter C/C++ queries miss
    c = { "lsp", "treesitter" },
    cpp = { "lsp", "treesitter" },
  },

  layout = {
    default_direction = "prefer_right",
    placement = "window",
    resize_to_content = true,
    max_width = { 40, 0.25 },
    min_width = 20,
  },

  attach_mode = "window",
  show_guides = true,
  highlight_on_hover = true,

  -- nvim-ufo owns folding (see plugins/ufo.lua); letting aerial manage folds
  -- makes the two providers fight over foldmethod
  manage_folds = false,

  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },

  open_automatic = function(bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 80
      and aerial.num_symbols(bufnr) > 4
      and not aerial.was_closed()
  end,

  nav = {
    preview = true,
    autojump = true,
  },

  keymaps = {
    -- these are window movement / save globally; keep them working in the aerial buffer
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-s>"] = false,
  },

  on_attach = function(bufnr)
    wk.add({
      mode = "n",
      buffer = bufnr,
      { "[a", "<cmd>AerialPrev<CR>", desc = "Previous symbol" },
      { "]a", "<cmd>AerialNext<CR>", desc = "Next symbol" },
    })
  end,
})

wk.add({
  mode = { "n", "v" },
  { "<leader>a", group = "Aerial" },
  { "<leader>aa", "<cmd>AerialToggle<CR>", desc = "Toggle outline" },
  { "<leader>an", "<cmd>AerialNavToggle<CR>", desc = "Nav window" },
  { "<leader>af", function() aerial.fzf_lua_picker({ profile = "ivy" }) end, desc = "Symbols (fzf-lua)" },
  { "<leader>as", function() aerial.snacks_picker({ layout = { preset = "dropdown" } }) end, desc = "Symbols (snacks)" },
})

-- winbar breadcrumb, referenced from options.lua
function _G.aerial_crumb()
  local symbols = aerial.get_location(false)
  if #symbols == 0 then
    return ""
  end
  local parts = {}
  for _, symbol in ipairs(symbols) do
    parts[#parts + 1] = symbol.icon .. " " .. symbol.name
  end
  return "\u{203a} " .. table.concat(parts, " \u{203a} ")
end
