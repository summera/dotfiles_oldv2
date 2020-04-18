local as = require "hs.applescript"
local geometry = require("hs.geometry")

--== Global Configuration ==--
hs.grid.MARGINX    = 0
hs.grid.MARGINY    = 0
hs.grid.GRIDWIDTH  = 1
hs.grid.GRIDHEIGHT = 1

hs.window.animationDuration = 0

--== Applications ==--
local function launchOrFocus(app)
  return hs.application.launchOrFocus(app)
end

k = hs.hotkey.modal.new({"ctrl"}, "space")

k:bind({}, 'i', function() launchOrFocus('iTerm') end, function() k:exit() end)
k:bind({}, 'f', function() launchOrFocus('FirefoxDeveloperEdition') end, function() k:exit() end)
k:bind({}, 's', function() launchOrFocus('Slack') end, function() k:exit() end)
k:bind({}, 'm', function() launchOrFocus('Messages') end, function() k:exit() end)
k:bind({}, 't', function() launchOrFocus('SourceTree') end, function() k:exit() end)
k:bind({}, 'c', function() launchOrFocus('Google Chrome') end, function() k:exit() end)
k:bind({}, 'm', function() launchOrFocus('Messages') end, function() k:exit() end)
k:bind({}, 'x', function() launchOrFocus('Xcode') end, function() k:exit() end)
k:bind({}, 'a', function() launchOrFocus('Android Studio') end, function() k:exit() end)

k:bind({}, 'r', function() hs.reload() end, function() k:exit() end)
k:bind({}, 'd', function() hs.window.focusedWindow():close() end, function() k:exit() end)


--== Multi-monitor ==--
k:bind({}, 'left', function() hs.grid.pushWindowNextScreen() end, function() k:exit() end)
k:bind({}, 'right', function() hs.grid.pushWindowPrevScreen() end, function() k:exit() end)


--== Grid snapping ==--
local function snapFocusedWindow(layout)
  hs.window.focusedWindow():moveToUnit(layout)
end

k:bind({}, 'h', function() snapFocusedWindow(hs.layout.left25) end, function() k:exit() end)
k:bind({}, 'j', function() snapFocusedWindow(hs.layout.left50) end, function() k:exit() end)
k:bind({}, 'l', function() snapFocusedWindow(hs.layout.right50) end, function() k:exit() end)
k:bind({}, ';', function() snapFocusedWindow(hs.layout.right25) end, function() k:exit() end)
k:bind({}, 'k', function() snapFocusedWindow(hs.layout.maximized) end, function() k:exit() end)
k:bind({}, 'i', function() snapFocusedWindow(geometry.rect(0.25, 0, 0.5, 1)) end, function() k:exit() end)


local function tellSonos(cmd)
  local _cmd = 'tell application "System Events" to tell process "Sonos" to ' .. cmd
  local ok, result = as.applescript(_cmd)
  if ok then
    return result
  else
    return nil
  end
end
local function isRunning(appName)
  local _cmd = 'application "' .. appName .. '" is running'
  local ok, result = as.applescript(_cmd)

  if ok then
    return result
  else
    return false
  end
end

k:bind({}, 'pageup', function()
  print("volume up!")
  if isRunning('Sonos') then
    tellSonos('set value of slider 1 of window 1 to get (value of slider 1 of window 1) + 4')
  else
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() + 10)
  end
end, function() k:exit() end)

k:bind({}, 'pagedown', function()
  if isRunning('Sonos') then
    tellSonos('set value of slider 1 of window 1 to get (value of slider 1 of window 1) - 4')
  else
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() - 10)
  end
end, function() k:exit() end)

--== Welcome ==--
hs.alert.show('Hammerspoon, at your service.')
