class Submission < ActiveRecord::Base
  attr_accessible :grade, :enrollment_id, :assignment_id

  belongs_to :assignment
  belongs_to :enrollment
  delegate :lop_mon_hoc, :to => :enrollment

  validates :assignment_id, :enrollment_id, :presence => true
  after_save :set_group_submission
  def can_destroy?
  	grade.nil? or grade == 0
  end
  
  private
  def set_group_submission
  	gs = enrollment.group_submissions.where(assignment_group_id: assignment.assignment_group.id).first_or_create!
	  gs.grade = gs.diem_trung_binh
	  gs.save!    
  end
end
