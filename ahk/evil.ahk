; 文本编辑
BackDeleteChar() => Send("{Backspace}")
BackDeleteWord() => Send("^{Backspace}")
BackDeleteLine() => Send("+{Home}{Backspace}")
#HotIf WinActive("ahk_exe Microsoft.CmdPal.UI.exe")
    || WinActive("ahk_exe chrome.exe")
    || WinActive("ahk_exe QQ.exe")
    || WinActive("ahk_exe WeChat.exe")
    ^h::BackDeleteChar
    ^w::BackDeleteWord
    ^u::BackDeleteLine
#HotIf


; 导航移动
#HotIf WinActive("ahk_exe Microsoft.CmdPal.UI.exe")
    ^j::Down
    ^k::Up
    ^n::Down
    ^p::Up
#HotIf

#HotIf WinActive("ahk_exe QQ.exe") || WinActive("ahk_exe WeChat.exe")
    ^j::^Down
    ^k::^Up
    ^n::^Down
    ^p::^Up
#HotIf

#HotIf WinActive("ahk_exe NeatReader.exe") || WinActive("ahk_class MultitaskingViewFrame")
    h::Left
    l::Right
    j::Down
    k::Up
#HotIf

; 虚拟桌面
#HotIf WinActive("ahk_class XExplorerHost") || WinActive("ahk_class Windows.UI.Core.CoreWindow")
    ; 虚拟桌面导航
    +h::Send "#^{Left}"
    +l::Send "#^{Right}"
    ; 任务导航
    h::Left
    l::Right
    j::Down
    k::Up
#HotIf

; 全局切换虚拟桌面
#^h::Send "#^{Left}"
#^l::Send "#^{Right}"
