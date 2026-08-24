local M = {}

vim.o.autocomplete = true
vim.o.completeopt = 'menu,menuone,popup,noselect,fuzzy'
-- 'complete' gives earlier sources a longer time slice, so LSP leads. |ins-autocompletion|
vim.o.complete = 'o,F,.^10,w^10,b^10'
vim.o.pummaxwidth = 60
vim.o.pumborder = 'rounded'

local PATH_CHAR = '[%w%._%-~%$/]'

function M.pathfunc(findstart, base)
    if findstart == 1 then
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col('.') - 1
        local start = col
        while start > 0 and line:sub(start, start):match(PATH_CHAR) do
            start = start - 1
        end
        -- Require a slash so this source stays quiet on ordinary words; -2 declines
        -- without leaving completion mode, which -3 would do and kill the other sources.
        if not line:sub(start + 1, col):find('/', 1, true) then
            return -2
        end
        return start
    end
    return vim.fn.getcompletion(base, 'file')
end

vim.o.completefunc = "v:lua.require'plugins.completion'.pathfunc"

local group = vim.api.nvim_create_augroup('completion', {})

vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if not client:supports_method('textDocument/completion') then
            return
        end
        -- 'autocomplete' already drives triggering, so autotrigger is left off; enable()
        -- is still what makes <C-y> apply snippets, text edits and commands.
        vim.lsp.completion.enable(true, client.id, ev.buf)
    end,
})

vim.keymap.set('i', '<C-Space>', '<C-n>', { desc = 'Trigger completion' })

-- 'autocomplete' forces "noselect", so pumvisible() would confirm an item the user
-- never selected; gate on an actual selection instead.
vim.keymap.set('i', '<CR>', function()
    return vim.fn.complete_info({ 'selected' }).selected ~= -1 and '<C-y>' or '<CR>'
end, { expr = true, desc = 'Confirm selected completion' })

vim.keymap.set('i', '<C-c>', function()
    return vim.fn.pumvisible() == 1 and '<C-e>' or '<C-c>'
end, { expr = true, desc = 'Abort completion' })

local function scroll_docs(key)
    return function()
        local winid = vim.fn.complete_info({ 'preview_winid' }).preview_winid
        if winid == 0 or not vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_feedkeys(vim.keycode(key), 'n', false)
            return
        end
        vim.api.nvim_win_call(winid, function()
            vim.cmd('normal! ' .. vim.keycode(key))
        end)
    end
end

vim.keymap.set('i', '<C-d>', scroll_docs('<C-d>'), { desc = 'Scroll docs down' })
vim.keymap.set('i', '<C-u>', scroll_docs('<C-u>'), { desc = 'Scroll docs up' })

vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildoptions = 'pum,tagfile,fuzzy'

vim.api.nvim_create_autocmd('CmdlineChanged', {
    group = group,
    pattern = { ':', '/', '?' },
    callback = function()
        vim.fn.wildtrigger()
    end,
})

-- wildtrigger() puts the pum in the way of history recall, so dismiss it first.
vim.keymap.set('c', '<Up>', function()
    return vim.fn.wildmenumode() == 1 and '<C-e><Up>' or '<Up>'
end, { expr = true })
vim.keymap.set('c', '<Down>', function()
    return vim.fn.wildmenumode() == 1 and '<C-e><Down>' or '<Down>'
end, { expr = true })

return M
