return {
  'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  dependencies = {
    'mason-org/mason.nvim',
    'lewis6991/gitsigns.nvim'
  },
  opts = {
    server = {
      cmd = {
        'sonarlint-language-server',
        '-stdio',
        '-analyzers',
        vim.fn.expand('$HOME/.local/share/nvim/mason/share/sonarlint-analyzers/sonargo.jar'),
        vim.fn.expand('$HOME/.local/share/nvim/mason/share/sonarlint-analyzers/sonarhtml.jar'),
        vim.fn.expand('$HOME/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjava.jar'),
        vim.fn.expand('$HOME/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjs.jar'),
      },
    },
    filetypes = {
      'angularhtml',
      'go',
      'html',
      'java',
      'typescript'
    },
  },
}
