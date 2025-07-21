return {
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	dependencies = {
		'mason-org/mason.nvim',
		'mason-org/mason-lspconfig.nvim'
	},
	opts = {
		ensure_installed = {
			"angularls",
			"docker_compose_language_service",
			"gh_actions_ls",
			"lua_ls",
			"jdtls",
			"postgres_lsp",
			"prettier",
			"tailwindcss",
			"ts_ls",
			"yamlls",
		},
	}
}
