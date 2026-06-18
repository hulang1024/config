return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = false, -- 关闭自动跟随展开
        },
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = {
            "ProjectSettings",
            "UserSettings",
            "Temp",
            "Logs",
            "Library",

            "AnimationClip",
            "AnimatorController",
            "Font",
            "GameObject",
            "Material",
            "Mesh",
            "Plugins",
            "Resources",
            "Shader",
            "Sprite",
            "Texture2D",
          },
          hide_by_pattern = {
            "*.meta",
            "*.asset",
            "*.unity",
          },
        },
      },
    },
  },
}
