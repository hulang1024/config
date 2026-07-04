local mode_map = {
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["c"] = "COMMAND",
  ["t"] = "TERMINAL",
  ["R"] = "REPLACE",

  ["v"] = "VISUAL",
  ["V"] = "V-LINE",
  ["\22"] = "V-BLOCK",

  ["s"] = "SELECT",
  ["S"] = "SELECT",
  ["\19"] = "SELECT",

  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",

  ["nt"] = "T-NORMAL",
  ["cv"] = "VIM-EX",
}

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            function()
              local m = vim.fn.mode(1)
              return mode_map[m] or string.sub(m, 1, 1)
            end,
          },
        },
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    version = "*",
    opts = {},
  },
}
