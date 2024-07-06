local function get_server_ops(server)
    local handlers = require("user.lsp.handlers")
    local opts = {
        on_attach = handlers.on_attach,
        capabilities = handlers.capabilities,
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

-- formatting
local range_format = function()
    local start_row, _ = vim.api.nvim_buf_get_mark(0, "<")
    local end_row, _ = vim.api.nvim_buf_get_mark(0, ">")
    vim.lsp.buf.format({
        range = {
            ["start"] =  start_row,
            ["end"] = end_row,
        },
        async = true,
        normal = true,
    })
end

local function set_formatting_keymaps()
        vim.keymap.set("v", "<leader>F", range_format)
        vim.api.nvim_set_keymap("n", "<leader>F", ":lua vim.lsp.buf.format()<cr>", { noremap = true, silent = true })
end

return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimtools/none-ls.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        for _, server in pairs(require("user.lsp.servers")) do
            lspconfig[server].setup(get_server_ops(server))
        end
        set_formatting_keymaps()
    end,
}
