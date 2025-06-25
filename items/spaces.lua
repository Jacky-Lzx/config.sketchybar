local colors = require("colors")
local settings = require("settings")
local get_icon = require("helpers.get_icon")

local spaces = {}

local spaces_color = colors.Catppuccin.Mocha.Yellow

local colors_spaces = {
  [1] = spaces_color,
  [2] = spaces_color,
  [3] = spaces_color,
  [4] = spaces_color,
  [5] = spaces_color,
  [6] = spaces_color,
  [7] = spaces_color,
  [8] = spaces_color,
  [9] = spaces_color,
  [10] = spaces_color,
}

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      font = {
        family = settings.font.numbers,
        size = 14,
      },
      string = i,
      padding_left = 5,
      padding_right = 0,
      color = colors_spaces[i],
      highlight_color = spaces_color,
    },
    label = {
      padding_right = 15,
      color = colors_spaces[i],
      font = "sketchybar-app-font:Regular:14.0",
      y_offset = -1,
      highlight_color = spaces_color,
    },
    background = {
      color = colors.Catppuccin.Mocha.Base,
    },
    padding_right = 2,
    padding_left = 2,
    popup = { background = { border_width = 5, border_color = colors.black } },
  })

  spaces[i] = space

  -- Padding space
  sbar.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 0,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 6,
        scale = 0.2,
      },
    },
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    sbar.animate("tanh", 10, function()
      space:set({
        icon = { highlight = selected },
        label = { highlight = selected },
      })
    end)
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  for app, _ in pairs(env.INFO.apps) do
    no_app = false
    local icon = get_icon(app)
    icon_line = icon_line .. utf8.char(0x202F) .. icon
  end

  if no_app then
    icon_line = "—"
  end
  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({
      label = {
        string = icon_line,
        color = colors.sky,
      },
    })
  end)
end)
