return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>st", "<cmd>TodoTelescope<cr>", mode = "n", desc = "[S]earch [T]odos" },
  },
}
