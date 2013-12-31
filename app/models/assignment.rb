class Assignment < ActiveRecord::Base   
  attr_accessible :assignment_group_id, :description, :lop_mon_hoc_id, :name, :points, :giang_vien_id

  belongs_to :assignment_group   
  belongs_to :lop_mon_hoc 
  acts_as_list scope: :assignment_group
  has_many :submissions, :dependent => :destroy
  validates :name, :points, :giang_vien_id, :assignment_group_id, :presence => true
end
