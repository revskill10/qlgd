class AddEncodedPositionToGiangVien < ActiveRecord::Migration
  def change
    add_column :giang_viens, :encoded_position, :string
  end
end
