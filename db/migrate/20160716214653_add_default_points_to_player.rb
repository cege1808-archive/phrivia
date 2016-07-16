class AddDefaultPointsToPlayer < ActiveRecord::Migration
  def change
    change_column :players, :points, :integer, default: 0
  end
end
