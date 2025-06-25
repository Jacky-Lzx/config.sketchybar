local settings = require("settings")
local colors = require("colors")

local calendar = sbar.add("item", {
  icon = {
    drawing = "off",
  },
  label = {
    color = colors.Catppuccin.Mocha.Mauve,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  background = {
    color = colors.item_background,
  },
  padding_left = settings.paddings,
  padding_right = settings.paddings,
})

calendar:subscribe({ "forced", "routine", "system_woke" }, function(_)
  calendar:set({ label = os.date("%a %d. %b %H:%M") })
end)
