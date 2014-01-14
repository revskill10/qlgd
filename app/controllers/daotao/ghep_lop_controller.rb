class Daotao::GhepLopController < TenantsController

	def lop_hanh_chinhs
		#results = SinhVien.where("ma_lop_hanh_chinh like ?", "%#{params[:q]}%").paginate(:page => params[:page], :per_page => params[:page_limit])
		search = SinhVien.search do 
			fulltext params[:q] do 
				fields(:ma_lop_hanh_chinh)
			end
			paginate(:page => params[:page] || 1, :per_page => params[:page_limit])
		end
		render json: search.results.map{|sv| sv.ma_lop_hanh_chinh}.uniq.map {|k| {:id => k, :text => k} }, :root => false
	end

	def lop_mon_hocs
		#results = LopMonHoc.all.map {|lop| {id: lop.id, text: lop.ma_lop + " - " + lop.ten_mon_hoc} }
		search = LopMonHoc.search do 
			fulltext params[:q]
			paginate(:page => params[:page] || 1, :per_page => params[:page_limit])
		end
		results = search.results.map {|lop| {id: lop.id, text: lop.ma_lop + " - " + lop.ten_mon_hoc} }
		render json: results, :root => false
	end

	def sinh_viens
		search = SinhVien.search do 
			fulltext params[:q]
			paginate(:page => params[:page] , :per_page => params[:page_limit])
		end
		render json: search.results.map {|k| {:id => k.id, :text => k.hovaten} }, :root => false
	end
end