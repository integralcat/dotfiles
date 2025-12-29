vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true })
end, {})

vim.api.nvim_create_user_command("T", function()
	vim.fn.jobstart({
		"alacritty",
	}, {
		detach = true,
	})
end, {})

-- alias for `:Compile rs`
vim.api.nvim_create_user_command("Crs", function()
	vim.cmd("Compile rs")
end, {})

-- alias for `:Compile hs`
vim.api.nvim_create_user_command("Chs", function()
	vim.cmd("Compile hs")
end, {})

vim.api.nvim_create_user_command("Compile", function(opts)
	local lang = opts.args

	local commands = {
		hs = "ghci " .. vim.api.nvim_buf_get_name(0),
		rs = "cargo run",
	}

	local cmd = commands[lang]

	if not cmd then
		print("Unknown language: " .. lang)
		return
	end

	vim.fn.jobstart({
		"alacritty",
		"--hold",
		"-e",
		"sh",
		"-c",
		cmd,
	}, {
		detach = true,
	})
end, {
	nargs = 1,
	complete = function()
		return { "rs" }
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})
