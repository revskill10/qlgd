# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if ENV["RAILS_ENV"] == 'development'
	require 'factory_girl_rails'
	gv = FactoryGirl.create(:giang_vien)
	us = FactoryGirl.create(:giangvien)
	us.imageable = gv
	us.save!
	lop1 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml1", :ma_mon_hoc => "mmh1", :ten_mon_hoc => "tmh1")
	lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :ma_mon_hoc => "mmh2", :ten_mon_hoc => "tmh2")
	t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12), :den_ngay => Date.new(2013, 8, 18))
	t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19), :den_ngay => Date.new(2013, 8, 25))
	t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26), :den_ngay => Date.new(2013, 8, 31))	    
	calendar1 = lop1.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 2, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)        
	calendar2 = lop2.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 3, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)
	calendar1.generate!	    
	calendar2.generate!
	sv1 = FactoryGirl.create(:sinh_vien, :code => "msv1")  	
	sv2 = FactoryGirl.create(:sinh_vien, :ho => "ho2", :dem => "dem2", :ten => "ten2", :code => "msv2")  	
	sv3 = FactoryGirl.create(:sinh_vien, :ho => "ho3", :dem => "dem3", :ten => "ten3", :code => "msv3")  	
	FactoryGirl.create(:enrollment, :sinh_vien => sv1, :lop_mon_hoc => lop1)
	FactoryGirl.create(:enrollment, :sinh_vien => sv2, :lop_mon_hoc => lop1)
	FactoryGirl.create(:enrollment, :sinh_vien => sv3, :lop_mon_hoc => lop1)
	FactoryGirl.create(:enrollment, :sinh_vien => sv3, :lop_mon_hoc => lop2)
	lop1.start!
	lop2.start!
	lop1.generate_assignments(gv)
	lop2.generate_assignments(gv)
end