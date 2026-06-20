## 1. 資料模型與 Migration

- [ ] 1.1 建立 `CreateTransactions` migration：欄位 `amount`(integer, null: false)、`kind`(string, null: false)、`occurred_on`(date, null: false)、`category`(string)、`note`(text)，含 timestamps
- [ ] 1.2 執行 `rails db:migrate`（docker-compose 環境）並確認 schema 更新
- [ ] 1.3 建立 `Transaction` model，加入 `kind` 的 enum（`income` / `expense`）

## 2. 驗證規則

- [ ] 2.1 model 驗證 `amount` 為必填且 `greater_than: 0`
- [ ] 2.2 model 驗證 `kind` 為必填且僅允許 `income` / `expense`
- [ ] 2.3 model 驗證 `occurred_on` 為必填
- [ ] 2.4 撰寫 model 測試覆蓋成功建立與各驗證失敗情境（對應 spec scenarios）

## 3. 路由與 Controller

- [ ] 3.1 新增 `transactions` 路由（`new`、`create`）
- [ ] 3.2 建立 `TransactionsController`，實作 `new` action（提供空白表單，`occurred_on` 預設今天）
- [ ] 3.3 實作 `create` action，使用 strong parameters 接收 `amount`/`kind`/`occurred_on`/`category`/`note`
- [ ] 3.4 建立成功時導向並顯示成功提示；驗證失敗時重新渲染表單並顯示錯誤訊息

## 4. 表單畫面

- [ ] 4.1 建立 `new` 表單 view，含金額、類型（收入/支出）、發生日期、分類、備註欄位
- [ ] 4.2 在表單顯示驗證錯誤訊息

## 5. 驗收

- [ ] 5.1 於 docker-compose 啟動 app，手動新增一筆支出與一筆收入記錄，確認成功保存
- [ ] 5.2 手動測試金額為負/缺漏、類型缺漏、日期缺漏時皆被拒絕並顯示錯誤
- [ ] 5.3 執行測試套件確認全數通過
