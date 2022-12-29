class AddPublicToViPham < ActiveRecord::Migration
  def change
    add_column :vi_phams, :public, :boolean
  end
end
