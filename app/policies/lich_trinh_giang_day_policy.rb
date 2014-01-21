LichTrinhGiangDayPolicy = Struct.new(:user, :lich_trinh_giang_day) do
  self::Scope = Struct.new(:user, :lich_trinh_giang_day_scope) do
    def resolve
      if user.nil?
        []
      elsif UserDecorator.new(user).is_admin? or UserDecorator.new(user).is_dao_tao?
        lich_trinh_giang_day_scope.all
      else
      	lich_ids = user.get_lichs.map(&:id)
        lich_trinh_giang_day_scope.where(:id => lich_ids)
      end
    end
  end
  def daotao?
    return true if user.decorate.is_super_admin?
    UserDecorator.new(user).is_dao_tao? or UserDecorator.new(user).is_dao_tao_duyet?
  end
  def thanhtra?
    return true if user.decorate.is_super_admin?
    UserDecorator.new(user).is_thanh_tra?
  end
  def update_thongso?
    update? and lich_trinh_giang_day.thoi_gian.localtime < Time.now
  end
  def update?
    return false unless user.giang_vien(lich_trinh_giang_day.lop_mon_hoc)
    #return true if user.decorate.is_super_admin?
    #return false unless Pundit.policy!(user, lich_trinh_giang_day.lop_mon_hoc).update?
    (!(lich_trinh_giang_day.state == "nghile") and !(lich_trinh_giang_day.state == "nghiday") and (lich_trinh_giang_day.status.to_sym == :accepted)  and user.get_lichs.map(&:id).include?(lich_trinh_giang_day.id))  
     # (
     #   (lich_trinh_giang_day.state == "bosung") and (lich_trinh_giang_day.waiting? or lich_trinh_giang_day.accepted?)  and user.get_lichs.map(&:id).include?(lich_trinh_giang_day.id) and !user.giang_vien(lich_trinh_giang_day.lop_mon_hoc).nil?
     # )
    return true
  end

end