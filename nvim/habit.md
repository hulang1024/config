# 按键

## 编辑
<C-h>
<C-w>
<C-u>


## Editor
Tab              接受补全
<A-Enter>        Code Action

<leader>e        切换树视图 (在根目录)
<eader><space>   查找文件 (在根目录)
<leader>,        查找缓冲区
<leader>/        Grep (在根目录)
<leader>:        选择命令历史

<leader>fc       查找配置文件
<leader>fr       查找最近文件
<leader>fp       查找工程

<leader>xq       Quickfix List
<leader>xQ       Quickfix List (Trouble)
<leader>xt       Todo List (Trouble)
<leader>xT       Todo/Fix List (Trouble)
<leader>xx       诊断信息 (Trouble)
<leader>xX       缓冲区诊断信息 (Trouble)

`[b`               上个缓冲区
`[b``               上个缓冲区
`]b``               下个缓冲区
`[q``               上个Quickfix项
`]q``               下个Quickfix项
`[d``               上个诊断
`]d``               下个诊断
`[e``               上个诊断错误
`]e``               下个诊断错误
`[w``               上个诊断警告
`]w`               下个诊断警告


## Others

<C-/>            显示隐藏终端 (根目录)
<leader>fT       显示隐藏终端 (pwd)
<C-\>_<C-n>      切换到普通模式
<leader>ql       恢复最后会话


# Text Objects
ga gi            缓冲区
ia aa            参数
if af            函数
ic ac            类
io ao            块
