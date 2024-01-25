-- install those packages:
-- `sudo pacman -S ripgrep lazygit`
_G.IS_WINDOWS = vim.loop.os_uname().sysname:find "Windows" and true or false
_G.IS_ARCH = vim.loop.os_uname().release:find "arch" and true or false

return {
  updater = {                -- Configure AstroNvim updates
    remote = "origin",       -- remote to use
    channel = "stable",      -- "stable" or "nightly"
    version = "latest",      -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    pin_plugins = nil,       -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,    -- skip prompts about breaking changes
    show_changelog = true,   -- show the changelog after performing an update
    auto_quit = false        -- automatically quit the current session after a successful update
  },
  colorscheme = "onedarker", -- Set colorscheme to use

  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
      number = true,         -- sets vim.opt.number
      spell = true,          -- sets vim.opt.spell
      signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
      wrap = false           -- sets vim.opt.wrap
      -- shiftwidth     = 4     ,
      -- tabstop        = 4     ,
    },
    g = {
      mapleader = " ",                 -- sets vim.g.mapleader
      diagnostics_mode = 3,            -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
      autoformat_enabled = false,      -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled = true,              -- enable completion at start
      autopairs_enabled = true,        -- enable autopairs at start
      icons_enabled = true,            -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled = true, -- disable notifications when toggling UI elements
      VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Add Cursor Down"] = "<C-A-j>",
        ["Add Cursor Up"] = "<C-A-k>"
      },

      SetUsLayout = function()
        vim.api.nvim_command "silent !xkb-switch -s us" -- yay -S xkb-switch
      end,

      set_cursor_to_find = function(ref)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for line_number, ln in ipairs(lines) do
          local start_index, end_index = string.find(ln, ref)
          if start_index and end_index then
            vim.api.nvim_win_set_cursor(0,
              { line_number, start_index })
            break -- Stop the loop because we found the search string
          end
        end
      end,

      go_to_markdown_ref = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]

        for match in string.gmatch(line, "%(([^'%)]+)") do
          local start_pos = string.find(line, match)
          local end_pos = start_pos + string.len(match)
          local link
          if cursor[2] + 1 >= start_pos and cursor[2] < end_pos then
            local rel_path = string.gsub(vim.api.nvim_buf_get_name(0), "(.+/)(.+)", "%1")
            vim.api.nvim_command(":edit " .. rel_path .. string.match(match, "^([^#]*)"))
            vim.api.nvim_command "m'"
            link = string.match(match, "#(.*)$")
            if link then
              vim.api.nvim_command(":call set_cursor_to_find('" .. link .. "')") -- GOD PLEASE WHY
            end
          end
        end
      end
    }
  },

  plugins = { -- Configure plugins
    {
      "goolord/alpha-nvim",
      opts = function(_, opts) -- override the options using lazy.nvim
        opts.section.header.val =
        {                      -- change the header section value
          "             \\                                      [            ",
          "              @                 ⟡                  ╢             ",
          "      /       ╣▒                                  ]▒       \\     ",
          "     ╔       ]Ñ▒                                  ╟╣┐       ▓    ",
          "    ╢╣       ╣▓            √          t            ▓╣       ▓╣   ",
          "   ▓╣▒╖    ╓╫╜           ╥▓   ASTROν   ▓@           ╙▓╖    ╔╣╢║  ",
          "   ▓▓▓▓  ,p▓,,,,,,      ╜╙▓▄╖,      ,╓╥╜╙╙    ,,,,,,,,▓▓,  ▀▓▓╣U ",
          "   ▀▓Ö   ╙█▓▓▓▓▓▓╢╫╣▓▓▓▓▓╦, ▀▓▓╗  g╢▓╝ ,╓H╢╢╢╢╢╢▓▓▓▓▓▓▒▓╜   ]▓▓  ",
          '    ▓▓▓╦╥╖ ╙╙╙╙`     `""▀▓▓@ ▐█▓L]▓╫╛ Æ▒╨╜"       ""╙╙` ╓╖∩▒▒▓   ',
          ' ╒▓▒╜""╙▀▓▓                ▀  █▒Γ▐▓▓  ╩                ▓╢╜""╙▀█╫L',
          " ▐▌`      └╝                  ▓▒` █▓                  ╜       └█▓",
          "▐▓                            ▓▒  █╢                           ▐▓",
          ' ▐Γ                            ╛  ▐"                           ▐[',
          " ¬U                                                            jU",
          "  C                                                            j ",
          "   L                                                          ]  ",
        }
      end,
    },
    -- Colorschemes
    { "fcpg/vim-orbital", },
    { "nocksock/nazgul-vim", },
    { "lunarvim/Onedarker.nvim", },
    { "Mofiqul/vscode.nvim", },
    { "nikolvs/vim-sunbather", },
    { "navarasu/onedark.nvim", },
    { "szorfein/darkest-space", },
    { "owickstrom/vim-colors-paramount", },
    -- LSP - TS - DAP
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "pyright",
          "lua_ls",
          "marksman",
          "clangd",
          -- "arduino_language_server",
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "python",
          "lua",
          "markdown",
          "markdown_inline",
          "arduino",
          "cpp",
          "c",
        },
      },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = {
          "python",
          "lua",
        },
      }
    },
    {
      "akinsho/flutter-tools.nvim",
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
      },
      config = true,
    }, -- add lsp plugin
    {
      "p00f/clangd_extensions.nvim",     -- install lsp plugin
      init = function()
        -- load clangd extensions when clangd attaches
        local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
          group = augroup,
          desc = "Load clangd_extensions with clangd",
          callback = function(args)
            if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
              require "clangd_extensions"
              -- add more `clangd` setup here as needed such as loading autocmds
              vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
            end
          end,
        })
      end,
    },
    { "kana/vim-textobj-entire", },
    { "kiyoon/treesitter-indent-object.nvim", },
    { "nvim-treesitter/nvim-treesitter", },
    { "stevearc/vim-arduino", }, -- sudo pacman -S arduino-cli (and arduino?)
    { "hiphish/rainbow-delimiters.nvim", lazy = false, },
    { "folke/zen-mode.nvim", lazy = false, },
    { "godlygeek/tabular", lazy = false, }, -- ALIGN <leader>a | https://stackoverflow.com/questions/5436715/how-do-i-align-like-this-with-vims-tabular-plugin
    { "folke/trouble.nvim", lazy = false, },
    { "svermeulen/vim-yoink", lazy = false, }, -- TERMUX https://github.com/GiorgosXou/our-neovim-setup/issues/2
    { "Shadowsith/vim-minify", lazy = false, }, -- TODO: It needs to be Checked 2023-03-24 06:29:23 PM
    { "m-pilia/vim-smarthome", lazy = false, },
    { "mg979/vim-visual-multi", lazy = false, },
    { "nvim-treesitter/nvim-treesitter-context", lazy = false,  },
    { "vim-scripts/ReplaceWithRegister", lazy = false, },
    {
      "iamcco/markdown-preview.nvim",
      config = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = {
        "markdown",
      },
    },
    {
      "petertriho/nvim-scrollbar",
      lazy = false,
      config = function()
        require("scrollbar").setup()
      end,
    },
    {
      "nat-418/boole.nvim",
      lazy = false,
      config = function()
        require("boole").setup { -- https://www.reddit.com/r/neovim/comments/y2h9sq/new_plugin_boolenvim_toggle_booleans_cycle_days/
          mappings = {
            increment = "<C-a>",
            decrement = "<C-x>",
          },
          additions = {
            {
              "Foo",
              "Bar",
            },
            {
              "tic",
              "tac",
              "toe",
            },
          },
          allow_caps_additions = {
            {
              "enable",
              "disable",
            },
          }
        }
      end
    }, {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end,
      event = "VeryLazy",
      version = "*",
    }, {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup {
          toggler = {
            line = "cml", -- Line-comment toggle keymap
            block = "gbc", -- Block-comment toggle keymap
          },
          opleader = {
            line = "cm", ---Line-comment keymap
            block = "gb", ---Block-comment keymap
          },
        }
      end,
      lazy = false
    }, -- permanant solution until fix https://discord.com/channels/939594913560031363/1088835559012716584
    {
      "Shatur/neovim-ayu",
      config = function()
        -- local utils = require "default_theme.utils"
        require("ayu").setup { -- don't forger :PackerCompile if it doesn't work
          overrides = {        -- :Telescope highlights https://github.com/Shatur/neovim-ayu#overrides-examples <------
            Type = { fg = "#FF5F00", },
            Macro = { fg = "#FF5F00", },
            Normal = { bg = "#000000", }, -- 'NONE'
            Repeat = { fg = "#FF5F00", },
            Method = { fg = "#FF5F00", },
            PreProc = { fg = "#FF5F00", },
            Include = { fg = "#FF5F00", },
            Keyword = { fg = "#FF5F00", },
            Exception = { fg = "#FF5F00", },
            Statement = { fg = "#FF5F00", },
            Constructor = { fg = "#FF5F00", },
            FuncBuiltin = { fg = "#FF5F00", },
            TypeDefinition = { fg = "#FF5F00", },
            KeywordFunction = { fg = "#FF5F00", },
            IndentBlanklineContextChar = { fg = "#FF5F00", },
            LspReferenceRead = { bg = "#626A73", },
            LspReferenceText = { bg = "#626A73", },
            LspReferenceWrite = { bg = "#626A73", },
            LineNr = { fg = "#626A73", },
            -- DiagnosticError =  utils.parse_diagnostic_style { fg = '#cc241d'},
            -- DiagnosticWarn  =  utils.parse_diagnostic_style { fg = '#ff8f40'},
            -- DiagnosticInfo  =  utils.parse_diagnostic_style { fg = '#39bae6'},
            -- DiagnosticHint  =  utils.parse_diagnostic_style { fg = '#95e6cb'},
            -- #FFC26B #860000 #64BAAA #006B5D #FF6A13 #FFB454 #FFF000 #Maybe?
          }
        }
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
        require("scrollbar.handlers.gitsigns").setup()
      end
    },
    {
      "mfussenegger/nvim-dap",
      config = function()
        local dap = require "dap" -- dap.defaults.fallback.force_external_terminal = true
        dap.defaults.fallback.external_terminal = {
          command = "/usr/bin/alacritty",
          args = {
            "-e",
          },
        }
        dap.configurations.python = {
          {                  -- The first three options are required by nvim-dap
            type = "python", -- the type here established the link to the adapter definition : `dap.adapters.python`
            request = "launch",
            name = "Launch file in external terminal",
            console = "externalTerminal", -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
            program = "${file}",          -- This configuration will launch the current file if used.
            pythonPath = "/usr/bin/python",
          },
          {                            -- The first three options are required by nvim-dap
            type = "python",                -- the type here established the link to the adapter definition : `dap.adapters.python`
            request = "launch",
            name = "Launch file in integrated terminal",
            console = "integratedTerminal", -- Options here and  below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
            program = "${file}",            -- This configuration will launch the current file if used.
            pythonPath = "/usr/bin/python",
          }
        }
      end
    },
    { "Darazaki/indent-o-matic", disable = true },
    {
      "yioneko/nvim-yati",
      config = function() -- #2
        require("nvim-treesitter.configs").setup {
          yati   = {
            enable           = true,
            disable          = { 'python', 'markdown', 'lua', 'cpp' }, -- Disable by languages, see `Supported languages`
            default_lazy     = true,                                   -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
            default_fallback = "auto",
          },
          indent = {
            enable = true, -- disable builtin indent module
          },
        }
      end,
      requires = "nvim-treesitter/nvim-treesitter"
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        window = {
          position = "right",
        },
        default_component_configs = {
          indent = {
            last_indent_marker = "╰",
          },
        },
      },
    },
    {
      "stevearc/conform.nvim",
      lazy = true,
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local conform = require("conform")

        conform.setup({
          formatters_by_ft = {
            php = { "php", },
          },
          format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          },
          notify_on_error = true,
          formatters = {
            php = {
              command = "php-cs-fixer",
              args = {
                "fix",
                "$FILENAME",
                "--config=$HOME/config.php",
                "--allow-risky=no", -- if you have risk stuff in config, if not you don't need it.
              },
              stdin = false,
            },
          },
        })
      end,
    },
  },

  diagnostics = { -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    virtual_text = true,
    underline = true
  },

  -- Extend LSP configuration
  lsp = {
    servers = { -- enable servers that you already have installed without mason
      -- "tst_lsp"
      "dartls"
    },
    setup_handlers = { -- add custom handler
      dartls = function(_, opts)
        require("flutter-tools").setup { lsp = opts }
      end
    },
    -- on_attach = function(client, bufnr)
    --   if client.name == "arduino_language_server" then
    --     client.server_capabilities.semanticTokensProvider = nil
    --     -- client.server_capabilities.semanticTokensProvider = false
    --   end
    -- end,
    formatting = {
      format_on_save = { -- control auto formatting on save
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = {},
        ignore_filetypes = {}
      },
      disabled = {},
      timeout_ms = 1000 -- default format timeout
    },
    mappings = {        -- easily add or disable built in mappings added during LSP attaching
      n = {             -- ["<leader>lf"] = false -- disable formatting keymap
      }
    },

    ["config"] = { -- Add overrides for LSP server settings, the keys are the name of the server
      dartls = {
        color = { enabled = true },
        settings = { showTodos = true, completeFunctionCalls = true }
      },

      tst_lsp = function()
        return {
          cmd = { "cmake-language-server" },
          -- filetypes = {"tst"};
          root_dir = require("lspconfig.util").root_pattern "pdack.tst"
        }
      end,
      -- arduino_language_server = { --  https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/arduino_language_server | https://discord.com/channels/939594913560031363/1078005571451621546/threads/1122910773270818887
      --   on_new_config = function (config, root_dir)
      --     local my_arduino_fqbn = {
      --       ["/home/xou/Desktop/xou/programming/hardware/arduino/nano"]  = "arduino:avr:nano", -- arduino-cli board listall
      --       ["/home/xou/Desktop/xou/programming/hardware/arduino/uno" ]  = "arduino:avr:uno" ,
      --     }
      --     local DEFAULT_FQBN = "arduino:avr:uno"
      --     local fqbn = my_arduino_fqbn[root_dir]
      --     if not fqbn then
      --       -- vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
      --       fqbn = DEFAULT_FQBN
      --     end
      --     config.cmd = {         --  https://forum.arduino.cc/t/solved-errors-with-clangd-startup-for-arduino-language-server-in-nvim/1019977
      --       "arduino-language-server",
      --       "-cli-config" , "~/.arduino15/arduino-cli.yaml", -- just in case it was /home/xou/.arduino15/arduino-cli.yaml
      --       "-cli"        , "/usr/bin/arduino-cli", -- 2023-06-26 ERROR | "Runs" if I set a wrong path
      --       "-clangd"     , "/usr/bin/clangd",
      --       "-fqbn"       , fqbn
      --     }
      --   end
      -- },
      pyright = {
        settings = { python = { analysis = { typeCheckingMode = "off" } } }
      }
    }
  },

  lazy = { -- Configure require("lazy").setup() options
    defaults = { lazy = true },
    performance = {
      rtp = { -- customize default disabled vim plugins
        disabled_plugins = {
          "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin",
          "tarPlugin"
        }
      }
    }
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    local map = vim.keymap
    local api = vim.api
    -- Unused variable.
    -- local opts = { silent = true, }
    local gs = require "gitsigns"

    if _G.IS_ARCH then
      api.nvim_command "autocmd InsertLeave * call SetUsLayout()"
    end

    -- imported from https://github.com/GiorgosXou/init.lua/blob/64dda3cd9fe81e3cfe6d51a82c0ce8924b9d0804/init.lua#L288
    vim.api.nvim_command "set shiftwidth=4" -- default if not Sleuth?
    -- Disabled due to error: Unknown function toggle_strict_mode()
    -- vim.api.nvim_command "call toggle_strict_mode()"

    -- vim.api.nvim_command('set im!')
    -- vim.api.nvim_input('i')
    -- vim.api.nvim_command('set iskeyword+=.')
    -- Set Keybindings

    -- Shift l h to switch tabs
    -- map.set('n', 'dil', "dd:let @+=matchlist(strtrans(@+),'[ ]*\\zs.*\\ze\\^@')[0]<CR>", { desc = "(Delete-in-line) Delete\\Cut line without \\n"}) --Delete in line
    --[[
    map.set("i", "<C-A-up>", "<ESC>:call vm#commands#add_cursor_up(0,1)<CR>", bufopts)
    map.set("i", "<C-A-down>", "<ESC>:call vm#commands#add_cursor_down(0,1)<CR>", bufopts)
    map.set("v", "<Tab>", ">gv", bufopts)
    map.set("v", "<S-Tab>", "<gv", bufopts)
    map.set("i", "<S-Tab>", "<ESC>v<<ESC>i<right>", bufopts)
    map.set("i", "<C-s>", "<C-o>:w!<CR>", bufopts) -- On blank line stays on normal mode
    map.set("n", "<C-s>", ":w!<CR>", bufopts)
    map.set("i", "<C-q>", "<C-o>:q!<CR>", bufopts)
    map.set("v", "<C-q>", ":q!<CR>", bufopts)
    map.set("n", "<A-j>", ":m+<CR>==", bufopts)
    map.set("n", "<A-down>", ":m+<CR>==", bufopts)
    map.set("n", "<A-k>", ":m-2<CR>==", bufopts)
    map.set("n", "<A-up>", ":m-2<CR>==", bufopts)
    map.set("i", "<A-j>", "<Esc>:m+<CR>==gi", bufopts)
    map.set("i", "<A-down>", "<Esc>:m+<CR>==gi", bufopts)
    map.set("i", "<A-k>", "<Esc>:m-2<CR>==gi", bufopts)
    map.set("i", "<A-up>", "<Esc>:m-2<CR>==gi", bufopts)
    map.set("v", "<A-j>", ":m'>+<CR>gv=gv", bufopts)
    map.set("v", "<A-down>", ":m'>+<CR>gv=gv", bufopts)
    map.set("v", "<A-k>", ":m-2<CR>gv=gv", bufopts)
    map.set("v", "<A-up>", ":m-2<CR>gv=gv", bufopts)
    map.set("i", "<C-right>", "<C-o>:call jump_word_e()<CR>", bufopts)
    map.set("i", "<C-left>", "<C-o>:call jump_word_b()<CR>", bufopts)
    map.set("n", "<C-right>", "e", bufopts) -- https://vi.stackexchange.com/questions/12614/prevent-w-from-jumping-to-next-line#comment21820_12614
    map.set("n", "<C-left>", "b", bufopts)
    map.set("v", "<C-c>", "ygv", bufopts) -- https://stackoverflow.com/questions/47842041/
    map.set("i", "<C-c>", "<C-o>yy", bufopts)
    map.set("v", "<C-v>", '"_dgP', bufopts)
    map.set("i", "<C-v>", "<C-r>=paste_check()<CR>", bufopts)
    map.set("i", "<C-Up>", "<C-o><C-y>", bufopts)
    map.set("i", "<C-S-Up>", "<C-o><C-v>k", bufopts) -- WTF HAPPENED WITH C-S-UpDown | C-v to see what key
    map.set("i", "<C-S-Down>", "<C-o><C-v>j", bufopts) -- WTF HAPPENED WITH C-S-UpDown | C-v to see what key
    map.set("i", "<F8>", "<C-o><C-v>k", bufopts) -- WTF HAPPENED WITH C-S-UpDown | C-v to see what key
    map.set("i", "<F6>", "<C-o><C-v>j", bufopts) -- WTF HAPPENED WITH C-S-UpDown | C-v to see what key
    map.set("i", "<A-M>", "<C-o>o", bufopts) -- Alacritty for some reason (Alt capital M?)
    map.set("i", "<C-cr>", "<C-o>o", bufopts)
    map.set("i", "<F9>", "<C-o>o", bufopts) -- On Windows | PowerToys > Keyboard Manager
    map.set("v", "<C-cr>", "<ESC>o", bufopts)
    map.set("v", "<F9>", "<ESC>o", bufopts) -- On Windows | PowerToys > Keyboard Manager
    map.set("i", "<C-Down>", "<C-o><C-e>", bufopts)
    map.set("i", "<S-Up>", "<left><C-o>vk", bufopts)
    map.set("i", "<S-Down>", "<C-o>vj", bufopts)
    map.set("i", "<S-left>", "<left><C-o>v", bufopts)
    map.set("i", "<S-right>", "<C-o>v", bufopts)
    map.set("i", "<C-S-left>", "<left><C-o>vb", bufopts)
    map.set("i", "<C-S-right>", "<C-o>vw", bufopts)
    map.set("i", "<C-x>", "<C-o>dd", bufopts) -- i fucked up termux or this messes up with termux
    map.set("v", "<C-x>", "di", bufopts)
    map.set("v", "<BS>", '"_di', bufopts)
    map.set("v", "<left>", "O<ESC>i", bufopts) -- Make it jump like in vscode vim.fn.col('O')?
    map.set("v", "<right>", "<ESC>i<right>", bufopts) -- Make it jump like in vscode
    map.set("v", "<up>", "<ESC><up>i", bufopts) -- fix right or left
    map.set("v", "<down>", "<ESC><down>i", bufopts) -- fix right or left
    map.set("v", "<S-right>", "l", bufopts)
    map.set("v", "<S-left>", "h", bufopts)
    map.set("v", "<S-up>", "k", bufopts)
    map.set("v", "<S-down>", "j", bufopts)
    map.set("i", "<C-_>", "<C-o>:Commentary<cr>", bufopts) -- On Windows
    map.set("i", "<C-/>", "<C-o>:Commentary<cr>", bufopts)
    map.set("v", "<C-_>", ":Commentary<cr>", bufopts) -- On Windows
    map.set("v", "<C-/>", ":Commentary<cr>", bufopts)
    map.set("i", "<C-b>", "<ESC>:Neotree toggle<cr>", bufopts)
    map.set("n", "<C-b>", ":Neotree toggle<cr>", bufopts)
    map.set("i", "<C-z>", "<C-o>u", bufopts)
    map.set("v", "<C-z>", "<ESC>ui", bufopts)
    map.set("i", "<C-r>", "<C-o>:redo<cr>", bufopts)
    map.set("i", "<C-S-z>", "<C-o>:redo<cr>", bufopts)
    map.set("i", "<F10>", "<C-o>:redo<cr>", bufopts) -- On Windows | PowerToys > Keyboard Manager
    map.set("i", "<C-BS>", '<esc><right>"_dbi', bufopts) -- ESC because last char (for now)
    map.set("i", "<C-h>", '<esc><right>"_dbi', bufopts)
    map.set("i", "<C-j>", "<esc>:ToggleTerm direction=horizontal<cr>", bufopts)
    map.set("i", "<C-d>", "<esc><right>:call vm#commands#ctrln(1)<cr>", bufopts)
    map.set("i", "<F4>", '<C-o>"_dd', bufopts) -- On Windows Only?
    map.set("i", "<C-S-k>", '<C-o>"_dd', bufopts)
    map.set("i", "<A-m>", "<C-o>:call toggle_strict_mode()<cr>")
    map.set("n", "<A-m>", ":call toggle_strict_mode()<cr>")
    map.set("i", "<C-g>", "<C-o>:call go_to_relative_line()<left>")
    map.set("i", "<F12>", vim.lsp.buf.definition, bufopts) -- Go to definition
    -- May i make <C-a> to select all in the block and <C-S-a> to select ALL?
    -- map.set('i', '<C-w>', '<ESC>:tabclose<cr>i') -- Go to definition | hmm...

    -- MOUSE
    map.set("v", "<RightMouse>", "yi", bufopts)
    map.set("i", "<RightMouse>", "<C-o>p", bufopts)
    map.set("i", "<ScrollWheelUp>", "<C-o>4<C-Y>", bufopts) -- MAYBE only for termux if indeed issue with <C-x>
    map.set("i", "<ScrollWheelDown>", "<C-o>4<C-E>", bufopts) -- MAYBE only for termux if indeed issue with <C-x>
    map.set("i", "<C-LeftMouse>", "<LeftMouse><C-o>:lua vim.lsp.buf.definition()<CR>", bufopts) -- Go to definition
    map.set("n", "<C-LeftMouse>", "<LeftMouse>:lua vim.lsp.buf.definition()<CR>", bufopts) -- Go to definition -- TODO: Add vertical scroll

    -- ADD ctrl+x on v mode
    -- Sto else vale variable to <CR> giati alla commands mporei na to kanoun overide
    vim.api.nvim_command "cnoremap <expr> <CR> (getcmdtype() ==# ':' && getcmdline() =~# '^call go_to_relative_line') ? '<CR><C-o>^' : '<CR>'" -- https://noahfrederick.com/log/vim-streamlining-grep
    -- vim.keymap.set('n', '<C-r>'     , 'i') -- because of some issue when at the end of change list
    -- maybe use bacspace as dd on visual
    -- -- About Search
    vim.keymap.set("i", "<C-f>", "<esc>:let mode=1<cr>/")
    vim.keymap.set("n", "<esc>", ":noh<cr>") -- https://vi.stackexchange.com/a/28063/42370

    -- vim.api.nvim_command("cnoremap <expr> <ESC> (getcmdtype() ==# '/' && mode == 1) ? '<ESC>:let mode=0<cr>:noh<cr>i' : '<ESC>'")
    -- vim.api.nvim_command("cnoremap <expr> <CR> (getcmdtype() ==# '/' && mode == 1) ? '<CR>:let mode=0<cr>i' : '<CR>'")

    -- vim.api.nvim_command("let mode=2")
    -- vim.api.nvim_command("inoremap <expr> <CR> mode == 2 ? 'n' : '<CR>'")

    -- vim.keymap.set('i', '<CR>' , 'N')
    -- -- Navigate\jump back fotrh change list
    vim.keymap.set("i", "<A-left>", "<C-o>g;") -- Going pass the changelist "overwrites" it?
    vim.keymap.set("i", "<A-right>", "<C-o>g,") -- Going pass the changelist "overwrites" it?
    vim.keymap.set("n", "<A-left>", "g;")
    vim.keymap.set("n", "<A-right>", "g,")
    -- vim.api.nvim_command("cnoremap <ESC> <ESC>:noh<cr>i")
    -- vim.api.nvim_command("cnoremap <expr> <tab> getcmdtype() =~ '^[colorscheme ?]$' ? '<ESC>:noh<cr>i' : '<tab>'")
    -- vim.api.nvim_command("cnoremap <expr> jk getcmdtype() =~ '^[/?]$' ? '<CR>' : 'jk'")
    -- vim.keymap.set('n', '<A-left>' , ''  )
    -- vim.keymap.set('n', '<A-right>', ''  )
    -- -- smarthome
    map.set("n", "<Home>", ":call smarthome#SmartHome('n')<cr>", bufopts)
    map.set("n", "<End>", ":call smarthome#SmartEnd('n')<cr>", bufopts)
    map.set("i", "<Home>", "<C-r>=smarthome#SmartHome('i')<cr>", bufopts) -- I guess? https://stackoverflow.com/a/10863134/11465149
    map.set("i", "<End>", "<C-r>=smarthome#SmartEnd('i')<cr>", bufopts)
    map.set("v", "<Home>", "<ESC>i<C-r>=smarthome#SmartHome('i')<cr>", bufopts)
    map.set("v", "<End>", "<ESC>i<C-r>=smarthome#SmartEnd('i')<cr>", bufopts)
    map.set("v", "<S-Home>", "<Esc>:call smarthome#SmartHome('v')<cr>", bufopts)
    map.set("v", "<S-End>", "<Esc>:call smarthome#SmartEnd('v')<cr>", bufopts)
    map.set("i", "<S-End>", "<C-o>v:call smarthome#SmartEnd('v')<cr>", bufopts)
    map.set("i", "<S-Home>", "<left><C-o>v:call smarthome#SmartHome('v')<cr>", bufopts)

    vim.api.nvim_create_augroup("packer_conf", {clear = true}) -- Set autocommands
    vim.api.nvim_create_autocmd("BufWritePost", {
        desc = "Sync packer after modifying plugins.lua",
        group = "packer_conf",
        pattern = "plugins.lua",
        command = "source <afile> | PackerSync"
    })

    -- vim.filetype.add { -- Set up custom filetypes
    --   extension    = { foo                   = "fooscript", },
    --   filename     = { ["Foofile"]           = "fooscript", },
    --   pattern      = { ["~/%.config/foo/.*"] = "fooscript", },
    -- }
    ]]

    map.set("v", "<leader>gs",
      function()
        gs.stage_hunk {
          vim.fn.line ".",
          vim.fn.line "v"
        }
      end)

    map.set("n", "<Leader>tt", 'a<C-R>=strftime("%Y-%m-%d %I:%M:%S %p")<CR><Esc>', { desc = "print time" })
    map.set("n", "<Leader>i", 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>', { desc = "print time" }) -- TODO: store it into register
    map.set("n", "<Leader>I", 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>', { desc = "print time" })
    map.set("n", '";', '"_')

    map.set({ "x", "o" }, "ai", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>")     -- select context-aware indent
    map.set({ "x", "o" }, "aI", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>") -- ensure selecting entire line (or just use Vai)
    map.set({ "x", "o" }, "ii", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>")     -- select inner block (only if block, only else block, etc.)
    map.set({ "x", "o" }, "iI", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>") -- select entire inner range (including if, else, etc.)

    map.set("i", "<C-S>", "<C-o>:w<cr>")
    map.set("n", "<C-S-s>", "<cmd>:noa w<cr>", bufopts)                                                             -- save without formatting
    map.set("n", "<leader>s", "<cmd>:noa w<cr>")                                                                    -- save without formatting
    map.set("i", "<C-z>", "<C-o>u", bufopts)                                                                        -- undo alternative
    map.set("i", "<C-r>", "<C-o>:redo<cr>", bufopts)                                                                -- redo alternative
    map.set("i", "<C-S-z>", "<C-o>:redo<cr>", bufopts)                                                              -- redo alternative
    map.set("i", "<C-Q>", "<C-o>:q!<cr>")
    map.set("v", "p", '"_dP')
    map.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
    map.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
    map.set("n", "<a-k>", ":m-2<cr>==")
    map.set("n", "<a-j>", ":m+1<cr>==")
    map.set("i", "<A-k>", "<C-o>:m-2<cr>")
    map.set("i", "<A-j>", "<C-o>:m+1<cr>")
    map.set("n", "i", ":noh<cr>i")
    map.set("n", "<ESC>", ":noh<cr>")
    map.set("v", "s", '"fy/\\V<C-R>f<CR>N') -- https://vi.stackexchange.com/a/34743/42370 | https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim#comment2699355_41400
    map.set("n", "x", '"_x')
    map.set("n", "X", '"_X')

    map.set("i", "<A-h>", "<ESC><<")
    map.set("i", "<A-l>", "<ESC>>>")
    map.set("v", "<A-h>", "<gv")
    map.set("v", "<A-l>", ">gv")
    map.set("n", "<A-h>", "<<")
    map.set("n", "<A-l>", ">>")
    map.set("v", "<S-h>", "^")
    map.set("v", "<S-l>", "$")

    map.set("n", "<Leader>h", "%")

    map.set("n", "gtn", ":bnext<cr>")
    map.set("n", "gtb", ":bprevious<cr>")
    map.set("n", "<Leader>L", ":bnext<cr>")
    map.set("n", "<Leader>H", ":bprevious<cr>")

    map.set("n", "<S-h>", ":call smarthome#SmartHome('n')<cr>")
    map.set("n", "<S-l>", ":call smarthome#SmartEnd('n')<cr>")
    map.set("n", "<Home>", ":call smarthome#SmartHome('n')<cr>")
    map.set("n", "<End>", ":call smarthome#SmartEnd('n')<cr>")
    map.set("i", "<Home>", "<C-r>=smarthome#SmartHome('i')<cr>")
    map.set("i", "<End>", "<C-r>=smarthome#SmartEnd('i')<cr>")

    map.set("n", "<Space>r", "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register" })

    -- map.set('n', '<Tab>', function() require("astronvim.utils.buffer").nav_to(vim.v.count +  1) end, { desc ="Go to Buffer" }) -- TODO: Messes up with CTRL+I

    map.set("n", "<Leader>j", ":call vm#commands#add_cursor_down(0,1)<CR>", { desc = "Add cursor down" })
    map.set("n", "<Leader>k", ":call vm#commands#add_cursor_up(0,1)<CR>", { desc = "Add cursor down" })
    map.set("i", "<C-A-up>", "<ESC>:call vm#commands#add_cursor_up(0,1)<CR>")
    map.set("i", "<C-A-down>", "<ESC>:call vm#commands#add_cursor_down(0,1)<CR>")

    map.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
    map.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
    map.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
    map.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
    map.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
    map.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

    -- map.set('n', "<Tab>"   , ">>"              )
    -- map.set('n', "<S-Tab>" , "<<"              ) -- windows issue

    -- map.set("n", "<leader>b" , ":lua require('dap').toggle_breakpoint()<cr>", { desc = 'Breakpoint Toggle'} )

    api.nvim_command "set cursorcolumn"

    api.nvim_command "nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'"
    api.nvim_command "nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'"

    -- api.nvim_command("let g:yoinkAutoFormatPaste='1'") -- Indent on paste
    api.nvim_command "map <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)'    : '<plug>(YoinkPaste_p)'"
    api.nvim_command "map <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'"
    api.nvim_command "xmap p <plug>(SubversiveSubstitute)"
    api.nvim_command "xmap P <plug>(SubversiveSubstitute)"
    -- Tabularize /(.*)

    api.nvim_command "set conceallevel=2"                                                             -- au FileType markdown setl conceallevel=0
    api.nvim_command "au BufRead,BufNewFile *.md nnoremap <buffer> gf :call go_to_markdown_ref()<cr>" -- https://www.reddit.com/r/vim/comments/yu49m1/rundont_run_vim_command_based_on_current_file/

    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>aa <cmd>ArduinoAttach<CR>"
    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>am <cmd>ArduinoVerify<CR>"
    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>au <cmd>ArduinoUpload<CR>"
    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ad <cmd>ArduinoUploadAndSerial<CR>"
    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ab <cmd>ArduinoChooseBoard<CR>"
    api.nvim_command "au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ap <cmd>ArduinoChooseProgrammer<CR>"

    map.set("n", "<leader>al", "<cmd>Tab /[=:|]/<cr>", { desc = "Align text" })

    -- api.nvim_command("nnoremap <c-a> :if !switch#Switch({'reverse': 0}) <bar> exe 'normal! <c-a>' <bar> endif<cr>") -- https://github.com/AndrewRadev/switch.vim/pull/41
    -- api.nvim_command("nnoremap <c-x> :if !switch#Switch({'reverse': 1}) <bar> exe 'normal! <c-x>' <bar> endif<cr>")

    -- api.nvim_command("let g:python3_host_prog = '~\\AppData\\Local\\Programs\\Python\\Python39\\python.exe'")
    -- map.set('n', 'N', '#') -- IF NOT ALREADY SLASH SEARCH (i think i can do this with lua and states)
    -- map.set('n', 'n', '*') -- IF NOT ALREADY SLASH SEARCH

    if vim.g.colors_name == "ayu" then
      api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#FF5F00" })
      api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
      api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
    elseif vim.g.colors_name == "sunbather" or vim.g.colors_name == "nazgul" then
      if _G.IS_WINDOWS then
        api.nvim_command "highlight Normal guibg=none"
      else
        api.nvim_command "highlight Normal guibg=#000000"
      end
      api.nvim_command "highlight LspReferenceRead  guibg=#353535"
      api.nvim_command "highlight LspReferenceWrite guibg=#353535"
      api.nvim_command "highlight LspReferenceText  guibg=#353535"
      api.nvim_command "highlight MatchParen        guibg=#000000 guifg=#FFFFFF guisp=#000000 cterm=underline gui=underline"
      api.nvim_command "highlight IndentBlanklineContextChar  guifg=#FFFFFF"
    end

    -- vim.filetype.add { -- Set up custom filetypes
    --   extension    = { foo                   = "fooscript", },
    --   filename     = { ["Foofile"]           = "fooscript", },
    --   pattern      = { ["~/%.config/foo/.*"] = "fooscript", },
    -- }
  end
}

--[[
  "Trust your Intuitions" -- Related to motions


  =====================================================================
                            REMIND STUFF
  =====================================================================
  * SmartHome SmartEnd but "smarter",  4 steps instead of 3 , a middle one where you were before taking the action


  =====================================================================
                            REMIND STUFF
  =====================================================================
  * http://www.viemu.com/vi-vim-tutorial-1.gif
  * https://www.youtube.com/watch?v=qZO9A5F6BZs
  * https://stackoverflow.com/a/26920014/11465149
  * nvim --startuptime output
  * :set background=light
  * :!git add *
  * :!git commit -m "whatever"
  * :!git push
  * git config --global credential.helper store (and after the first push credentials get stored)


  =====================================================================
                         FOR THING TO WORK
  =====================================================================
  * CPP
  * * install gdb for cpp in dap
  * * compile with -g : g++ -g file.cpp -o file.o
  * Clean Install
  * * sudo -E rm -r ~/.local/share/nvim
  * * sudo -E rm -r ~/.config/nvim
  * * sudo -E rm -r /usr/share/nvim/
  * * sudo -E rm -r /home/xou/.cache/nvim
  * * sudo pacman -R neovim
  * * sudo pacman -S neovim


  =====================================================================
                           HELPFUL STUFF
  =====================================================================
  * https://alpha2phi.medium.com/neovim-for-beginners-debugging-using-dap-44626a767f57
  * https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  * https://github.com/rockerBOO/awesome-neovim#markdown--latex



  =====================================================================
                         POTENTIAL PLUGINS
  =====================================================================
  * https://github.com/phaazon/hop.nvim
  * nvim-telescope/telescope-media-files.nvim      MUST INSTALL
  * https://github.com/xiyaowong/nvim-transparent
  * https://github.com/sindrets/winshift.nvim
  * https://github.com/kevinhwang91/nvim-hlslens
  * https://github.com/sindrets/diffview.nvim
  * https://github.com/glts/vim-radical
  * https://github.com/terryma/vim-expand-region
  * https://github.com/ThePrimeagen/harpoon
  * https://github.com/fedepujol/move.nvim


  =====================================================================
                           Watch Later
  =====================================================================
  * https://www.youtube.com/watch?v=vpwJ7fqD1CE
  * https://www.youtube.com/watch?v=VFESU67M4bk
  * https://www.youtube.com/watch?v=Bi9JiW5nSig


  =====================================================================
                             REFERENCES
  =====================================================================
  - #2 fix python indent (example: open brackets in comment like "# ([)")
  - - https://github.com/yioneko/nvim-yati
  - - https://github.com/nvim-treesitter/nvim-treesitter/issues/1136#issuecomment-1127145770
]]
