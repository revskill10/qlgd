class Assignment < ActiveRecord::Base   
  attr_accessible :assignment_group_id, :description, :lop_mon_hoc_id, :name, :points, :giang_vien_id

  belongs_to :assignment_group   
  belongs_to :lop_mon_hoc 
  belongs_to :giang_vien

  acts_as_list :scope => :assignment_group
  has_many :submissions, :dependent => :destroy

  validates :giang_vien, :presence => true
  validates :name, :points, :giang_vien_id, :assignment_group_id, :presence => true
  validates :assignment_group, :presence => true
  validates :points, numericality: {only_integer: true}
  def can_destroy?
  	submissions.to_a.sum { |e| e.grade.to_i } == 0
  end
end
