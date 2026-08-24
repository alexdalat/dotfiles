-- main branch fetches parsers with curl+tar only; the master-branch prefer_git
-- escape hatch is gone. A bad archive now fails loudly (curl --fail), see :TSLog.
require('nvim-treesitter').install {
    "cpp", "lua", "vim", "vimdoc", "python", "bash", "json", "yaml", "html", "css", "javascript"
}

-- names of parsers, not filetypes
local disabled = { c = true, rust = true }

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or disabled[lang] then
            return
        end
        -- most filetypes have no parser installed; that is not an error
        if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
        end
    end,
})
