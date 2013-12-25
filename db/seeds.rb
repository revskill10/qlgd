# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'factory_girl_rails'
gv = FactoryGirl.create(:giang_vien)
us = FactoryGirl.create(:giangvien)
us.imageable = gv
us.save!
lop1 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml1", :ma_mon_hoc => "mmh1", :ten_mon_hoc => "tmh1")
lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :ma_mon_hoc => "mmh2", :ten_mon_hoc => "tmh2")
t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))	    
calendar1 = lop1.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 2, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)        
calendar2 = lop2.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 3, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)
calendar1.generate!	    
calendar2.generate!
sv1 = FactoryGirl.create(:sinh_vien, :code => "msv1")  	
sv2 = FactoryGirl.create(:sinh_vien, :ho => "ho2", :dem => "dem2", :ten => "ten2", :code => "msv2")  	
FactoryGirl.create(:enrollment, :sinh_vien => sv1, :lop_mon_hoc => lop1)
FactoryGirl.create(:enrollment, :sinh_vien => sv2, :lop_mon_hoc => lop1)
