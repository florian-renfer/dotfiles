local jdtls_status, jdtls = pcall(require, 'jdtls')
local mason_status, mason = pcall(require, 'mason-registry')

if not jdtls_status then
  vim.notify 'jdtls not found'
  return
end

if not mason_status then
  vim.notify 'mason not found'
  return
end

-- mason.nvim jdtls path
local JDTLS_PATH = mason.get_package('jdtls'):get_install_path()

-- lombok snapshot path
local LOMBOK_EDGE_PATH = os.getenv 'HOME' .. '/lib/lombok-edge-1.18.36.jar'

-- Workspace
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local JDTLS_DATA = os.getenv 'XDG_DATA_HOME' .. '/jdtls/' .. project_name

-- Additional capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',

    -- use when lombok.jar shipped with jdtls provided by mason.nvim is fixed
    -- '-javaagent:'
    --   .. JDTLS_PATH
    --   .. '/lombok.jar',
    '-javaagent:' .. LOMBOK_EDGE_PATH,

    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    vim.fn.glob(JDTLS_PATH .. '/plugins/org.eclipse.equinox.launcher_*.jar', true),

    '-configuration',
    JDTLS_PATH .. '/config_mac',

    '-data',
    JDTLS_DATA,
  },
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = false,
      },
      references = {
        includeDecompiledSources = true,
      },
    },
    signatureHelp = { enabled = true },
    -- completion = {
    --     favoriteStaticMembers = {
    --         "org.hamcrest.MatcherAssert.assertThat",
    --         "org.hamcrest.Matchers.*",
    --         "org.hamcrest.CoreMatchers.*",
    --         "org.junit.jupiter.api.Assertions.*",
    --         "java.util.Objects.requireNonNull",
    --         "java.util.Objects.requireNonNullElse",
    --         "org.mockito.Mockito.*",
    --     },
    -- },
    contentProvider = { preferred = 'fernflower' },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  -- init_options = {
  --     -- Enable debugging
  --     bundles = bundles,
  -- },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)

-- Keymaps
vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })
