return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>sf", "<cmd>:lua require('telescope.builtin').find_files()<cr>", desc = "[S]earch [f]iles" },
		{ "<leader>sg", "<cmd>:lua require('telescope.builtin').live_grep()<cr>", desc = "[S]earch via [g]rep" },
		{ "<leader>sh", "<cmd>:lua require('telescope.builtin').help_tags()<cr>", desc = "[S]earch neovim [h]elp" },
		{ "<leader>sc", "<cmd>:lua require('telescope.builtin').colorscheme()<cr>", desc = "[S]earch [c]olorschemes" },
		{ "<leader>sp", "<cmd>:lua require('telescope.builtin').oldfiles()<cr>", desc = "[S]earch [p]revious files" },
		{ "<leader>sk", "<cmd>:lua require('telescope.builtin').keymaps()<cr>", desc = "[S]earch [k]eymaps" },
	},
}
