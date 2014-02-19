class AddEncodedPositionToSinhVien < ActiveRecord::Migration
  def change
    add_column :sinh_viens, :encoded_position, :string
  end
end
