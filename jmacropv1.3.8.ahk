; ~CHANGE LOOP NUMBER TO INCREASE OR DECREASE TIME SPENT LOADING ROBLOX (LOOP = HOW MANY TIMES IT WILL LOOP 200MS) EX. +5 LOOP = 1 SEC~
; above can be changed using gui

#NoEnv
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input

; variables
global KeepRunning := false
global KeepRunningF3 := false
global CycleCount := 0
global CurrentAction := "Ready"
global MacroType := "Idle"
global StartTime := 0
global IsFirstLoop := true

; settings variables
global AlwaysOnTop := true
global ShowTooltips := false
global FugaAnimLoops := 40
global LoadTimeLoops := 35
global MeteorAnimLoops := 35
global MeteorSHold := 500

; creation of gui..? idk how to say it
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 1F1F1F, 1F1F1F
Gui, Font, s10 cWhite, Segoe UI

Gui, Add, Tab3, x10 y10 w280 h320, macro|settings

; macro
Gui, Tab, 1
Gui, Font, s12 Bold
Gui, Add, Text, x20 y50 w260 Center, raid macro compact gui
Gui, Font, s9 Norm
Gui, Add, GroupBox, x20 y80 w260 h100 cWhite, status
Gui, Add, Text, x30 y100 w240 vTypeDisplay, macro: idle
Gui, Add, Text, x30 y118 w240 vStatusDisplay, current: idle
Gui, Add, Text, x30 y136 w240 vRunsDisplay, runs: 0
Gui, Add, Text, x30 y154 w240 vTimeDisplay, elapsed: 00:00
Gui, Add, Button, x20 y185 w125 h40 gStartFuga, start fuga (f1)
Gui, Add, Button, x155 y185 w125 h40 gStartDF, start meteor (f3)
Gui, Add, Button, x20 y235 w125 h40 gF2Label, reload (f2)
Gui, Add, Button, x155 y235 w125 h40 gF4Label, kill script (f4)
Gui, Add, Text, x20 y285 w250 Center, READ: 80 fov | ct slot 2 | skill bind to C | face rocks | start

; settings
Gui, Tab, 2
Gui, Add, CheckBox, x20 y45 vAlwaysOnTop Checked gToggleAOT, always on top
Gui, Add, CheckBox, x130 y45 vShowTooltips gSaveSettings, show tooltips (debug)
Gui, Add, Text, x20 y75, fuga wait duration (loop#)
Gui, Add, Edit, x20 y95 w60 cWhite vEditFuga, %FugaAnimLoops%
Gui, Add, Text, x20 y125, meteor anim duration (loop#)
Gui, Add, Edit, x20 y145 w60 cWhite vEditMeteor, %MeteorAnimLoops%
Gui, Add, Text, x20 y175, roblox load wait time (loop#)
Gui, Add, Text, x170 y75, meteor S hold (ms)
Gui, Add, Edit, x170 y95 w60 cWhite vEditSHold, %MeteorSHold%
Gui, Add, Edit, x20 y195 w60 cWhite vEditLoad, %LoadTimeLoops%
Gui, Add, Text, x20 y290 w260 Center, 1 loop = 200ms

Gui, Add, Button, x20 y235 w125 h35 gSaveSettings, apply
Gui, Add, Button, x155 y235 w125 h35 gResetDefaults, reset defaults

Gui, Show, w300 h340, TOOLWINDOW | made by overticked
SetTimer, UpdateStats, 1000

; Tooltip Timer
SetTimer, PreStartTooltip, 10

PreStartTooltip:
    if (!KeepRunning && !KeepRunningF3 && ShowTooltips) {
        ToolTip, debug | appear on start command
    } else {
        ToolTip 
    }
return

ToggleAOT:
    Gui, Submit, NoHide
    if (AlwaysOnTop)
        Gui, +AlwaysOnTop
    else
        Gui, -AlwaysOnTop
return

SaveSettings:
    Gui, Submit, NoHide
    FugaAnimLoops := EditFuga
    MeteorAnimLoops := EditMeteor
    LoadTimeLoops := EditLoad
    if (!ShowTooltips)
        ToolTip
return

ResetDefaults:
    FugaAnimLoops := 40
    MeteorAnimLoops := 35
    LoadTimeLoops := 35
    AlwaysOnTop := true
    ShowTooltips := true
    GuiControl,, EditFuga, 40
    GuiControl,, EditMeteor, 35
    GuiControl,, EditLoad, 35
    GuiControl,, AlwaysOnTop, 1
    GuiControl,, ShowTooltips, 1
    Gui, +AlwaysOnTop
    ToolTip, Defaults Restored!
    Sleep, 1000
    ToolTip
return

UpdateStats:
    if (KeepRunning || KeepRunningF3) {
        ElapsedSeconds := Floor((A_TickCount - StartTime) / 1000)
        Mins := Floor(ElapsedSeconds / 60)
        Secs := Mod(ElapsedSeconds, 60)
        FormatSecs := (Secs < 10) ? "0" . Secs : Secs
        
        GuiControl,, TypeDisplay, macro: %MacroType%
        GuiControl,, StatusDisplay, current: %CurrentAction%
        GuiControl,, RunsDisplay, runs: %CycleCount%
        GuiControl,, TimeDisplay, elapsed: %Mins%:%FormatSecs%
    }
return

; GUI Button Redirects
StartFuga:
    Gosub, F1
return

StartDF:
    Gosub, F3
return

F2Label:
    Gosub, F2
return

F4Label:
    ExitApp
return

; Logic Helpers
ScaleX(x) {
    return (x / 1920) * A_ScreenWidth
}
ScaleY(y) {
    return (y / 1080) * A_ScreenHeight
}

Glide(targetX, targetY, steps := 5) {
    MouseGetPos, startX, startY
    deltaX := (targetX - startX) / steps
    deltaY := (targetY - startY) / steps
    Loop, %steps% {
        MouseMove, startX + (deltaX * A_Index), startY + (deltaY * A_Index), 0
        DllCall("Sleep", "UInt", 1) 
    }
}

; fuga loop section
F1:: 
    SetTimer, PreStartTooltip, Off
    ToolTip
    KeepRunning := true
    KeepRunningF3 := false
    MacroType := "FUGA"
    CycleCount := 0 
    StartTime := A_TickCount
    SetTimer, TooltipFollow, 10
    
    Loop {
        if (!KeepRunning)
            break
        IfWinExist, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe

        CurrentAction := "setting up.."
        Glide(ScaleX(0), ScaleY(534), 5) 
        Sleep, 300
        Click
        Sleep, 100

        CurrentAction := "shrine ct"
        Send, 2
        Sleep, 250 

        CurrentAction := "fuga (c)"
        Send, {c down}
        Sleep, 60 
        Send, {c up}
        Sleep, 200

        CurrentAction := "animating..."
        Loop, %FugaAnimLoops% { 
            if (!KeepRunning) 
                return
            Sleep, 200
        }

        CurrentAction := "navigating UI"
        MouseMove, % ScaleX(702), % ScaleY(118), 0 
        Sleep, 300
        Click ; Stats
        Sleep, 200
        Click ; Summary
        Sleep, 200
        MouseMove, % ScaleX(680), % ScaleY(118), 0 
        Sleep, 200
        Click ; Retry
        Sleep, 300 

        CurrentAction := "loading..."
        Loop, %LoadTimeLoops% { 
            if (!KeepRunning) 
                return
            Sleep, 200
        }
        CycleCount++ 
    }
return

; meteor macro section
F3::
    SetTimer, PreStartTooltip, Off
    ToolTip
    KeepRunning := false 
    KeepRunningF3 := true
    MacroType := "METEOR"
    CycleCount := 0
    StartTime := A_TickCount
    SetTimer, TooltipFollow, 10

    Loop {
        if (!KeepRunningF3)
            break
        IfWinExist, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe

        CurrentAction := "setting up.."
        Glide(ScaleX(0), ScaleY(534), 5) 
        Sleep, 300
        Click
        Sleep, 100

        CurrentAction := "df ct"
        Send, 2
        Sleep, 250 

        CurrentAction := "backing up"
        Send, {s down}
        Sleep, 500
        Send, {s up}
        Sleep, 200

        CurrentAction := "meteor (c)"
        Send, {c down}
        Sleep, 60 
        Send, {c up}
        Sleep, 200

        CurrentAction := "animating..."
        Loop, %MeteorAnimLoops% { 
            if (!KeepRunningF3) 
                return
            Sleep, 200
        }

        CurrentAction := "navigating UI"
        MouseMove, % ScaleX(702), % ScaleY(118), 0 
        Sleep, 300
        Click
        Sleep, 200
        Click
        Sleep, 200
        MouseMove, % ScaleX(680), % ScaleY(118), 0 
        Sleep, 200
        Click
        Sleep, 300 

        CurrentAction := "loading..."
        Loop, %LoadTimeLoops% { 
            if (!KeepRunningF3) 
                return
            Sleep, 200
        }
        CycleCount++
        Sleep, 100 
    }
return

TooltipFollow:
    if ((KeepRunning || KeepRunningF3) && ShowTooltips) {
        ElapsedSeconds := Floor((A_TickCount - StartTime) / 1000)
        Mins := Floor(ElapsedSeconds / 60)
        Secs := Mod(ElapsedSeconds, 60)
        FormatSecs := (Secs < 10) ? "0" . Secs : Secs
        ToolTip, macro: %MacroType%`ncurr: %CurrentAction%`nruns: %CycleCount%`nF4 to Kill
    } else {
        ToolTip
        if (!KeepRunning && !KeepRunningF3) {
            SetTimer, TooltipFollow, Off
            SetTimer, PreStartTooltip, On
        }
    }
return

F2::
    KeepRunning := false
    KeepRunningF3 := false
    MacroType := "Idle"
    ToolTip
    GuiControl,, StatusDisplay, status: reloading
    Reload
return

F4::
    ExitApp