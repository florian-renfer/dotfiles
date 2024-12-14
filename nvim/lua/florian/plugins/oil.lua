return {
  "stevearc/oil.nvim",
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc= "Open parent directory" },
  },
  opts = {
    keymaps = {
      ["q"] = { "actions.close" },
      ["<bs>"] = { "actions.parent" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
