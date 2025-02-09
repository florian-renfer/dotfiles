return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open [L]azyGit' },
  },
}
