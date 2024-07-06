if vim.g.vscode then
    return
end

require("user.options")
require("user.keymaps")
require("user.lazy")
require("user.colorscheme")
-- require("user.cmp")
-- require("user.dap")
-- require("user.spelling")
-- require("user.tabnine")
-- require("user.chatgpt") -- fixme
