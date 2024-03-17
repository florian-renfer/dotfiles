return {
  {
    "mfussenegger/nvim-jdtls",
    ---@type lspconfig.options.jdtls
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      jdtls = function(opts)
        local jvmArg = "-javaagent:/Users/florianrenfer/Downloads/lombok-edge.jar"

        table.insert(opts.cmd, "--jvm-arg=" .. jvmArg)

        return opts
      end,
    },
  },
}
