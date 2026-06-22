-- Remember current frontmost app so we can restore focus after
tell application "System Events"
    set frontApp to name of first application process whose frontmost is true
end tell

-- Toggle system microphone
set micVol to input volume of (get volume settings)
if micVol > 0 then
    do shell script "echo " & micVol & " > /tmp/karabiner-mic-vol"
    set volume input volume 0
else
    try
        set savedVol to (do shell script "cat /tmp/karabiner-mic-vol") as integer
    on error
        set savedVol to 75
    end try
    set volume input volume savedVol
end if

-- Sync Teams mute UI if Teams is running
tell application "System Events"
    if exists process "Microsoft Teams" then
        tell application "Microsoft Teams" to activate
        repeat 25 times
            if frontmost of process "Microsoft Teams" then exit repeat
            delay 0.02
        end repeat
        keystroke "m" using {command down, shift down}
    end if
end tell

-- Restore original frontmost app (unless the user was already in Teams)
if frontApp is not "Microsoft Teams" then
    tell application frontApp to activate
end if
