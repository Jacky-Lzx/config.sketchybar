local get_icon = require("helpers.get_icon")
local settings = require("settings")
local colors = require("colors")

local front_app = sbar.add("item", "front_app", {
  position = "right",
  padding_right = 100,
  display = "active",
  icon = {
    string = "􀆊",
    padding_right = 10,
    font = "sketchybar-app-font:Regular:14.0",
  },
  background = {
    color = colors.Catppuccin.Mocha.Base,
  },
  label = {
    font = {
      style = settings.font.style_map["Black"],
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  local app = env.INFO
  local icon = get_icon(app)

  front_app:set({ icon = { string = "" }, label = { string = "" } })
  sbar.animate("tanh", 10, function()
    front_app:set({ icon = { string = icon }, label = { string = env.INFO } })
  end)
end)

front_app:subscribe("mouse.clicked", function(_)
  sbar.trigger("swap_menus_and_spaces")
end)
