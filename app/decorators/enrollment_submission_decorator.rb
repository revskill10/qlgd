#encoding: utf-8
class EnrollmentSubmissionDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def initialize(obj, assignment, index)    
    @object = obj
    @assignment = assignment
    @submission = @object.submissions.where(assignment_id: @assignment.id).first
    @index = index
  end
  def index
    @index
  end
  
  def sinh_vien_id
    @object.sinh_vien.id
  end
  def assignment_id
    @assignment.id
  end
  def assignment_name
    @assignment.name
  end
  def assignment_points
    return 0 unless @assignment.points
    @assignment.points
  end
  def can_destroy
    return false if @assignment.can_destroy? == false
    true
  end
  def grade
    return 0 unless @submission    
    return 0 unless @submission.grade
    return @submission.grade if @submission
  end  
  def name
    @object.sinh_vien.hovaten
  end  
  def code
    @object.sinh_vien.code
  end  
  def tinhhinh
    return 0 if @assignment.lop_mon_hoc.tong_so_tiet == 0
    (@object.tong_vang * 100.0 / @assignment.lop_mon_hoc.tong_so_tiet).round(2)
  end
end
