-- Project-local editor configuration.
--
-- A project may drop a `./.nvim/bl_local_config.lua` returning a table of settings that
-- the rest of this config reads (build directory, QML import paths, ...). It is picked
-- up by `require("bl_local_config")`, which resolves because ~/.zprofile exports
-- LUA_PATH=".nvim/?.lua;" -- the same trick `.nvim/debug_config.lua` already uses.
--
-- Why not `.lazy.lua`? lazy.nvim reads that through `vim.secure.read`, so every edit
-- re-triggers the `:trust` prompt. This path never does.
--
-- Schema (every key optional):
--
--   return {
--     build_dir = "../build",       -- CMake build dir, relative to the project root
--     qml = {
--       import_paths = { "..." },   -- extra QML import paths, relative to build_dir
--       qt_root = "...",            -- default: Qt6_DIR from <build_dir>/CMakeCache.txt
--       doc_dir = "...",            -- default: $QT_DOC_DIR, else <qt_root>/doc
--       no_cmake_calls = true,      -- set false to let qmlls trigger CMake rebuilds
--     },
--   }

local MODULE = "bl_local_config"
local RELATIVE_PATH = ".nvim/" .. MODULE .. ".lua"

---@type table<string, string>
local SCHEMA = {
	build_dir = "string",
	qml = "table",
}

local M = {}

local cache = nil

local function warn(message)
	vim.notify(RELATIVE_PATH .. ": " .. message, vim.log.levels.WARN)
end

--- The project root. LUA_PATH is resolved against the working directory, and
--- `lua/plugins/persistence.lua` makes the same assumption for `.nvim/sessions/`.
---@return string
function M.root()
	return vim.uv.cwd()
end

--- Absolute, symlink-resolved path with no trailing slash.
---@param path string?
---@param base string? defaults to the project root
---@return string?
function M.path(path, base)
	if path == nil or path == "" then
		return nil
	end
	if not vim.startswith(path, "/") and not vim.startswith(path, "~") then
		path = (base or M.root()) .. "/" .. path
	end
	local absolute = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
	return (vim.fn.resolve(absolute):gsub("/$", ""))
end

local function validate(config)
	for key, value in pairs(config) do
		local expected = SCHEMA[key]
		if not expected then
			warn(("unknown key `%s`"):format(key))
		elseif type(value) ~= expected then
			warn(("`%s` should be a %s, got %s"):format(key, expected, type(value)))
			config[key] = nil
		end
	end
end

local function load()
	local path = M.root() .. "/" .. RELATIVE_PATH
	if not vim.uv.fs_stat(path) then
		return {}
	end

	local ok, config = pcall(require, MODULE)
	if not ok then
		-- LUA_PATH comes from ~/.zprofile, which only login shells source. Read the
		-- file directly so the mechanism still works elsewhere -- and so a syntax
		-- error in it gets reported rather than swallowed by the failed require.
		local chunk, err = loadfile(path)
		if not chunk then
			warn(err)
			return {}
		end
		ok, config = pcall(chunk)
		if not ok then
			warn(config)
			return {}
		end
	end

	if type(config) ~= "table" then
		warn(("expected the file to return a table, got %s"):format(type(config)))
		return {}
	end

	validate(config)
	return config
end

--- The project-local config, or an empty table when there is none.
---@return table
function M.get()
	if cache == nil then
		cache = load()
	end
	return cache
end

--- The configured CMake build directory, or nil when unset or missing on disk.
---@return string?
function M.build_dir()
	local build_dir = M.path(M.get().build_dir)
	if build_dir and vim.fn.isdirectory(build_dir) == 1 then
		return build_dir
	end
	return nil
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("bl_local_config", { clear = true }),
	pattern = "*/" .. RELATIVE_PATH,
	callback = function()
		cache = nil
		package.loaded[MODULE] = nil
		vim.notify(
			"Reloaded " .. RELATIVE_PATH .. " -- run :LspRestart to re-apply LSP settings",
			vim.log.levels.INFO
		)
	end,
})

-- Debugging aid: shows what was loaded and how it resolved.
vim.api.nvim_create_user_command("LocalConfig", function()
	vim.print({
		root = M.root(),
		path = M.root() .. "/" .. RELATIVE_PATH,
		loaded = M.get(),
		build_dir = M.build_dir(),
	})
end, { desc = "Show the project-local config (.nvim/bl_local_config.lua)" })

return M
