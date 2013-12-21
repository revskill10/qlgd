class LichTrinhGiangDayPolicy
  attr_reader :user, :lich_trinh_giang_day

  def initialize(user, lich_trinh_giang_day)
    @user = user
    @lich_trinh_giang_day = lich_trinh_giang_day
  end

  def marked?
    (not lich_trinh_giang_day.nghile? and not lich_trinh_giang_day.nghiday?) and lich_trinh_giang_day.accepted?
  end
end