class LopMonHocPolicy
  attr_reader :user, :lop_mon_hoc

  def initialize(user, lop_mon_hoc)
    @user = user
    @lop_mon_hoc = lop_mon_hoc
  end
  
  def update?
  	user and user.imageable.is_a?(GiangVien) and user.imageable.lop_mon_hocs.include?(lop_mon_hoc)
  end
end