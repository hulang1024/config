; 文本编辑
DeleteLeftChar() => Send("{Backspace}")
DeleteLeftWord() => Send("^{Backspace}")
DeleteToHead() => Send("+{Home}{Backspace}")
DeleteRightChar() => Send("{Delete}")
DeleteRightWord() => Send("^{Delete}")
DeleteToEnd() => Send("+{End}{Delete}")
BackChar() => Send("{Left}")
ForwardChar() => Send("{Right}")
BackWord() => Send("^{Left}")
ForwardWord() => Send("^{Right}")
ToHead() => Send("{Home}")
ToEnd() => Send("{End}")
NewLine() => Send("{Enter}")
#HotIf WinActive("ahk_exe Microsoft.CmdPal.UI.exe")
    || WinActive("ahk_exe QQ.exe")
    || WinActive("ahk_exe Weixin.exe")
    ^h::DeleteLeftChar
    ^w::DeleteLeftWord
    ^d::DeleteRightChar
    !d::DeleteRightWord
    ^u::DeleteToHead
    ^k::DeleteToEnd
    ^b::BackChar
    ^f::ForwardChar
    !b::BackWord
    !f::ForwardWord
    ^i::ToHead
    ^a::ToHead
    ^e::ToEnd
    ^j::NewLine
#HotIf
#HotIf WinActive("ahk_exe chrome.exe")
    ^h::DeleteLeftChar
    ^w::DeleteLeftWord
    ^d::DeleteRightChar
    !d::DeleteRightWord
    ^u::DeleteToHead
    ^k::DeleteToEnd
    ^b::BackChar
    !b::BackWord
    !f::ForwardWord
    ^i::ToHead
    ^e::ToEnd
#HotIf

#;::#1
#+v::#2
#+q::#3
#+x::#4
#+o::#5
#+w::#7
#+b::#8

; 导航移动
#HotIf WinActive("ahk_exe Microsoft.CmdPal.UI.exe")
    ^n::Down
    ^p::Up
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
