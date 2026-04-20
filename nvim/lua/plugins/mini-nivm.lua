return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({})
		require("mini.comment").setup({})
		-- TODO not oworking at the moment, re-check configuration in keys.lua and opts.lua
		require("mini.move").setup({})
		require("mini.surround").setup({})
		require("mini.cursorword").setup({})
		require("mini.indentscope").setup({})
		require("mini.pairs").setup({})
		require("mini.trailspace").setup({})
		require("mini.bufremove").setup({})
		-- Super annoying, crashes often and LSP notifications are driving me crazy
		-- require("mini.notify").setup({})
		require("mini.icons").setup({})
	end,
}
