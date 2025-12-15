# Neovim Configuration - Pure Nix with Home Manager
# All plugins and LSPs managed via Nix. No lazy.nvim, no Mason.
# Nord theme, foundational setup.

{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # ═══════════════════════════════════════════════════════════════════════
    # LSPs, formatters, linters - replaces Mason!
    # ═══════════════════════════════════════════════════════════════════════
    extraPackages = with pkgs; [
      # Lua
      lua-language-server
      stylua

      # Python
      basedpyright
      ruff

      # TypeScript/JavaScript
      nodePackages.typescript-language-server

      # Web (HTML, CSS, JSON, ESLint)
      vscode-langservers-extracted

      # Nix
      nil
      nixfmt-classic

      # General tools
      nodePackages.prettier

      # For Telescope
      ripgrep
      fd
    ];

    # ═══════════════════════════════════════════════════════════════════════
    # Plugins
    # ═══════════════════════════════════════════════════════════════════════
    plugins = with pkgs.vimPlugins; [
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
          local lspconfig = require("lspconfig")
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

          -- Lua
          lspconfig.lua_ls.setup({
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
          lspconfig.basedpyright.setup({ capabilities = capabilities, on_attach = on_attach })
          lspconfig.ruff.setup({ capabilities = capabilities, on_attach = on_attach })

          -- TypeScript
          lspconfig.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })

          -- Web
          lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
          lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
          lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })

          -- Nix
          lspconfig.nil_ls.setup({ capabilities = capabilities, on_attach = on_attach })

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

    # ═══════════════════════════════════════════════════════════════════════
    # Core Neovim Configuration (Lua)
    # ═══════════════════════════════════════════════════════════════════════
    extraLuaConfig = ''
      -- Leader key
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- ─── Options ─────────────────────────────────────────────────────────
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.colorcolumn = "80"
      vim.opt.cursorline = true
      vim.opt.updatetime = 50
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undofile = true
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.mouse = "a"

      -- ─── Keymaps ─────────────────────────────────────────────────────────
      local map = vim.keymap.set

      -- Window navigation
      map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
      map("n", "<C-j>", "<C-w>j", { desc = "Down window" })
      map("n", "<C-k>", "<C-w>k", { desc = "Up window" })
      map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

      -- Buffer navigation
      map("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
      map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
      map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

      -- Better indenting (stay in visual mode)
      map("v", "<", "<gv")
      map("v", ">", ">gv")

      -- Move lines up/down
      map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
      map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

      -- Center after scroll
      map("n", "<C-d>", "<C-d>zz")
      map("n", "<C-u>", "<C-u>zz")
      map("n", "n", "nzzzv")
      map("n", "N", "Nzzzv")

      -- Quality of life
      map("n", "<leader>w", ":w<CR>", { desc = "Save" })
      map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
      map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search" })
      map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })

      -- ─── Autocommands ────────────────────────────────────────────────────
      local augroup = vim.api.nvim_create_augroup("UserConfig", {})

      -- Highlight on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = augroup,
        callback = function()
          vim.highlight.on_yank({ timeout = 200 })
        end,
      })

      -- Return to last edit position
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = augroup,
        callback = function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })
    '';
  };
}
