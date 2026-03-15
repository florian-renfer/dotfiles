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

		-- WARN: Required filetype definitions are setup using `ftdetect/*.lua` files.
		local lsp_servers = {
			"angularls",
			"clangd",
			"docker_compose_language_service",
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
			end,
		})
	end,
}
