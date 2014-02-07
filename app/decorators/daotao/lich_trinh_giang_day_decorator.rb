class Daotao::LichTrinhGiangDayDecorator < Draper::Decorator
  delegate_all
  

  def so_tiet
    object.so_tiet_moi
  end
  def phong
    return '' unless object.phong
    return object.phong
  end
end