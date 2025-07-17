return {
	-- Highlighting
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>"),

	-- Buffer management
	vim.keymap.set("n", "<leader>ba", ":%bd<CR>", { desc = "Delete [a]ll open buffers" }),
	vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "[D]elete current buffer" }),
	vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "[N]ew buffer" }),

	-- Window management
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" }),
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" }),
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" }),
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" }),

	-- Diagnostics
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" }),
}
