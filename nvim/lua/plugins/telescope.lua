local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail, parent)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      path_display = filenameFirst,
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "bottom",
        height = 0.95,
      },
    },
  },
  keys = {
    { "<leader>sf", "<cmd>:lua require('telescope.builtin').find_files()<cr>",  desc = "[S]earch [f]iles" },
    { "<leader>sg", "<cmd>:lua require('telescope.builtin').live_grep()<cr>",   desc = "[S]earch via [g]rep" },
    { "<leader>sh", "<cmd>:lua require('telescope.builtin').help_tags()<cr>",   desc = "[S]earch neovim [h]elp" },
    { "<leader>sc", "<cmd>:lua require('telescope.builtin').colorscheme()<cr>", desc = "[S]earch [c]olorschemes" },
    { "<leader>sp", "<cmd>:lua require('telescope.builtin').oldfiles()<cr>",    desc = "[S]earch [p]revious files" },
    { "<leader>sk", "<cmd>:lua require('telescope.builtin').keymaps()<cr>",     desc = "[S]earch [k]eymaps" },
  },
}
