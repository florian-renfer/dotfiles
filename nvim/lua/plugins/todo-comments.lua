return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  keys = {
    { "<leader>st", "<cmd>TodoTelescope<cr>", mode = "n", desc = "[S]earch [T]odos" },
  },
  opts = {},
  lazy = false,
}
