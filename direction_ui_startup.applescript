-- AppleScript for launching DirectionUI 8way on macOS
-- Save this as an Application to use it as a startup item

on run
    -- Get the directory where this script is located
    tell application "Finder"
        set currentPath to (path to me as text)
        set AppleScript's text item delimiters to ":"
        set pathItems to text items of currentPath
        set pathItems to items 1 thru -2 of pathItems
        set AppleScript's text item delimiters to ":"
        set scriptDirectory to pathItems as text
    end tell
    
    -- Check if running from .app bundle or as script
    if currentPath contains ".app" then
        -- Running as compiled application
        set pythonScriptPath to scriptDirectory & ":direction_ui_8way_mac.py"
    else
        -- Running as script (development)
        set pythonScriptPath to scriptDirectory & ":direction_ui_8way_mac.py"
    end if
    
    -- Convert Mac path to POSIX path for shell command
    set posixPath to POSIX path of pythonScriptPath
    
    -- Check if Python script exists
    try
        do shell script "test -f " & quoted form of posixPath
    on error
        display dialog "Error: direction_ui_8way_mac.py not found at:" & return & posixPath buttons {"OK"} default button "OK" with icon stop
        return
    end try
    
    -- Launch the Python application in background
    try
        -- Try with python3 first (standard on modern macOS)
        do shell script "python3 " & quoted form of posixPath & " > /dev/null 2>&1 &"
        
        display notification "DirectionUI is now running. Use mouse side button to activate." with title "DirectionUI 8way" subtitle "Started Successfully"
        
    on error errorMessage
        -- If python3 fails, try with python
        try
            do shell script "python " & quoted form of posixPath & " > /dev/null 2>&1 &"
            display notification "DirectionUI is now running. Use mouse side button to activate." with title "DirectionUI 8way" subtitle "Started Successfully"
        on error
            display dialog "Failed to start DirectionUI:" & return & errorMessage buttons {"OK"} default button "OK" with icon stop
        end try
    end try
end run

-- Handle quit event
on quit
    -- Kill any running Python processes for DirectionUI
    try
        do shell script "pkill -f direction_ui_8way_mac.py"
    end try
    continue quit
end quit