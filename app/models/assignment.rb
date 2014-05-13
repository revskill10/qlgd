class Assignment < ActiveRecord::Base   
  attr_accessible :assignment_group_id, :description, :lop_mon_hoc_id, :name, :points

  belongs_to :assignment_group   
  belongs_to :lop_mon_hoc 
  

  acts_as_list :scope => :assignment_group
  has_many :submissions, :dependent => :destroy

  validates :name, :points, :assignment_group_id, :presence => true
  validates :assignment_group, :presence => true
  validates :points, numericality: {only_integer: true}
  def can_destroy?
  	#submissions.to_a.sum { |e| e.grade.to_i } == 0
    true
  end
end
