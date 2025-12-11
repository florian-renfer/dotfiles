return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      go = { "gofmt" },
      html = { "prettier" },
      htmlangular = { "prettier" },
      java = { "google-java-format" },
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      sql = { "pg_format" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "yamlfmt" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 2500 },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
