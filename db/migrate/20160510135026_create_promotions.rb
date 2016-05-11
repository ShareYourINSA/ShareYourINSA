class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.date :start_date
      t.date :end_date
      t.integer :id_department

      t.timestamps null: false
    end
  end
end
