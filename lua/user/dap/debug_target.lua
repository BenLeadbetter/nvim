local M = {}

local has_telescope, _ = pcall(require, "telescope")
if not has_telescope then
    -- todo: fallback
    return M
end

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local function config_file()
    return vim.fn.getcwd() .. "/.nvim/dap_debug_target"
end

function M.debug_target()
    local file = io.open(config_file(), "r")
    if file then
        return file:read("*line")
    else
        vim.notify("Debug target not set", vim.log.levels.WARN)
        return ""
    end
end

local function set_debug_target(prompt_buf_number)
    local selected = actions_state.get_selected_entry()
    if selected[1] then
        local file = io.open(config_file(), "w")
        if file then
            file:write(selected[1])
            file:close()
        else
            vim.notify("Could not open config file", vim.log.levels.ERROR)
        end
    end
    actions.close(prompt_buf_number)
end

function M.input_debug_target()
    local search_dir = vim.fn.input("Search dir: ", vim.fn.getcwd() .. "/", "file")
    local opts = {
        find_command = { "fd", "--type", "x", "--no-ignore", "--color", "never", },
        cwd = search_dir,
        previewer = false,
        attach_mappings = function(_, map)
            map("i", "<CR>", set_debug_target)
            map("n", "<CR>", set_debug_target)
            return false
        end,
    }
    builtin.find_files(opts)
end

vim.cmd("command DapSetDebugTarget lua require('user.dap.debug_target').input_debug_target()")

return M
