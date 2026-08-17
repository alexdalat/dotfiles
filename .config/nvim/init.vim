call plug#begin('~/.config/nvim/plugged/')

    " LSP
    Plug 'williamboman/mason.nvim'
        Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'https://github.com/neovim/nvim-lspconfig'
    Plug 'https://github.com/hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-vsnip'
        Plug 'hrsh7th/vim-vsnip'
    Plug 'https://github.com/ray-x/lsp_signature.nvim'
    Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'branch': 'master', 'do': ':TSUpdate'}
        Plug 'https://github.com/Badhi/nvim-treesitter-cpp-tools.git'

    " Editing
    Plug 'https://github.com/NMAC427/guess-indent.nvim'
    Plug 'https://github.com/github/copilot.vim'
    Plug 'https://github.com/nvim-neotest/neotest'
        Plug 'kevinhwang91/promise-async'
        Plug 'https://github.com/alfaix/neotest-gtest'
        Plug 'https://github.com/nvim-neotest/neotest-python'
    Plug 'https://github.com/folke/todo-comments.nvim'  " TODO highlighting
    Plug 'https://github.com/L3MON4D3/LuaSnip.git'


    " Debugging
    Plug 'https://github.com/mfussenegger/nvim-dap.git'
        "Plug 'https://github.com/Weissle/persistent-breakpoints.nvim'
        Plug 'https://github.com/rcarriga/nvim-dap-ui'
            Plug 'nvim-neotest/nvim-nio'
            Plug 'https://github.com/folke/neodev.nvim'
            Plug 'https://github.com/theHamsta/nvim-dap-virtual-text'
                Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'branch': 'master', 'do': ':TSUpdate'}
        Plug 'https://github.com/nvim-telescope/telescope-dap.nvim.git'

    " Profiling
    Plug 'https://github.com/t-troebst/perfanno.nvim'

    " Project specific task running / compilation
    "Plug 'https://github.com/skywind3000/asynctasks.vim'
    "    Plug 'skywind3000/asyncrun.vim', {'on': ['AsyncRun', 'AsyncStop'] }
    "    Plug 'https://github.com/GustavoKatel/telescope-asynctasks.nvim'
    Plug 'https://github.com/stevearc/overseer.nvim'

    " Navigation
    Plug 'https://github.com/nvim-neo-tree/neo-tree.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-tree/nvim-web-devicons'
        Plug 'MunifTanjim/nui.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'https://github.com/kevinhwang91/nvim-ufo'

    " Other
    Plug 'rcarriga/nvim-notify'
    Plug 'https://github.com/catppuccin/nvim', { 'as': 'catppuccin' }
    Plug 'https://github.com/folke/which-key.nvim'
    Plug 'https://github.com/stevearc/dressing.nvim'
    Plug 'https://github.com/luukvbaal/statuscol.nvim'
        Plug 'https://github.com/lewis6991/gitsigns.nvim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Mini
    Plug 'echasnovski/mini.starter'
    Plug 'echasnovski/mini.sessions'
    Plug 'echasnovski/mini.icons'

call plug#end()

" asynctasks (plugin currently disabled above)
"let g:asyncrun_open = 6  " Setup
"let g:asynctasks_confirm = 0  " Don't ask to name file
"let g:asynctasks_term_pos = 'bottom'  " Open terminal at bottom (not quickfix)

lua require('options')
" sets mapleader, so it precedes every <leader> mapping
lua require('keymaps')
lua require('utils')
" mini.sessions must precede mini.starter, which reads its session list
lua require('sessions')

lua require('plugins.ui')
lua require('plugins.editing')
" before dap: nvim-dap-virtual-text depends on treesitter
lua require('plugins.treesitter')
lua require('plugins.dap')
" before lsp: servers pick up cmp capabilities
lua require('plugins.completion')
lua require('snippets')
lua require('plugins.lsp')
lua require('plugins.neotree')
lua require('plugins.telescope')
lua require('plugins.perfanno')
lua require('plugins.overseer')
lua require('plugins.ufo')
lua require('plugins.neotest')
