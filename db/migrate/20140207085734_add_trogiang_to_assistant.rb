class AddTrogiangToAssistant < ActiveRecord::Migration
  def change
    add_column :assistants, :trogiang, :boolean
  end
end
