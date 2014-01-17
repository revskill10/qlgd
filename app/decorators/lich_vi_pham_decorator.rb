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
	def note2
		return "" unless  @lich.vi_pham
		return @lich.vi_pham.note2
	end
	def note3
		return "" unless  @lich.vi_pham
		return @lich.vi_pham.note3
	end
end