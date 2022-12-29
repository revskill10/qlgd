class AddPositionToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :position, :integer
  end
end
