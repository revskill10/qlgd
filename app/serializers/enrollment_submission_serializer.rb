class EnrollmentSubmissionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :sinh_vien_id, :index, :name, :assignment_id, :code, :tong_vang, :tinhhinh, :grade, :assignment_name

  def index
    object.index
  end
  def tinhhinh
    object.tinhhinh
  end
  def tong_vang
    object.tong_vang
  end
  def sinh_vien_id
    object.sinh_vien_id
  end
  def assignment_id
    object.assignment_id
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
