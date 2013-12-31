class LichTrinhGiangDayPolicy
  attr_reader :user, :lich_trinh_giang_day

  def initialize(user, lich_trinh_giang_day)
    @user = user
    @lich_trinh_giang_day = lich_trinh_giang_day
  end

  def update?
  	!(lich_trinh_giang_day.state == :nghile) and !(lich_trinh_giang_day.state == :nghiday) and lich_trinh_giang_day.accepted? and user.imageable.is_a?(GiangVien) and user.imageable.lich_trinh_giang_days.include?(lich_trinh_giang_day) and lich_trinh_giang_day.thoi_gian.localtime >= Time.now and lich_trinh_giang_day.lop_mon_hoc.started?
  end
  


end