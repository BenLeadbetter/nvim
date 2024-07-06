if vim.g.vscode then
    return
end

require("user.options")
require("user.keymaps")
require("user.lazy")
require("user.colorscheme")
-- require("user.dap")
-- require("user.spelling")
-- require("user.chatgpt") -- fixme
