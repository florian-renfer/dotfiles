return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "java", "lua" },
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(_, bufnr)
					return vim.api.nvim_buf_line_count(bufnr) > 5000
				end,
			},
			indent = { enbale = true },
		})
	end,
}
