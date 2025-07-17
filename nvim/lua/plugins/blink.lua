return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"saghen/blink.pairs",
		version = "*", -- (recommended) only required with prebuilt binaries

		-- download prebuilt binaries from github releases
		dependencies = "saghen/blink.download",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
				enabled = true,
				-- you may also disable with `vim.g.pairs = false` (global) or `vim.b.pairs = false` (per-buffer)
				disabled_filetypes = {},
				-- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L12
				pairs = {},
			},
			highlights = {
				enabled = true,
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
				},
				matchparen = {
					enabled = true,
					group = "MatchParen",
				},
			},
			debug = false,
		},
	},
	{
		"saghen/blink.indent",
		--- @module 'blink.indent'
		--- @type blink.indent.Config
		opts = {
			-- or disable with `vim.g.indent_guide = false` (global) or `vim.b.indent_guide = false` (per-buffer)
			blocked = {
				buftypes = {},
				filetypes = {},
			},
			static = {
				enabled = true,
				char = "▎",
				priority = 1,
				-- specify multiple highlights here for rainbow-style indent guides
				-- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
				highlights = { "BlinkIndent" },
			},
			scope = {
				enabled = true,
				char = "▎",
				priority = 1024,
				-- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
				-- highlights = { 'BlinkIndent' },
				highlights = {
					"BlinkIndentOrange",
					"BlinkIndentViolet",
					"BlinkIndentBlue",
					-- 'BlinkIndentRed',
					-- 'BlinkIndentCyan',
					-- 'BlinkIndentYellow',
					-- 'BlinkIndentGreen',
				},
				underline = {
					-- enable to show underlines on the line above the current scope
					enabled = false,
					highlights = {
						"BlinkIndentOrangeUnderline",
						"BlinkIndentVioletUnderline",
						"BlinkIndentBlueUnderline",
						-- 'BlinkIndentRedUnderline',
						-- 'BlinkIndentCyanUnderline',
						-- 'BlinkIndentYellowUnderline',
						-- 'BlinkIndentGreenUnderline',
					},
				},
			},
		},
	},
}
