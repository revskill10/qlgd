#encoding: utf-8
class Calendar < ActiveRecord::Base
  include IceCube
  attr_accessible :so_tiet, :so_tuan, :thu, :tiet_bat_dau, :tuan_hoc_bat_dau, :giang_vien_id


  belongs_to :lop_mon_hoc
  belongs_to :giang_vien

  validates :so_tiet, :so_tuan, :thu, :tiet_bat_dau, :tuan_hoc_bat_dau, :lop_mon_hoc, :giang_vien, :presence => true
  TIET = {1 => [6,30], 2 => [7,20], 3 => [8,10],
          4 => [9,5], 5 => [9,55], 6 => [10, 45],
          7 => [12,30], 8 => [13,20], 9 => [14,10],
          10 => [15, 5], 11 => [15, 55], 12 => [16, 45],
          13 => [18, 0], 14 => [18, 50], 15 => [19,40], 16 => [20,30]}
  THU2 = {2 => "Thứ 2", 3 => "Thứ 3", 4 => "Thứ 4", 5 => "Thứ 5", 6 => "Thứ 6", 7 => "Thứ 7", 8 => "Chủ nhật"}
  THU = {2 => :monday, 3 => :tuesday, 4 => :wednesday, 5 => :thursday, 6 => :friday, 7 => :saturday, 8 => :sunday}

  def schedule
    new_schedule = Schedule.new(ngay_bat_dau)
    new_schedule.add_recurrence_rule(Rule.daily.day(THU[thu]).hour_of_day(TIET[tiet_bat_dau][0]).minute_of_hour(TIET[tiet_bat_dau][1]).second_of_minute(0).until(ngay_ket_thuc))
    new_schedule.all_occurrences.to_a
  end

  state_machine :state, :initial => :pending do  
    event :generate do 
      transition :pending => :generated # da hoan thanh gio hoc
    end    
  end

  def generate    
    if self.lop_mon_hoc
      sch = self.schedule
      if sch.count > 0
        sch.each do |s|
          begin
            lich = self.lop_mon_hoc.lich_trinh_giang_days.create(thoi_gian: s.to_datetime, giang_vien_id: self.giang_vien.id, so_tiet: self.so_tiet)
            lich.accept!          
          rescue Exception => e
            puts e
          end
        end
      end
    end
    super
  end
  def ngay_bat_dau
    t1 = Tuan.where(stt: tuan_hoc_bat_dau).first
    day = t1.tu_ngay + (thu - 2).days
    return DateTime.new(day.year, day.month, day.day).change(:offset => Rational(7,24))
  end
  def ngay_ket_thuc
    t2 = Tuan.where(stt: tuan_hoc_bat_dau + so_tuan - 1).first    
    if t2
      day = t2.den_ngay
      return DateTime.new(day.year, day.month, day.day).change(:offset => Rational(7,24))
    else
      return nil
    end
  end
end
