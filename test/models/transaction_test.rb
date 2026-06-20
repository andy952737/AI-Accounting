require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def valid_attributes(overrides = {})
    { amount: 120, kind: "expense", occurred_on: Date.new(2026, 6, 20) }.merge(overrides)
  end

  # 對應 spec: 新增收支記錄
  test "成功建立一筆支出記錄" do
    transaction = Transaction.new(valid_attributes(amount: 120, kind: "expense"))
    assert transaction.valid?
    assert transaction.save
    assert transaction.expense?
  end

  test "成功建立一筆收入記錄" do
    transaction = Transaction.new(valid_attributes(amount: 50000, kind: "income", occurred_on: Date.new(2026, 6, 1)))
    assert transaction.valid?
    assert transaction.save
    assert transaction.income?
  end

  test "可一併保存分類與備註" do
    transaction = Transaction.new(valid_attributes(category: "餐飲", note: "午餐便當"))
    assert transaction.save
    assert_equal "餐飲", transaction.reload.category
    assert_equal "午餐便當", transaction.note
  end

  # 對應 spec: 金額驗證
  test "金額為負數時無效" do
    transaction = Transaction.new(valid_attributes(amount: -100))
    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "must be greater than 0"
  end

  test "金額為 0 時無效" do
    transaction = Transaction.new(valid_attributes(amount: 0))
    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "must be greater than 0"
  end

  test "金額缺漏時無效" do
    transaction = Transaction.new(valid_attributes(amount: nil))
    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "can't be blank"
  end

  # 對應 spec: 類型驗證
  test "類型缺漏時無效" do
    transaction = Transaction.new(valid_attributes(kind: nil))
    assert_not transaction.valid?
    assert_includes transaction.errors[:kind], "can't be blank"
  end

  test "類型為不合法值時被拒絕" do
    # enum 會在指派非法值時丟出 ArgumentError，由 controller 攔截處理
    assert_raises(ArgumentError) do
      Transaction.new(valid_attributes(kind: "transfer"))
    end
  end

  # 對應 spec: 發生日期驗證
  test "發生日期缺漏時無效" do
    transaction = Transaction.new(valid_attributes(occurred_on: nil))
    assert_not transaction.valid?
    assert_includes transaction.errors[:occurred_on], "can't be blank"
  end
end
