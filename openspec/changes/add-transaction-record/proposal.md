## Why

這是一個生活記帳 side project，目前還沒有任何記帳功能。使用者最核心的需求是把每天的花費與收入記下來，所以第一步要先讓使用者能新增一筆收支記錄，作為後續查詢、統計、分類等功能的基礎。

## What Changes

- 新增「收支記錄」這個核心資料模型，每筆記錄包含金額、類型（收入 / 支出）、發生日期、可選的分類與備註。
- 提供新增一筆收支記錄的功能（表單頁面與建立的 endpoint）。
- 對輸入做基本驗證：金額需為正數、類型必填且只能是收入或支出、日期必填。
- 建立對應的資料表 migration。

## Capabilities

### New Capabilities
- `transaction-recording`: 讓使用者新增一筆收支記錄，涵蓋記錄的欄位定義、驗證規則與建立流程。

### Modified Capabilities
<!-- 無 — 這是第一個功能，沒有既有 capability 需要修改 -->

## Impact

- **資料庫**: 新增 `transactions` 資料表（PostgreSQL）與對應 migration。
- **程式碼**: 新增 `Transaction` model、controller（new / create action）、表單 view 與路由。
- **依賴 / 系統**: 不引入新依賴；沿用現有 Rails 8.x + PostgreSQL 架構，可在 docker-compose 環境下執行。
