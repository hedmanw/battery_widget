local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.battery_widget = nil

local battery_widget = {
    indicator   = require(module_path .. "battery_widget.indicator"),
}

return battery_widget
