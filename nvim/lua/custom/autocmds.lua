vim.api.nvim_create_autocmd("FileType", {
	pattern = "hyprlang",
	callback = function()
		vim.cmd "TSBufDisable highlight"
	end,
})
