local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  update_freq = 1,
  updates = "when_shown",

  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.white,
    highlight = colors.background,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    -- corner_radius = 6,
    background = { image = { corner_radius = 12 } },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,
    },
    color = colors.white,
    highlight = colors.background,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    -- color = colors.item_background,
    corner_radius = 10,
    height = 22,
    border_width = 0,
    border_color = colors.yellow,
    image = {
      corner_radius = 0,
    },
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 2,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 20,
  },
  padding_left = settings.paddings,
  padding_right = settings.paddings,
  -- scroll_texts = true,
})
