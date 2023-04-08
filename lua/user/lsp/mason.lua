local servers = {"clangd", "lua_ls", "pyright", "rust_analyzer"}

local settings = {
    ui = {
        border = "none",
        icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍"
        }
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then return end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities
    }

    server = vim.split(server, "@")[1]

    local has_global_opts, global_opts = pcall(require,
                                               "user.lsp.server_settings." ..
                                                   server)
    if has_global_opts then
        opts = vim.tbl_deep_extend("force", global_opts, opts)
    end

    local has_local_opts, local_opts = pcall(require,
                                             "local.lsp.server_settings." ..
                                                 server)
    if has_local_opts then
        opts = vim.tbl_deep_extend("force", local_opts, opts)
    end

    --[[
    
    print(string.format("** %s **", server))

    local function print_ops(o, indent)
        for key, opt in pairs(o) do
            print(string.rep(" ", indent) .. string.format("key:%s val:%s", key, opt))
            if type(opt) == "table" then
                print_ops(opt, indent + 1)
            end
        end
    end
    print_ops(opts, 0)

    ]] --

    lspconfig[server].setup(opts)
end
