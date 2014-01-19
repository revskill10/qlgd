#encoding: utf-8
namespace :hpu do    
  task sort_sv:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    ss = "AÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬBCDĐEÈÉẺẼẸÊỀẾỂỄỆFGHIÌÍỈĨỊJKLMNOÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢPQRSTUÙÚỦŨỤƯỪỨỬỮỰVWXYỲÝỶỸỴZ "
            ss2 = "aàáảãạăằắẳẵặâầấẩẫậbcdđeèéẻẽẹêềếểễệfghiìíỉĩịjklmnoòóỏõọôồốổỗộơờớởỡợpqrstuùúủũụưừứửữựvwxyỳýỷỹỵz "
    sv = SinhVien.find(1)
    puts sv.ten
    index = 0
    while index < sv.ten.length
      if ss.index(sv.ten[index]).nil? or ss2.index(sv.ten[index]).nil?
        puts sv.ten[index]
      else 
        puts "A#{index}"
      end
      index += 1
    end
  end
  #1
  task load_tuan: :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    Tuan.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('tuans') 
    d = Date.new(2014, 1, 13)
    (0..20).each do |t|
        Tuan.where(:stt => t+23, :tu_ngay => d + t.weeks, :den_ngay => d + t.weeks + 6.day).first_or_create!
    end 
  end
  #2
  task load_giang_vien: :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    GiangVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('giang_viens') 
  	@client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:tkb_theo_giai_doan)         
    res_hash = response.body.to_hash                
    ls = res_hash[:tkb_theo_giai_doan_response][:tkb_theo_giai_doan_result][:diffgram][:document_element]
    ls = ls[:tkb_theo_giai_doan]
    puts "loading... giang_vien"
    ls.each_with_index do |l,i|
      puts l.inspect
      tmp = titleize(l[:ten_giao_vien].strip.downcase).split(" ")          
      ho = tmp[0]
      dem = tmp[1..-2].join(" ")
      ten = tmp[-1]
      GiangVien.where(:ho => ho, :dem => dem, :ten => ten, :code => l[:ma_giao_vien].strip.upcase).first_or_create!
    end
  end
  #3
  task load_lop_mon_hoc: :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    LopMonHoc.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lop_mon_hocs') 
    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:tkb_theo_giai_doan)         
    res_hash = response.body.to_hash                
    ls = res_hash[:tkb_theo_giai_doan_response][:tkb_theo_giai_doan_result][:diffgram][:document_element]
    ls = ls[:tkb_theo_giai_doan]
    puts "loading... lop mon hoc"
    ls.each_with_index do |l,i|       
      lop = LopMonHoc.where(:ma_lop => l[:ma_lop].strip.upcase, :ma_mon_hoc => l[:ma_mon_hoc].strip.upcase, :ten_mon_hoc => titleize(l[:ten_mon_hoc].strip.downcase) ).first_or_create!      
      #lop.start!
    end
  end
  # 4
  task load_calendar: :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    LichTrinhGiangDay.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lich_trinh_giang_days') 
    Calendar.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('calendars') 
    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:tkb_theo_giai_doan)         
    res_hash = response.body.to_hash                
    ls = res_hash[:tkb_theo_giai_doan_response][:tkb_theo_giai_doan_result][:diffgram][:document_element]
    ls = ls[:tkb_theo_giai_doan]
    
    ls.each_with_index do |l,i| 
      puts l.inspect
      gv = GiangVien.where(code: l[:ma_giao_vien].strip.upcase).first
      lop = LopMonHoc.where(ma_lop: l[:ma_lop].strip.upcase, ma_mon_hoc: l[:ma_mon_hoc].strip.upcase).first
      calendar = lop.calendars.where(:so_tiet => l[:so_tiet], :so_tuan => l[:so_tuan_hoc], :thu => l[:thu], :tiet_bat_dau => l[:tiet_bat_dau], :tuan_hoc_bat_dau => l[:tuan_hoc_bat_dau], :giang_vien_id => gv.id).first_or_create!
      calendar.update_attributes(phong: (l[:ma_phong_hoc].strip if l.has_key?(:ma_phong_hoc) and l[:ma_phong_hoc].is_a?(String)))
    end
  end
  # 5
  task :load_sinh_vien => :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)    
    SinhVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('sinh_viens')
    # attr_accessible :gioi_tinh, :ho_dem, :lop_hc, :ma_he_dao_tao, :ma_khoa_hoc, :ma_nganh, :ma_sinh_vien, :ngay_sinh, :ten, :trang_thai, :ten_nganh

    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:sinh_vien_dang_hoc)
    res_hash = response.body.to_hash
    ls = res_hash[:sinh_vien_dang_hoc_response][:sinh_vien_dang_hoc_result][:diffgram][:document_element]
    ls = ls[:sinh_vien_dang_hoc]
    puts "loading ... sinh viens"
    ls.each do |l|
      tmp = titleize(l[:hodem].strip.downcase).split(" ")
      ho = tmp[0]
      dem = tmp[1..-1].join(" ")
      SinhVien.create!(
        gioi_tinh: (l[:gioi_tinh] ? 1 : 0),
        ho: ho,
        dem: dem,
        ma_lop_hanh_chinh: (l[:lop].strip.upcase if l[:lop] and l[:lop].is_a?(String) ) ,
        he: ( titleize(l[:ten_he_dao_tao].strip.downcase) if l[:ten_he_dao_tao] and l[:ten_he_dao_tao].is_a?(String) ),
        khoa: ( titleize(l[:ten_khoa_hoc].strip.downcase) if l[:ten_khoa_hoc] and l[:ten_khoa_hoc].is_a?(String) ) ,
        code: (l[:ma_sinh_vien].strip.upcase if l[:ma_sinh_vien]),
        ngay_sinh: (l[:ngay_sinh].to_time if l[:ngay_sinh]),
        ten: ( titleize(l[:ten].strip.downcase) if l[:ten] and l[:ten].is_a?(String) ),
        nganh: ( titleize(l[:ten_nganh].strip.downcase) if l[:ten_nganh] and l[:ten_nganh].is_a?(String) ),
        tin_chi: ( l[:dao_tao_theo_tin_chi] ? true : false )
      )
    end
  end 
  # 6
  task :load_lopsv => :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)    
    Enrollment.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('enrollments')
    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:lop_mon_hoc_sinh_vien_hk)
    res_hash = response.body.to_hash
    ls = res_hash[:lop_mon_hoc_sinh_vien_hk_response][:lop_mon_hoc_sinh_vien_hk_result][:diffgram][:document_element]
    ls = ls[:lop_mon_hoc_sinh_vien_hk]    
    ls.each do |l|         
      lop = LopMonHoc.where(ma_lop: l[:malop].strip.upcase, ma_mon_hoc: l[:ma_mon_hoc].strip.upcase).first
      sv = SinhVien.where(code: l[:ma_sinh_vien].strip.upcase).first
      if lop and sv
        lop.enrollments.where(sinh_vien_id: sv.id).first_or_create!
      end
    end                
  end
  # 7
  task :load_lopghep => :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)        
    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:lop_ghep_hoc_ky)
    res_hash = response.body.to_hash
    ls = res_hash[:lop_ghep_hoc_ky_response][:lop_ghep_hoc_ky_result][:diffgram][:document_element]


    ls = ls[:lop_ghep_hoc_ky]    
    ls.each do |l|         
      lop = LopMonHoc.where(ma_lop: l[:ma_lop_ghep].strip.upcase, ma_mon_hoc: l[:ma_mon_hoc].strip.upcase).first
      sv = SinhVien.where(code: l[:ma_sinh_vien].strip.upcase).first
      if lop and sv
        lop.enrollments.where(sinh_vien_id: sv.id).first_or_create!
      end
    end  
  end
  # 8
  task :start_lop => :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)    
    LopMonHoc.all.each do |lop|
      lop.start! unless lop.started?
    end
  end

  #9
  task :sort_sinh_vien => :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)    
    svs = SinhVien.all.sort
    svs.each_with_index do |sv, index|
      sv.insert_at(index+1)
    end
  end

  #10
  task :reindex => :environment do
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)    
    SinhVien.reindex
    LopMonHoc.reindex    
    Sunspot.commit
  end
  
  #11: update grade
  task :update_grade => :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    Submission.all.each do |s|
      s.save!
    end
  end

  #12 :update tinh hinh vang
  task :update_tinhhinh => :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    Enrollment.all.each do |en|
      en.tinhhinh = en.tinhhinhvang
      en.save!
    end
  end

  def titleize(str)
    str.split(" ").map(&:capitalize).join(" ").gsub("Ii","II")
  end
end