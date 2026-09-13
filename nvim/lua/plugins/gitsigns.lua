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
			"]c",
			function()
				require("gitsigns").nav_hunk("next")
			end,
			mode = "n",
			desc = "Next git hunk",
		},
		{
			"[c",
			function()
				require("gitsigns").nav_hunk("prev")
			end,
			mode = "n",
			desc = "Previous git hunk",
		},
		{
			"<leader>gb",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			mode = "n",
			desc = "[G]it [b]lame line",
		},
		{
			"<leader>gs",
			function()
				require("gitsigns").stage_hunk()
			end,
			mode = "n",
			desc = "[G]it [s]tage hunk",
		},
		{
			"<leader>gr",
			function()
				require("gitsigns").reset_hunk()
			end,
			mode = "n",
			desc = "[G]it [r]eset hunk",
		},
	},
}

-- require('gitsigns').setup{
--   ...
--   on_attach = function(bufnr)
--     local gitsigns = require('gitsigns')
--
--     local function map(mode, l, r, opts)
--       opts = opts or {}
--       opts.buffer = bufnr
--       vim.keymap.set(mode, l, r, opts)
--     end
--
--     -- Navigation
--     map('n', ']c', function()
--       if vim.wo.diff then
--         vim.cmd.normal({']c', bang = true})
--       else
--         gitsigns.nav_hunk('next')
--       end
--     end)
--
--     map('n', '[c', function()
--       if vim.wo.diff then
--         vim.cmd.normal({'[c', bang = true})
--       else
--         gitsigns.nav_hunk('prev')
--       end
--     end)
--
--     -- Actions
--     map('n', '<leader>hs', gitsigns.stage_hunk)
--     map('n', '<leader>hr', gitsigns.reset_hunk)
--
--     map('v', '<leader>hs', function()
--       gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
--     end)
--
--     map('v', '<leader>hr', function()
--       gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
--     end)
--
--     map('n', '<leader>hS', gitsigns.stage_buffer)
--     map('n', '<leader>hR', gitsigns.reset_buffer)
--     map('n', '<leader>hp', gitsigns.preview_hunk)
--     map('n', '<leader>hi', gitsigns.preview_hunk_inline)
--
--     map('n', '<leader>hb', function()
--       gitsigns.blame_line({ full = true })
--     end)
--
--     map('n', '<leader>hd', gitsigns.diffthis)
--
--     map('n', '<leader>hD', function()
--       gitsigns.diffthis('~')
--     end)
--
--     map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
--     map('n', '<leader>hq', gitsigns.setqflist)
--
--     -- Toggles
--     map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
--     map('n', '<leader>tw', gitsigns.toggle_word_diff)
--
--     -- Text object
--     map({'o', 'x'}, 'ih', gitsigns.select_hunk)
--   end
-- }
