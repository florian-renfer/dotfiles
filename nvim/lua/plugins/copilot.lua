return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      window = {
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        title = '🤖 AI Assistant',
      },
      headers = {
        user = '👤 Renfer, Florian',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },
      separator = '━━',
      auto_fold = true, -- Automatically folds non-assistant messages
      mappings = {
        reset = false,
        complete = {
          insert = '<S-Tab>',
          callback = function()
            require('CopilotChat.completion').complete()
          end,
        },
      },
      functions = {
        plan = {
          description = [[
            Store the provided markdown-formatted development plan as a file resource (.copilot/plan.md).
            Returns the plan file resource for future reference and actions.

            This plan can be updated iteratively as the project evolves.
            Use the latest saved plan as a reference for all future development actions and tool calls.
          ]],
          schema = {
            type = "object",
            properties = {
              plan = { type = "string", description = "The markdown-formatted development plan to save or update." },
            },
            required = { "plan" },
          },
          resolve = function(input, source)
            require('CopilotChat.utils').schedule_main()
            local plan_file = source.cwd() .. '/.copilot/plan.md'
            local dir = vim.fn.fnamemodify(plan_file, ':h')
            vim.fn.mkdir(dir, 'p')

            local file = io.open(plan_file, 'w')
            if file then
              file:write(input.plan)
              file:close()
            end

            return {
              {
                uri = 'file://' .. plan_file,
                name = '.copilot/plan.md',
                mimetype = 'text/markdown',
                data = input.plan,
              }
            }
          end,
        }
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
        Plan = {
          system_prompt = [[
            You are a software architect and technical planner focused on clear, actionable development plans.

            When creating development plans:
            - ALWAYS use plan tool to store and retrieve current plan after each step
            - Start with a high-level overview
            - Break down into concrete implementation steps
            - Identify potential challenges and their solutions
            - Consider architectural impacts
            - Note required dependencies or prerequisites
            - Estimate complexity and effort levels
            - Track confidence percentage (0-100%)
            - Format in markdown with clear sections

            Always end with:
            "Current Confidence Level: X%"
            "Would you like to proceed with implementation?" (only if confidence >= 90%)
          ]],
          tools = {
            "copilot", "plan"
          },
        },
      },
    },
    keys = {
      { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "[C]opilot Chat [T]oggle " },
    },
  },
}
