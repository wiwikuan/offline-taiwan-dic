# 超級快速的離線國語辭典

無依賴的離線國語字典，支援《重編國語辭典修訂本》和《國語辭典簡編本》兩本字典切換。

## 使用方式

把以下三個檔案放在同一個目錄：

```
.
├── index.html
├── dict_revised.csv     # 重編國語辭典修訂本
└── dict_concised.csv    # 國語辭典簡編本
```

CSV 檔名可以在 `index.html` 的 `DICT_FILES` 設定區改。

然後啟動一個 web server。最簡單的方式是用 Python 內建的：

```sh
python3 -m http.server 8765
```

接著瀏覽器打開 `http://localhost:8765/`。

## 資料來源

字典資料來自[教育部《重編國語辭典修訂本》](https://dict.revised.moe.edu.tw/)和[《國語辭典簡編本》](https://dict.concised.moe.edu.tw/)。去除了大部分欄位，只留下最常用的「字詞名、注音一式、釋義」。