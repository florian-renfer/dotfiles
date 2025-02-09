return {
  vim.keymap.set('n', '<leader>ba', ':%bd<CR>', { desc = 'Delete [a]ll open buffers' }),
  vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = '[D]elete current buffer' }),
  vim.keymap.set('n', '<leader>bn', ':enew<CR>', { desc = '[N]ew buffer' }),
}
