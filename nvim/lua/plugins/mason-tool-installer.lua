return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	opts = {
		ensure_installed = {
			"angularls",
			"docker_compose_language_service",
			"gh_actions_ls",
			"lua_ls",
			"jdtls",
			"java-debug-adapter",
			-- TODO:: 13.07.2026 Latest version not published to OpenVSX, therefore manual installation
			-- "java-test",
			"postgres_lsp",
			"prettier",
			"tailwindcss",
			"ts_ls",
			"yamlls",
		},
	},
}
