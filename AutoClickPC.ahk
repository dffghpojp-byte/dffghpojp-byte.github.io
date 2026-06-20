#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
DllCall("SetProcessDPIAware")

; ===== WIND BREAKER PC版 イベント自動周回 =====
; F5: 短縮周回ループ
; F6: 停止
; F7: フル周回

; --- 設定 ---
GAME_TITLE := "winhero_Steam"

; --- タップ座標（クライアント領域） ---
TAP_SHOKYU_X := 607
TAP_SHOKYU_Y := 166
TAP_KETTEI_X := 601
TAP_KETTEI_Y := 468
TAP_BATTLE_X := 883
TAP_BATTLE_Y := 490

; --- 状態 ---
running := false

F5:: {
    global running
    if running {
        ShowTip("すでに実行中です（F6で停止）")
        return
    }
    running := true
    DllCall("SetThreadExecutionState", "UInt", 0x80000001 | 0x00000002)

    loop {
        if !running
            return

        GameClick(TAP_SHOKYU_X, TAP_SHOKYU_Y)
        Sleep(3000)
        if !running
            return

        GameClick(TAP_KETTEI_X, TAP_KETTEI_Y)
        Sleep(3000)
        if !running
            return

        Sleep(3000)
        if !running
            return
        GameClick(TAP_BATTLE_X, TAP_BATTLE_Y)
        Sleep(1000)
        if !running
            return

        loop 5 {
            if !running
                return
            GameClick(TAP_BATTLE_X, TAP_BATTLE_Y)
            Sleep(1000)
        }

        Sleep(3000)
    }
}

F6:: {
    global running
    running := false
    DllCall("SetThreadExecutionState", "UInt", 0x80000000)
    ShowTip("PC版 停止（スリープ有効に戻した）")
}


; --- クリック ---
GameClick(x, y) {
    global GAME_TITLE
    try {
        hwnd := WinExist(GAME_TITLE)
        if !hwnd
            return
        pt := Buffer(8, 0)
        NumPut("int", 0, pt, 0)
        NumPut("int", 0, pt, 4)
        DllCall("ClientToScreen", "Ptr", hwnd, "Ptr", pt)
        sx := NumGet(pt, 0, "int") + x
        sy := NumGet(pt, 4, "int") + y
        CoordMode("Mouse", "Screen")
        MouseGetPos(&oldX, &oldY)
        DllCall("SetCursorPos", "int", sx, "int", sy)
        Sleep(30)
        Click
        Sleep(30)
        DllCall("SetCursorPos", "int", oldX, "int", oldY)
    } catch {
        ShowTip("⚠ クリック失敗")
    }
}

ShowTip(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -3000
}
