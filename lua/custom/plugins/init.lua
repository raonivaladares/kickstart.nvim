-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
    'ahmedkhalf/project.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', 'build.sbt', 'build.sc' },
      }
      require('telescope').load_extension 'projects'
    end,
    keys = {
      { '<leader>sp', '<cmd>Telescope projects<cr>', desc = '[S]earch [P]rojects' },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd file' })
      vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })
      vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end)
    end,
  },
  {
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local metals_config = require('metals').bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
      }
      metals_config.init_options.statusBarProvider = 'off'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()
      return metals_config
    end,
    config = function(self, metals_config)
      local group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = group,
      })
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.scala' },
        callback = function()
          vim.lsp.buf.code_action {
            context = { only = { 'source.organizeImports' } },
            apply = true,
          }
        end,
        group = group,
      })
    end,
  },
}
