local o = vim.opt
local bo = vim.bo
local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local cmd = vim.cmd

require "paq" {
  "savq/paq-nvim",
  "neovim/nvim-lspconfig",
  "shaunsingh/nord.nvim",
  "tpope/vim-surround"
}

o.shortmess:append({ I = true })
o.undofile = true

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.cinoptions = "g0:0"

o.cursorline = true
o.colorcolumn = "81"

o.list = true
o.listchars = "tab:▸ ,eol:¬"

-- linenumbers
o.number = true
o.relativenumber = true
local augroup_numbertoggle = api.nvim_create_augroup("numbertoggle", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = augroup_numbertoggle,
  callback = function()
    if bo.buflisted then
      o.relativenumber = true
    end
  end
})
api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = augroup_numbertoggle,
  callback = function()
    if bo.buflisted then
      o.relativenumber = false
      cmd("redraw")
    end
  end
})

-- search
o.smartcase = true
o.ignorecase = true
o.inccommand = 'nosplit'
o.showmatch = true
o.gdefault = true
keymap.set("n", "<leader><space>", "<cmd>noh<CR>", {})
keymap.set({ "n", "x" }, "&", "<cmd>&&<CR>", {})

-- wildmenu
o.wildmenu = true
o.wildmode = "list:longest"
keymap.set("c", "<c-p>", function()
  if fn.wildmenumode() == 1 then return "<c-p>" end
  return "<up>"
end, { expr = true })
keymap.set("c", "<c-n>", function()
  if fn.wildmenumode() == 1 then return "<c-n>" end
  return "<down>"
end, { expr = true })

o.backspace = "indent,eol,start"

cmd("colorscheme nord")

-- restore cursor position
local augroup_restore = api.nvim_create_augroup("restore", { clear = true })
api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  group = augroup_restore,
  callback = function()
    local line = fn.line("'\"")
    if line >= 1 and line <= fn.line("$") then
      cmd.normal("g`\"")
    end
  end
})
