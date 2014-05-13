class GroupSubmission < ActiveRecord::Base
  attr_accessible :assignment_group_id, :enrollment_id, :grade

  belongs_to :assignment_group
  belongs_to :enrollment
  after_save :set_diem_qua_trinh
  
  def diem_trung_binh
    if self.assignment_group.weight.to_i == 30
      return diemtb2
    elsif self.assignment_group.weight.to_i == 60
      return diemtb3
    else
      return diemtb1
    end
  end

  private
  def set_diem_qua_trinh
  	enrollment.diem_qua_trinh = enrollment.diemqt
  	enrollment.save!
  end
  def diemtb1
    count = assignment_group.assignments.count
    return 0 if count == 0
    sum = assignment_group.assignments.to_a.sum { |a| (a.submissions.where(enrollment_id: enrollment_id).first.try(:grade) || 0.0 ) * (assignment_group.weight / 10.0) / (a.try(:points) || 1) / count }    
    sum.round(2)
  end
  def diemtb2
    count = assignment_group.assignments.count
    return 0 if count == 0
    sum = assignment_group.assignments.to_a.sum { |a| (a.submissions.where(enrollment_id: enrollment_id).first.try(:grade) || 0.0 ) * 10.0/ (a.try(:points).to_f || 1) / count.to_f }.round(0).to_i
    if sum == 9 or sum == 10
      return 3
    elsif sum == 7 or sum == 8
      return 2
    elsif sum == 5 or sum == 6
      return 1
    else
      return 0
    end
  end
  def diemtb3
    count = assignment_group.assignments.count
    return 0 if count == 0
    sum = assignment_group.assignments.to_a.sum { |a| (a.submissions.where(enrollment_id: enrollment_id).first.try(:grade) || 0.0 ) * 10.0/ (a.try(:points).to_f || 1) / count.to_f }.round(0).to_i
    if (sum <= 10 and sum >= 5)
      return sum - 4
    else
      return 0
    end
  end
end
