local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'ahmedkhalf/project.nvim' }

require('project_nvim').setup {
  detection_methods = { 'lsp', 'pattern' },
  patterns = { '.git', 'build.sbt', 'build.sc' },
}
require('telescope').load_extension 'projects'
vim.keymap.set('n', '<leader>sp', '<cmd>Telescope projects<cr>', { desc = '[S]earch [P]rojects' })
