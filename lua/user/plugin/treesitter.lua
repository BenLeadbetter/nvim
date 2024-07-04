return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    version = false,
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
        "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "asm",
                "bash",
                "c",
                "clojure",
                "cmake",
                "commonlisp",
                "cpp",
                "css",
                "csv",
                "cuda",
                "d",
                "dart",
                "disassembly",
                "dockerfile",
                "doxygen",
                "elixir",
                "elm",
                "erlang",
                "faust",
                "fish",
                "fortran",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "glsl",
                "gnuplot",
                "go",
                "graphql",
                "groovy",
                "haskell",
                "html",
                "http",
                "java",
                "javascript",
                "json",
                "julia",
                "latex",
                "llvm",
                "lua",
                "markdown",
                "nim",
                "objc",
                "pascal",
                "printf",
                "python",
                "qmldir",
                "qmljs",
                "r",
                "regex",
                "ruby",
                "rust",
                "scheme",
                "slint",
                "sql",
                "supercollider",
                "svelte",
                "swift",
                "todotxt",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "wgsl",
                "wgsl_bevy",
                "xml",
                "yaml",
                "zig",
            },
            sync_install = false,
            ignore_install = { "" }, -- List of parsers to ignore installing
            highlight = {
                enable = true, -- false will disable the whole extension
                disable = { "" }, -- list of language that will be disabled
                additional_vim_regex_highlighting = true,
            },
            indent = { enable = true, disable = { "yaml", "cpp" } },
            rainbow = {
                enable = true,
                disable = { "" },
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
            },
        })
    end,
}
