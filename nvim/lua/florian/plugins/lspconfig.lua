return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
		},
		{
			"williamboman/mason-lspconfig.nvim",
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local servers = {
			lua_ls = true,
			gopls = {
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
		}

		local servers_to_install = vim.tbl_filter(function(key)
			return servers[key]
		end, vim.tbl_keys(servers))

		local tools_to_install = {
			"stylua",
		}

		local ensure_installed = servers_to_install or {}
		vim.list_extend(ensure_installed, tools_to_install)

		require("mason").setup()
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		local lspconfig = require("lspconfig")

		for name, config in pairs(servers) do
			if config == true then
				config = {}
			end
			lspconfig[name].setup(config)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "invalid client supplied")
				local builtin = require("telescope.builtin")

				vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
				vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0, desc = "Goto [d]efinition" })
				vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0, desc = "Goto [r]eferences" })
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0, desc = "Goto [D]eclaration" })
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0, desc = "Go to [t]ype definition" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0, desc = "[R]ename" })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code [a]ctions" })
				vim.keymap.set(
					"n",
					"<leader>ds",
					builtin.lsp_document_symbols,
					{ buffer = 0, desc = "Search document [s]ymbols" }
				)

				if not client then
					return
				end
				-- [[ Auto formatting on save ]]
				-- Currently handled by stevearc/conform.nvim
				-- -- Auto-format on save (lsp support required)
				-- if client.supports_method("textDocument/formatting", 0) then
				-- 	vim.api.nvim_create_autocmd("BufWritePre", {
				-- 		buffer = args.buf,
				-- 		callback = function()
				-- 			vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
				-- 		end,
				-- 	})
				-- end
			end,
		})

		-- [[ Formatting keymap ]]
		-- Currently handled by stevearc/conform.nvim
		-- vim.keymap.set("n", "<leader>f", function()
		-- 	vim.lsp.buf.format()
		-- end, { desc = "[F]ormat current buffer" })
	end,
}
