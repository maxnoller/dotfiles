{ ... }:

{
  programs.neovim.extraLuaConfig = ''
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
}
