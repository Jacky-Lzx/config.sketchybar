local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  update_freq = 30,

  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 19.0,
    },
  },
  label = {
    font = {
      family = settings.font.numbers,
    },
    color = colors.Catppuccin.Mocha.Green,
  },
  background = {
    color = colors.Catppuccin.Mocha.Base,
  },
  popup = {
    align = "center",
    background = {
      color = colors.tn_black3,
      border_color = colors.tn_orange,
      border_width = 2,
    },
  },
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    padding_left = 0,
    padding_right = 0,
    string = "Charging:",
    color = colors.tn_orange,
    width = 55,
    align = "left",
    font = {
      size = 13.0,
    },
  },
  label = {
    string = "??:??h",
    width = 90,
    align = "right",
  },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.Catppuccin.Mocha.Green
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
    else
      if found and charge > 80 then
        icon = icons.battery._100
      elseif found and charge > 60 then
        icon = icons.battery._75
      elseif found and charge > 40 then
        icon = icons.battery._50
      elseif found and charge > 20 then
        icon = icons.battery._25
        color = colors.Catppuccin.Mocha.Peach
      else
        icon = icons.battery._0
        color = colors.Catppuccin.Mocha.Red
      end
    end

    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color,
      },
      label = { string = lead .. label },
      popup = {
        background = {
          border_color = color,
        },
      },
    })
    remaining_time:set({ label = { color = color }, icon = { color = color } })
  end)
end)

battery:subscribe("mouse.clicked", function(_)
  local drawing = battery:query().popup.drawing
  battery:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set({ label = { string = label } })
    end)
  end
end)

battery:subscribe("mouse.exited.global", function(_)
  battery:set({ popup = { drawing = false } })
end)
