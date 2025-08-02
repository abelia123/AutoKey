' AutoKey Startup Script
' This script starts the AutoKey application without showing a console window

Set objShell = CreateObject("Wscript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
strPythonScript = objFSO.BuildPath(strScriptPath, "direction_ui_8way.py")

' Check if Python script exists
If objFSO.FileExists(strPythonScript) Then
    ' Try to run with pythonw.exe (no console window)
    On Error Resume Next
    objShell.Run "pythonw.exe """ & strPythonScript & """", 0, False
    
    ' If pythonw fails, try python
    If Err.Number <> 0 Then
        Err.Clear
        objShell.Run "python.exe """ & strPythonScript & """", 0, False
    End If
    
    If Err.Number <> 0 Then
        MsgBox "Error: Could not start AutoKey." & vbCrLf & _
               "Please ensure Python is installed and in PATH.", _
               vbCritical, "AutoKey Startup Error"
    End If
    On Error GoTo 0
Else
    MsgBox "Error: direction_ui_8way.py not found in:" & vbCrLf & _
           strScriptPath, vbCritical, "AutoKey Startup Error"
End If