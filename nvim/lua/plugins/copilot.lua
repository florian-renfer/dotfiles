return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      mappings = {
        reset = false,
      },
      prompts = {
        Test = {
          prompt =
          'Write comprehensive unit tests, following patterns, conventions and practices in the current codebase. Be sure to cover all cases, edge cases and exceptions. Add @DisplayName to all tests. Always follow the naming convention <method>Should<expected>When<condition>. In case method parameters have validation constraints or annotations, add test cases ensuring all possible cases too.',
          system_prompt = 'You are a proficient Testautomation Engineer.',
          description = 'Unit tests.',
          resources = {
            'files:all',
            'buffer:active',
          },
        },
      }
    },
    keys = {
      { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle [C]opilot [C]hat" },
    },
  },
}
