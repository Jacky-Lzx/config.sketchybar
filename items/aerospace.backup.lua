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

for ws_i = 1, 10, 1 do
  local space = sbar.add("item", "aws." .. ws_i, {
    position = "center",
    icon = {
      font = {
        family = settings.font.numbers,
        size = 14,
      },
      string = ws_i,
      padding_left = 5,
      padding_right = 0,
      color = colors_spaces[ws_i],
      highlight_color = spaces_color,
    },
    label = {
      padding_right = 15,
      color = colors_spaces[ws_i],
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

  spaces[ws_i] = space

  -- Change space color on focus
  space:subscribe("aerospace_workspace_change", function(env)
    local ws_focused = tonumber(env.FOCUSED_WORKSPACE)

    local is_focused = (ws_i == ws_focused)

    sbar.animate("tanh", 10, function()
      space:set({
        icon = { highlight = is_focused },
        label = { highlight = is_focused },
      })
    end)

    sbar.exec(string.format('aerospace list-windows --workspace %s --format "%%{app-name}"', ws_i), function(output)
      local icon_line = ""
      local no_app = true
      for app in string.gmatch(output or "", "[^\r\n]+") do
        no_app = false
        local icon = get_icon(app)
        icon_line = icon_line .. utf8.char(0x202F) .. icon
      end

      if no_app then
        icon_line = "—"
      end
      sbar.animate("tanh", 10, function()
        spaces[ws_i]:set({
          label = {
            string = icon_line,
            color = colors.sky,
          },
        })
      end)
    end)
  end)

  -- Change space on click
  space:subscribe("mouse.clicked", function(env)
    -- local op = (env.BUTTON == "right") and "--destroy" or "--focus"
    sbar.exec("aerospace workspace " .. ws_i)
  end)
end

-- local space_window_observer = sbar.add("item", {
--   drawing = false,
--   updates = true,
-- })
