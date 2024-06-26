local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- custom window bindings
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<S-Up>", ":resize +2<CR>", opts)
keymap("n", "<S-Down>", ":resize -2<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- nvim tree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- buffers
keymap("n", "]a", ":next<cr>", opts)
keymap("n", "[a", ":prev<cr>", opts)
keymap("n", "]A", ":first<cr>", opts)
keymap("n", "[A", ":last<cr>", opts)
keymap("n", "]b", ":bnext<cr>", opts)
keymap("n", "[b", ":bprev<cr>", opts)
keymap("n", "]B", ":blast<cr>", opts)
keymap("n", "[B", ":bfirst<cr>", opts)
keymap("n", "<leader>qab", ":bufdo bw<cr>", opts)
keymap("n", "<leader>qa!", ":bufdo bw!<cr>", opts)

-- telescope
keymap("n", "<leader>f", "<cmd>Telescope find_files no_ignore=true theme=dropdown<cr>", opts)
keymap("n", "<leader>rg", "<cmd>Telescope live_grep<cr>", opts)

-- formatting
local range_format = function()
    local start_row, _ = vim.api.nvim_buf_get_mark(0, "<")
    local end_row, _ = vim.api.nvim_buf_get_mark(0, ">")
    vim.lsp.buf.format({
        range = {
            ["start"] = { start_row, 0 },
            ["end"] = { end_row, 0 },
        },
        async = true,
        normal = true,
    })
end
vim.keymap.set("v", "<leader>F", range_format)
keymap("n", "<leader>F", ":lua vim.lsp.buf.format()<cr>", opts)

local function with_module(module_name, f)
    return function()
        local has_module, module = pcall(require, module_name)
        if has_module then
            f(module)
        end
    end
end

local function with_dap(f)
    return with_module("dap", f)
end

local function with_tc(f)
    return with_module("textcase", f)
end

local function change_current_word(to_case)
    return function(tc)
        tc.current_word(to_case)
    end
end

local function with_persistent_breakpoints(f)
    return with_module("persistent-breakpoints.api", f)
end

-- text-case
vim.keymap.set("n", "<leader>tcu", with_tc(change_current_word("to_upper_case")))
vim.keymap.set("n", "<leader>tcl", with_tc(change_current_word("to_lower_case")))
vim.keymap.set("n", "<leader>tcs", with_tc(change_current_word("to_snake_case")))
vim.keymap.set("n", "<leader>tcd", with_tc(change_current_word("to_dash_case")))
vim.keymap.set("n", "<leader>tcn", with_tc(change_current_word("to_constant_case")))
vim.keymap.set("n", "<leader>tcd", with_tc(change_current_word("to_dot_case")))
vim.keymap.set("n", "<leader>tca", with_tc(change_current_word("to_phrase_case")))
vim.keymap.set("n", "<leader>tcc", with_tc(change_current_word("to_camel_case")))
vim.keymap.set("n", "<leader>tcp", with_tc(change_current_word("to_pascal_case")))
vim.keymap.set("n", "<leader>tct", with_tc(change_current_word("to_title_case")))
vim.keymap.set("n", "<leader>tcf", with_tc(change_current_word("to_path_case")))

local dap_commands = {
    continue = with_dap(function(dap)
        dap.continue()
    end),
    step_over = with_dap(function(dap)
        dap.step_over()
    end),
    step_into = with_dap(function(dap)
        dap.step_into()
    end),
    step_out = with_dap(function(dap)
        dap.step_out()
    end),
    toggle_breakpoint = with_persistent_breakpoints(function(dap)
        dap.step_out()
    end),
    set_log_point = with_dap(function(dap)
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end),
    open_repl = with_dap(function(dap)
        dap.repl.open()
    end),
    debug_hover = with_dap(function(dap)
        dap.ui.widgets.hover()
    end),
    debug_preview = with_dap(function(dap)
        dap.ui.widgets.preview()
    end),
}

-- debugging
vim.keymap.set("n", "<F5>", dap_commands.continue)
vim.keymap.set("n", "<leader>do", dap_commands.step_over)
vim.keymap.set("n", "<leader>di", dap_commands.step_into)
vim.keymap.set("n", "<leader>dO", dap_commands.step_out)
vim.keymap.set("n", "<Leader>db", dap_commands.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dlp", dap_commands.set_log_point)
vim.keymap.set("n", "<Leader>dr", dap_commands.open_repl)
vim.keymap.set({ "n", "v" }, "<Leader>dh", dap_commands.debug_hover)
vim.keymap.set({ "n", "v" }, "<Leader>dp", dap_commands.debug_preview)
vim.keymap.set("n", "<Leader>dg", function()
    local has_dapui, dapui = pcall(require, "dapui")
    if has_dapui then
        dapui.toggle()
    end
end)

-- ai
if pcall(require, "chatgpt") then
    vim.keymap.set("v", "<leader>ai", function()
        require("chatgpt").edit_with_instructions()
    end)
    keymap("n", "<leader>ai", ":ChatGPT<cr>", opts)
end
