local server_map = {
    python = "pyright",
    rust = "rust_analyzer",
    c = "clangd",
    cpp = "clangd",
    lua = "lua_ls",
}

local setup_servers = {}

local function get_server_ops(server)
    local opts = {
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

local function reload_buffers_for_server(server)
    local server_filetype = ""
    for filetype, filetype_server in pairs(server_map) do
        if server == filetype_server then
            server_filetype = filetype
        end
    end

    assert(server_filetype ~= "")

    local buffers = vim.api.nvim_list_bufs()
    for _, buffer_number in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buffer_number) then
            local buffer_filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer_number })
            if server_filetype == buffer_filetype then
                vim.api.nvim_buf_call(buffer_number, function()
                    vim.cmd('edit!')
                end)
            end
        end
    end
end

local function ensure_server_setup(server)
    if not setup_servers[server] then
        require("lspconfig")[server].setup(get_server_ops(server))
        setup_servers[server] = true
        reload_buffers_for_server(server)
    end
end

local function install_and_setup(server)
    local server_id_map = require("mason-lspconfig").get_mappings().lspconfig_to_mason
    local server_package = require("mason-registry").get_package(server_id_map[server])
    assert(not server_package:is_installed())
    local install_handle = server_package:install()
    install_handle:on("state:change", function()
        if install_handle:is_closed() then
            vim.schedule(function()
                ensure_server_setup(server)
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
        ensure_server_setup(server)
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
