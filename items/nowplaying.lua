local colors = require("colors")
local get_icon = require("helpers.get_icon")

local whitelist = { ["Music"] = true, ["网易云音乐"] = true }

local nowplaying = sbar.add("item", "nowplaying", {
  position = "right",
  updates = true,
  update_freq = 1,
  icon = {
    font = "sketchybar-app-font:Regular:14.0",
    string = "􀑪 􀊆",
    color = colors.Catppuccin.Mocha.Rosewater,
    padding_right = 0,
  },
  label = {
    max_chars = 15,
    align = "center",
    padding_right = 3,
    padding_left = 0,
    color = colors.Catppuccin.Mocha.Rosewater,
  },
  background = {
    color = colors.Catppuccin.Mocha.Base,
  },
})

local function update_music_info(env)
  local playing_state = env.INFO.state
  if playing_state == "paused" then
    sbar.animate("tanh", 20, function()
      nowplaying:set({
        icon = "􀑪 􀊆",
        label = "",
      })
    end)
    return
  end

  local app = env.INFO.app
  local title = env.INFO.title

  local result = "􀑪"

  local icon = get_icon(app)

  -- Only show info for whitelisted apps
  if whitelist[app] then
    result = title
  end

  sbar.animate("tanh", 20, function()
    nowplaying:set({
      icon = {
        string = icon,
      },
      label = {
        string = result,
      },
    })
  end)
end

nowplaying:subscribe({ "media_change" }, update_music_info)
