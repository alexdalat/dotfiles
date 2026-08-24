
local wk = require("which-key")
local telescope = require("telescope")

-- keybinds --
local wk = require("which-key")
wk.add({
  mode = { "n", "v" },
  -- group defined in keybinds.lua
  { "<leader>tf", ":Telescope find_files<CR>", desc = "Find file" },
  { "<leader>tb", ":Telescope buffers<CR>", desc = "Find buffer" },
  { "<leader>tH", ":Telescope help_tags<CR>", desc = "Find help" },
  { "<leader>tg", ":Telescope live_grep<CR>", desc = "Find string" },
  { "<leader>ta", ":Telescope aerial<CR>", desc = "Find symbol" },
})
-- end keybinds --


-- perfanno extension
local perfanno_actions = telescope.extensions.perfanno.actions
telescope.setup {
    extensions = {
        aerial = {
            col1_width = 4,
            show_columns = "both",
        },
        perfanno = {
            -- Special mappings in the telescope finders
            mappings = {
                ["i"] = {
                    -- Find hottest callers of selected entry
                    ["<C-h>"] = perfanno_actions.hottest_callers,
                    -- Find hottest callees of selected entry
                    ["<C-l>"] = perfanno_actions.hottest_callees,
                },

                ["n"] = {
                    ["gu"] = perfanno_actions.hottest_callers,
                    ["gd"] = perfanno_actions.hottest_callees,
                }
            }
        }
    }
}

telescope.load_extension("aerial")
