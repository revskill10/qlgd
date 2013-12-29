class Assignment < ActiveRecord::Base
  attr_accessible :assignment_group_id, :description, :lop_mon_hoc_id, :name, :points

  belongs_to :assignment_group 
  belongs_to :lop_mon_hoc 
  validates :name, :points, :presence => true
end
