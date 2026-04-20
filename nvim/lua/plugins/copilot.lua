local function find_agents_md_files()
	local files = vim.fn.glob("**/AGENTS.md", true, true)
	local resources = {}
	for _, file in ipairs(files) do
		table.insert(resources, "file:" .. file)
	end
	return resources
end

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			model = "gpt-5.4",
			window = {
				border = "rounded", -- 'single', 'double', 'rounded', 'solid'
				title = "🤖 AI Assistant",
			},
			headers = {
				user = "👤 Renfer, Florian",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},
			separator = "━━",
			auto_fold = true, -- Automatically folds non-assistant messages
			mappings = {
				reset = false,
				complete = {
					insert = "<S-Tab>",
					callback = function()
						require("CopilotChat.completion").complete()
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
							plan = {
								type = "string",
								description = "The markdown-formatted development plan to save or update.",
							},
						},
						required = { "plan" },
					},
					resolve = function(input, source)
						require("CopilotChat.utils").schedule_main()
						local plan_file = source.cwd() .. "/.copilot/plan.md"
						local dir = vim.fn.fnamemodify(plan_file, ":h")
						vim.fn.mkdir(dir, "p")

						local file = io.open(plan_file, "w")
						if file then
							file:write(input.plan)
							file:close()
						end

						return {
							{
								uri = "file://" .. plan_file,
								name = ".copilot/plan.md",
								mimetype = "text/markdown",
								data = input.plan,
							},
						}
					end,
				},
				agents = {
					description = "Find all AGENTS.md files in the project and return them as file resources.",
					schema = {
						type = "object",
						properties = {},
						additionalProperties = false,
					},
					resolve = function(_, source)
						require("CopilotChat.utils").schedule_main()
						local files = vim.fn.glob("**/AGENTS.md", true, true)
						local resources = {}
						for _, file in ipairs(files) do
							table.insert(resources, {
								uri = "file://" .. file,
								name = vim.fn.fnamemodify(file, ":t"),
								mimetype = "text/markdown",
							})
						end
						return resources
					end,
				},
			},
			prompts = {
				Doc = {
					prompt = "Write clear, concise, easy to read, easy to maintain, and developer focused documentation for all methods, including parameters, return types and exceptions or errors according to the given filestype and programming language. Follow industry standards and best-practices respectively.",
					system_prompt = "You are an expert Fullstack Software Enginierr proficient in every industry related programming language. You are aware of development patterns, widely used frameworks and libraries as well as the tooling for certain ecosystems. If required, you import required types, classes, etc. You don't like fully qualified names in your documentation if possible.",
					description = "Developer Documentation.",
					resources = {
						"buffer:active",
					},
				},
				Test = {
					prompt = [[
            You are tasked with writing comprehensive unit tests for the current codebase.

            When creating unit tests:
            - ALWAYS use the available tools to store and retrieve current test plans after each step
            - Start with a high-level overview of what is being tested
            - Break down into concrete test cases, covering all logic branches, edge cases, and error conditions
            - Identify dependencies, mocks, or fixtures required
            - Consider architectural or integration impacts
            - Note any prerequisites or setup steps
            - Estimate coverage and confidence levels
            - Format in markdown with clear sections

            Always end with:
            "Current Test Coverage Estimate: X%"
            "Would you like to proceed with implementation?" (only if coverage estimate >= 90%)
          ]],
					system_prompt = [[
            You are a proficient Test Automation Engineer focused on clear, actionable, and maintainable unit, integration and end-to-end tests.

            When writing tests:
            - Use best practices and conventions of the current codebase and language
            - Ensure all parameters, validation constraints, and edge cases are covered
            - Use descriptive names and comments
            - Prefer readability and maintainability
            - Track and communicate test coverage and confidence

            Always use the available tools to store and retrieve test plans and results.
          ]],
					description = "Unit tests.",
					resources = vim.tbl_extend("force", { "buffer:active" }, find_agents_md_files()),
					tools = {
						"copilot",
						"plan",
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
						"copilot",
						"plan",
					},
				},
			},
		},
		keys = {
			{ "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "[C]opilot Chat [T]oggle " },
		},
	},
}
