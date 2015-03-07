local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.battery_widgets = nil

local battery_widgets = {
    indicator   = require(module_path .. "battery_widgets.indicator"),
    --status      = require(module_path .. "battery_widgets.status")
}

return battery_widgets
