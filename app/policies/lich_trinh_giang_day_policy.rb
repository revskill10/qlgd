LichTrinhGiangDayPolicy = Struct.new(:user, :lich_trinh_giang_day) do
  self::Scope = Struct.new(:user, :lich_trinh_giang_day_scope) do
    def resolve
      if user.nil?
        []
      elsif UserDecorator.new(user).is_admin? or UserDecorator.new(user).is_dao_tao?
        lich_trinh_giang_day_scope.all
      else
      	lop_ids = user.get_lops.map(&:id)
        lich_trinh_giang_day_scope.where(:lop_mon_hoc_id => lop_ids)
      end
    end
  end
  
  def update?
    return false unless Pundit.policy!(user, lich_trinh_giang_day.lop_mon_hoc).update?
    !(lich_trinh_giang_day.state == "nghile") and !(lich_trinh_giang_day.state == "nghiday") and lich_trinh_giang_day.accepted? and user and user.imageable.is_a?(GiangVien) and user.imageable.lop_mon_hocs.include?(lich_trinh_giang_day.lop_mon_hoc) and lich_trinh_giang_day.thoi_gian.localtime < Time.now and lich_trinh_giang_day.lop_mon_hoc.tong_so_tiet > 0
  end

end