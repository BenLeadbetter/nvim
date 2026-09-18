-- Debug configurations for compiled targets, driven by `.nvim/bl_local_config.lua`.
--
-- The launch parameters of a native binary -- which executable, which arguments, which
-- source map back onto the build machine's paths -- are inherently per-checkout, so they
-- live in the project rather than here (see lua/user/local-config.lua):
--
--	 return {
--	   build_dir = "../build",
--	   debug = {
--		 program = "path/to/binary",			  -- relative paths resolve against build_dir
--		 args = { "--platform", "offscreen" },
--		 env = { QT_LOGGING_RULES = "..." },
--		 cwd = "...",							  -- default: build_dir
--		 source_maps = { ["/build/machine/src"] = "local/src" },
--		 pre_run_commands = { ... },			  -- default: DEFAULT_PRE_RUN_COMMANDS below
--		 filetypes = { ... },					  -- default: FILETYPES below
--	   },
--	 }
--
-- Every field is read through a function, so `:w`ing the project config takes effect on the
-- next `<leader>dc` -- no restart, unlike the LSP `cmd` in lua/plugins/qmlls.lua.
--
-- The `codelldb` adapter itself comes from LazyVim's clangd extra, which is imported
-- before this file in lua/config/lazy.lua.

local local_config = require("user.local-config")

-- Superset of LazyVim's { "c", "cpp" }: objc/objcpp for the Apple frameworks, `qml` so a
-- session can be started from a QML buffer, and "" for buffers with no filetype at all.
local FILETYPES = { "", "c", "cpp", "objc", "objcpp", "qml" }

local DEFAULT_PRE_RUN_COMMANDS = {
	-- Something in the Qt/LLDB setup arms a break on every C++ throw *and* catch, which
	-- makes stepping through Qt code impossible. Disarm it before the process starts.
	"breakpoint delete cpp_exception",
}

-- Superseded by the `debug` key above. Read for as long as older checkouts still carry it;
-- when both exist, `bl_local_config.debug` wins.
local LEGACY_PATH = ".nvim/debug_config.lua"

---@return table?
local function legacy_settings()
	local path = local_config.root() .. "/" .. LEGACY_PATH
	if not vim.uv.fs_stat(path) then
		return nil
	end
	-- Deliberately not `require`d: re-reading from disk on every session start keeps the
	-- edit-and-rerun loop working without any cache to invalidate.
	local chunk, err = loadfile(path)
	if not chunk then
		vim.notify(LEGACY_PATH .. ": " .. err, vim.log.levels.WARN)
		return nil
	end
	local ok, settings = pcall(chunk)
	if not ok or type(settings) ~= "table" then
		return nil
	end
	return settings
end

---@return table
local function settings()
	return local_config.get().debug or legacy_settings() or {}
end

--- Where a relative path in the debug settings is anchored: the build directory, since
--- that is where the binaries these settings point at are written.
---@return string
local function base()
	return local_config.build_dir() or local_config.root()
end

--- codelldb rejects an empty table where it expects a map or a list, and there is no way
--- to tell the two apart once encoded -- so send nothing instead.
---@generic T: table
---@param map T?
---@return T?
local function nil_if_empty(map)
	if map == nil or next(map) == nil then
		return nil
	end
	return map
end

---@return string
local function program()
	local configured = local_config.path(settings().program, base())
	if configured then
		return configured
	end
	-- No project config: behave like LazyVim's stock "Launch file", but offer the build
	-- directory rather than the source root as the starting point.
	return vim.fn.input("Path to executable: ", base() .. "/", "file")
end

---@return string
local function cwd()
	return local_config.path(settings().cwd, base()) or base()
end

--- Maps the absolute source paths baked into the build machine's debug info onto this
--- checkout. Keys are the build machine's paths and stay verbatim; only the local side is
--- resolved, against the project root.
---@return table<string, string>?
local function source_map()
	local maps = settings().source_maps
	if maps == nil then
		return nil
	end
	local resolved = {}
	for remote, local_path in pairs(maps) do
		resolved[remote] = local_config.path(local_path) or local_path
	end
	return nil_if_empty(resolved)
end

---@return table[]
local function configurations()
	local pre_run_commands = settings().pre_run_commands or DEFAULT_PRE_RUN_COMMANDS
	return {
		{
			name = "LLDB Launch From Config",
			type = "codelldb",
			request = "launch",
			program = program,
			cwd = cwd,
			sourceMap = source_map,
			env = function()
				return nil_if_empty(settings().env)
			end,
			args = function()
				return nil_if_empty(settings().args)
			end,
			preRunCommands = pre_run_commands,
		},
		{
			name = "Attach to process",
			type = "codelldb",
			request = "attach",
			pid = require("dap.utils").pick_process,
			cwd = cwd,
			sourceMap = source_map,
			preRunCommands = pre_run_commands,
		},
	}
end

return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>dL",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log Point",
			},
		},
		-- Runs after LazyVim's clangd extra -- lua/config/lazy.lua imports `plugins` last --
		-- so this replaces its two stock c/cpp entries rather than appending to them.
		opts = function()
			local dap = require("dap")
			for _, filetype in ipairs(settings().filetypes or FILETYPES) do
				-- A fresh list per filetype: mason-nvim-dap appends its own codelldb entries
				-- from nvim-dap's `config`, i.e. after this, and one shared table would then
				-- collect an append for every language it handles.
				dap.configurations[filetype] = configurations()
			end
		end,
	},
}
