class Submission < ActiveRecord::Base
  attr_accessible :grade, :sinh_vien_id

  belongs_to :assignment
  belongs_to :sinh_vien
  
  validates :assignment_id, :sinh_vien_id, :presence => true

  def can_destroy?
  	grade.nil? or grade == 0
  end
  
end
