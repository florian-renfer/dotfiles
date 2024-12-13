return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
	{ "nvim-lua/plenary.nvim" }
  },
  keys = {
    { "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "Search [f]iles" },
    { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Search in files using [g]rep" },
    { "<leader>sb", function() require("telescope.builtin").buffers() end, desc = "Search open [b]uffers" },
    { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Search [h]elp tags" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Search [k]eymaps (normal mode)" },
    { "<leader>sm", function() require("telescope.builtin").man_pages() end, desc = "Search [m]an pages" },
    { "<leader>s.", function() require("telescope.builtin").oldfiles() end, desc = "Search recently opened files" },
  },
}
