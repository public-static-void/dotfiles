local status_ok, markdown = pcall(require, "markdown")
if not status_ok then
	return
end

markdown.setup({
	mkdp_filetypes = { "markdown" },
	mkdp_auto_start = 1,
})
