require("paq")({
  "savq/paq-nvim",
  "shaunsingh/nord.nvim",
  "kylechui/nvim-surround",
  "tpope/vim-fugitive",
  "kana/vim-textobj-user",
  "kana/vim-textobj-entire",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "neovim/nvim-lspconfig",
  "nvim-treesitter/nvim-treesitter",
})

vim.opt.shortmess:append({ I = true })
vim.opt.undofile = true

-- indentation
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

-- highlight text on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end
})

vim.keymap.set("n", "<leader>c", "<cmd>close<CR>")
vim.keymap.set("n", "<space>", "za")

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

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "cpp", "rust", "bash", "powershell", "lua", "vim", "vimdoc" },
  highlight = {
    enable = false,
  }
})

require("nvim-surround").setup()

-- fugitive
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { silent = true })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>", { silent = true })

-- textobjs
vim.g.textobj_entire_no_default_key_mappings = 1
local augroup_textobj_entire = vim.api.nvim_create_augroup("textobj-entire", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  group = augroup_textobj_entire,
  command = [[
    call textobj#user#map("entire", {"-": {"select-a": "aE", "select-i": "iE"}})
  ]]
})

-- lualine
require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_x = {
      "encoding", "fileformat", "filetype",
      { "diagnostics", sources = { "nvim_lsp" }}
    },
    lualine_z = {
      { "location", icon = "" }
    }
  },
})
