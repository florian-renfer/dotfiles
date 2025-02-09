return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = function(plugin)
    if vim.fn.executable 'npx' then
      vim.cmd('!cd ' .. plugin.dir .. ' && cd app && npx --yes yarn install && npm install')
    else
      vim.cmd [[Lazy load markdown-preview.nvim]]
      vim.fn['mkdp#util#install']()
    end
  end,
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  config = function()
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = 'Preview markdown' })
    vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Stop markdown preview' })
  end,
  ft = { 'markdown' },
}
