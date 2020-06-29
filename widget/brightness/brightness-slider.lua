local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon_button = require('widget.material.icon-button')
local clickable_container = require('widget.material.clickable-container')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')

local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider:connect_signal(
  'property::value',
  function()
    spawn('ddcutil setvcp 10 ' .. math.max(slider.value, 5))
  end
)

watch(
  [[bash -c "ddcutil getvcp 10 2>/dev/null"]],
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local brightness = string.match(stdout, 'current value = +(%d+)')

    slider:set_value(tonumber(brightness))
    collectgarbage('collect')
  end
)

local icon =
  wibox.widget {
  image = icons.brightness,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)

local brightness_setting =
  wibox.widget {
  button,
  slider,
  widget = mat_list_item
}

return brightness_setting
