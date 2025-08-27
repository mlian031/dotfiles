-- ~/.config/nvim/init.lua

-- 1) Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            "https://github.com/folke/lazy.nvim.git",
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

-- 2) Basic editor options
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = " "

-- 3) Diagnostics UI defaults (can be tweaked later)
vim.diagnostic.config(
    {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true
    }
)

-- 4) LSP on_attach and capabilities
local on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
    map("n", "gr", vim.lsp.buf.references, "List References")
    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map(
        "n",
        "<leader>fd",
        function()
            vim.diagnostic.open_float(nil, { border = "rounded" })
        end,
        "Line Diagnostics"
    )
    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
    map(
        { "n", "v" },
        "<leader>f",
        function()
            vim.lsp.buf.format({ async = true })
        end,
        "Format"
    )
end

-- Will be enhanced by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 5) Plugins
require("lazy").setup(
    {
        -- File explorer
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle tree" } },
            config = function()
                require("nvim-tree").setup({ view = { width = 30 } })
            end
        },
        -- Fuzzy finder
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
            keys = {
                { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
                { "<leader>fg",       "<cmd>Telescope live_grep<CR>",  desc = "Live Grep" },
                { "<leader>fb",       "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
                { "<leader>fh",       "<cmd>Telescope help_tags<CR>",  desc = "Help" }
            }
        },
        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            opts = {
                ensure_installed = {
                    "c",
                    "cpp",
                    "rust",
                    "python",
                    "typescript",
                    "tsx",
                    "json",
                    "lua",
                    "vim",
                    "vimdoc",
                    "html",
                    "css"
                },
                highlight = { enable = true },
                indent = { enable = true }
            },
            config = function(_, opts)
                require("nvim-treesitter.configs").setup(opts)
            end
        },
        -- Mason core
        { "williamboman/mason.nvim", opts = {} },
        -- Mason LSP bridge
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "neovim/nvim-lspconfig" },
            opts = {
                ensure_installed = {
                    "clangd",
                    "rust_analyzer",
                    "pyright", -- or "basedpyright"
                    -- Use whichever exists in your lspconfig/mason version
                    -- Newer lspconfig uses "ts_ls"; older uses "tsserver".
                    "ts_ls",
                    "tsserver",
                    "lua_ls"
                },
                automatic_installation = true
            }
        },
        -- LSP config
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lspconfig = require("lspconfig")

                -- Enhance capabilities with cmp
                local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                if ok_cmp then
                    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
                end

                -- Per-server tweaks
                lspconfig.clangd.setup(
                    {
                        on_attach = on_attach,
                        capabilities = capabilities
                    }
                )

                lspconfig.rust_analyzer.setup(
                    {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = { allFeatures = true },
                                check = { command = "clippy" }
                            }
                        }
                    }
                )

                lspconfig.pyright.setup(
                    {
                        on_attach = on_attach,
                        capabilities = capabilities
                    }
                )
                -- If you prefer BasedPyright:
                -- lspconfig.basedpyright.setup({ on_attach = on_attach, capabilities = capabilities })

                do
                    local ts = lspconfig.ts_ls or lspconfig.tsserver
                    if ts then
                        ts.setup(
                            {
                                on_attach = on_attach,
                                capabilities = capabilities,
                                init_options = { hostInfo = "neovim" }
                            }
                        )
                    end
                end

                -- Nice to have for editing your config
                lspconfig.lua_ls.setup(
                    {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                workspace = { checkThirdParty = false }
                            }
                        }
                    }
                )
            end
        },
        -- Completion (nvim-cmp + snippets)
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path"
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")
                require("luasnip.loaders.from_vscode").lazy_load()

                cmp.setup(
                    {
                        snippet = {
                            expand = function(args)
                                luasnip.lsp_expand(args.body)
                            end
                        },
                        mapping = cmp.mapping.preset.insert(
                            {
                                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                ["<C-Space>"] = cmp.mapping.complete(),
                                ["<C-e>"] = cmp.mapping.abort(),
                                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                ["<Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            cmp.select_next_item()
                                        elseif luasnip.expand_or_jumpable() then
                                            luasnip.expand_or_jump()
                                        else
                                            fallback()
                                        end
                                    end,
                                    { "i", "s" }
                                ),
                                ["<S-Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            cmp.select_prev_item()
                                        elseif luasnip.jumpable(-1) then
                                            luasnip.jump(-1)
                                        else
                                            fallback()
                                        end
                                    end,
                                    { "i", "s" }
                                )
                            }
                        ),
                        sources = cmp.config.sources(
                            {
                                { name = "nvim_lsp" },
                                { name = "luasnip" }
                            },
                            {
                                { name = "buffer" },
                                { name = "path" }
                            }
                        )
                    }
                )
            end
        },
        -- Formatting with conform.nvim
        {
            "stevearc/conform.nvim",
            opts = {
                notify_on_error = false,
                format_on_save = {
                    lsp_fallback = true,
                    timeout_ms = 1000
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black", "isort" },
                    rust = { "rustfmt" },
                    javascript = { "prettierd", "prettier" },
                    typescript = { "prettierd", "prettier" },
                    javascriptreact = { "prettierd", "prettier" },
                    typescriptreact = { "prettierd", "prettier" },
                    json = { "prettierd", "prettier" },
                    html = { "prettierd", "prettier" },
                    css = { "prettierd", "prettier" },
                    c = { "clang-format" },
                    cpp = { "clang-format" }
                }
            }
        },
        -- Linting with nvim-lint
        {
            "mfussenegger/nvim-lint",
            config = function()
                local lint = require("lint")
                lint.linters_by_ft = {
                    python = { "ruff" }, -- fast lints+fixes (needs ruff installed)
                    javascript = { "eslint_d", "eslint" },
                    typescript = { "eslint_d", "eslint" },
                    javascriptreact = { "eslint_d", "eslint" },
                    typescriptreact = { "eslint_d", "eslint" },
                    c = { "clangtidy" },
                    cpp = { "clangtidy" }
                    -- rust lints handled by rust-analyzer/clippy via cargo; you can add "clippy" runners per-project
                }
                local function try_lint()
                    lint.try_lint()
                end
                vim.api.nvim_create_autocmd(
                    { "BufEnter", "BufWritePost", "InsertLeave" },
                    {
                        callback = try_lint
                    }
                )
            end
        },
        -- Status line
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("lualine").setup(
                    {
                        options = {
                            theme = "auto",
                            icons_enabled = true,
                            section_separators = { left = "", right = "" },
                            component_separators = { left = "", right = "" },
                            globalstatus = true
                        },
                        sections = {
                            lualine_a = { "mode" },
                            lualine_b = { "branch" },
                            lualine_c = { "filename" },
                            lualine_x = {
                                { "diagnostics", sources = { "nvim_diagnostic" } },
                                "encoding",
                                "filetype"
                            },
                            lualine_y = { "progress" },
                            lualine_z = { "location" }
                        },
                        extensions = { "nvim-tree", "lazy" }
                    }
                )
            end
        },
    -- Colorscheme (single source of truth)
        {
            "lervag/vimtex",
            lazy = false,
            --tag  = "v2.15",
            init = function()
                vim.g.vimtex_view_method = "zathura"
            end
        },
        {
            "everviolet/nvim",
            name = "evergarden",
            priority = 1000,
            -- If the plugin exposes a module named 'evergarden', this will apply opts automatically
            -- and set the colorscheme. All calls are protected to avoid hard errors if the plugin/module differ.
            opts = {
                theme = {
                    variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
                    accent = "green"
                },
                editor = {
                    transparent_background = false,
                    sign = { color = "none" },
                    float = {
                        color = "mantle",
                        solid_border = false
                    },
                    completion = {
                        color = "surface0"
                    }
                }
            },
            config = function(_, opts)
                pcall(function()
                    require("evergarden").setup(opts)
                end)
                pcall(vim.cmd.colorscheme, "evergarden")
            end
        }
    }
)

-- 6) Quick compile/run hotkeys (same as yours)
vim.keymap.set("n", "<leader>r", ":!cargo run<CR>", { desc = "Run Rust" })
vim.keymap.set("n", "<leader>c", ":!g++ % -o %< && ./%<CR>", { desc = "Compile & Run C++" })
vim.keymap.set("n", "<leader>p", ":!python3 %<CR>", { desc = "Run Python" })
