class Assistant < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :user_id

  belongs_to :user
  belongs_to :lop_mon_hoc

  validates :user, :lop_mon_hoc, :presence => true
end
