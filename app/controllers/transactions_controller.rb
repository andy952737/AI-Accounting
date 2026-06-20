class TransactionsController < ApplicationController
  def index
    # 依發生日期由新到舊排序，同日期再以建立時間排序，方便檢視最近的記錄
    @transactions = Transaction.order(occurred_on: :desc, created_at: :desc)
  end

  def new
    # 表單預設發生日期為今天，方便輸入
    @transaction = Transaction.new(occurred_on: Date.current)
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to new_transaction_path, notice: "已新增一筆收支記錄"
    else
      render :new, status: :unprocessable_entity
    end
  rescue ArgumentError
    # enum 收到非法的 kind 值（例如被竄改的表單）時，視為驗證失敗重新渲染表單
    @transaction ||= Transaction.new
    @transaction.errors.add(:kind, "不是有效的類型")
    render :new, status: :unprocessable_entity
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :kind, :occurred_on, :category, :note)
  end
end
