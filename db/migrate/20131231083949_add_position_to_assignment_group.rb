class AddPositionToAssignmentGroup < ActiveRecord::Migration
  def change
    add_column :assignment_groups, :position, :integer
  end
end
