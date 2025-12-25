{ pkgs, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # ─── Core ───────────────────────────────────────────────────────────
    plenary-nvim
    nvim-web-devicons

    # ─── Colorscheme: Nord ──────────────────────────────────────────────
    {
      plugin = nord-nvim;
      type = "lua";
      config = ''
        vim.cmd.colorscheme("nord")
      '';
    }

    # ─── UI ─────────────────────────────────────────────────────────────
    {
      plugin = lualine-nvim;
      type = "lua";
      config = ''
        require("lualine").setup({
          options = {
            theme = "nord",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
        })
      '';
    }

    {
      plugin = trouble-nvim;
      type = "lua";
      config = ''
        require("trouble").setup({})
        vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
      '';
    }

    # ─── Treesitter ─────────────────────────────────────────────────────
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = ''
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
        })
      '';
    }

    # ─── Telescope ──────────────────────────────────────────────────────
    {
      plugin = telescope-nvim;
      type = "lua";
      config = ''
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git files" })
        vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      '';
    }

    # ─── LSP ────────────────────────────────────────────────────────────
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Try to get cmp capabilities if available
        local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
          capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
        end

        local on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        end

        -- Helper to handle lsp setup (works with 0.10 and 0.11+)
        local setup_server = function(server, config)
          if vim.lsp.config then
            -- Neovim 0.11+ (new API)
            -- Merge capabilities, on_attach is handled by autocmds mostly now but we keep it for now
            vim.lsp.config(server, config)
            vim.lsp.enable(server)
          else
            -- Neovim 0.10 and older (legacy lspconfig)
            require("lspconfig")[server].setup(config)
          end
        end

        -- Lua
        setup_server("lua_ls", {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        })

        -- Python
        setup_server("basedpyright", { capabilities = capabilities, on_attach = on_attach })
        setup_server("ruff", { capabilities = capabilities, on_attach = on_attach })

        -- TypeScript
        setup_server("ts_ls", { capabilities = capabilities, on_attach = on_attach })

        -- Web
        setup_server("html", { capabilities = capabilities, on_attach = on_attach })
        setup_server("cssls", { capabilities = capabilities, on_attach = on_attach })
        setup_server("jsonls", { capabilities = capabilities, on_attach = on_attach })

        -- Nix
        setup_server("nil_ls", { capabilities = capabilities, on_attach = on_attach })

        -- Diagnostics UI
        vim.diagnostic.config({
          virtual_text = { prefix = "●" },
          float = { border = "rounded" },
          signs = true,
          underline = true,
          severity_sort = true,
        })
      '';
    }

    {
      plugin = fidget-nvim;
      type = "lua";
      config = ''require("fidget").setup({})'';
    }

    # ─── Completion ─────────────────────────────────────────────────────
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
          }, {
            { name = "buffer", keyword_length = 3 },
          }),
          experimental = { ghost_text = true },
        })
      '';
    }
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    luasnip
    cmp_luasnip
    friendly-snippets

    # ─── Formatting ─────────────────────────────────────────────────────
    {
      plugin = conform-nvim;
      type = "lua";
      config = ''
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            json = { "prettier" },
            nix = { "nixfmt" },
          },
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
          },
        })
      '';
    }

    # ─── Quality of Life ────────────────────────────────────────────────
    {
      plugin = nvim-autopairs;
      type = "lua";
      config = ''require("nvim-autopairs").setup({})'';
    }

    vim-tmux-navigator
    vim-fugitive
  ];
}
