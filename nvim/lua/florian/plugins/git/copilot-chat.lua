return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {},
    keys = {
      { "<leader>cc", function() require("CopilotChat").toggle() end, desc = "Toggle [c]opilot chat" }
    },
  },
}