class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, default: 0, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
