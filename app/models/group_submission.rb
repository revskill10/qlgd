class GroupSubmission < ActiveRecord::Base
  attr_accessible :assignment_group_id, :enrollment_id, :grade

  belongs_to :assignment_group
  belongs_to :enrollment
  after_save :set_diem_qua_trinh
  def diem_trung_binh
  	count = assignment_group.assignments.count
    return 0 if count == 0
    sum = assignment_group.assignments.to_a.sum { |a| (a.submissions.where(enrollment_id: enrollment_id).first.try(:grade) || 0.0 ) * (assignment_group.weight / 10.0) / (a.try(:points) || 1) / count }    
    sum.round(2)
  end

  private
  def set_diem_qua_trinh
  	enrollment.diem_qua_trinh = enrollment.diemqt
  	enrollment.save!
  end
end
