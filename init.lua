-- paq {{{
require "paq" {
  "savq/paq-nvim",
  "shaunsingh/nord.nvim",
  "kylechui/nvim-surround",
  "tpope/vim-fugitive",
  "kana/vim-textobj-user",
  "kana/vim-textobj-entire",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "ibhagwan/fzf-lua",
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig"
}
-- }}}
-- colorscheme {{{
vim.cmd.colorscheme "nord"
-- }}}
-- misc {{{
vim.opt.shortmess:append { I = true }
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "81"
vim.opt.backspace = "indent,eol,start"
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", eol = "¬" }
-- }}}
-- indentation {{{
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cinoptions = "g0:0"
-- }}}
-- linenumbers {{{
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
      vim.cmd "redraw"
    end
  end
})
-- }}}
-- search {{{
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.showmatch = true
vim.opt.gdefault = true
vim.keymap.set("n", "<leader><space>", "<cmd>noh<CR>", {})
vim.keymap.set({ "n", "x" }, "&", "<cmd>&&<CR>", {})
-- }}}
-- wildmenu {{{
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
-- }}}
-- highlight text on yank {{{
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { timeout = 500 }
  end
})
-- }}}
-- misc keymaps {{{
vim.keymap.set("n", "<leader>c", "<cmd>close<CR>")
vim.keymap.set("n", "<space>", "za")
-- }}}
-- restore cursor position {{{
local augroup_restore = vim.api.nvim_create_augroup("restore", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  group = augroup_restore,
  callback = function()
    local line = vim.fn.line "'\""
    if line >= 1 and line <= vim.fn.line "$" then
      vim.cmd.normal "g`\""
    end
  end
})
-- }}}
-- quickfix {{{
local augroup_quickfix = vim.api.nvim_create_augroup("qf", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "qf",
  group = augroup_quickfix,
  callback = function()
    vim.opt.buflisted = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = ""
    vim.opt.list = false
    vim.opt.wrap = false
  end
})
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  pattern = "*",
  group = augroup_quickfix,
  callback = function()
    if (#vim.api.nvim_list_wins() == 1) and (not vim.bo.buflisted) then
      vim.cmd "silent! quit"
    end
  end
})
-- }}}
-- surround {{{
require "nvim-surround".setup {}
-- }}}
-- fugitive {{{
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { silent = true })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>", { silent = true })
-- }}}
-- textobjs {{{
vim.g.textobj_entire_no_default_key_mappings = 1
local augroup_textobj_entire = vim.api.nvim_create_augroup("textobj-entire", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  group = augroup_textobj_entire,
  callback = function()
    vim.fn["textobj#user#map"]("entire", { ["-"] = { ["select-a"] = "aE", ["select-i"] = "iE" } })
  end
})
-- }}}
-- lualine {{{
require "lualine".setup {
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" }
  },
  sections = {
    lualine_x = {
      "encoding", "fileformat", "filetype",
      { "diagnostics", sources = { "nvim_lsp" } }
    },
    lualine_z = {
      { "location", icon = "" }
    }
  }
}
-- }}}
-- fzf {{{
require "fzf-lua".setup {
  keymap = {
    fzf = {
      true,
      -- Use <c-q> to select all items and add them to the quickfix list
      ["ctrl-q"] = "select-all+accept"
    }
  }
}
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>")
-- }}}
-- treesitter {{{
require "nvim-treesitter.configs".setup {
  ensure_installed = { "c", "cpp", "rust", "bash", "powershell", "lua", "vim", "vimdoc" },
  highlight = {
    enable = true
  }
}
-- }}}
-- lspconfig {{{
vim.lsp.enable "lua_ls"
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath "config"
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua"
        }
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library"
        }
      }
    })
  end,
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          trailing_table_separator = "never",
          call_arg_parentheses = "remove"
        }
      }
    }
  }
})
-- }}}
