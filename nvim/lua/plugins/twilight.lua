return {
	"folke/twilight.nvim",
	opts = {
		exclude = {
			"markdown",
		},
		expand = {
			"function",
			"method",
			"table",
			"if_statement",
		},
	},
	keys = {
		{
			"<leader>tw",
			function()
				require("twilight").toggle()
			end,
			desc = "Toggle Twilight",
		},
	},
}
