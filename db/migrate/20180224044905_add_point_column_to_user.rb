class AddPointColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :point, :int, null: false, default: 0
  end
end
