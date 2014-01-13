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

    
  def update?
    return true if user.decorate.is_super_admin?
    user and user.get_lops.map(&:id).include?(lop_mon_hoc.id) and !lop_mon_hoc.completed? and !lop_mon_hoc.removed? and !user.giang_vien(lop_mon_hoc).nil?
  end
end