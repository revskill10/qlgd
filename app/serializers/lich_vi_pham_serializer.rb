class LichViPhamSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :info, :di_muon_alias, :ve_som_alias, :bo_tiet_alias, :alias_state, :note1, :note2, :note3, :di_muon_color, :ve_som_color, :bo_tiet_color
  
  def di_muon_color
  	object.di_muon? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end

  def ve_som_color
  	object.ve_som? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end

  def bo_tiet_color
  	object.bo_tiet? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end
end