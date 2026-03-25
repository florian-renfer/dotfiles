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
	},
	config = function()
		local home = os.getenv("HOME")

		do
			local luacheck = require("efmls-configs.linters.luacheck")
			local stylua = require("efmls-configs.formatters.stylua")

			local prettier_d = require("efmls-configs.formatters.prettier_d")
			local eslint_d = require("efmls-configs.linters.eslint_d")

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

			google_java_format = vim.tbl_deep_extend("force", google_java_format, {
				-- The upstream range wrapper only partially reformats some Java buffers here.
				-- For save/manual formatting, full-buffer formatting is more reliable.
				-- TODO: check removal of aosp
				formatCanRange = false,
				formatCommand = google_java_format_executable .. " --aosp -",
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

			-- local go_revive = require("efmls-configs.linters.go_revive")
			-- local gofumpt = require("efmls-configs.formatters.gofumpt")

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
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				init_options = { documentFormatting = true },
				settings = {
					languages = {
						-- go = { gofumpt, go_revive },
						css = { prettier_d },
						html = { prettier_d },
						htmlangular = { prettier_d },
						java = { google_java_format },
						javascript = { eslint_d, prettier_d },
						javascriptreact = { eslint_d, prettier_d },
						json = { eslint_d, fixjson },
						jsonc = { eslint_d, fixjson },
						lua = { luacheck, stylua },
						markdown = { prettier_d },
						sh = { shellcheck, shfmt },
						typescript = { eslint_d, prettier_d },
						typescriptreact = { eslint_d, prettier_d },
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
			"jdtls",
			"java-debug-adapter",
			"java-test",
			"lua_ls",
			"tailwindcss",
			"ts_ls",
			"yamlls",
		}

		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

		local sysname = vim.uv.os_uname().sysname
		local config_dir = sysname == "Darwin" and home .. "/.local/share/nvim/mason/packages/jdtls/config_mac"
			or home .. "/.local/share/nvim/mason/packages/jdtls/config_linux"

		local jdtls_status, jdtls = pcall(require, "jdtls")
		if not jdtls_status then
			print("LSP: JDTLS setup failed")
			return
		end

		local java_debug = home
			.. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
		local bundles = {
			vim.fn.glob(java_debug, 1),
		}

		local java_test = home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar"
		local java_test_bundles = vim.split(vim.fn.glob(java_test, 1), "\n")
		local excluded = {
			"com.microsoft.java.test.runner-jar-with-dependencies.jar",
			"jacocoagent.jar",
		}
		for _, java_test_jar in ipairs(java_test_bundles) do
			local fname = vim.fn.fnamemodify(java_test_jar, ":t")
			if not vim.tbl_contains(excluded, fname) then
				table.insert(bundles, java_test_jar)
			end
		end

		vim.lsp.config("jdtls", {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.level=ALL",
				"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
				"-Xmx4G",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob(
					home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
				),
				"-configuration",
				config_dir,
				"-data",
				home .. "/.local/share/jdtls/workspace/" .. project_name,
			},
			settings = {
				java = {
					configuration = {
						runtimes = {
							{
								name = "JavaSE-17",
								path = home .. "/.sdkman/candidates/java/17.0.17-amzn",
							},
							-- NOTE: this is used on Arch Linux
							-- {
							--   name = "JavaSE-21",
							--   path = home .. "/.sdkman/candidates/java/21.0.8-amzn",
							-- },
							-- NOTE: this is used on macOS
							{
								name = "JavaSE-21",
								path = home .. "/.sdkman/candidates/java/21.0.7-amzn",
							},
							{
								name = "JavaSE-25",
								path = home .. "/.sdkman/candidates/java/25.0.2-amzn",
							},
						},
					},
				},
			},
			init_options = {
				bundles = bundles,
			},
		})

		for _, server in ipairs(lsp_servers) do
			vim.lsp.enable(server)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.name == "jdtls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

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
