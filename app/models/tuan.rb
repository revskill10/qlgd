class Tuan < ActiveRecord::Base
  attr_accessible :den_ngay, :stt, :tu_ngay

  validates :stt, :tu_ngay, :den_ngay, :presence => true
end
