---
--- Nvim settings
---

-- Базовая настройка
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.wrap = false
vim.o.incsearch = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

-- Отключение Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Сочетания клавиш
vim.g.mapleader = " " -- кастомная клавиша для пользовательских команд

vim.keymap.set("n", "<leader>so", ":source %<CR>")

vim.keymap.set("n", "<C-n>", ":botright vnew<CR>") -- Новая пустая вкладка
vim.keymap.set("n", "<Tab>", ":wincmd w<CR>") -- Переключение между вкладками
vim.keymap.set("n", "<S-Tab>", ":wincmd r<CR>") -- Сменить вкладки местами

vim.keymap.set("n", "H", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>v", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)


---
--- Plugins
---

-- Цветовая тема Evergarden
vim.pack.add({ { src = "https://codeberg.org/evergarden/nvim.git", name = "evergarden" } })

require("evergarden").setup({
  theme = {
    variant = "fall", -- "winter"|"fall"|"spring"|"summer"
    accent = "green",
  },
  editor = {
    transparent_background = false,
    sign = { color = "none" },
    float = {
      color = "mantle",
      solid_border = false,
    },
    completion = {
      color = "surface0",
    },
  },
})

vim.cmd.colorscheme "evergarden" -- Тема по умолчанию


-- Поисковик Telescope
vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope-file-browser.nvim"},
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
})
require("telescope").load_extension("file_browser")
vim.keymap.set("n", "<leader>ff", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Сочетания клавишь для Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>o", builtin.find_files) -- Поиск файлов
vim.keymap.set("n", "<leader>fs", builtin.live_grep) -- Поиск по файлам


-- Удобная работа с git
vim.pack.add({
	{ src = "https://github.com/tpope/vim-fugitive" },
})

-- Lualine - Красивая нижняя панель
vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim"
})

require("lualine").setup({})


-- Плагин Mason - менеджер lsp
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
})
require("mason").setup()

-- Автодополнение Blink
vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

-- Ленивая загрузка: настройка происходит при первом входе в режим вставки
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = group,
    once = true,
    callback = function()
        require("blink.cmp").setup({
            keymap = { preset = "super-tab" },     -- Tab для навигации и подтверждения
            completion = { documentation = { auto_show = true } },
			appearance = {
                nerd_font_variant = "mono",        -- Для Nerd Font Mono
                use_nvim_cmp_as_default = true,    -- Использует тему nvim-cmp
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },  -- Основные источники
            },
			fuzzy = { implementation = "lua" }, -- Используем Lua вместо Rust
			providers = {
            	lsp = {
                	transform_items = function(_, items) return items end,
            	},
        	},
        })
    end,
})


---
--- Настройка языковых серверов LSP
---

-- Lua
vim.lsp.config["lua_ls"] = {
  -- Command and arguments to start the server.
  cmd = { "lua-language-server" },
  -- Filetypes to automatically attach to.
  filetypes = { "lua" },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      }
    }
  }
}

vim.lsp.enable("lua_ls")

-- Rust
vim.lsp.config["rust"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
}
vim.lsp.enable("rust")

-- Python
vim.lsp.config["python"] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
}
vim.lsp.enable("python")

-- Минимальная настройка clangd
vim.lsp.config["clangd"] = {
	--capabilities = require("blink.cmp").get_lsp_capabilities(),
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { ".git" },
}

vim.lsp.enable("clnagd")
