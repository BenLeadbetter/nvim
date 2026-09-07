-- QML Language Server. https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
--
-- Driven entirely by `.nvim/bl_local_config.lua` (see lua/user/local-config.lua).
-- qmlls has to match the Qt the project was built against -- otherwise its
-- builtins.qmltypes and the shipped QML modules disagree with the build output -- so the
-- Qt prefix is read out of the build rather than hardcoded, and if none can be resolved
-- the server is left unregistered instead of falling back to some other qmlls.

local local_config = require("user.local-config")

---@param build_dir string
---@return string? qt prefix, from <prefix>/lib/cmake/Qt6
local function qt_root_from_cache(build_dir)
	local cache = build_dir .. "/CMakeCache.txt"
	if vim.fn.filereadable(cache) ~= 1 then
		return nil
	end
	for _, line in ipairs(vim.fn.readfile(cache)) do
		local qt6_dir = line:match("^Qt6_DIR:PATH=(.+)$")
		if qt6_dir then
			return vim.fn.fnamemodify(qt6_dir, ":h:h:h")
		end
	end
	return nil
end

---@return string?
local function resolve_qt_root(cfg, build_dir)
	local explicit = local_config.path(cfg.qt_root)
	if explicit then
		return explicit
	end
	if build_dir then
		return qt_root_from_cache(build_dir)
	end
	return nil
end

--- Hover documentation only works against a built Qt doc tree. The static Qt packages
--- ship a doc/ directory without the generated docs, so probe for a real one.
---@return string?
local function resolve_doc_dir(cfg, qt_root)
	local candidates = {}
	for _, candidate in ipairs({ cfg.doc_dir, vim.env.QT_DOC_DIR, qt_root .. "/doc" }) do
		if candidate and candidate ~= "" then
			table.insert(candidates, candidate)
		end
	end
	for _, candidate in ipairs(candidates) do
		if vim.fn.isdirectory(candidate .. "/qtqml") == 1 then
			return candidate
		end
	end
	return nil
end

---@return string[]? argv, or nil when no usable qmlls could be resolved
local function qmlls_cmd()
	local cfg = local_config.get().qml or {}
	local build_dir = local_config.build_dir()

	local qt_root = resolve_qt_root(cfg, build_dir)
	if not qt_root then
		return nil
	end

	local qmlls = qt_root .. "/bin/qmlls"
	if vim.fn.executable(qmlls) ~= 1 then
		return nil
	end

	local cmd = { qmlls }

	if build_dir then
		-- Lets qmlls map a source file back to its CMake target, so C++-registered
		-- types (QML_ELEMENT etc.) and generated .qmltypes resolve.
		vim.list_extend(cmd, { "--build-dir", build_dir })
	end

	-- Qt's own modules (QtQuick, QtQuick.Controls, Qt5Compat.GraphicalEffects, ...).
	vim.list_extend(cmd, { "-I", qt_root .. "/qml" })

	-- The project's own modules. Where qt_add_qml_module() writes them is a per-project
	-- decision (QT_QML_OUTPUT_DIRECTORY is a plain CMake variable, so it never reaches
	-- CMakeCache.txt), which is why this has to be declared rather than inferred.
	for _, import_path in ipairs(cfg.import_paths or {}) do
		vim.list_extend(cmd, { "-I", local_config.path(import_path, build_dir) })
	end

	-- Generated .qmlls.ini files are gitignored and machine specific, so they easily
	-- outlive the configure that wrote them: stale Qt versions, per-target build dirs,
	-- CI doc paths. Everything qmlls needs is passed explicitly above.
	table.insert(cmd, "--ignore-settings")

	if cfg.no_cmake_calls ~= false then
		-- Keeps qmlls from triggering CMake rebuilds while editing. Set
		-- `no_cmake_calls = false` to have C++ type registrations refresh
		-- automatically, at the cost of background builds.
		table.insert(cmd, "--no-cmake-calls")
	end

	local doc_dir = resolve_doc_dir(cfg, qt_root)
	if doc_dir then
		vim.list_extend(cmd, { "--doc-dir", doc_dir })
	end

	return cmd
end

return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		local cmd = qmlls_cmd()
		if not cmd then
			return opts
		end

		opts.servers = opts.servers or {}
		opts.servers.qmlls = opts.servers.qmlls or {}
		opts.servers.qmlls.cmd = cmd
		-- Never route through mason: its qmlls is built against whatever Qt mason
		-- shipped, not the Qt this project builds with.
		opts.servers.qmlls.mason = false

		return opts
	end,
}
