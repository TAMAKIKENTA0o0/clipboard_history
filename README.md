# 📋 AutoHotkey Clipboard Manager

![AHK Logo](https://www.autohotkey.com/static/ahk_logo_no_text.svg)  
*A lightweight clipboard history manager for Windows using AutoHotkey v2.0*

## ✨ Features

- **Clipboard History**: Automatically saves up to 30 text entries
- **Quick Access**: Press `Ctrl+Alt+V` to view your clipboard history
- **Smart Preview**: Shows truncated text with timestamps for easy identification
- **One-Click Paste**: Select any item to automatically paste it
- **Auto-Clean**: Removes duplicates and empty entries
- **Clear Function**: Easily clear all history with the menu option

## 📥 Installation

1. **Prerequisite**: Install [AutoHotkey v2.0](https://www.autohotkey.com/download/ahk-v2.exe)
2. Download the script file ([clipboard_manager.ahk](clipboard_manager.ahk))
3. Double-click to run the script
4. (Optional) Add to startup for automatic launch

## ⌨️ Usage

- **Save to history**: Just copy text as normal (automatically captured)
- **View history**: Press `Ctrl + Alt + V`
- **Paste from history**: Select an item from the menu
- **Clear history**: Select "清空历史记录" from the menu

## ⚙️ Customization

Edit these variables at the top of the script:

```ahk
maxHistory := 30         ; Maximum history entries to save
previewLength := 40      ; Max characters to show in preview
tooltipDuration := 1500  ; Tooltip display time in milliseconds
```

## 📜 License

This project is open source under the [MIT License](LICENSE).

---

💡 *Tip: The script runs silently in the background. Look for the AHK icon in your system tray.*
