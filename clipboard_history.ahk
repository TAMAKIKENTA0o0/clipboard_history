#Requires AutoHotkey v2.0  ; 指定需要AutoHotkey v2.0或更高版本
Persistent  ; 保持脚本持续运行（即使没有可见窗口）

; === 全局变量定义 ===
clipHistory := []        ; 数组，用于存储剪贴板历史记录
maxHistory := 30         ; 最大保存的历史记录条数
previewLength := 40      ; 预览时显示的文本最大长度
tooltipDuration := 1500  ; 工具提示显示时长（毫秒）

; === 剪贴板变化回调函数注册 ===
OnClipboardChange(ClipChanged)  ; 当剪贴板内容变化时调用ClipChanged函数

; === 剪贴板变化处理函数 ===
ClipChanged(DataType) {
    global clipHistory, maxHistory, previewLength, tooltipDuration
    
    ; 仅处理文本类型（DataType=1表示文本）
    if (DataType != 1)
        return  ; 非文本内容直接返回
    
    text := A_Clipboard  ; 获取当前剪贴板文本内容
    
    ; 检查有效性：空内容或与上一条记录相同则忽略
    if (text == "" || (clipHistory.Length > 0 && text == clipHistory[clipHistory.Length]["content"]))
        return
    
    ; 将新记录添加到历史数组（包含时间和内容）
    clipHistory.Push(Map("time", FormatTime(, "HH:mm:ss"), "content", text))
    
    ; 保持历史记录不超过最大限制
    if (clipHistory.Length > maxHistory)
        clipHistory.RemoveAt(1)  ; 移除最旧的记录
    
    ; 创建预览文本（过长则截断）
    preview := (StrLen(text) > previewLength) ? SubStr(text, 1, previewLength) "..." : text
    
    ; 显示工具提示
    ToolTip("📋 剪贴板已保存: `n" preview)
    ; 设置定时器自动关闭工具提示
    SetTimer(() => ToolTip(), -tooltipDuration)
}

; === 快捷键定义 ===
^!v::ShowClipboardHistory()  ; Ctrl+Alt+V触发历史记录菜单

; === 显示历史记录菜单函数 ===
ShowClipboardHistory() {
    global clipHistory, previewLength
    
    ; 空历史记录检查
    if (clipHistory.Length == 0) {
        ToolTip("剪贴板历史记录为空！")
        ; 设置定时器自动关闭工具提示
        SetTimer(() => ToolTip(), -tooltipDuration)
        return
    }
    
    ; 创建菜单对象
    myMenu := Menu()
    
    ; 添加不可点击的标题项
    myMenu.Add("📋 剪贴板历史 (" clipHistory.Length " 条)", (*) => "")
    myMenu.Disable("📋 剪贴板历史 (" clipHistory.Length " 条)")
    
; 倒序添加历史记录（最新在最上面）
loop clipHistory.Length {  ; 遍历剪贴板历史记录数组中的所有元素
    ; 计算倒序索引：
    ; A_Index 是循环内置变量，表示当前循环次数(从1开始)
    ; clipHistory.Length 获取数组总长度
    ; 这样计算可以得到从最后一项到第一项的索引
    i := clipHistory.Length - A_Index + 1
    
    ; 获取当前索引对应的历史记录项
    item := clipHistory[i]
    
    ; 格式化菜单项文本，格式为：时间 + 截断的内容
    ; 使用三元条件运算符(?:)判断内容长度是否需要截断
    text := i " - " item["time"] " - " ((StrLen(item["content"]) > previewLength) 
        ? SubStr(item["content"], 1, previewLength) "..."  ; 如果内容长度超过预览长度，截断并添加省略号
        : item["content"])                                  ; 否则显示完整内容
    
    ; 为每项添加点击事件处理：
    ; myMenu.Add() 向菜单添加项目
    ; (*) => 是AHK v2中的胖箭头函数语法，相当于匿名函数
    ; 这里绑定点击事件到PasteFromHistory函数，并传递当前项的索引i
    ; 注意这里传递的是i而不是直接使用item，因为菜单项点击时需要通过索引找到原始数据
    ; myMenu.Add(text, (*) => PasteFromHistory(i))
    myMenu.Add(text, PasteFromHistory.Bind(i)) 
    }
    
    ; 添加清空功能菜单项
    myMenu.Add("清空历史记录", (*) => ClearClipboardHistory())
    
    ; 显示弹出菜单
    myMenu.Show()
}

; === 从历史记录粘贴函数 ===
PasteFromHistory(i, ItemName, ItemPos, MyMenu) {
    global clipHistory
    ; 索引有效性检查
    if (i > 0 && i <= clipHistory.Length) {
        try {
            ; 获取选中项内容
            content := clipHistory[i]["content"]
            ; 写入剪贴板
            A_Clipboard := content
            Sleep(50)  ; 短暂延迟确保剪贴板更新
            Send("^v")  ; 模拟粘贴操作
        } catch as e {
            ; 错误处理
            ToolTip("粘贴失败: " e.Message)
            SetTimer(() => ToolTip(), -2000)
        }
    }
}

; === 清空历史记录函数 ===
ClearClipboardHistory() {
    global clipHistory
    clipHistory := []  ; 重置数组
    ToolTip("剪贴板历史记录已清空！")
    ; 设置定时器自动关闭工具提示
    SetTimer(() => ToolTip(), -tooltipDuration)
}