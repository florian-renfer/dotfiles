return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	opts = {
		signs = {
			add = { text = "\u{2590}" }, -- ▏
			change = { text = "\u{2590}" }, -- ▐
			delete = { text = "\u{2590}" }, -- ◦
			topdelete = { text = "\u{25e6}" }, -- ◦
			changedelete = { text = "\u{25cf}" }, -- ●
			untracked = { text = "\u{25cb}" }, -- ○
		},
		signcolumn = true,
		current_line_blame = true,
	},
	keys = {
		{
			"<leader>gb",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			mode = "n",
			desc = "[G]it [b]lame line",
		},
	},
}
