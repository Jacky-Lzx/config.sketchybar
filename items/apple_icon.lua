local colors = require("colors")
local icons = require("icons")

sbar.add("item", {
  background = {
    color = colors.item_background,
  },
  icon = {
    drawing = "off",
  },
  label = {
    align = "center",
    string = icons.apple,
    padding_left = 10,
    padding_right = 10,
    color = colors.Catppuccin.Mocha.Green,
  },
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
  align = "center",
})
