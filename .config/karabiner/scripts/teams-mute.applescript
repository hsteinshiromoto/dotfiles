-- Bring Teams forward (required — can't send a key to a background Electron window)
tell application "Microsoft Teams" to activate

tell application "System Events"
    -- wait until Teams is actually frontmost before sending the key
    repeat 25 times
        if frontmost of process "Microsoft Teams" then exit repeat
        delay 0.02
    end repeat

    -- toggle Teams mute (Teams stays in front afterwards)
    keystroke "m" using {command down, shift down}
end tell
