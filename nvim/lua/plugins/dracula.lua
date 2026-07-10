return {
	{
		"Mofiqul/dracula.nvim",
		config = function()
			require("dracula").setup({
				overrides = {
					NormalFloat = { bg = "#21222c" },
					FloatBorder = { fg = "#6272a4", bg = "#21222c" },
				},
			})
			vim.cmd.colorscheme("dracula")
		end,
	},
}
