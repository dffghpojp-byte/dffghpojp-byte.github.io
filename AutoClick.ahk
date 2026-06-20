#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; ===== WIND BREAKER BlueStacks版 イベント自動周回 =====
; F9: 短縮周回ループ
; F10: 停止

; --- 設定 ---
ADB := "C:\Program Files\BlueStacks_nxt\HD-Adb.exe"
ADB_ADDR := "127.0.0.1:5625"

; --- タップ座標 (Android 1280x720) ---
TAP_SHOKYU_X := 798
TAP_SHOKYU_Y := 231
TAP_KETTEI_X := 781
TAP_KETTEI_Y := 622
TAP_BATTLE_X := 1165
TAP_BATTLE_Y := 641

; --- 状態 ---
running := false

; --- 起動時にADB接続 ---
RunWait(A_ComSpec ' /c "' ADB '" connect ' ADB_ADDR,, "Hide")
ShowTip("BS版 ADB接続済み・F9で開始")

F9:: {
    global running
    if running {
        ShowTip("すでに実行中（F10で停止）")
        return
    }
    running := true
    ShowTip("BS版 周回開始")

    loop {
        if !running
            return

        ShowTip("BS版 周回中...(F10で停止)")

        ADBTap(TAP_SHOKYU_X, TAP_SHOKYU_Y)
        Sleep(3000)
        if !running
            return

        ADBTap(TAP_KETTEI_X, TAP_KETTEI_Y)
        Sleep(3000)
        if !running
            return

        Sleep(3000)
        if !running
            return
        ADBTap(TAP_BATTLE_X, TAP_BATTLE_Y)
        Sleep(1000)
        if !running
            return

        loop 5 {
            if !running
                return
            ADBTap(TAP_BATTLE_X, TAP_BATTLE_Y)
            Sleep(1000)
        }

        Sleep(3000)
    }
}

F10:: {
    global running
    running := false
    ShowTip("BS版 停止")
}

ADBTap(x, y) {
    global ADB, ADB_ADDR
    try {
        shell := ComObject("WScript.Shell")
        cmd := A_ComSpec ' /c "' ADB '" -s ' ADB_ADDR ' shell input tap ' x ' ' y
        shell.Run(cmd, 0, false)
    }
}

ShowTip(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -3000
}
