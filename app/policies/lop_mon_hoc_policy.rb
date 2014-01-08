class LopMonHocPolicy
  attr_reader :user, :lop_mon_hoc

  def initialize(user, lop_mon_hoc)
    @user = user
    @lop_mon_hoc = lop_mon_hoc
  end
  

  def update?
  	giangvien_update? or asisstant_update?
  end

  private
  def giangvien_update?
  	user and user.imageable.is_a?(GiangVien) and user.imageable.lop_mon_hocs.include?(lop_mon_hoc)
  end
  def asisstant_update?
  	user and user.lop_mon_hocs.include?(lop_mon_hoc)
  end
end