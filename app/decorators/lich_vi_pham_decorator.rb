#encoding: utf-8
class LichViPhamDecorator < Draper::Decorator
	delegate_all

	def initialize(lich)
		@lich = lich
	end
	def info
		return "Thời gian: #{@lich.thoi_gian.strftime("%Hh%M %d/%m/%Y")}\nGiảng viên: #{@lich.giang_vien.hovaten}\nPhòng: #{@lich.phong}\nSố tiết: #{@lich.so_tiet_moi}"
	end
	def di_muon_alias
		return "Không đi muộn" unless @lich.vi_pham
		return @lich.vi_pham.di_muon ? "Đi muộn" : "Không đi muộn"
	end
	def ve_som_alias
		return "Không về sơm" unless  @lich.vi_pham
		return @lich.vi_pham.ve_som ? "Về sớm" : "Không về sơm"				
	end
	def bo_tiet_alias
		return "Không bỏ tiết" unless  @lich.vi_pham
		return @lich.vi_pham.bo_tiet ? "Bỏ tiết" : "Không bỏ tiết"					
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