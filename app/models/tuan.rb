class Tuan < ActiveRecord::Base
  attr_accessible :den_ngay, :stt, :tu_ngay

  validates :stt, :tu_ngay, :den_ngay, :presence => true

  scope :active, where(["tu_ngay <= ? and den_ngay >= ?", Time.now, Time.now])

  
end
