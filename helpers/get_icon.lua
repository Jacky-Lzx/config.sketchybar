local get_icon = function(name)
  local app_icons = require("helpers.app_icons")

  local icon = app_icons[name]
  if icon == nil then
    icon = app_icons["Default"]
  end

  return icon
end

return get_icon
