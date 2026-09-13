-- `root_dir` must point to the root of your project.
-- See `:help vim.fs.root`
local root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }) or vim.fn.getcwd()

-- Keyed by root_dir hash, not just the folder's basename: this monorepo has several unrelated
-- projects named "backend"/"frontend"/"main", and a bare basename would make them share one
-- jdtls workspace. Every switch between two differently-structured same-named projects would
-- force a full workspace project re-import, and if that ever got interrupted (kill, crash,
-- sleep), the shared workspace's metadata would be left corrupt and jdtls would refuse to start
-- for every project of that name.
local project_name = vim.fs.basename(root_dir) .. "-" .. vim.fn.sha256(root_dir):sub(1, 12)

local launcher_jar =
	vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

if launcher_jar == "" then
	error("Could not find the jdtls Equinox launcher JAR")
end

-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
	name = "jdtls",

	-- `cmd` defines the executable to launch eclipse.jdt.ls.
	-- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
	--
	-- As alternative you could also avoid the `jdtls` wrapper and launch
	-- eclipse.jdt.ls via the `java` executable
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=ALL",
		"-Xmx4G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens=java.base/java.util=ALL-UNNAMED",
		"--add-opens=java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
		"-jar",
		launcher_jar,
		"-configuration",
		vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_mac",
		"-data",
		vim.fn.stdpath("cache") .. "/jdtls/" .. project_name,
	},

	root_dir = root_dir,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-17",
						path = os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.17-amzn",
					},
					{
						name = "JavaSE-21",
						path = os.getenv("HOME") .. "/.sdkman/candidates/java/21.0.7-amzn",
					},
					{
						name = "JavaSE-25",
						path = os.getenv("HOME") .. "/.sdkman/candidates/java/25.0.2-amzn",
					},
				},
			},
		},
	},

	-- This sets the `initializationOptions` sent to the language server
	-- If you plan on using additional eclipse.jdt.ls plugins like java-debug
	-- you'll need to set the `bundles`
	--
	-- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on any eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {},
	},
}

local java_debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/*.jar"
local bundles = {
	vim.fn.glob(java_debug_adapter_path, true),
}

local java_test_path = vim.fn.stdpath("data") .. "/packages/vscode-java-test/server/*.jar"
local java_test_bundles = vim.split(vim.fn.glob(java_test_path, true), "\n")
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

config["init_options"] = {
	bundles = bundles,
}

vim.keymap.set("n", "<F6>", function()
	require("jdtls").test_class()
end, { desc = "Java: Test class" })

vim.keymap.set("n", "<F7>", function()
	require("jdtls").test_nearest_method()
end, { desc = "Java: Test nearest method" })

require("jdtls").start_or_attach(config)
