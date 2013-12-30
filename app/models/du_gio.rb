class DuGio < ActiveRecord::Base
  attr_accessible :danh_gia, :lich_trinh_giang_day_id, :settings, :state, :user_id

  belongs_to :lich_trinh_giang_day
  belongs_to :user

  validates :lich_trinh_giang_day_id, :user_id, :presence => true
end
