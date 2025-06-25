local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

----------------------------------------------------------------------------------------------------
----                                            cpu                                             ----
----------------------------------------------------------------------------------------------------
-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 1.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 1.0")

local cpu = sbar.add("item", "widgets.cpu", {
  position = "right",
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.cpu,
    color = colors.blue,
  },
  label = {
    string = "??%",
    color = colors.blue,
    font = {
      family = settings.font.numbers,
    },
    align = "right",
  },
  padding_right = 0,
  padding_left = 5,
})

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  local load = tonumber(env.total_load)

  local color = colors.tn_blue
  if load > 30 then
    if load < 60 then
      color = colors.tn_yellow
    elseif load < 80 then
      color = colors.tn_orange
    else
      color = colors.tn_red
    end
  end

  cpu:set({
    label = {
      string = env.total_load .. "%",
      color = color,
    },
    icon = { color = color },
  })
  -- bracket:set({ background = { border_color = color } })
end)

cpu:subscribe("mouse.clicked", function(_)
  sbar.exec("open -a 'Activity Monitor'")
end)

return cpu
