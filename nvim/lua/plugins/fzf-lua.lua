return {
	"ibhagwan/fzf-lua",
	lazy = false,
	opts = {},
	keys = {
		{
			"<leader>sf",
			function()
				require("fzf-lua").files()
			end,
			desc = "[S]earch [f]files",
		},
		{
			"<leader>sg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[S]earch via [g]rep",
		},
		{
			"<leader>sh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "[S]earch [h]elp",
		},
		{
			"<leader>sq",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "[S]earch Document Diagnostics",
		},
		{
			"<leader>sx",
			function()
				require("fzf-lua").diagnostics_workspace()
			end,
			desc = "[S]earch Workspace Diagnostics",
		},
	},
}
