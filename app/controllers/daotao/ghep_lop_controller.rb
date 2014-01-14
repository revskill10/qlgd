class Daotao::GhepLopController < TenantsController

	def lop_hanh_chinhs
		results = SinhVien.where("ma_lop_hanh_chinh like ?", "%#{params[:q]}%").paginate(:page => params[:page], :per_page => params[:page_limit])
		render json: results.pluck(:ma_lop_hanh_chinh).uniq.map {|k| {:id => k, :text => k} }, :root => false
	end

	def lop_mon_hocs
		results = LopMonHoc.all.map {|lop| {id: lop.id, text: lop.ma_lop + " - " + lop.ten_mon_hoc} }
		render json: results, :root => false
	end

	def sinh_viens

	end
end