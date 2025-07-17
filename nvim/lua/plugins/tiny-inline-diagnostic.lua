return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	config = function()
		vim.diagnostic.config({ virtual_text = true })
	end,
	opts = {},
	keys = {
		{
			"<leader>qt",
			function()
				require("tiny-inline-diagnostic").toggle()
			end,
			mode = "",
			desc = "[T]oggle inline diagnostic",
		},
	},
}
