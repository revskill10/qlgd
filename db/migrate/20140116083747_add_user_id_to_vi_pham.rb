class AddUserIdToViPham < ActiveRecord::Migration
  def change
    add_column :vi_phams, :user_id, :integer
  end
end
