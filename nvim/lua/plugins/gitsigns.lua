return {
  'lewis6991/gitsigns.nvim',
  opts = {},
  keys = {
    {
      "<leader>gb",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      mode = "n",
      desc = "[G]it [b]lame line",
    },
  },
}
