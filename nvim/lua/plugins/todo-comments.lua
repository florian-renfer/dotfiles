return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
	},
	lazy = false,
	opts = {},
	keys = {
		{ "<leader>st", "<cmd>TodoFzf<cr>", mode = "n", desc = "[S]earch [T]odos" },
	},
}
