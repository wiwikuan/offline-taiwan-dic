# 超級快速的離線國語辭典

無依賴的離線國語字典，支援《重編國語辭典修訂本》和《國語辭典簡編本》兩本字典切換。

## 使用方式（網頁版）

把以下三個檔案放在同一個目錄：

```
.
├── index.html
├── dict_revised.csv     # 重編國語辭典修訂本
└── dict_concise.csv    # 國語辭典簡編本
```

CSV 檔名可以在 `index.html` 的 `DICT_FILES` 設定區改。

然後啟動一個 web server。最簡單的方式是用 Python 內建的：

```sh
python3 -m http.server 8765
```

接著瀏覽器打開 `http://localhost:8765/`。

## 使用方式（終端機版）

把 `dic` 丟進 `$PATH` 裡某個地方（例如 `~/.local/bin/`）並加上執行權限：

```sh
install -m 755 dic ~/.local/bin/dic
```

把兩個字典 CSV 檔放在：

- 重編修訂本：`~/.local/share/dic/dict_revised.csv`
- 簡編本：`~/.local/share/dic/dict_concise.csv`

想改路徑，就直接編輯 `dic` 程式碼開頭的 `DICT_PATH_1` / `DICT_PATH_2` 兩行。

語法：

```sh
dic 香蕉           # 兩本字典都查
dic -r 香蕉        # 只查重編修訂本
dic -c 香蕉        # 只查簡編本
dic -a 香          # 顯示所有包含關鍵字的匹配
dic -l 香          # 只列出匹配的字詞名清單
dic --no-color 香  # 不染色
dic -h             # 顯示說明
```

## 資料來源

字典資料來自[教育部《重編國語辭典修訂本》](https://dict.revised.moe.edu.tw/)和[《國語辭典簡編本》](https://dict.concised.moe.edu.tw/)。去除了大部分欄位，只留下最常用的「字詞名、注音一式、釋義」。
