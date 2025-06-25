return {
  paddings = 3,
  group_paddings = 2,

  icons = "sf-symbols", -- alternatively available: NerdFont

  -- This is a font configuration for SF Pro and SF Mono (installed manually)
  font = {
    text = "SF Pro", -- Used for text
    numbers = "SF Mono", -- Used for numbers

    -- Unified font style map
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Semibold",
      ["Bold"] = "Bold",
      ["Heavy"] = "Heavy",
      ["Black"] = "Black",
    },
  },

  -- Alternatively, this is a font config for JetBrainsMono Nerd Font
  -- font = {
  --   text = "JetBrainsMono Nerd Font", -- Used for text
  --   numbers = "JetBrainsMono Nerd Font", -- Used for numbers
  --   style_map = {
  --     ["Regular"] = "Regular",
  --     ["Semibold"] = "Medium",
  --     ["Bold"] = "SemiBold",
  --     ["Heavy"] = "Bold",
  --     ["Black"] = "ExtraBold",
  --   },
  -- },
}
