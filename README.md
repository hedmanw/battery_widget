# battery_widget
Battery widget for awesome WM using `acpi`

##How to use it
Clone the repository into your awesome config folder.
```
git clone git@github.com:hedmanw/battery_widget.git ~/.config/awesome/battery_widget
```
Add the following to your `rc.lua`
```Lua
local battery_widget = require("battery_widget")
```
Create the widget and configure it with
```Lua
battery_indicator = battery_widget.indicator({
  -- Options (all optional)
  timeout = 10 -- update interval in seconds. default = 10
  battery = "BAT0/" -- battery path in /sys/class/power_supply/. default = "BAT0/"
  font    = "SourceCodePro 11" -- font to use in popup. should be monospaced. default = beautiful.font
})
```
Don't forget to add it to your wibox layout!
