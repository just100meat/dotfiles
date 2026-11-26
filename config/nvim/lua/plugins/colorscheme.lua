return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "auto",

      background = {
        light = "latte",
        dark = "mocha",
      },

      transparent_background = false,
      term_colors = true,

      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },

      auto_integrations = true,

      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        lualine = true,
        lsp_trouble = true,
        which_key = true,
        indent_blankline = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },

      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },

      popupmenu = {
        enabled = true,
        backend = "nui",
      },

      notify = {
        enabled = true,
      },

      lsp = {
        progress = {
          enabled = true,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
      },

      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },
}
