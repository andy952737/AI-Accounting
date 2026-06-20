require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  def valid_params(overrides = {})
    { amount: 120, kind: "expense", occurred_on: "2026-06-20" }.merge(overrides)
  end

  test "new 顯示空白表單" do
    get new_transaction_path
    assert_response :success
    assert_select "h1", "新增收支記錄"
  end

  test "成功新增一筆支出記錄" do
    assert_difference -> { Transaction.count }, 1 do
      post transactions_path, params: { transaction: valid_params }
    end
    assert_redirected_to new_transaction_path
    follow_redirect!
    assert_match "已新增一筆收支記錄", response.body
  end

  test "成功新增一筆收入記錄" do
    assert_difference -> { Transaction.count }, 1 do
      post transactions_path, params: { transaction: valid_params(amount: 50000, kind: "income", occurred_on: "2026-06-01") }
    end
    assert_redirected_to new_transaction_path
  end

  test "金額為負數時被拒絕" do
    assert_no_difference -> { Transaction.count } do
      post transactions_path, params: { transaction: valid_params(amount: -100) }
    end
    assert_response :unprocessable_entity
  end

  test "金額缺漏時被拒絕" do
    assert_no_difference -> { Transaction.count } do
      post transactions_path, params: { transaction: valid_params(amount: "") }
    end
    assert_response :unprocessable_entity
  end

  test "類型缺漏時被拒絕" do
    assert_no_difference -> { Transaction.count } do
      post transactions_path, params: { transaction: valid_params(kind: "") }
    end
    assert_response :unprocessable_entity
  end

  test "類型為不合法值時被拒絕" do
    assert_no_difference -> { Transaction.count } do
      post transactions_path, params: { transaction: valid_params(kind: "transfer") }
    end
    assert_response :unprocessable_entity
  end

  test "發生日期缺漏時被拒絕" do
    assert_no_difference -> { Transaction.count } do
      post transactions_path, params: { transaction: valid_params(occurred_on: "") }
    end
    assert_response :unprocessable_entity
  end
end
