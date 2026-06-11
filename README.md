<div align="center">

# toolbox

**我自己做的小工具,一行指令裝到任何一台 Windows。**

新電腦、只想要工具、不想搞開發環境?這個就對了。

</div>

---

## 一行安裝

開 PowerShell,貼這行:

```powershell
irm https://raw.githubusercontent.com/Jeffrey0117/toolbox/main/install.ps1 | iex
```

它會**自動抓每個 app 的最新版**(免安裝的建捷徑、安裝版的跑安裝程式),東西放在 `C:\Tools`。
不寫死版本號——你哪天發了新版,這行永遠裝到最新。

---

## 裡面有什麼

| App | 用途 | 連結 |
|---|---|---|
| **Lanpai Overlay** | 螢幕浮層:把文字/圖片釘在螢幕上,透明無框 | [repo](https://github.com/Jeffrey0117/lanpai-overlay) · [下載](https://github.com/Jeffrey0117/lanpai-overlay/releases/latest) |
| **DuckShot** | 輕巧截圖工具 | [repo](https://github.com/Jeffrey0117/DuckShot) · [下載](https://github.com/Jeffrey0117/DuckShot/releases/latest) |
| **RePic** | 批次改圖片尺寸 | [repo](https://github.com/Jeffrey0117/RePic) · [下載](https://github.com/Jeffrey0117/RePic/releases/latest) |
| **Screenshot OCR** | 截圖轉文字 (OCR) | [repo](https://github.com/Jeffrey0117/Screenshot-OCR) · [下載](https://github.com/Jeffrey0117/Screenshot-OCR/releases/latest) |
| **PyClick** | 圖像辨識自動點擊器 | [repo](https://github.com/Jeffrey0117/PyClick) · [下載](https://github.com/Jeffrey0117/PyClick/releases/latest) |
| **MemoryGuy** | 記憶體監控 / 一鍵優化 | [repo](https://github.com/Jeffrey0117/MemoryGuy) · [下載](https://github.com/Jeffrey0117/MemoryGuy/releases/latest) |
| **ReVid** | 本地影片檢視 / 裁切 | [repo](https://github.com/Jeffrey0117/ReVid) · [下載](https://github.com/Jeffrey0117/ReVid/releases/latest) |
| **ClaudeBot** | 用 Telegram 操控 Claude Code | [repo](https://github.com/Jeffrey0117/ClaudeBot) · [下載](https://github.com/Jeffrey0117/ClaudeBot/releases/latest) |

> 這張表也是我自己的記憶清單——哪些東西做好了、各自幹嘛,一頁看完。
> 加了新 app?在 `install.ps1` 的清單補一行、這張表補一列就好。

---

## 其他用法

當成本機檔案跑的話:

```powershell
.\install.ps1 -List                          # 只列清單,不安裝
.\install.ps1 -Only lanpai-overlay,RePic     # 只裝這幾個
.\install.ps1 -Silent                         # 安裝版走靜默安裝(支援的才有效)
```

## 怎麼運作的

`install.ps1` 對每個 repo 打 GitHub API 拿 `releases/latest`,挑出 Windows 的 `.exe`
(優先免安裝版),下載到 `C:\Tools\<app>\`。免安裝的建開始選單捷徑,安裝版的直接跑。
全程不需要登入(都是公開 repo)。

---

## 兄弟專案

| | 幹嘛的 | 什麼時候用 |
|---|---|---|
| **toolbox**(這個) | 裝**做好的 App** 來「用」 | 新電腦只想要工具,連不寫 code 的機器也行 |
| [**DevFault**](https://github.com/Jeffrey0117/DevFault) | 重建**開發環境**(裝 git/node/docker、clone 原始碼、裝依賴) | 新電腦要拿來「寫程式」 |

一個把機器變成「能用我的工具」,一個把機器變成「能開發」。別搞混、別重疊。

---

## License

MIT
