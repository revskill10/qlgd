class LopMonHocSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :settings
end