#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; EMBER'S MACRO - OWNER CONTROLLED BUILD
; ============================================================

Enabled := false
MacroBusy := false

CurrentHotkey := "F1"
TriggerKey := "None"

BoomKey := "f"
DashKey := "r"

WaitingForKey := false
WaitingForTrigger := false
WaitingForBoom := false
WaitingForDash := false

; ============================================================
; OWNER ONLINE MASTER SWITCH
; ============================================================

; Put your raw status URL here.
; File must contain exactly:
; ON
; or
; OFF

StatusURL := "PASTE_YOUR_RAW_STATUS_URL_HERE"

OnlineEnabled := true
LastOnlineCheck := 0
OnlineCheckInterval := 30000

; ============================================================
; COLORS
; ============================================================

BG        := "D9E1E7"
CARD      := "EEF2F5"
TEXT      := "26313A"
SECONDARY := "6F7C86"
ICE       := "6388A3"
GREEN     := "6E9C86"
RED       := "B87979"
YELLOW    := "B08E55"

; ============================================================
; GUI
; ============================================================

MyGui := Gui("+AlwaysOnTop", "> Ember's Macro")
MyGui.BackColor := BG
MyGui.SetFont("s10", "Segoe UI")

; HEADER
MyGui.AddText("x12 y12 w356 h64 Background" CARD)

MyGui.SetFont("s18 Bold", "Segoe UI")
MyGui.AddText(
    "x20 y17 w340 h32 Center c" ICE,
    "> EMBER'S MACRO"
)

MyGui.SetFont("s9", "Segoe UI")
MyGui.AddText(
    "x20 y47 w340 h20 Center c" SECONDARY,
    "FROST EDITION  •  TESTING BUILD"
)

; ============================================================
; MODE
; ============================================================

MyGui.AddText("x12 y88 w356 h112 Background" CARD)

MyGui.SetFont("s12 Bold", "Segoe UI")
MyGui.AddText(
    "x24 y98 w200 h25 c" TEXT,
    "MACRO MODE"
)

MyGui.SetFont("s9", "Segoe UI")
MyGui.AddText(
    "x24 y123 w320 h20 c" SECONDARY,
    "Choose your macro configuration."
)

ModeBox := MyGui.AddDropDownList(
    "x24 y148 w332",
    [
        "Boom Jump",
        "Boom Jump (ShiftLock)",
        "Akari",
        "Akari (ShiftLock)",
        "Auto ShiftLock",
        "Custom"
    ]
)

ModeBox.Value := 1

; ============================================================
; EXTRA TRIGGER
; ============================================================

MyGui.AddText("x12 y210 w356 h88 Background" CARD)

MyGui.SetFont("s12 Bold", "Segoe UI")
MyGui.AddText(
    "x24 y220 w220 h25 c" TEXT,
    "EXTRA TRIGGER"
)

MyGui.SetFont("s9", "Segoe UI")
MyGui.AddText(
    "x24 y245 w320 h20 c" SECONDARY,
    "Optional key that triggers the macro."
)

TriggerText := MyGui.AddText(
    "x24 y270 w90 h28 Center Border c" ICE,
    "NONE"
)

SetTrigger := MyGui.AddButton(
    "x122 y269 w95 h29",
    "Set Extra"
)

ClearTrigger := MyGui.AddButton(
    "x222 y269 w65 h29",
    "Clear"
)

SetTrigger.OnEvent("Click", StartTriggerKeybind)
ClearTrigger.OnEvent("Click", ClearTriggerKeybind)

; ============================================================
; TIMING
; ============================================================

MyGui.AddText("x12 y308 w356 h105 Background" CARD)

MyGui.SetFont("s12 Bold", "Segoe UI")
MyGui.AddText(
    "x24 y318 w150 h25 c" TEXT,
    "TIMING"
)

MyGui.SetFont("s9", "Segoe UI")

MyGui.AddText(
    "x24 y350 w55 h23 c" TEXT,
    "Action"
)

ActionDelay := MyGui.AddEdit(
    "x82 y347 w52 h27",
    "30"
)

MyGui.AddText(
    "x138 y350 w25 h23 c" SECONDARY,
    "ms"
)

MyGui.AddText(
    "x175 y350 w45 h23 c" TEXT,
    "Jump"
)

JumpDelay := MyGui.AddEdit(
    "x222 y347 w52 h27",
    "30"
)

MyGui.AddText(
    "x278 y350 w25 h23 c" SECONDARY,
    "ms"
)

MyGui.AddText(
    "x24 y382 w55 h23 c" TEXT,
    "Extra"
)

MainDelay := MyGui.AddEdit(
    "x82 y379 w52 h27",
    "60"
)

MyGui.AddText(
    "x138 y382 w25 h23 c" SECONDARY,
    "ms"
)

; ============================================================
; KEYBINDS
; ============================================================

MyGui.AddText("x12 y423 w356 h130 Background" CARD)

MyGui.SetFont("s12 Bold", "Segoe UI")
MyGui.AddText(
    "x24 y433 w150 h25 c" TEXT,
    "KEYBINDS"
)

MyGui.SetFont("s9", "Segoe UI")

; BOOM
MyGui.AddText(
    "x24 y466 w60 h24 c" TEXT,
    "Boom"
)

BoomKeyText := MyGui.AddText(
    "x88 y463 w55 h28 Center Border c" ICE,
    "F"
)

SetBoom := MyGui.AddButton(
    "x150 y462 w82 h30",
    "Set Boom"
)

SetBoom.OnEvent("Click", StartBoomKeybind)

; DASH
MyGui.AddText(
    "x24 y502 w60 h24 c" TEXT,
    "Dash"
)

DashKeyText := MyGui.AddText(
    "x88 y499 w55 h28 Center Border c" ICE,
    "R"
)

SetDash := MyGui.AddButton(
    "x150 y498 w82 h30",
    "Set Dash"
)

SetDash.OnEvent("Click", StartDashKeybind)

; TOGGLE
MyGui.AddText(
    "x242 y466 w55 h24 c" TEXT,
    "Toggle"
)

KeybindText := MyGui.AddText(
    "x300 y463 w45 h28 Center Border c" ICE,
    "F1"
)

SetKey := MyGui.AddButton(
    "x242 y498 w103 h30",
    "Set Toggle"
)

SetKey.OnEvent("Click", StartKeybind)

; ============================================================
; STATUS
; ============================================================

MyGui.AddText("x12 y563 w356 h50 Background" CARD)

MyGui.SetFont("s11 Bold", "Segoe UI")

Status := MyGui.AddText(
    "x24 y575 w332 h27 Center c" RED,
    "●  MACRO OFF"
)

Toggle := MyGui.AddButton(
    "x12 y625 w356 h44",
    "MACRO: OFF"
)

Toggle.SetFont("s11 Bold", "Segoe UI")
Toggle.OnEvent("Click", ToggleMacro)

MyGui.SetFont("s8", "Segoe UI")

MyGui.AddText(
    "x12 y678 w356 h18 Center c" SECONDARY,
    "EMBER  •  FROST UI"
)

; ============================================================
; GUI EVENTS
; ============================================================

MyGui.OnEvent("Close", (*) => ExitApp())

MyGui.Show("w380 h710")

; ============================================================
; DEFAULT TOGGLE
; ============================================================

Hotkey("F1", ToggleMacro, "On")

; ============================================================
; ONLINE CHECK
; ============================================================

SetTimer(CheckOnlineStatus, 30000)

; ============================================================
; OWNER ONLINE MASTER SWITCH
; ============================================================

CheckOnlineStatus(*) {
    global StatusURL
    global OnlineEnabled
    global LastOnlineCheck
    global OnlineCheckInterval
    global Enabled

    ; No URL = local mode
    if (
        StatusURL = ""
        || InStr(StatusURL, "PASTE_YOUR_RAW_STATUS_URL_HERE")
    ) {
        return true
    }

    ; Don't check too frequently
    if (A_TickCount - LastOnlineCheck < OnlineCheckInterval)
        return OnlineEnabled

    LastOnlineCheck := A_TickCount

    TempFile := A_Temp "\ember_macro_status.txt"

    try {
        if FileExist(TempFile)
            FileDelete(TempFile)

        Download(StatusURL, TempFile)

        RemoteStatus := StrUpper(
            Trim(FileRead(TempFile, "UTF-8"))
        )

        try FileDelete(TempFile)

        if (RemoteStatus = "ON") {
            OnlineEnabled := true
        }
        else if (RemoteStatus = "OFF") {
            OnlineEnabled := false
            Enabled := false

            UpdateStatus()

            ToolTip("Macro disabled by owner")
            SetTimer(ClearToolTip, -1500)
        }
    }
    catch {
        ; Keep previous state if server cannot be reached.
    }

    return OnlineEnabled
}

; ============================================================
; TOGGLE
; ============================================================

ToggleMacro(*) {
    global Enabled

    if !CheckOnlineStatus() {
        ToolTip("Macro is currently disabled")
        SetTimer(ClearToolTip, -1200)
        return
    }

    Enabled := !Enabled

    UpdateStatus()

    ToolTip(
        Enabled
            ? "Macro ON"
            : "Macro OFF"
    )

    SetTimer(ClearToolTip, -800)
}

; ============================================================
; UPDATE STATUS
; ============================================================

UpdateStatus() {
    global Enabled
    global Toggle
    global Status

    if Enabled {
        Toggle.Text := "MACRO: ON"
        Status.Text := "●  MACRO ON"
        Status.SetFont("c6E9C86")
    }
    else {
        Toggle.Text := "MACRO: OFF"
        Status.Text := "●  MACRO OFF"
        Status.SetFont("cB87979")
    }
}

; ============================================================
; TOOLTIP
; ============================================================

ClearToolTip(*) {
    ToolTip()
}

; ============================================================
; KEY CAPTURE
; ============================================================

CaptureKey(Message := "Press a key") {

    ToolTip(Message)

    ih := InputHook("L1 T5")

    ih.KeyOpt("{All}", "E")

    ih.Start()
    ih.Wait()

    Key := ih.EndKey

    ih.Stop()

    ToolTip()

    if (Key = "")
        return ""

    return NormalizeKey(Key)
}

; ============================================================
; SET TOGGLE KEY
; ============================================================

StartKeybind(*) {
    global WaitingForKey
    global KeybindText
    global SetKey
    global CurrentHotkey

    if WaitingForKey
        return

    WaitingForKey := true

    KeybindText.Text := "..."
    KeybindText.SetFont("c" YELLOW)

    SetKey.Text := "Listening..."

    Key := CaptureKey(
        "Press the key you want to use"
    )

    if (Key != "")
        SetNewHotkey(Key)

    KeybindText.Text := FormatKeyName(CurrentHotkey)
    KeybindText.SetFont("c" ICE)

    SetKey.Text := "Set Toggle"

    WaitingForKey := false
}

; ============================================================
; SET BOOM KEY
; ============================================================

StartBoomKeybind(*) {
    global WaitingForBoom
    global BoomKeyText
    global SetBoom
    global BoomKey

    if WaitingForBoom
        return

    WaitingForBoom := true

    BoomKeyText.Text := "..."
    BoomKeyText.SetFont("c" YELLOW)

    SetBoom.Text := "Listening..."

    Key := CaptureKey(
        "Press your Boom key"
    )

    if (Key != "")
        SetNewBoomKey(Key)

    BoomKeyText.Text := FormatKeyName(BoomKey)
    BoomKeyText.SetFont("c" ICE)

    SetBoom.Text := "Set Boom"

    WaitingForBoom := false
}

; ============================================================
; SET DASH KEY
; ============================================================

StartDashKeybind(*) {
    global WaitingForDash
    global DashKeyText
    global SetDash
    global DashKey

    if WaitingForDash
        return

    WaitingForDash := true

    DashKeyText.Text := "..."
    DashKeyText.SetFont("c" YELLOW)

    SetDash.Text := "Listening..."

    Key := CaptureKey(
        "Press your Dash key"
    )

    if (Key != "")
        SetNewDashKey(Key)

    DashKeyText.Text := FormatKeyName(DashKey)
    DashKeyText.SetFont("c" ICE)

    SetDash.Text := "Set Dash"

    WaitingForDash := false
}

; ============================================================
; SET EXTRA TRIGGER
; ============================================================

StartTriggerKeybind(*) {
    global WaitingForTrigger
    global TriggerText
    global SetTrigger
    global TriggerKey

    if WaitingForTrigger
        return

    WaitingForTrigger := true

    TriggerText.Text := "..."
    TriggerText.SetFont("c" YELLOW)

    SetTrigger.Text := "Listening..."

    Key := CaptureKey(
        "Press the key that should trigger the macro"
    )

    if (Key != "")
        SetNewTrigger(Key)

    if (TriggerKey = "")
        TriggerKey := "None"

    TriggerText.Text := FormatKeyName(TriggerKey)
    TriggerText.SetFont("c" ICE)

    SetTrigger.Text := "Set Extra"

    WaitingForTrigger := false
}

; ============================================================
; CLEAR EXTRA TRIGGER
; ============================================================

ClearTriggerKeybind(*) {
    global TriggerKey
    global TriggerText

    if (TriggerKey != "None") {
        try Hotkey(TriggerKey, "Off")
    }

    TriggerKey := "None"

    TriggerText.Text := "None"
    TriggerText.SetFont("c" ICE)

    ToolTip("Trigger cleared")
    SetTimer(ClearToolTip, -700)
}

; ============================================================
; NORMALIZE KEY
; ============================================================

NormalizeKey(Key) {

    if RegExMatch(
        Key,
        "^F([1-9]|1[0-2])$"
    )
        return Key

    if RegExMatch(
        Key,
        "^[a-zA-Z]$"
    )
        return StrLower(Key)

    if RegExMatch(
        Key,
        "^[0-9]$"
    )
        return Key

    switch Key {

        case "Space":
            return "Space"

        case "Enter":
            return "Enter"

        case "Tab":
            return "Tab"

        case "Backspace":
            return "Backspace"

        case "Escape":
            return "Escape"

        case "Delete":
            return "Delete"

        case "Insert":
            return "Insert"

        case "Home":
            return "Home"

        case "End":
            return "End"

        case "PgUp":
            return "PgUp"

        case "PgDn":
            return "PgDn"

        case "Up":
            return "Up"

        case "Down":
            return "Down"

        case "Left":
            return "Left"

        case "Right":
            return "Right"

        case "LShift":
            return "LShift"

        case "RShift":
            return "RShift"

        case "LCtrl":
            return "LCtrl"

        case "RCtrl":
            return "RCtrl"

        case "LAlt":
            return "LAlt"

        case "RAlt":
            return "RAlt"

        case "CapsLock":
            return "CapsLock"

        case "NumLock":
            return "NumLock"

        case "ScrollLock":
            return "ScrollLock"
    }

    return Key
}

; ============================================================
; FORMAT KEY NAME
; ============================================================

FormatKeyName(Key) {

    if (StrLen(Key) = 1)
        return StrUpper(Key)

    return Key
}

; ============================================================
; SET BOOM
; ============================================================

SetNewBoomKey(NewKey) {
    global BoomKey
    global BoomKeyText

    BoomKey := NewKey

    BoomKeyText.Text :=
        FormatKeyName(BoomKey)

    BoomKeyText.SetFont("c6388A3")

    ToolTip(
        "Boom key: "
        FormatKeyName(BoomKey)
    )

    SetTimer(ClearToolTip, -900)
}

; ============================================================
; SET DASH
; ============================================================

SetNewDashKey(NewKey) {
    global DashKey
    global DashKeyText

    DashKey := NewKey

    DashKeyText.Text :=
        FormatKeyName(DashKey)

    DashKeyText.SetFont("c6388A3")

    ToolTip(
        "Dash key: "
        FormatKeyName(DashKey)
    )

    SetTimer(ClearToolTip, -900)
}

; ============================================================
; SET TOGGLE
; ============================================================

SetNewHotkey(NewKey) {
    global CurrentHotkey
    global KeybindText
    global TriggerKey

    ; Space is reserved for the optional trigger
    if (NewKey = "Space") {
        ToolTip("Space cannot be the toggle key")
        SetTimer(ClearToolTip, -1000)
        return
    }

    ; Prevent same key being used twice
    if (NewKey = TriggerKey) {
        ToolTip(
            "That key is already your Extra Trigger"
        )
        SetTimer(ClearToolTip, -1000)
        return
    }

    OldKey := CurrentHotkey

    try {
        Hotkey(NewKey, ToggleMacro, "On")
    }
    catch {
        ToolTip(
            "Unable to use "
            FormatKeyName(NewKey)
        )

        SetTimer(ClearToolTip, -1000)
        return
    }

    try Hotkey(OldKey, "Off")

    CurrentHotkey := NewKey

    KeybindText.Text :=
        FormatKeyName(CurrentHotkey)

    KeybindText.SetFont("c6388A3")

    ToolTip(
        "Toggle key: "
        FormatKeyName(CurrentHotkey)
    )

    SetTimer(ClearToolTip, -900)
}

; ============================================================
; SET TRIGGER
; ============================================================

SetNewTrigger(NewKey) {
    global TriggerKey
    global TriggerText
    global CurrentHotkey

    if (NewKey = CurrentHotkey) {
        ToolTip(
            "That key is already your Toggle Key"
        )

        SetTimer(ClearToolTip, -1000)
        return
    }

    ; Remove old trigger
    if (TriggerKey != "None") {
        try Hotkey(TriggerKey, "Off")
    }

    ; Create new trigger
    try {
        Hotkey(NewKey, RunMacro, "On")
    }
    catch {
        ToolTip(
            "Unable to use "
            FormatKeyName(NewKey)
        )

        SetTimer(ClearToolTip, -1000)
        return
    }

    TriggerKey := NewKey

    TriggerText.Text :=
        FormatKeyName(TriggerKey)

    TriggerText.SetFont("c6388A3")

    ToolTip(
        "Macro trigger: "
        FormatKeyName(TriggerKey)
    )

    SetTimer(ClearToolTip, -900)
}

; ============================================================
; MACRO TRIGGER
; ============================================================

RunMacro(*) {
    global Enabled
    global MacroBusy

    if !CheckOnlineStatus()
        return

    if !Enabled
        return

    if MacroBusy
        return

    MacroBusy := true

    try {
        RunMacroInternal()
    }
    finally {
        MacroBusy := false
    }
}

; ============================================================
; MACRO
; ============================================================

RunMacroInternal() {
    global ModeBox
    global ActionDelay
    global JumpDelay
    global MainDelay
    global BoomKey
    global DashKey

    Mode := ModeBox.Text

    Action := GetDelay(
        ActionDelay.Value
    )

    Jump := GetDelay(
        JumpDelay.Value
    )

    ExtraDelay := GetDelay(
        MainDelay.Value
    )

    ; --------------------------------------------------------
    ; BOOM JUMP
    ; --------------------------------------------------------

    if (Mode = "Boom Jump") {

        Send("{" BoomKey "}")

        if (Action > 0)
            Sleep(Action)
    }

    ; --------------------------------------------------------
    ; BOOM JUMP SHIFTLOCK
    ; --------------------------------------------------------

    else if (Mode = "Boom Jump (ShiftLock)") {

        Send("{Shift}")

        Sleep(30)

        Send("{" BoomKey "}")

        if (Action > 0)
            Sleep(Action)

        Send("{Shift}")
    }

    ; --------------------------------------------------------
    ; AKARI
    ; --------------------------------------------------------

    else if (Mode = "Akari") {

        Send("{" DashKey "}")

        if (Action > 0)
            Sleep(Action)

        Send("{Space}")

        if (Jump > 0)
            Sleep(Jump)
    }

    ; --------------------------------------------------------
    ; AKARI SHIFTLOCK
    ; --------------------------------------------------------

    else if (Mode = "Akari (ShiftLock)") {

        Send("{Shift}")

        if (Action > 0)
            Sleep(Action)

        Send("{" DashKey "}")

        if (Action > 0)
            Sleep(Action)

        Send("{Space}")

        if (Jump > 0)
            Sleep(Jump)
    }

    ; --------------------------------------------------------
    ; AUTO SHIFTLOCK
    ; --------------------------------------------------------

    else if (Mode = "Auto ShiftLock") {

        Send("{Shift}")

        Sleep(30)

        Send("{Space}")

        if (Jump > 0)
            Sleep(Jump)
    }

    ; --------------------------------------------------------
    ; CUSTOM
    ; --------------------------------------------------------

    else if (Mode = "Custom") {

        Send("{Space}")

        if (Action > 0)
            Sleep(Action)
    }

    ; --------------------------------------------------------
    ; EXTRA DELAY
    ; --------------------------------------------------------

    if (ExtraDelay > 0)
        Sleep(ExtraDelay)
}

; ============================================================
; DELAY VALIDATION
; ============================================================

GetDelay(Value) {

    try {
        Number := Integer(Value)
    }
    catch {
        return 0
    }

    if (Number < 0)
        Number := 0

    if (Number > 5000)
        Number := 5000

    return Number
}