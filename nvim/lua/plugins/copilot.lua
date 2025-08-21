return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {},
		keys = {
			{ "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle [C]opilot [C]hat" },
		},
	},
}
