require "paq" {
  "savq/paq-nvim",
  "neovim/nvim-lspconfig",
  "shaunsingh/nord.nvim",
  "tpope/vim-surround"
}

vim.opt.shortmess:append({ I = true })
vim.opt.undofile = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cinoptions = "g0:0"

vim.opt.cursorline = true
vim.opt.colorcolumn = "81"

vim.opt.list = true
vim.opt.listchars = "tab:▸ ,eol:¬"

-- linenumbers
vim.opt.number = true
vim.opt.relativenumber = true
local augroup_numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = augroup_numbertoggle,
  callback = function()
    if vim.bo.buflisted then
      vim.opt.relativenumber = true
    end
  end
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = augroup_numbertoggle,
  callback = function()
    if vim.bo.buflisted then
      vim.opt.relativenumber = false
      vim.cmd("redraw")
    end
  end
})

-- search
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.showmatch = true
vim.opt.gdefault = true
vim.keymap.set("n", "<leader><space>", "<cmd>noh<CR>", {})
vim.keymap.set({ "n", "x" }, "&", "<cmd>&&<CR>", {})

-- wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.keymap.set("c", "<c-p>", function()
  if vim.fn.wildmenumode() == 1 then return "<c-p>" end
  return "<up>"
end, { expr = true })
vim.keymap.set("c", "<c-n>", function()
  if vim.fn.wildmenumode() == 1 then return "<c-n>" end
  return "<down>"
end, { expr = true })

vim.opt.backspace = "indent,eol,start"

vim.cmd.colorscheme("nord")

-- restore cursor position
local augroup_restore = vim.api.nvim_create_augroup("restore", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  group = augroup_restore,
  callback = function()
    local line = vim.fn.line("'\"")
    if line >= 1 and line <= vim.fn.line("$") then
      vim.cmd.normal("g`\"")
    end
  end
})
