LopMonHocPolicy  = Struct.new(:user, :lop_mon_hoc) do
  self::Scope = Struct.new(:user, :lop_mon_hoc_scope) do
    def resolve
      if UserDecorator.new(user).is_admin? or UserDecorator.new(user).is_dao_tao?
        lop_mon_hoc_scope.all
      else
        lop_ids = user.get_lops.map(&:id)
        lop_mon_hoc_scope.where(:id => lop_ids)
      end
    end
  end   
  def daotao?
    UserDecorator.new(user).is_dao_tao?
  end
  def duyet?
    return false unless user.imageable.is_a?(GiangVien)    
    #return true if daotao?    
    return false if user.imageable.khoas.count == 0
    return true if Set.new(lop_mon_hoc.giang_viens.map(&:id)).subset?(Set.new(GiangVien.where(ten_khoa: user.imageable.khoas.first.ten_khoa).map(&:id)))
    false
  end
  def update?    
    user and user.get_lops.map(&:id).include?(lop_mon_hoc.id) and !lop_mon_hoc.completed? and !lop_mon_hoc.removed? and !user.giang_vien(lop_mon_hoc).nil?
  end
end
