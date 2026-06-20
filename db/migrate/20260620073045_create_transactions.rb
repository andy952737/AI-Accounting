class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :amount, null: false
      t.string :kind, null: false
      t.date :occurred_on, null: false
      t.string :category
      t.text :note

      t.timestamps
    end
  end
end
