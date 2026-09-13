local M = {}

local function get_root_dir()
	local root_markers = {
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
	}

	return require("jdtls.setup").find_root(root_markers)
end

local function get_workspace_dir(root_dir)
	local project_name = vim.fs.basename(root_dir)
	local project_hash = vim.fn.sha256(root_dir):sub(1, 12)
	return vim.fn.stdpath("data") .. "/jdtls/workspace/" .. project_name .. "-" .. project_hash
end

local function collect_bundles(mason_packages)
	local bundles = {}
	local by_path = {}
	local function add(path)
		if path ~= "" and not by_path[path] then
			by_path[path] = true
			table.insert(bundles, path)
		end
	end

	local java_debug_bundles = vim.fn.glob(
		mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		0,
		1
	)
	for _, jar in ipairs(java_debug_bundles) do
		add(jar)
	end

	local asm_bundles = vim.fn.glob(mason_packages .. "/jdtls/plugins/org.objectweb.asm*.jar", 0, 1)
	for _, jar in ipairs(asm_bundles) do
		add(jar)
	end

	local java_test_dir = mason_packages .. "/java-test/extension/server"
	local java_test_jars = vim.fn.glob(java_test_dir .. "/*.jar", 0, 1)
	local deferred_plugin = {}
	local deferred_runtime = {}
	local excluded = {
		"com.microsoft.java.test.runner-jar-with-dependencies.jar",
		"jacocoagent.jar",
	}
	for _, jar in ipairs(java_test_jars) do
		local fname = vim.fn.fnamemodify(jar, ":t")
		if vim.tbl_contains(excluded, fname) then
			goto continue
		end

		if vim.startswith(fname, "com.microsoft.java.test.plugin-") then
			table.insert(deferred_plugin, jar)
		elseif
			vim.startswith(fname, "org.eclipse.jdt.junit4.runtime_")
			or vim.startswith(fname, "org.eclipse.jdt.junit5.runtime_")
			or vim.startswith(fname, "org.eclipse.jdt.junit6.runtime_")
			or vim.startswith(fname, "org.jacoco.core_")
		then
			table.insert(deferred_runtime, jar)
		else
			add(jar)
		end

		::continue::
	end

	for _, jar in ipairs(deferred_runtime) do
		add(jar)
	end
	for _, jar in ipairs(deferred_plugin) do
		add(jar)
	end

	return bundles
end

local function get_config_dir(mason_packages)
	local sysname = vim.uv.os_uname().sysname
	if sysname == "Darwin" then
		return mason_packages .. "/jdtls/config_mac"
	end
	if sysname == "Windows_NT" then
		return mason_packages .. "/jdtls/config_win"
	end
	return mason_packages .. "/jdtls/config_linux"
end

local function ensure_runtime_config_dir(mason_packages, root_dir)
	local base_config_dir = get_config_dir(mason_packages)
	local runtime_config_dir = vim.fn.stdpath("data") .. "/jdtls/config/" .. vim.fn.sha256(root_dir):sub(1, 12)

	if not vim.uv.fs_stat(runtime_config_dir .. "/config.ini") then
		vim.fn.mkdir(runtime_config_dir, "p")
		vim.fn.system({ "cp", "-R", base_config_dir .. "/.", runtime_config_dir })
		if vim.v.shell_error ~= 0 then
			vim.notify("JDTLS: failed to prepare runtime config dir", vim.log.levels.ERROR)
		end
	end

	-- Clear OSGi cache so stale extension bundles do not survive bundle-set changes.
	vim.fn.delete(runtime_config_dir .. "/org.eclipse.osgi", "rf")
	vim.fn.delete(runtime_config_dir .. "/org.eclipse.core.runtime", "rf")
	vim.fn.delete(runtime_config_dir .. "/org.eclipse.equinox.app", "rf")

	return runtime_config_dir
end

local function has_test_command(client)
	local execute = client.server_capabilities and client.server_capabilities.executeCommandProvider
	local commands = execute and execute.commands or {}
	local cmd_codelens = "vscode.java.test.search.codelens"
	local cmd_find_tests = "vscode.java.test.findTestTypesAndMethods"
	for _, command in ipairs(commands) do
		if command == cmd_codelens or command == cmd_find_tests then
			return true
		end
	end
	return false
end

local function set_java_keymaps(bufnr, jdtls, client, bundles)
	local missing_test_capability_warned = false
	vim.keymap.set("n", "<F6>", function()
		if not has_test_command(client) then
			if not missing_test_capability_warned then
				missing_test_capability_warned = true
				vim.notify("JDTLS: Java test command missing. Bundles loaded: " .. #bundles, vim.log.levels.ERROR)
			end
			return
		end
		jdtls.test_class()
	end, { buffer = bufnr, desc = "Debug: Test Java class" })

	vim.keymap.set("n", "<F7>", function()
		if not has_test_command(client) then
			if not missing_test_capability_warned then
				missing_test_capability_warned = true
				vim.notify("JDTLS: Java test command missing. Bundles loaded: " .. #bundles, vim.log.levels.ERROR)
			end
			return
		end
		jdtls.test_nearest_method()
	end, { buffer = bufnr, desc = "Debug: Test nearest Java method" })
end

function M.start_or_attach(bufnr)
	local ok, jdtls = pcall(require, "jdtls")
	if not ok then
		vim.notify("JDTLS: plugin not available", vim.log.levels.ERROR)
		return
	end

	local root_dir = get_root_dir()
	if not root_dir or root_dir == "" then
		vim.notify("JDTLS: project root not found", vim.log.levels.WARN)
		return
	end

	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
	local home = os.getenv("HOME")
	local launcher = vim.fn.glob(mason_packages .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
	if launcher == "" then
		vim.notify("JDTLS: launcher jar not found", vim.log.levels.ERROR)
		return
	end
	local bundles = collect_bundles(mason_packages)

	local config = {
		root_dir = root_dir,
		on_attach = function(client, buffer)
			local jdtls_dap = require("jdtls.dap")
			jdtls.setup_dap({ hotcodereplace = "auto" })
			jdtls_dap.setup_dap_main_class_configs()
			set_java_keymaps(buffer, jdtls, client, bundles)
		end,
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
		cmd = {
			home .. "/.sdkman/candidates/java/25.0.2-amzn/bin/java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.level=ALL",
			"-javaagent:" .. mason_packages .. "/jdtls/lombok.jar",
			"-Xmx4G",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			launcher,
			"-configuration",
			ensure_runtime_config_dir(mason_packages, root_dir),
			"-data",
			get_workspace_dir(root_dir),
		},
		settings = {
			java = {
				configuration = {
					runtimes = {
						{
							name = "JavaSE-17",
							path = home .. "/.sdkman/candidates/java/17.0.17-amzn",
						},
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
	}

	if vim.g.jdtls_debug_bundles == 1 then
		vim.notify("JDTLS bundles: " .. #bundles, vim.log.levels.INFO)
	end

	jdtls.start_or_attach(config)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("jdtls-java", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "java",
		callback = function(args)
			M.start_or_attach(args.buf)
		end,
	})

	if vim.bo.filetype == "java" then
		M.start_or_attach(vim.api.nvim_get_current_buf())
	end
end

return {}
