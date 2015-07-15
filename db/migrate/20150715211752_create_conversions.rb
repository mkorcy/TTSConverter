class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.string :title
      t.string :author
      t.string :pid
      t.text :recording
      t.text :description

      t.timestamps null: false
    end
  end
end
