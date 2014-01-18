#encoding: utf-8
class LichViPhamDecorator < Draper::Decorator
	delegate_all



	def initialize(lich)
		@lich = lich
	end
	def id
		@lich.id
	end
	def info
		return "<table class='table table-condensed'><colgroup><col style='width:30%'/><col style='width:70%'/></colgroup><tbody><tr><td>Thời gian:</td><td>#{@lich.thoi_gian.localtime.strftime("%Hh%M %d/%m/%Y")}</td></tr><tr><td>Giảng viên:</td><td>#{@lich.giang_vien.hovaten}</td></tr><tr><td>Phòng:</td><td>#{@lich.phong}, #{@lich.so_tiet_moi} tiết</td></tr><tr><td>Môn:</td><td>#{@lich.lop_mon_hoc.ten_mon_hoc}</td></tr><tr><td>Trạng thái:</td><td>#{@lich.alias_state}</td></tr></tbody></table>"
	end
	def di_muon?
		return false unless @lich.vi_pham
		return @lich.vi_pham.di_muon
	end
	def ve_som?
		return false unless @lich.vi_pham
		return @lich.vi_pham.ve_som
	end
	def bo_tiet?
		return false unless @lich.vi_pham
		return @lich.vi_pham.bo_tiet
	end
	def di_muon_alias
		return "Không đi muộn" unless @lich.vi_pham
		return @lich.vi_pham.di_muon ? "Đi muộn" : "Không đi muộn"
	end
	def ve_som_alias
		return "Không về sớm" unless  @lich.vi_pham
		return @lich.vi_pham.ve_som ? "Về sớm" : "Không về sớm"				
	end
	def bo_tiet_alias
		return "Không bỏ tiết" unless  @lich.vi_pham
		return @lich.vi_pham.bo_tiet ? "Bỏ tiết" : "Không bỏ tiết"					
	end
	def alias_state
		return @lich.alias_state
	end
	def note1
		return "" unless  @lich.vi_pham
		return @lich.vi_pham.note1
	end
	def note1_html			
	    return '' if note1.try(:length) == 0 or note1.nil?
	    note1.gsub(/\n/,'<br/>')
	end
	def note2
		return "" unless  @lich.vi_pham
		return @lich.vi_pham.note2
	end
	def note2_html			
	    return '' if note2.try(:length) == 0 or note2.nil?
	    note2.gsub(/\n/,'<br/>')
	end
	def note3
		return "" unless  @lich.vi_pham
		return @lich.vi_pham.note3
	end
	def note3_html			
	    return '' if note3.try(:length) == 0 or note3.nil?
	    note3.gsub(/\n/,'<br/>')
	end
	def can_report
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_report?
	end
	def can_unreport
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_unreport?
	end
	def can_confirm
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_confirm?
	end
	def can_remove
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_remove?
	end
	def can_restore
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_restore?
	end
	def can_request
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_request?
	end
	def can_accept
		return false unless @lich.vi_pham
		return @lich.vi_pham.can_accept?
	end
	def can_giang_vien_edit
		return false unless @lich.vi_pham
	    @lich.vi_pham.reported? or @lich.vi_pham.requested?
	end
	def can_thanh_tra_edit
		return true unless @lich.vi_pham
	    !@lich.vi_pham.accepted? and !@lich.vi_pham.removed? and !@lich.vi_pham.confirmed?
	end
end