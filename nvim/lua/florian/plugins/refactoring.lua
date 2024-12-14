return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	lazy = false,
	keys = {
		{
			"<leader>re",
			function()
				require("refactoring").refactor("Extract Function")
			end,
			desc = "[E]xtract function",
		},
		{
			"<leader>rv",
			function()
				require("refactoring").refactor("Extract Variable")
			end,
			desc = "Extract [v]ariable",
		},
		{
			"<leader>rI",
			function()
				require("refactoring").refactor("Inline Function")
			end,
			desc = "Extract [I]nline function",
		},
		{
			"<leader>ri",
			function()
				require("refactoring").refactor("Inline Variable")
			end,
			desc = "Extract [i]nline variable",
		},
		{
			"<leader>rb",
			function()
				require("refactoring").refactor("Extract Block")
			end,
			desc = "Extract [b]lock",
		},
	},
	opts = {},
}
