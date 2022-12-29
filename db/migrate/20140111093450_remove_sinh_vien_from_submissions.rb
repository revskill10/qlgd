class RemoveSinhVienFromSubmissions < ActiveRecord::Migration
  def change
  	remove_column :submissions, :sinh_vien_id
  end
end
