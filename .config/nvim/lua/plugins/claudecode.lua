
local wk = require("which-key")

require("claudecode").setup({
    -- native binary install; nvim may not inherit the shell PATH
    terminal_cmd = vim.fn.expand("~/.local/bin/claude"),
    terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.35,
        diff_split_width_percentage = 0.20,
    },
    diff_opts = {
        layout = "vertical",
    },
})

require("claude-fzf").setup({
    auto_context = true,
    batch_size = 10,
    logging = {
        level = "WARN"
    }
})

-- keybinds --
wk.add({
    mode = { "n", "v" },
    { "<leader>c", group = "Claude" },
    { "<leader>cc", ":ClaudeCode<CR>", desc = "Toggle Claude" },
    { "<leader>cf", ":ClaudeCodeFocus<CR>", desc = "Focus Claude" },
    { "<leader>cr", ":ClaudeCode --resume<CR>", desc = "Resume Claude" },
    { "<leader>cC", ":ClaudeCode --continue<CR>", desc = "Continue Claude" },
    { "<leader>cm", ":ClaudeCodeSelectModel<CR>", desc = "Select model" },
    { "<leader>cb", ":ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
    { "<leader>ca", ":ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
    { "<leader>cd", ":ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },

    { "<leader>cz", group = "Claude fzf" },
    { "<leader>czf", ":ClaudeFzfFiles<CR>", desc = "Add files" },
    { "<leader>czg", ":ClaudeFzfGrep<CR>", desc = "Search and add" },
    { "<leader>czb", ":ClaudeFzfBuffers<CR>", desc = "Add buffers" },
    { "<leader>czG", ":ClaudeFzfGitFiles<CR>", desc = "Add git files" },
    { "<leader>czd", ":ClaudeFzfDirectory<CR>", desc = "Add directory files" },
})

wk.add({
    mode = "v",
    { "<leader>cs", ":ClaudeCodeSend<CR>", desc = "Send selection" },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "neo-tree",
    callback = function(ev)
        wk.add({
            buffer = ev.buf,
            { "<leader>cs", ":ClaudeCodeTreeAdd<CR>", desc = "Add file to Claude" },
        })
    end,
})
-- end keybinds --
