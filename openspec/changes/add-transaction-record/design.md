## Context

這是生活記帳 side project 的第一個功能，目前 codebase 還沒有任何記帳相關的 model 與畫面。技術棧為 Rails 8.x、Ruby 3.3.7、PostgreSQL，並以 docker-compose 在 local 啟動。由於是個人小型專案，設計目標以簡單、可快速實作、好維護為主，不需要過度設計。本功能聚焦於「新增一筆收支記錄」，是後續查詢、統計、分類等功能的資料基礎。

## Goals / Non-Goals

**Goals:**
- 定義 `Transaction` 資料模型與資料表，作為日後所有記帳功能的核心。
- 提供新增收支記錄的表單頁與建立流程，含基本的伺服器端驗證。
- 保持實作精簡，能在現有 docker-compose 環境直接跑起來。

**Non-Goals:**
- 不處理使用者登入 / 多使用者隔離（單人使用，暫不需要）。
- 不做記錄的列表、查詢、編輯、刪除（留待後續 change）。
- 不做分類的獨立管理（category 先以字串欄位存放，不建獨立資料表）。
- 不做統計報表、圖表、匯入匯出。
- 不引入背景工作（Sidekiq）；新增記錄為同步操作。

## Decisions

**1. 單一 `transactions` 資料表，類型以欄位區分收入/支出**
- 以一張表搭配 `kind` 欄位（`income` / `expense`）表示收支，而非拆成兩張表。理由：收入與支出的欄位結構相同，單表更簡單，後續統計與查詢也更直接。
- `kind` 以 string enum 實作（Rails `enum`），值為 `income`、`expense`，並在資料庫層加上 `null: false`。
- 替代方案：用 boolean `is_income` — 可讀性差且不易擴充，捨棄。

**2. 金額以整數（最小貨幣單位）儲存**
- `amount` 使用 `integer`，以「元」為單位儲存（台幣無小數需求）。理由：避免浮點數誤差，計算與比較單純。
- 資料庫層加 `null: false`，model 層驗證 `numericality: greater_than: 0`。
- 替代方案：`decimal` — 對僅記台幣的個人專案而言偏重，暫不採用；若日後需多幣別或小數再行調整。

**3. category 先以字串欄位儲存**
- `category` 為可選的 string 欄位，先不建獨立的分類資料表。理由：第一個功能不需要分類管理，字串足以滿足記錄需求，降低初期複雜度。
- 後續若要做分類統計或下拉選單，再以獨立 change 抽出 `Category` model。

**4. 標準 Rails MVC，無 API 層**
- 以 server-rendered 的 controller + ERB 表單（`new` / `create`）實作，沿用 Rails 慣例與 strong parameters。理由：個人專案、單人操作，毋須 SPA 或 JSON API。

## Risks / Trade-offs

- [category 用字串，日後可能出現拼字不一致 / 難以彙總] → 第一版可接受；後續做分類統計時再抽成獨立 model 並做資料遷移。
- [金額用整數元、不存小數] → 對台幣記帳足夠；若未來要支援外幣或小數，需 migration 調整欄位型別與既有資料。
- [無使用者驗證與授權] → 符合單人 side project 現況；若日後開放多人，需新增 user 關聯與權限控制。

## Migration Plan

1. 建立 `CreateTransactions` migration，新增 `transactions` 表，欄位：`amount`(integer, null: false)、`kind`(string, null: false)、`occurred_on`(date, null: false)、`category`(string, null: true)、`note`(text, null: true)，含 timestamps。
2. 執行 `rails db:migrate`（於 docker-compose 環境）。
3. Rollback 策略：此為新增資料表，回滾即 `rails db:rollback`，不影響既有資料（目前無其他資料表依賴）。

## Open Questions

- 金額是否需要支援小數（例如記帳含外幣）？目前假設僅台幣、整數元，如有需求再調整。
- 發生日期預設值是否帶今天（建立表單預設 `Date.current`）？傾向預設今天以方便輸入，實作時確認。
