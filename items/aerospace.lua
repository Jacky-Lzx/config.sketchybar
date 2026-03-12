-- Copied and modified from `https://github.com/robsteriam/dotfiles-public/blob/main/config/sketchybar/items/spaces.lua`

local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local get_icon = require("helpers.get_icon")

local spaces_color = colors.Catppuccin.Mocha.Yellow

local workspace_names = {
  ["1"] = "Web",
  ["2"] = "Code",
  ["3"] = "Media",
  ["4"] = "Editing",
  ["5"] = "Gaming",
  ["6"] = "Work",
  ["7"] = "7",
  ["8"] = "8",
  ["9"] = "9",
  ["T"] = "Terminal",
  ["W"] = "WeChat",
}

local query_workspaces =
  "aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

-- Root is used to handle event subscriptions
local root = sbar.add("item", { drawing = false })
local workspaces = {}

local function withWindows(f)
  local open_windows = {}
  -- Include the window ID in the query so we can track unique windows
  local get_windows = "aerospace list-windows --monitor all --format '%{workspace}%{app-name}%{window-id}' --json"
  local query_visible_workspaces =
    "aerospace list-workspaces --visible --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"
  local get_focus_workspaces = "aerospace list-workspaces --focused"
  sbar.exec(get_windows, function(workspace_and_windows)
    -- Use a set to track unique window IDs
    local processed_windows = {}

    for _, entry in ipairs(workspace_and_windows) do
      local workspace_index = entry.workspace
      local app = entry["app-name"]
      local window_id = entry["window-id"]

      -- Only process each window ID once
      if not processed_windows[window_id] then
        processed_windows[window_id] = true

        if open_windows[workspace_index] == nil then
          open_windows[workspace_index] = {}
        end

        -- Check if this app is already in the list for this workspace
        local app_exists = false
        for _, existing_app in ipairs(open_windows[workspace_index]) do
          if existing_app == app then
            app_exists = true
            break
          end
        end

        -- Only add the app if it's not already in the list
        if not app_exists then
          table.insert(open_windows[workspace_index], app)
        end
      end
    end

    sbar.exec(get_focus_workspaces, function(focused_workspaces)
      sbar.exec(query_visible_workspaces, function(visible_workspaces)
        local args = {
          open_windows = open_windows,
          focused_workspaces = focused_workspaces,
          visible_workspaces = visible_workspaces,
        }
        f(args)
      end)
    end)
  end)
end

local function updateWindow(workspace_index, args)
  local open_windows = args.open_windows[workspace_index]
  local focused_workspaces = args.focused_workspaces
  local visible_workspaces = args.visible_workspaces

  if open_windows == nil then
    open_windows = {}
  end

  -- local icon_line = ""
  local no_app = true
  for _, open_window in ipairs(open_windows) do
    no_app = false
    -- local app = open_window
    -- local icon = get_icon(app)
    -- icon_line = icon_line .. utf8.char(0x202F) .. icon
  end

  sbar.animate("tanh", 10, function()
    for _, visible_workspace in ipairs(visible_workspaces) do
      if no_app and workspace_index == visible_workspace["workspace"] then
        local monitor_id = visible_workspace["monitor-appkit-nsscreen-screens-id"]
        -- icon_line = "—"
        workspaces[workspace_index]:set({
          -- drawing = true,
          -- ["label.string"] = icon_line,
          display = monitor_id,
        })
        return
      end
    end
    if no_app and workspace_index ~= focused_workspaces then
      -- icon_line = "—"
      workspaces[workspace_index]:set({
        -- drawing = true,
        -- ["label.string"] = icon_line,
      })
      return
    end
    if no_app and workspace_index == focused_workspaces then
      -- icon_line = "—"
      workspaces[workspace_index]:set({
        -- drawing = true,
        -- ["label.string"] = icon_line,
      })
    end

    -- workspaces[workspace_index]:set({
    --   -- drawing = true,
    --   -- ["label.string"] = icon_line,
    -- })
  end)
end

local function updateWindows()
  withWindows(function(args)
    for workspace_index, _ in pairs(workspaces) do
      updateWindow(workspace_index, args)
    end
  end)
end

local function updateWorkspaceMonitor()
  local workspace_monitor = {}
  sbar.exec(query_workspaces, function(workspaces_and_monitors)
    for _, entry in ipairs(workspaces_and_monitors) do
      local space_index = entry.workspace
      local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])
      workspace_monitor[space_index] = monitor_id
    end
    for workspace_index, _ in pairs(workspaces) do
      workspaces[workspace_index]:set({
        display = workspace_monitor[workspace_index],
      })
    end
  end)
end

sbar.exec(query_workspaces, function(workspaces_and_monitors)
  for _, entry in ipairs(workspaces_and_monitors) do
    local workspace_index = entry.workspace

    local workspace = sbar.add("item", "workspace." .. workspace_index, {
      -- drawing = false,
      position = "center",
      icon = {
        font = {
          family = settings.font.numbers,
          size = 14,
        },
        string = workspace_index,
        padding_left = 5,
        padding_right = 0,
        color = spaces_color,
        highlight_color = spaces_color,
      },
      label = {
        padding_right = 15,
        color = colors.sky,
        font = "sketchybar-app-font:Regular:14.0",
        y_offset = -1,
        highlight_color = spaces_color,
      },
      background = {
        color = colors.Catppuccin.Mocha.Base,
      },
      padding_right = 2,
      padding_left = 2,
      click_script = "aerospace workspace " .. workspace_index,
    })

    workspaces[workspace_index] = workspace

    workspace:subscribe("aerospace_workspace_change", function(env)
      local focused_workspace = env.FOCUSED_WORKSPACE
      local is_focused = (focused_workspace == workspace_index)

      sbar.animate("tanh", 10, function()
        workspace:set({
          icon = { highlight = is_focused },
          label = { highlight = is_focused },
          blur_radius = 30,
        })
      end)

      sbar.exec(
        string.format('aerospace list-windows --workspace %s --format "%%{app-name}"', workspace_index),
        function(output)
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
            workspace:set({
              drawing = not (no_app and not is_focused),
              label = {
                string = icon_line,
                color = colors.sky,
              },
            })
          end)
        end
      )
    end)
  end

  -- Initial setup
  updateWindows()
  updateWorkspaceMonitor()

  -- Subscribe to window creation/destruction events
  root:subscribe("aerospace_workspace_change", function()
    updateWindows()
  end)

  -- Subscribe to front app changes too
  root:subscribe("front_app_switched", function()
    updateWindows()
  end)

  root:subscribe("display_change", function()
    updateWorkspaceMonitor()
    updateWindows()
  end)

  sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
    focused_workspace = focused_workspace:match("^%s*(.-)%s*$")
    workspaces[focused_workspace]:set({
      icon = { highlight = true },
      label = { highlight = true },
    })
  end)
end)
