return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
        ensure_installed = require("user.lsp.servers"),
        automatic_installation = true,
    }
}
