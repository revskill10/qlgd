#encoding: utf-8
namespace :survey do    
    task generate: :environment do
    	s = Survey.where(name: "Đánh giá dự giờ").first_or_create
    	s.questions.create(name: "Khuyến khích sinh viên tích cực và chủ động học tập")
    	s.questions.create(name: "Kết nối được kiến thức hiện có và trải nghiệm của sinh viên với bài học")
    	s.questions.create(name: "Coi trọng sự đa dạng, đa chiều")
    	s.questions.create(name: "Khuyến khích sinh viên phát triển, mở rộng nhận thức và hiểu biết")
    	s.questions.create(name: "Hoạt động dạy/học có sự kết nối rõ ràng với chuẩn đầu ra")
    	s.questions.create(name: "Sự gắn kết với các kết quả nghiên cứu và thực tế nghề nghiệp")
    	s.questions.create(name: "Sử dụng hiệu quả các nguồn lực và kỹ thuật giảng dạy")
    	s.questions.create(name: "Cấu trúc các hoạt động dạy/học hợp lý và logic")
    	s.questions.each do |q|
    		q.data ||= {}
    		q.data["1"] = "Không có minh chứng"
    		q.data["2"] = "Một vài minh chứng"
    		q.data["3"] = "Có nhiều minh chứng"
    		q.data["4"] = "Có rất nhiều minh chứng"
    		q.data["5"] = "Không rõ tính hiệu quả"
    		q.data["6"] = "Hiệu quả thấp"
    		q.data["7"] = "Hiệu quả trung bình"
    		q.data["8"] = "Hiệu quả cao"
    		q.save!
    	end
   	end
    task seed: :environment do 
        require 'factory_girl_rails'
        # quy trinh lay du lieu
        # 1. Chuyen tenant qua ky moi
        # 2. Tao tuan
        # 3. Lay danh sach giang vien
        # 4. Lay danh sach lop ( thong qua thoi khoa bieu )
        # 5. Tao thoi khoa bieu va lien ket voi lop + giang vien
        # 6. Lay danh sach sinh vien
        # 7. Lay danh sach sinh vien lop mon hoc
        # 8. Start tat ca lop
        t = Tenant.last
        Apartment::Database.switch(t.name)
        d = Date.new(2013, 8, 12)
        (0..46).each do |t|
            FactoryGirl.create(:tuan, :stt => t+1, :tu_ngay => d + t.weeks, :den_ngay => d + t.weeks + 6.day)    
        end 
        gv = FactoryGirl.create(:giang_vien)        
        lop1 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml1", :ma_mon_hoc => "mmh1", :ten_mon_hoc => "tmh1")
        lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :ma_mon_hoc => "mmh2", :ten_mon_hoc => "tmh2")        
        calendar1 = lop1.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 2, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)        
        calendar2 = lop2.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 3, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)
        sv1 = FactoryGirl.create(:sinh_vien, :code => "msv1")   
        sv2 = FactoryGirl.create(:sinh_vien, :ho => "ho2", :dem => "dem2", :ten => "ten2", :code => "msv2")     
        sv3 = FactoryGirl.create(:sinh_vien, :ho => "ho3", :dem => "dem3", :ten => "ten3", :code => "msv3")     
        FactoryGirl.create(:enrollment, :sinh_vien => sv1, :lop_mon_hoc => lop1)
        FactoryGirl.create(:enrollment, :sinh_vien => sv2, :lop_mon_hoc => lop1)
        FactoryGirl.create(:enrollment, :sinh_vien => sv3, :lop_mon_hoc => lop1)
        FactoryGirl.create(:enrollment, :sinh_vien => sv3, :lop_mon_hoc => lop2)
        lop1.start!
        lop2.start!
    end

    task seed_tuan: :environment do
        require 'factory_girl_rails'
        d = Date.new(2013, 8, 12)
        (0..46).each do |t|
            FactoryGirl.create(:tuan, :stt => t+1, :tu_ngay => d + t.weeks, :den_ngay => d + t.weeks + 6.day)    
        end         
    end
end