class AssignmentGroup < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :name, :state, :weight, :giang_vien_id

  belongs_to :lop_mon_hoc
  has_many :assignments, :dependent => :destroy

  validates :name, :weight, :giang_vien_id, :presence => true
end
