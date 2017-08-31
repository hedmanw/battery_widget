local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

local indicator = {}
local function worker(args)
    local args = args or {}

    local widget = wibox.layout.fixed.horizontal()

    -- Settings come here
    local timeout   = args.timeout or 10
    local battery   = args.battery or "BAT0/"
    local font      = args.font or beautiful.font

    local battery_path = "/sys/class/power_supply/" .. battery
    local catbat = "cat " .. battery_path

    -- Widget contents
    local bat_text = wibox.widget.textbox()
    bat_text:set_text("Hello!")

    local battery_level = 0
    local status = ""
    -- Change this based on lookup
    local battery_connected = true

    local function acpi_update()
        local battery_status = ""
        -- Do acpi update stuff and set bat text accordingly
        awful.spawn.easy_async(catbat .. "capacity", function(capacity, _, _, _)
            battery_level = string.match(capacity, "([0-9]*)") or "N/A"

            awful.spawn.easy_async(catbat .. "status", function(status_val, _, _, _)
                status = status_val
                if string.match(status, "Charging") then
                    battery_status = "⬆"
                else
                    battery_status = "⬇"
                end
                bat_text:set_text(battery_status .. battery_level .. "%")
            end)
        end)
    end

    acpi_update()

    local acpi_timer = gears.timer {
        timeout = timeout,
        autostart = true,
        callback = function()
            acpi_update()
        end
    }

    widget:add(bat_text)

    local function fetch_popup_text()
        local msg = ""
        if battery_connected then
            awful.spawn.easy_async("acpi | cut -d, -f 3", function(remaining, _, _, _)
                msg =
                    "<span font_desc=\""..font.."\">"..
                    "┌["..battery.."]\n"..
                    "├Status: "..status..
                    "└Time:\t"..remaining.."</span>"
           end)
        else
            msg = "Battery is not present."
        end

        return msg
    end

    local notification = nil
    function widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function widget:show(tout)
        widget:hide()

        notification = naughty.notify({
            preset = fs_notification_preset,
            text = fetch_popup_text(),
            timeout = tout
        })
    end

    widget:connect_signal('mouse::enter', function () widget:show(0) end)
    widget:connect_signal('mouse::leave', function () widget:hide() end)

    return widget
end

return setmetatable(indicator, {__call = function(_,...) return worker(...) end})

