return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- closes Neo-tree if it's the last window
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          padding = 0,
        },
icon = {
  -- folders
  folder_open = "",
  folder_closed = "",
  folder_empty = "ﰊ",
  folder_arrow_open = "",
  folder_arrow_closed = "",

  -- files
  default = "",
  symlink = "",
  lua = "𖠯",
  -- optionally different icons for different file types (you can extend this via a table)
  -- e.g., lua = "𖠯", js = "", py = ""

  -- git status
  git = {
    added = "✚",
    modified = "",
    removed = "✖",
    renamed = "",
    untracked = "★",
    ignored = "◌",
    unstaged = "✗",
    staged = "✓",
    conflict = "",
  },

  -- diagnostics
  diagnostics = {
    hint = "𝒊",
    info = "𝔦",
    warning = "✠",
    error = "⛌",
  },
}
      },
    })
  end,
}
