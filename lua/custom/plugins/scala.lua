local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'scalameta/nvim-metals',
  gh 'mfussenegger/nvim-dap',
  gh 'nvim-lua/plenary.nvim',
}

vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ebug [C]ontinue' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[D]ebug [B]reakpoint' })
vim.keymap.set('n', '<leader>dso', function() require('dap').step_over() end, { desc = '[D]ebug [S]tep [O]ver' })
vim.keymap.set('n', '<leader>dsi', function() require('dap').step_into() end, { desc = '[D]ebug [S]tep [I]nto' })
vim.keymap.set('n', '<leader>dq', function() require('dap').terminate() end, { desc = '[D]ebug [Q]uit' })

local metals_config
local group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  group = group,
  callback = function()
    if not metals_config then
      metals_config = require('metals').bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
      }
      metals_config.init_options.statusBarProvider = 'off'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()

      local dap = require 'dap'
      dap.configurations.scala = {
        { type = 'scala', request = 'launch', name = 'Run file', metals = { runType = 'runOrTestFile' } },
        { type = 'scala', request = 'launch', name = 'Test target', metals = { runType = 'testTarget' } },
      }
      require('metals').setup_dap()
    end
    require('metals').initialize_or_attach(metals_config)
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.scala' },
  group = group,
  callback = function()
    vim.lsp.buf.code_action {
      context = { only = { 'source.organizeImports' } },
      apply = true,
    }
  end,
})
