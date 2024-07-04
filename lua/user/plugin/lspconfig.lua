local server_map = {
    python = "pyright",
    rust = "rust_analyzer",
    c = "clangd",
    cpp = "clangd",
}

local setup_servers = {}

local function get_server_ops(server)
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	local has_global_opts, global_opts = pcall(require, "user.lsp.server_settings." .. server)
	if has_global_opts then
		opts = vim.tbl_deep_extend("force", global_opts, opts)
	end

	local has_local_opts, local_opts = pcall(require, "local.lsp.server_settings." .. server)
	if has_local_opts then
		opts = vim.tbl_deep_extend("force", local_opts, opts)
	end

    return opts
end

local function restart_lsp(buffer_number)
    vim.api.nvim_buf_call(buffer_number, function()
        vim.cmd('edit!')
    end)
end

local function ensure_server_setup(server, triggering_buffer_number)
    if not setup_servers[server] then
        require("lspconfig")[server].setup(get_server_ops(server))
        setup_servers[server] = true
        restart_lsp(triggering_buffer_number)
    end
end

local function install_and_setup(server)
    local server_id_map = require("mason-lspconfig").get_mappings().lspconfig_to_mason
    local server_package = require("mason-registry").get_package(server_id_map[server])
    assert(not server_package:is_installed())
    local install_handle = server_package:install()
    local buffer_number = vim.api.nvim_get_current_buf();
    install_handle:on("state:change", function() 
        if install_handle:is_closed() then
            vim.schedule(function() 
                ensure_server_setup(server, buffer_number) 
            end)
        end
    end)
end

local function is_installed(server)
    local server_id_map = require("mason-lspconfig").get_mappings().lspconfig_to_mason
    local server_package = require("mason-registry").get_package(server_id_map[server])
    return server_package:is_installed()
end

local function initialise_server(server)
    if is_installed(server) then
        ensure_server_setup(server, vim.api.nvim_get_current_buf())
    else
        install_and_setup(server)
    end
end

local function ensure_lsp_plugins_loaded()
    vim.cmd('doautocmd User LoadLspPlugins')
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local server = server_map[vim.bo.filetype]
        if not server then
            return
        end

        ensure_lsp_plugins_loaded()

        if pcall(require, "lspconfig") then
            -- lspconfig already loaded
            -- setup additional server
            initialise_server(server)
        end
    end,
})

return {
    "neovim/nvim-lspconfig",
    event = "User LoadLspPlugins",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function() 
        initialise_server(server_map[vim.bo.filetype])
    end
}
