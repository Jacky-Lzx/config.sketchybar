local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local position = "right"
local label_size = 7
----------------------------------------------------------------------------------------------------
----                                         network                                            ----
----------------------------------------------------------------------------------------------------
-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 1.0 seconds.
sbar.exec(
  "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 1.0"
)

local wifi_up = sbar.add("item", "widgets.wifi_up", {
  position = position,
  padding_left = -5,
  width = 0,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = label_size,
    },
    string = icons.wifi.upload,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = label_size,
    },
    color = colors.tn_red,
    string = "??? Bps",
  },
  y_offset = 5,
})

local wifi_down = sbar.add("item", "widgets.wifi_down", {
  position = position,
  padding_left = -5,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = label_size,
    },
    string = icons.wifi.download,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = label_size,
    },
    color = colors.tn_cyan,
    string = "??? Bps",
  },
  y_offset = -5,
})

local wifi = sbar.add("item", "widgets.wifi.padding", {
  position = position,
  label = { drawing = false },
  padding_right = 2,
  padding_left = 2,
})

-- Background around the item
local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {
  wifi.name,
  wifi_up.name,
  wifi_down.name,
}, {
  popup = {
    align = "center",
    height = 30,
    background = { color = colors.tn_black3, border_color = colors.tn_magenta, border_width = 2 },
  },
})

wifi_up:subscribe("network_update", function(env)
  -- Extract the value and unit
  local upload_value, upload_unit = env.upload:match("^(%d+)%s*([KMG]?)")
  local download_value, download_unit = env.download:match("^(%d+)%s*([KMG]?)")

  -- Convert the value to a number
  upload_value = tonumber(upload_value)
  download_value = tonumber(download_value)

  -- Convert the value based on the unit (K=1024, M=1024^2, G=1024^3)
  local unit_multiplier = { K = 1024, M = 1024 ^ 2, G = 1024 ^ 3 }
  if upload_unit and unit_multiplier[upload_unit] then
    upload_value = upload_value * unit_multiplier[upload_unit]
  end
  if download_unit and unit_multiplier[download_unit] then
    download_value = download_value * unit_multiplier[download_unit]
  end

  -- Set the color
  local up_color = (upload_value == 0) and colors.tn_black1 or colors.tn_red
  local down_color = (download_value == 0) and colors.tn_black1 or colors.tn_cyan

  -- Set the label
  wifi_up:set({
    icon = { color = up_color },
    label = {
      string = env.upload,
      color = up_color,
    },
  })
  wifi_down:set({
    icon = { color = down_color },
    label = {
      string = env.download,
      color = down_color,
    },
  })
end)

wifi:subscribe({ "wifi_change", "system_woke" }, function(_)
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    wifi:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.tn_magenta or colors.tn_black1,
      },
    })
    if connected then
      wifi_up:set({ drawing = true })
      wifi_down:set({ drawing = true })
    else
      wifi_up:set({ drawing = false })
      wifi_down:set({ drawing = false })
    end
  end)
end)

return wifi_bracket
