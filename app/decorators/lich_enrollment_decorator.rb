#encoding: utf-8
class LichEnrollmentDecorator < Draper::Decorator
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
    @at = @object.attendances.where(lich_trinh_giang_day_id: @lich.id).first
  end
  def sinh_vien_id
    @object.sinh_vien.id
  end
  def id
    @object.id
  end
  def so_tiet_vang
    return 0 unless @at    
    return @at.so_tiet_vang if @at
  end
  def phep_status
    return 'Không phép' unless @at
    return @at.decorate.phep_status
  end
  def idle_status
    return 'Có' unless @at.idle?
    return 'Không'
  end
  def phep
    return false unless @at
    return false unless @at.phep    
    return @at.phep
  end
  def status  	
  	return 'Không vắng' unless @at
  	return @at.decorate.status if @at
  end
  def name
    @object.sinh_vien.hovaten
  end
  def note
    return '' unless @at
    return @at.note if @at
  end
  def code
    @object.sinh_vien.code
  end
  def max
    @lich.so_tiet_moi
  end
  def tinhhinh
    return 0 if (@lich.lop_mon_hoc.tong_so_tiet == 0)
    (@object.tong_vang * 100.0 / @lich.lop_mon_hoc.tong_so_tiet).round(2)
  end
  def dihoc_tinhhinh
    return (100 - tinhhinh).round(2)
  end
end
