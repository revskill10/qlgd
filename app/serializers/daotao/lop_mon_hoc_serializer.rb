class Daotao::LopMonHocSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :can_start, :can_remove, :can_restore, :state, :text

  def can_start
  	object.can_start?  	
  end

  def can_remove
  	object.can_remove?
  end

  def can_restore
  	object.can_restore?
  end

  def text
    object.ma_lop + " - " + object.ten_mon_hoc
  end
end