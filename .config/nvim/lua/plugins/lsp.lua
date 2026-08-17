-- Keybinds --

local wk = require("which-key")

wk.add({
    mode = "n",
    { "<leader>e", vim.diagnostic.open_float, desc = "Open diagnostics" },
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        wk.add({
            mode = { "n" },
            { "<leader>F",  vim.lsp.buf.format,                                                                             desc = "Format",                  buffer = ev.buf },
            { "<leader>a",  vim.lsp.buf.code_action,                                                                        desc = "Code action",             mode = { "n", "v" }, buffer = ev.buf },
            { "<leader>k",  vim.lsp.buf.hover,                                                                              desc = "Hover",                   buffer = ev.buf },
            { "<leader>r",  vim.lsp.buf.rename,                                                                             desc = "Rename",                  buffer = ev.buf },

            { "<leader>w",  group = "Workspace" },
            { "<leader>wa", vim.lsp.buf.add_workspace_folder,                                                               desc = "Add workspace folder",    buffer = ev.buf },
            { "<leader>wr", vim.lsp.buf.remove_workspace_folder,                                                            desc = "Remove workspace folder", buffer = ev.buf },
            { "<leader>wl", ":lua vim.api.nvim_echo({{vim.inspect(vim.lsp.buf.list_workspace_folders())}}, false, {})<CR>", desc = "List workspace folders",  buffer = ev.buf },
        })

        wk.add({
            mode = { "n", "v" },
            { "<leader>g",  group = "LSP" },
            { "<leader>gD", vim.lsp.buf.declaration,     desc = "Declaration",     buffer = ev.buf },
            { "<leader>gd", vim.lsp.buf.definition,      desc = "Definition",      buffer = ev.buf },
            { "<leader>gr", vim.lsp.buf.references,      desc = "References",      buffer = ev.buf },
            { "<leader>gi", vim.lsp.buf.implementation,  desc = "Implementation",  buffer = ev.buf },
            { "<leader>gt", vim.lsp.buf.type_definition, desc = "Type definition", buffer = ev.buf },
            { "<leader>gs", vim.lsp.buf.signature_help,  desc = "Signature help",  buffer = ev.buf },
        })
    end,
})

-- End keybinds --


require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup()


-- LSP Stuff
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
            return
        end
        require("lsp_signature").on_attach({
            -- ... setup options here ...
        }, bufnr)
    end,
})



local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- applies to mason-enabled servers too, which previously got no cmp capabilities
vim.lsp.config('*', { capabilities = capabilities })

-- Other manually setup servers:
-- Lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { -- Get the language server to recognize the `vim` global
                    'vim',
                    'require'
                },
            },
            workspace = { -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

-- C++
vim.lsp.config('clangd', {
    cmd = {
        "clangd",
        "--enable-config",
        "--offset-encoding=utf-16",
        "--background-index",
        "--pretty",
        "--j=4",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--fallback-style=Google",
    },
})

vim.lsp.enable({ 'lua_ls', 'clangd' })
