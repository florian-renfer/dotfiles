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

local java_debug = home ..
    "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
local bundles = {
  vim.fn.glob(java_debug, 1)
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

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xmx1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    config_dir,
    "-data",
    home .. "/.local/share/jdtls/workspace/" .. project_name,
  },
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-17",
            path = home .. "/.sdkman/candidates/java/17.0.17-amzn",
          },
          {
            name = "JavaSE-21",
            path = home .. "/.sdkman/candidates/java/21.0.8-amzn",
          },
          -- NOTE: this is used on macOS
          -- {
          -- 	name = "JavaSE-21",
          -- 	path = home .. "/.sdkman/candidates/java/21.0.7-amzn",
          -- },
        },
      },
    },
  },
  root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
  init_options = {
    bundles = bundles
  },
}

jdtls.start_or_attach(config)

vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
  "v",
  "<leader>crv",
  "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
  { desc = "Extract Variable" }
)
vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
vim.keymap.set(
  "v",
  "<leader>crc",
  "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
  { desc = "Extract Constant" }
)
vim.keymap.set(
  "v",
  "<leader>crm",
  "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
  { desc = "Extract Method" }
)
