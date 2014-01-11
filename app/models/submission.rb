class Submission < ActiveRecord::Base
  attr_accessible :grade, :enrollment_id, :assignment_id

  belongs_to :assignment
  belongs_to :enrollment
  delegate :lop_mon_hoc, :to => :enrollment

  validates :assignment_id, :enrollment_id, :presence => true

  def can_destroy?
  	grade.nil? or grade == 0
  end
  
end
