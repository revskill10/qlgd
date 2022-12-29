class TuanSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :stt, :tu_ngay2, :den_ngay2
end