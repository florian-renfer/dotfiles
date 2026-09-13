return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"b0o/SchemaStore.nvim",
			version = false,
		},
	},
	config = function()
		local home = os.getenv("HOME")

		vim.lsp.config("*", {
			handlers = {
				["textDocument/hover"] = function(err, result, ctx, config)
					config = vim.tbl_deep_extend("force", config or {}, { border = "rounded", max_width = 80 })
					vim.lsp.handlers.hover(err, result, ctx, config)
				end,
			},
		})

		local schemastore = require("schemastore")

		vim.lsp.config("jsonls", {
			settings = {
				json = {
					validate = { enable = true },
					schemas = schemastore.json.schemas(),
				},
			},
		})

		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					validate = true,
					completion = true,
					hover = true,
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = schemastore.yaml.schemas(),
				},
			},
		})

		do
			local luacheck = require("efmls-configs.linters.luacheck")
			local stylua = require("efmls-configs.formatters.stylua")

			local oxlint = {
				lintCommand = "oxlint --format unix ${INPUT}",
				lintStdin = false,
				lintIgnoreExitCode = true,
				lintFormats = {
					"%f:%l:%c: %m",
				},
				rootMarkers = {
					".oxlintrc.json",
					".oxlintrc.jsonc",
					"package.json",
					"tsconfig.json",
					".git",
				},
			}
			local oxfmt = {
				formatCommand = "oxfmt --stdin-filepath ${INPUT}",
				formatStdin = true,
				rootMarkers = {
					".oxlintrc.json",
					".oxlintrc.jsonc",
					"package.json",
					"tsconfig.json",
					".git",
				},
			}

			local fixjson = require("efmls-configs.formatters.fixjson")

			local shellcheck = require("efmls-configs.linters.shellcheck")
			local shfmt = require("efmls-configs.formatters.shfmt")

			local google_java_format = require("efmls-configs.formatters.google_java_format")
			local google_java_format_executable = vim.fn.exepath("google-java-format")
			if google_java_format_executable == "" then
				local mason_google_java_format = home .. "/.local/share/nvim/mason/bin/google-java-format"
				if vim.uv.fs_stat(mason_google_java_format) then
					google_java_format_executable = mason_google_java_format
				else
					google_java_format_executable = "google-java-format"
				end
			end

			local sqlfluff_lint = require("efmls-configs.linters.sqlfluff")
			local sqlfluff_format = require("efmls-configs.formatters.sqlfluff")

			google_java_format = vim.tbl_deep_extend("force", google_java_format, {
				-- The upstream range wrapper only partially reformats some Java buffers here.
				-- For save/manual formatting, full-buffer formatting is more reliable.
				formatCanRange = false,
				formatCommand = google_java_format_executable .. " -",
				rootMarkers = {
					".git",
					".project",
					"classpath",
					"pom.xml",
					"build.gradle",
					"build.gradle.kts",
					"settings.gradle",
					"settings.gradle.kts",
					"gradlew",
					"gradlew.bat",
				},
			})

			local go_revive = require("efmls-configs.linters.go_revive")
			local gofumpt = require("efmls-configs.formatters.gofumpt")

			vim.lsp.config("efm", {
				filetypes = {
					"c",
					"cpp",
					"css",
					"go",
					"html",
					"htmlangular",
					"java",
					"javascript",
					"javascriptreact",
					"json",
					"jsonc",
					"lua",
					"markdown",
					"python",
					"sh",
					"sql",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				init_options = { documentFormatting = true },
				settings = {
					languages = {
						css = { oxfmt },
						go = { gofumpt, go_revive },
						html = { oxfmt },
						htmlangular = { oxfmt },
						java = { google_java_format },
						javascript = { oxlint, oxfmt },
						javascriptreact = { oxlint, oxfmt },
						json = { oxlint, fixjson },
						jsonc = { oxlint, fixjson },
						lua = { luacheck, stylua },
						markdown = { oxfmt },
						sh = { shellcheck, shfmt },
						sql = { sqlfluff_lint, sqlfluff_format },
						typescript = { oxlint, oxfmt },
						typescriptreact = { oxlint, oxfmt },
					},
				},
			})
		end

		-- WARN: Required filetype definitions are setup using `ftdetect/*.lua` files.
		local lsp_servers = {
			"angularls",
			"clangd",
			"docker_compose_language_service",
			"efm",
			"gh_actions_ls",
			"glsl_analyzer",
			"gopls",
			"gradle_ls",
			"hyprls",
			"jsonls",
			"lua_ls",
			"sqlls",
			"tailwindcss",
			"ts_ls",
			"yamlls",
		}

		for _, server in ipairs(lsp_servers) do
			vim.lsp.enable(server)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
				map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
				map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("fzf-lua").lsp_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				map("<leader>co", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = { only = { "source.organizeImports" } },
					})
				end, "[C]ode [O]rganize Imports")

				map("<leader>crv", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = { only = { "refactor.extract.variable" } },
					})
				end, "[C]ode [R]efactor [V]ariable")

				map("<leader>crc", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = { only = { "refactor.extract.constant" } },
					})
				end, "[C]ode [R]efactor [C]onstant")

				map("<leader>crm", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = { only = { "refactor.extract.method" } },
					})
				end, "[C]ode [R]efactor [M]ethod", { "x" })
			end,
		})
	end,
}
