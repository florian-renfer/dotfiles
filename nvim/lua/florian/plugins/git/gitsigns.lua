return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "[S]tage current hunk" },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "[R]eset current hunk" },
    { "<leader>hb", function() require("gitsigns").blame_line({full=true}) end, desc = "[B]lame current line" },
    { "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, desc = "[T]oggle current line blame" },
  }
}
