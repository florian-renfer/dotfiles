return {
	"nvim-telescope/telescope-dap.nvim",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("dap")
	end,
	keys = {
		{
			"<leader>sb",
			"<cmd>:lua require('telescope').extensions.dap.list_breakpoints({})<cr>",
			desc = "[S]earch [b]reakpoints",
		},
		{
			"<leader>sv",
			"<cmd>:lua require('telescope').extensions.dap.variables({})<cr>",
			desc = "[S]earch [v]ariables",
		},
	},
}
