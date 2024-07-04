return {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
        local notify = require("notify")

        notify.setup({
            max_width = 80,
            render = "compact",
            stages = "static",
            top_down = false,
        })
        vim.notify = notify
    end
}
