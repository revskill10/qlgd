class LichViPhamSerializer < ActiveModel::Serializer
  self.root = false
  attributes :info, :di_muon_alias, :ve_som_alias, :bo_tiet_alias, :alias_state, :note1, :note2, :note3
end