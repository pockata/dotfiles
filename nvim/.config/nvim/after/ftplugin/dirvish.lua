vim.defer_fn(function()
	vim.cmd(":call dirvish_git#init()")
end, 0)
