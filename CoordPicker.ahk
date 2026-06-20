#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
DllCall("SetProcessDPIAware")

; ===== 座標ピッカー =====
; F5: 現在の座標をクリップボードにコピー
; F6: 終了

GAME_TITLE := "winhero_Steam"

SetTimer(ShowCoords, 50)

ShowCoords() {
    global GAME_TITLE
    hwnd := WinExist(GAME_TITLE)
    if !hwnd
        return
    ; スクリーン座標を取得
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mx, &my)
    ; クライアント領域の原点をスクリーン座標で取得
    pt := Buffer(8, 0)
    DllCall("ClientToScreen", "Ptr", hwnd, "Ptr", pt)
    cx := mx - NumGet(pt, 0, "int")
    cy := my - NumGet(pt, 4, "int")
    ToolTip("X: " cx "  Y: " cy)
}

F5:: {
    global GAME_TITLE
    hwnd := WinExist(GAME_TITLE)
    if !hwnd
        return
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mx, &my)
    pt := Buffer(8, 0)
    DllCall("ClientToScreen", "Ptr", hwnd, "Ptr", pt)
    cx := mx - NumGet(pt, 0, "int")
    cy := my - NumGet(pt, 4, "int")
    A_Clipboard := "X: " cx " Y: " cy
    ToolTip("コピー: X=" cx " Y=" cy)
    SetTimer(() => ToolTip(), -2000)
}

F6:: ExitApp
