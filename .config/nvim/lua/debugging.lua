local dap = require('dap')
local util = require('utils')

-- Keybinds --

---- dap-ui ----
-- edit: e
-- expand: Enter
-- open: o
-- remove: d
-- repl: r
-- toggle: t
----------------

local wk = require("which-key")

wk.add({
    mode = { "n", "v" },
    -- Top-level Debug commands
    { "<leader>d",   group = "Debug" },
    { "<leader>dc",  dap.continue,          desc = "Continue" },
    { "<leader>dC",  dap.run_last,          desc = "Run last" },
    { "<leader>dt",  dap.terminate,         desc = "Terminate" },
    { "<leader>ds",  dap.step_over,         desc = "Step over" },
    { "<leader>di",  dap.step_into,         desc = "Step into" },
    { "<leader>do",  dap.step_out,          desc = "Step out" },

    -- Breakpoints
    { "<leader>db",  group = "Breakpoints" },
    { "<leader>dbb", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
    {
        "<leader>dbl",
        function()
            util.text_input(function(log_msg)
                dap.set_breakpoint(nil, nil, log_msg)
            end, "Log message: ", "x: {x}")
        end,
        desc = "Log point"
    },
    { "<leader>dbC", dap.clear_breakpoints,              desc = "Clear breakpoints" },
    { "<leader>dbL", dap.list_breakpoints,               desc = "List breakpoints" },

    -- DAP UI
    { "<leader>du",  ":lua require'dapui'.toggle()<CR>", desc = "Toggle UI" },
})

-- End keybinds --



--- nvim-dap
dap.defaults.fallback.focus_terminal = true -- can also be added to individual configs

if vim.fn.has('macunix') == 1 then
    local function find_lldb_vscode()
        local paths = { -- paths to be searched for the debugger installation
            '/usr/lib/llvm-14/bin/lldb-vscode',
            '/opt/homebrew/opt/llvm/bin/lldb-vscode',
        }
    
        for _, path in ipairs(paths) do
            local file = io.open(path, "r")
            if file then
                file:close()
                return path
            end
        end
        return nil
    end

    dap.adapters.lldb = {
        type = 'executable',
        command = find_lldb_vscode(), -- must be absolute path
        name = 'lldb'
    }

    if not dap.adapters.lldb.command then
        vim.notify('LLDB not found', vim.log.levels.WARN)
    else
        --vim.notify('LLDB found at ' .. dap.adapters.lldb.command, vim.log.levels.INFO)
    end

    dap.configurations.cpp = {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            runInTerminal = true, -- necessary for interactive console
            showDisassembly = "never",
        },
    }
else  -- non Mac
    -- not implemented yet
end


dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


--- nvim-dap-ui
local dapui = require("dapui")
dapui.setup()

-- Auto open and close dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
    --dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Dependency for nvim-dap-ui
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "cpp", "lua", "vim", "vimdoc", "python", "bash", "json", "yaml", "html", "css", "javascript" },
    sync_install = true,

    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,
    ignore_install = {},

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype.
        disable = { "c", "rust" },
    },
}

require("nvim-dap-virtual-text").setup {
    enabled = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables
    show_stop_reason = true,
    commented = false,
    only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
    all_references = true,         -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,     -- clear virtual text on "continue" (might cause flickering when stepping)

    ---@diagnostic disable-next-line: unused-local
    display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
        else
            return variable.name .. ' = ' .. variable.value
        end
    end,
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy(?)
    virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column
}

--require('persistent-breakpoints').setup {
--    save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
--    load_breakpoints_event = "BufReadPost",
--}
