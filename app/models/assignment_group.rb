class AssignmentGroup < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :name, :state, :weight

  belongs_to :lop_mon_hoc
  has_many :assignments, :dependent => :destroy

  validates :name, :weight, :presence => true
end
