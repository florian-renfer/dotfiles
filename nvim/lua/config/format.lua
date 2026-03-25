local M = {}

local function is_real_file_buffer(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return false
	end
	if not vim.bo[bufnr].modifiable then
		return false
	end
	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return false
	end

	return true
end

local function pick_formatter(bufnr)
	local has_efm = false

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.name == "efm" and client:supports_method("textDocument/formatting") then
			has_efm = true
			break
		end
	end

	if has_efm then
		return "efm"
	end

	return nil
end

function M.format_buffer(bufnr, opts)
	opts = opts or {}

	if not is_real_file_buffer(bufnr) then
		return false
	end

	local formatter = pick_formatter(bufnr)
	if not formatter then
		if opts.notify_missing then
			vim.notify(
				("No efm formatter is attached for %s"):format(vim.bo[bufnr].filetype),
				vim.log.levels.WARN
			)
		end
		return false
	end

	local ok, err = pcall(vim.lsp.buf.format, {
		bufnr = bufnr,
		timeout_ms = opts.timeout_ms or 4000,
		async = opts.async or false,
		filter = function(client)
			return client.name == formatter
		end,
	})

	if not ok then
		vim.notify(("Formatting with %s failed: %s"):format(formatter, err), vim.log.levels.ERROR)
		return false
	end

	return true
end

return M
