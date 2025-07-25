return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Adds the current buffer to harpoon
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add buffer to Harpoon list" })

		-- Open harpoon
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Open Harpoon list" })

		-- Jump to the first buffer
		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(1)
		end)

		-- Jump to the second buffer
		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end)

		-- Jump to the third buffer
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(3)
		end)

		-- Jump to the fourth buffer
		vim.keymap.set("n", "<C-s>", function()
			harpoon:list():select(4)
		end)

		-- Toggle previous buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)

		-- Toggle next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)
	end,
}
