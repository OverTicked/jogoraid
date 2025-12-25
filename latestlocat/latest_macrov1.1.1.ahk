; made mouse movement consistent across all hz, polling rate, resolution, fixed 1st iteration fuga bug, added tutorial that you WILL read

#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
; removed setdefaultmouse bcuz high polling rates exist

; variables
global KeepRunning := false
global CycleCount := 0
global CurrentAction := "Ready"
global StartTime := 0
global IsFirstLoop := true

; tooltip on f1
SetTimer, PreStartTooltip, 10

PreStartTooltip:
    if (!KeepRunning) {
        ToolTip, PUT RBLX IN WINDOWED SHRINE CT SLOT 2 FUGA BIND TO C RESET CHAR FACE PILE OF ROCKS (FACING PLAYER) THEN F1
    } else {
        ToolTip ; Clears this specific tooltip once running
        SetTimer, PreStartTooltip, Off
    }
return

; res scaling
ScaleX(x) {
    return (x / 1920) * A_ScreenWidth
}
ScaleY(y) {
    return (y / 1080) * A_ScreenHeight
}

; i really don't know why, but sometimes the first fuga doesnt shoot at jogo and its annoying. i hope this fixes it

Glide(targetX, targetY, steps := 5) {
    MouseGetPos, startX, startY
    deltaX := (targetX - startX) / steps
    deltaY := (targetY - startY) / steps
    
    Loop, %steps% {
        MouseMove, startX + (deltaX * A_Index), startY + (deltaY * A_Index), 0
        DllCall("Sleep", "UInt", 1) ; i was gonna write something here but i forgot
    }
}

F1:: 
	KeepRunning := true
	CycleCount := 0 
	IsFirstLoop := true
	StartTime := A_TickCount
	SetTimer, TooltipFollow, 10
    
    Loop {
        if (!KeepRunning)
            break

        IfWinExist, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe

        if (IsFirstLoop) {
            CurrentAction := "setting up.."
            Glide(ScaleX(0), ScaleY(534), 5) ; glide change
            Sleep, 300
	    Click
	    Sleep, 100
        }

        CurrentAction := "shrine ct activation"
        Send, 2
        Sleep, 250 

        CurrentAction := "fuga activation (c)"
        Send, {c down}
        Sleep, 60 
        Send, {c up}
        Sleep, 200

        CurrentAction := "FUGA animation (8s)"
        Loop, 40 { 
            if (!KeepRunning) 
                return
            Sleep, 200
        }

        CurrentAction := "move to ui area"
        MouseMove, % ScaleX(702), % ScaleY(118), 0 
        Sleep, 300

        CurrentAction := "stats click"
        Click
        Sleep, 200
        
        CurrentAction := "raid summary click"
        Click
        Sleep, 200

        CurrentAction := "move to retry"
        MouseMove, % ScaleX(680), % ScaleY(118), 0 
        Sleep, 200

        CurrentAction := "retry run click"
        Click
        Sleep, 300 

	CurrentAction := "roblox load time (7s)"
        Loop, 35 { 
            if (!KeepRunning) 
                return
            Sleep, 200
        }

        CycleCount++ 
    }
return

TooltipFollow:
    if (KeepRunning) {
        ElapsedSeconds := Floor((A_TickCount - StartTime) / 1000)
        Mins := Floor(ElapsedSeconds / 60)
        Secs := Mod(ElapsedSeconds, 60)
        FormatSecs := (Secs < 10) ? "0" . Secs : Secs
        
	ToolTip, curr: %CurrentAction%`nruns: %CycleCount%`nelapsed: %Mins%:%FormatSecs%`nscrres: %A_ScreenWidth%x%A_ScreenHeight%`nmade by overticked
    } else {
        ToolTip
        SetTimer, TooltipFollow, Off
    }
return

F2::
	KeepRunning := false
	ToolTip
	Reload
return
