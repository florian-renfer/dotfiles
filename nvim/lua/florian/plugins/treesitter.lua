return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "angular", "css", "go", "html", "java","lua", "markdown", "markdown_inline", "typescript" },
  },
}
