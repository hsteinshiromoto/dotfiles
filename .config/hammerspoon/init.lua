-- ~/.config/hammerspoon/init.lua
-- Turn the media Play/Pause key (e.g. EarPods centre button) into a UNIVERSAL
-- microphone mute toggle.
--
-- Karabiner can't seize a USB-audio headset's consumer keys, so instead we place
-- a system-level event tap here: we intercept the Play/Pause key before it reaches
-- Spotify / the macOS NowPlaying framework, consume it, and toggle the mic mute at
-- the CoreAudio layer (works even when AppleScript `input volume` is unavailable).
-- Optionally we also sync the Microsoft Teams in-app mute toggle (Cmd+Shift+M).

-- Set to false to skip the Teams UI sync (no Teams focus-flash, no Accessibility
-- needed for the keystroke).
local SYNC_TEAMS_UI = true

local LOG = "/tmp/mic-mute.log"
local function logmsg(s)
    local f = io.open(LOG, "a")
    if f then f:write(os.date("%H:%M:%S ") .. s .. "\n"); f:close() end
end

-- ---------------------------------------------------------------------------
-- Microphone state via CoreAudio mute property (falls back to volume = 0).
-- ---------------------------------------------------------------------------
local function currentlyMuted()
    local dev = hs.audiodevice.defaultInputDevice()
    if not dev then return false end
    local m = dev:inputMuted()
    if m == nil then
        local v = dev:inputVolume()
        return v ~= nil and v == 0
    end
    return m
end

local function setMicMuted(muted)
    local dev = hs.audiodevice.defaultInputDevice()
    if not dev then return end
    local ok = dev:setInputMuted(muted)
    if not ok then
        dev:setInputVolume(muted and 0 or 75)
    end
end

-- ---------------------------------------------------------------------------
-- Sync the Teams in-app mute toggle (Cmd+Shift+M). Teams must be frontmost to
-- receive it, so we activate it, send the key, then restore the previous app.
-- ---------------------------------------------------------------------------
local function whenFrontmost(app, attempts, fn)
    if attempts <= 0 or hs.application.frontmostApplication() == app then
        fn()
    else
        hs.timer.doAfter(0.02, function() whenFrontmost(app, attempts - 1, fn) end)
    end
end

local function syncTeamsMute()
    local teams = hs.application.get("Microsoft Teams")
    if not teams then return end
    local prev = hs.application.frontmostApplication()
    teams:activate()
    whenFrontmost(teams, 25, function()
        hs.eventtap.keyStroke({ "cmd", "shift" }, "m", 0)
        if prev and prev:bundleID() ~= teams:bundleID() then
            hs.timer.doAfter(0.05, function() prev:activate() end)
        end
    end)
end

-- ---------------------------------------------------------------------------
-- The toggle itself.
-- ---------------------------------------------------------------------------
local function doMuteToggle()
    local newMuted = not currentlyMuted()
    setMicMuted(newMuted)
    hs.alert.closeAll()
    hs.alert.show(newMuted and "🔇  Mic muted" or "🎙️  Mic live", 0.7)
    logmsg("toggle -> muted=" .. tostring(newMuted))
    if SYNC_TEAMS_UI then syncTeamsMute() end
end

-- Manual trigger for testing: open -g "hammerspoon://mic-mute-toggle"
hs.urlevent.bind("mic-mute-toggle", function()
    logmsg("url triggered")
    doMuteToggle()
end)

-- ---------------------------------------------------------------------------
-- Intercept the Play/Pause media key system-wide and repurpose it.
-- Must be stored in a non-local so it isn't garbage-collected.
-- ---------------------------------------------------------------------------
mediaKeyTap = hs.eventtap.new({ hs.eventtap.event.types.systemDefined }, function(event)
    local d = event:systemKey()
    if d and d.key == "PLAY" then
        logmsg("PLAY key down=" .. tostring(d.down))
        if d.down then doMuteToggle() end
        return true -- consume so Spotify / NowPlaying never see it
    end
    return false
end)
mediaKeyTap:start()

logmsg("init loaded; tap running=" .. tostring(mediaKeyTap:isEnabled()))
hs.alert.show("🎙️ mic-mute loaded (tap)")
