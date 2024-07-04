return {
    "williamboman/mason.nvim",
    cmd = {
        "Mason",
        "MasonUpdate",
        "MasonInstall",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
    },
    opts = {
        ui = {
            border = "none",
            icons = {
                package_installed = "◍",
                package_pending = "◍",
                package_uninstalled = "◍",
            },
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
    },
}

