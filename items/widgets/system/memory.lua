local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

----------------------------------------------------------------------------------------------------
----                                          memory                                            ----
----------------------------------------------------------------------------------------------------
-- Execute the event provider binary which provides the event "memory_update" for
-- the memory load data, which is fired every 1.0 second.
sbar.exec(
  "killall memory_load >/dev/null; $CONFIG_DIR/helpers/event_providers/memory_load/bin/memory_load memory_update 1.0"
)

local memory = sbar.add("item", "widgets.memory", {
  position = "right",
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.memory,
    font = { size = 23 },
    color = colors.pure_green,
  },
  label = {
    string = "??%",
    color = colors.pure_green,
    font = {
      family = settings.font.numbers,
    },
    align = "right",
  },
  padding_right = 0,
  padding_left = 5,
})

memory:subscribe("memory_update", function(env)
  -- Fetch the used memory percentage from the event provider
  local used_percentage = tonumber(env.used_percentage)
  if used_percentage == nil then
    used_percentage = -1
  end

  local color = colors.pure_green
  if used_percentage > 30 then
    if used_percentage < 60 then
      color = colors.yellow
    elseif used_percentage < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  memory:set({
    label = {
      string = string.format("%d", math.floor(used_percentage)) .. "%",
      color = color,
    },

    icon = { color = color },
  })
end)

memory:subscribe("mouse.clicked", function(_)
  sbar.exec("open -a 'Activity Monitor'")
end)

return memory
