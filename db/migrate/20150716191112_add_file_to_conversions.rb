class AddFileToConversions < ActiveRecord::Migration
  def change
    add_column :conversions, :file, :string
  end
end
