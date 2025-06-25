local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

local volume_color = colors.Catppuccin.Mocha.Pink

local volume_item = sbar.add("item", "widgets.volume1", {
  position = "right",
  icon = {
    color = volume_color,
    width = 25,
    align = "left",
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = {
    string = "??%",
    align = "right",
    padding_left = -1,
    font = { family = settings.font.numbers },
    color = volume_color,
  },
  background = {
    color = colors.Catppuccin.Mocha.Base,
  },
  popup = {
    align = "center",
    background = {
      color = colors.tn_black3,
      border_color = volume_color,
      border_width = 2,
    },
  },
})

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_item.name,
  slider = {
    highlight_color = volume_color,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.Catppuccin.Mocha.Overlay_0,
    },
    knob = {
      string = "􀀁",
      drawing = true,
    },
  },
  background = {
    color = volume_color,
    height = 2,
    y_offset = -20,
  },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"',
})

volume_item:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  local icon = icons.volume._0
  if volume > 60 then
    icon = icons.volume._100
  elseif volume > 30 then
    icon = icons.volume._66
  elseif volume > 10 then
    icon = icons.volume._33
  elseif volume > 0 then
    icon = icons.volume._10
  end

  volume_item:set({ icon = icon, label = volume .. "%" })
  volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
  local drawing = volume_item:query().popup.drawing == "on"
  if not drawing then
    return
  end
  volume_item:set({ popup = { drawing = false } })
  sbar.remove("/volume.device\\.*/")
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume_item:query().popup.drawing == "off"
  if should_draw then
    volume_item:set({ popup = { drawing = true } })
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        local current = current_audio_device
        local counter = 0

        for device in string.gmatch(available, "[^\r\n]+") do
          local color = colors.Catppuccin.Mocha.Text
          if current == device then
            color = volume_color
          end
          sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume_item.name,
            width = popup_width,
            align = "center",
            label = { string = device, color = color },
            click_script = 'SwitchAudioSource -s "'
              .. device
              .. '" && sketchybar --set /volume.device\\.*/ label.color='
              .. colors.Catppuccin.Mocha.Text
              .. " --set $NAME label.color="
              .. volume_color,
          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.SCROLL_DELTA
  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_item:subscribe("mouse.clicked", volume_toggle_details)
volume_item:subscribe("mouse.exited.global", volume_collapse_details)
volume_item:subscribe("mouse.scrolled", volume_scroll)
