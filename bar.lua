local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  -- topmost = "window",
  height = 26,
  margin = 10,
  color = colors.transparent,
  y_offset = 4,
  padding_right = 0,
  padding_left = 0,
  blur_radius = 12,
  border_width = 0,
  corner_radius = 0,
  shadow = "off",
  position = "top",
  sticky = "on",
})
