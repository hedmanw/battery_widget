local wibox = require("wibox")
local awful = require("awful")

local indicator = {}
local function worker(args)
    local args = args or {}

    local widget = wibox.layout.fixed.horizontal()

    -- Settings come here
    local timeout   = args.timeout or 10

    -- Widget contents
    local bat_text = wibox.widget.textbox()
    bat_text:set_text("Hello!")

    local acpi_timer = timer({ timeout = timeout })
    local battery_level = 0

    local function acpi_update()
        -- Do acpi update stuff and set bat text accordingly
        local energy_full = tonumber(awful.util.pread("cat /sys/class/power_supply/BAT0/energy_full"))
        local energy_now = tonumber(awful.util.pread("cat /sys/class/power_supply/BAT0/energy_now"))
        battery_level = math.floor((energy_now / energy_full)*100)
        bat_text:set_text(battery_level .. "%")
    end

    acpi_update()
    acpi_timer:connect_signal("timeout", acpi_update)
    acpi_timer:start()

    widget:add(bat_text)

    return widget
end

return setmetatable(indicator, {__call = function(_,...) return worker(...) end})

