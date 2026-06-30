local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
  gh 'nvim-lua/plenary.nvim',
}

local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd file' })
vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu' })
vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end)
