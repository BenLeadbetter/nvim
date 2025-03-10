local root = nil

local function git_root()
	if root then
		return root
	end
	local has_plenary_path, plenary_path = pcall(require, "plenary.path")
	if not has_plenary_path then
		return nil
	end
	root  = plenary_path:new(vim.loop.cwd()):find_upwards(".git")
    if not root then
        vim.notify("Couldn't determine git root", vim.log.levels.WARN)
    end
    return root
end

return git_root
