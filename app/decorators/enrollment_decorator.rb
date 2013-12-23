#encoding: utf-8
class EnrollmentDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def initialize(obj,lich)    
    @object = obj
    @lich = lich
  end
  def id
    @object.id
  end
  def status
  	at = @object.attendances.with_lich(@lich)
  	return "Không vắng" unless at
  	return at.status if at
  end
  def name
    @object.sinh_vien.hovaten
  end
  def code
    @object.sinh_vien.code
  end
end
