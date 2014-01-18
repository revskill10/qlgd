class LichViPhamSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :info, :di_muon_alias, :ve_som_alias, :bo_tiet_alias, :alias_state, :note1, :note2, :note3, :di_muon_color, :ve_som_color, :bo_tiet_color, :can_accept, :can_request, :can_remove, :can_confirm, :can_report, :can_unreport, :can_restore, :can_thanh_tra_edit, :can_giang_vien_edit, :note1_html, :note2_html, :note3_html, :di_muon_label, :ve_som_label, :bo_tiet_label
  
  def di_muon_color
  	object.di_muon? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end

  def ve_som_color
  	object.ve_som? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end

  def bo_tiet_color
  	object.bo_tiet? ? "btn btn-sm btn-danger" : "btn btn-sm btn-success"
  end
  
  def di_muon_label
    object.di_muon? ? "label label-danger" : "label label-success"    
  end

  def ve_som_label
    object.ve_som? ? "label label-danger" : "label label-success"
  end

  def bo_tiet_label
    object.bo_tiet? ? "label label-danger" : "label label-success"
  end
end