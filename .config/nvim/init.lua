vim.loader.enable()

-- Must precede vim.pack.add(): PackChanged does not fire for plugins already
-- added, so hooks registered later never run on first install.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'fzf' then
      vim.system({ vim.fs.joinpath(ev.data.path, 'install'), '--bin' }):wait()
    end

    if name == 'nvim-treesitter' then
      -- :TSUpdate is defined in the plugin's own plugin/ files, which are not
      -- sourced yet when kind == 'install'
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh('williamboman/mason.nvim'),
  gh('williamboman/mason-lspconfig.nvim'),
  gh('neovim/nvim-lspconfig'),
  gh('ray-x/lsp_signature.nvim'),
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  gh('Badhi/nvim-treesitter-cpp-tools'),

  gh('NMAC427/guess-indent.nvim'),
  gh('github/copilot.vim'),
  gh('nvim-neotest/neotest'),
  gh('kevinhwang91/promise-async'),
  gh('nvim-neotest/neotest-python'),
  gh('folke/todo-comments.nvim'),
  gh('L3MON4D3/LuaSnip'),
  gh('MeanderingProgrammer/render-markdown.nvim'),

  gh('coder/claudecode.nvim'),
  gh('folke/snacks.nvim'),
  gh('pittcat/claude-fzf.nvim'),
  gh('ibhagwan/fzf-lua'),

  gh('mfussenegger/nvim-dap'),
  gh('rcarriga/nvim-dap-ui'),
  gh('nvim-neotest/nvim-nio'),
  gh('theHamsta/nvim-dap-virtual-text'),
  gh('nvim-telescope/telescope-dap.nvim'),

  gh('t-troebst/perfanno.nvim'),
  gh('stevearc/overseer.nvim'),

  gh('nvim-neo-tree/neo-tree.nvim'),
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-tree/nvim-web-devicons'),
  gh('MunifTanjim/nui.nvim'),
  gh('nvim-telescope/telescope.nvim'),
  gh('kevinhwang91/nvim-ufo'),
  gh('stevearc/aerial.nvim'),
  gh('karb94/neoscroll.nvim'),

  gh('rcarriga/nvim-notify'),
  { src = gh('catppuccin/nvim'), name = 'catppuccin' },
  gh('folke/which-key.nvim'),
  gh('stevearc/dressing.nvim'),
  gh('luukvbaal/statuscol.nvim'),
  gh('lewis6991/gitsigns.nvim'),
  gh('junegunn/fzf'),
  gh('junegunn/fzf.vim'),

  gh('echasnovski/mini.starter'),
  gh('echasnovski/mini.sessions'),
  gh('echasnovski/mini.icons'),
}, { confirm = false })

require('options')
-- sets mapleader, so it precedes every <leader> mapping
require('keymaps')
require('utils')
-- mini.sessions must precede mini.starter, which reads its session list
require('sessions')

require('plugins.ui')
require('plugins.editing')
-- before dap: nvim-dap-virtual-text depends on treesitter
require('plugins.treesitter')
require('plugins.dap')
-- before lsp: registers the LspAttach autocmd that must exist before clients
-- are enabled, or the first attach is missed
require('plugins.completion')
require('snippets')
require('plugins.lsp')
require('plugins.neotree')
-- before telescope: telescope.lua loads aerial's extension
require('plugins.aerial')
require('plugins.telescope')
require('plugins.perfanno')
require('plugins.overseer')
require('plugins.ufo')
require('plugins.neotest')
require('plugins.claudecode')
