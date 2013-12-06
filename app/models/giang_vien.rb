class GiangVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ten, :ten_khoa

  has_one :user, :as => :imageable
end
