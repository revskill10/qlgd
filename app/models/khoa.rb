class Khoa < ActiveRecord::Base
  attr_accessible :giang_vien_id, :ten_khoa
  belongs_to :giang_vien
end
