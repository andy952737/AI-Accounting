class Transaction < ApplicationRecord
  # 收入 / 支出，以資料庫的 kind 字串欄位儲存
  enum :kind, { income: "income", expense: "expense" }

  validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :kind, presence: true
  validates :occurred_on, presence: true
end
