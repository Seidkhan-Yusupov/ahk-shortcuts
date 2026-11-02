#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



; quit apps remap
#q::
Send, !{F4}
return

; Function to check if Shift is held down
ShiftIsDown() {
    return GetKeyState("Shift", "P")
}

; Navigation with CapsLock + Arrow Keys or Selection with Shift + CapsLock + Arrow Keys
CapsLock & l::
    if (ShiftIsDown())
        SendInput, +{Right}  ; Select text to the right
    else
        SendInput, {Right}   ; Move right
return

CapsLock & j::
    if (ShiftIsDown())
        SendInput, +{Left}   ; Select text to the left
    else
        SendInput, {Left}    ; Move left
return

CapsLock & k::
    if (ShiftIsDown())
        SendInput, +{Down}   ; Select text downward
    else
        SendInput, {Down}    ; Move down
return

CapsLock & i::
    if (ShiftIsDown())
        SendInput, +{Up}     ; Select text upward
    else
        SendInput, {Up}      ; Move up
return

CapsLock & o::
    if (ShiftIsDown())
        SendInput, +{End}    ; Select to the end of the line
    else
        SendInput, {End}     ; Move to the end of the line
return

CapsLock & u::
    if (ShiftIsDown())
        SendInput, +{Home}   ; Select to the beginning of the line
    else
        SendInput, {Home}    ; Move to the beginning of the line
return

CapsLock & h::
    if (ShiftIsDown())
        SendInput, +^{Left}  ; Select to the left word by word
    else
        SendInput, ^{Left}   ; Move left word by word
return

CapsLock & n::
    if (ShiftIsDown())
        SendInput, +^{Right} ; Select to the right word by word
    else
        SendInput, ^{Right}  ; Move right word by word
return

; Media Control Hotkeys
^!Space::Send       {Media_Play_Pause}
^!Left::SendInput, {Media_Prev}
^!Right::SendInput, {Media_Next}
^!Up::Send {Volume_Up}
^!Down::Send {Volume_Down}
^!m::Send {Volume_Mute}

; Remap Right Ctrl to Shift + F10 
RCtrl::Send +{F10}

; winscan scan shortcuts if active
#IfWinActive WinScan2PDF 8.22

MButton::
    Click, 262, 164
    Sleep, 600
    Click
return

^!s::
    Click, 262, 164
    Sleep, 600
    Click
return

#IfWinActive

; Text Case Changer

; Initialize mode (1 = UPPERCASE, 2 = lowercase, 3 = CamelCase)
global caseMode := 1

^+u::  ; Ctrl + Shift + U
    ClipboardBackup := ClipboardAll  ; Backup clipboard
    Clipboard := ""  ; Clear clipboard

    Send, ^c  ; Copy selected text
    ClipWait, 0.5  ; Wait for clipboard to update
    if (ErrorLevel) {
        ShowToast("No text selected!", 800)
        return
    }

    text := Clipboard
    if (caseMode = 1) {  ; UPPERCASE
        StringUpper, text, text
        Clipboard := text
        ShowToast("UPPERCASE MODE", 800)
        caseMode := 2
    }
    else if (caseMode = 2) {  ; lowercase
        StringLower, text, text
        Clipboard := text
        ShowToast("lowercase mode", 800)
        caseMode := 3
    }
    else {  ; CamelCase
        Clipboard := ConvertToCamelCase(text)
        ShowToast("CamelCase Mode", 800)
        caseMode := 1
    }

    Send, ^v  ; Paste modified text
    Clipboard := ClipboardBackup  ; Restore clipboard
return

; Function to convert text to CamelCase
ConvertToCamelCase(text) {
    newText := ""
    Loop, Parse, text, %A_Space%
    {
        firstLetter := SubStr(A_LoopField, 1, 1)  ; Get first letter
        restLetters := SubStr(A_LoopField, 2)  ; Get the rest of the word

        StringUpper, firstLetter, firstLetter  ; Capitalize first letter
        StringLower, restLetters, restLetters  ; Make rest lowercase

        newText .= firstLetter . restLetters . " "  ; Combine properly
    }
    return Trim(newText)  ; Remove any trailing space
}

; Function to show a toast notification (non-intrusive)
ShowToast(msg, duration := 1000) {
    ToolTip, %msg%
    SetTimer, RemoveToolTip, %duration%
}

RemoveToolTip:
    ToolTip
return
; End of Text Case Changer

; remapping minimizing all windows
#d::#m

; minimizing windows
#+z::
Send, #{Down}
return

; fullscreen shortcut remaps
; Win + Up/Down -> Win + F
toggle := false

#f::
toggle := !toggle

if (toggle)
    Send, #{Up}
else
    Send, #{Down}

Return

; Ctrl + Win + . -> Win + Shift + F
#+f::
Send, {F11}
Return
