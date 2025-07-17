return {
	"folke/twilight.nvim",
	opts = {
		exclude = {
			"markdown",
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
