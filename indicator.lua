local wibox = require("wibox")
local awful = require("awful")

local indicator = {}
local function worker(args)
    local args = args or {}

    local widget = wibox.layout.fixed.horizontal()

    -- Settings come here
    local timeout   = args.timeout or 10
    local battery   = "/sys/class/power_supply/BAT0/"

    local catbat = "cat " .. battery

    -- Widget contents
    local bat_text = wibox.widget.textbox()
    bat_text:set_text("Hello!")

    local acpi_timer = timer({ timeout = timeout })
    local battery_level = 0
    local battery_status = "↓"

    local function acpi_update()
        -- Do acpi update stuff and set bat text accordingly
        local energy_full = tonumber(awful.util.pread(catbat .. "energy_full"))
        local energy_now = tonumber(awful.util.pread(catbat .. "energy_now"))
        battery_level = math.floor((energy_now / energy_full)*100)

        local status = awful.util.pread(catbat .. "status")
        if string.match(status, "Charging") then
            battery_status = "^"
        else
            battery_status = "↓"
        end
        bat_text:set_text(battery_status .. battery_level .. "%")
    end

    acpi_update()
    acpi_timer:connect_signal("timeout", acpi_update)
    acpi_timer:start()

    widget:add(bat_text)

    return widget
end

return setmetatable(indicator, {__call = function(_,...) return worker(...) end})

