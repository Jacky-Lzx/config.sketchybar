local colors = require("colors")

local wifi_bracket = require("items.widgets.system.wifi")
local memory = require("items.widgets.system.memory")
local cpu = require("items.widgets.system.cpu")

----------------------------------------------------------------------------------------------------
----                                         system bracket                                     ----
----------------------------------------------------------------------------------------------------
sbar.add("bracket", "widgets.system.bracket", {
  cpu.name,
  memory.name,
  wifi_bracket.name,
}, {
  background = {
    color = colors.Catppuccin.Mocha.Base,
  },
})
