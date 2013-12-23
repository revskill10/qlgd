#encoding: utf-8
class AttendanceDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def status
  	return "Trễ" if object.late?
  	return "Vắng" if object.absent?
  	return "Không vắng" if object.present?
  	return "Không học" if object.idle?
  end
end
