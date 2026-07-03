[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$env:https_proxy="http://127.0.0.1:7897"
$env:http_proxy="http://127.0.0.1:7897"

# Import-Module -Name Terminal-Icons
# Import-Module PSFzf
$fzfTriggered = $false
function Initialize-Fzf {
    if (-not $fzfTriggered) {
        Import-Module PSFzf -ErrorAction SilentlyContinue
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        $global:fzfTriggered = $true
    }
}

# PSReadLine
# Install-Module -Name PSReadLine -Repository Tsinghua -Scope CurrentUser -Force -AllowClobber
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Prompt
Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineKeyHandler -Chord "Ctrl+o" -Function ViCommandMode
Set-PSReadLineKeyHandler -Key Tab -Function AcceptSuggestion

# 在 Insert 模式下添加 Emacs 风格快捷键
$emacsBindings = @{
    # 光标移动
    "Ctrl+a" = "BeginningOfLine"
    "Ctrl+e" = "EndOfLine"
    "Ctrl+f" = "ForwardChar"
    "Ctrl+b" = "BackwardChar"
    "Alt+f"  = "ForwardWord"
    "Alt+b"  = "BackwardWord"
    # 历史命令
    "Ctrl+p" = "PreviousHistory"
    "Ctrl+n" = "NextHistory"
    "Ctrl+r" = "ReverseSearchHistory"
    "Ctrl+s" = "ForwardSearchHistory"
    # 文本编辑 (Ctrl+{h,w,u}在shell和vim里通用)
    "Ctrl+h" = "BackwardDeleteChar"      # 删除光标前字符
    "Ctrl+w" = "BackwardDeleteWord"      # 删除前一个单词
    "Ctrl+u" = "BackwardDeleteLine"      # 删除到行首
    "Ctrl+d" = "DeleteChar"              # 删除光标处字符
    "Alt+d"  = "DeleteWord"              # 删除后一个单词
    "Ctrl+k" = "KillLine"                # 删除到行尾
    "Shift+Ctrl+y" = "Yank"              # 粘贴
    "Alt+y"  = "YankPop"                 # 在粘贴历史中循环
    # 参数操作 (重点添加)
    "Alt+."   = "YankLastArg"            # 插入上一个命令的最后一个参数
    # 其他实用功能
    "Ctrl+l" = "ClearScreen"             # 清屏
    "Ctrl+_" = "Undo"                    # 撤销
    "Tab"    = "Complete"
    "Ctrl+y" = "AcceptSuggestion"        # 自动补全
}

foreach ($key in $emacsBindings.Keys) {
    Set-PSReadLineKeyHandler -Chord $key -Function $emacsBindings[$key] -ViMode Insert
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -ScriptBlock { Initialize-Fzf; [Microsoft.PowerShell.PSConsoleReadLine]::Insert('Ctrl+t') }
Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -ScriptBlock { Initialize-Fzf; [Microsoft.PowerShell.PSConsoleReadLine]::RemoveLine() }
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'


function ssh-go {
    $sshConfig = "$HOME\.ssh\config"
    # 检查配置文件是否存在
    if (-not (Test-Path $sshConfig)) {
        Write-Warning "未找到 SSH 配置文件: $sshConfig"
        return
    }
    Initialize-Fzf
    # 读取 config，正则提取 Host 名称（过滤掉通配符 *），传给 fzf 模糊搜索
    $selected = Select-String -Path $sshConfig -Pattern '^\s*Host\s+([a-zA-Z0-9_.-]+)$' |
                ForEach-Object { $_.Matches.Groups[1].Value } |
                fzf --height 40% --reverse --border --prompt="🌐 SSH > "
    # 如果在 fzf 中选中了服务器并回车，则发起连接
    if (-not [string]::IsNullOrWhiteSpace($selected)) {
        Write-Host "正在连接到 $selected ..." -ForegroundColor Cyan
        ssh $selected
    }
}

function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

$starshipCache = "$HOME\.starship_cache.ps1"
if (-not (Test-Path $starshipCache)) {
    # 如果缓存不存在，生成一个（仅在第一次或手动删除时发生一次）
    starship init powershell --print-full-init > $starshipCache
}
. $starshipCache
