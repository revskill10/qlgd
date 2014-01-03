class EnrollmentGroupSubmissionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :weight, :sinh_vien_id, :name, :assignment_group_id, :code, :tong_vang, :tinhhinh, :diem_trung_binh, :assignment_group_name

  def index
    object.index
  end
  def tinhhinh
    object.tinhhinh
  end
  def tong_vang
    object.tong_vang
  end
  def assignmnet_points
    object.assignment_points
  end
  def sinh_vien_id
    object.sinh_vien_id
  end
  def assignment_id
    object.assignment_id
  end  
  def can_destroy
    object.can_destroy
  end
  def name
  	object.name
  end
  def code
  	object.code
  end  
  def grade
    object.grade
  end
  def assignment_name
    object.assignment_name
  end
end
