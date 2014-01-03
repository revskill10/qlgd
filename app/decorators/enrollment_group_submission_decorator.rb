#encoding: utf-8
class EnrollmentGroupSubmissionDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def initialize(obj, assignment_group)    
    @object = obj
    @assignment_group = assignment_group    
  end  
  
  def sinh_vien_id
    @object.sinh_vien.id
  end
  def assignment_group_id
    @assignment_group.id
  end
  def assignment_group_name
    @assignment_group.name
  end
  def weight
    return 0 unless @assignment_group.weight
    @assignment_group.weight
  end
  def diem_trung_binh
    @assignment_group.diem_trung_binh(@object.sinh_vien.id)
  end  
  def name
    @object.sinh_vien.hovaten
  end  
  def code
    @object.sinh_vien.code
  end  
  def tinhhinh
    return 0 if @assignment_group.lop_mon_hoc.tong_so_tiet == 0
    (@object.tong_vang * 100.0 / @assignment_group.lop_mon_hoc.tong_so_tiet).round(2)
  end
end
