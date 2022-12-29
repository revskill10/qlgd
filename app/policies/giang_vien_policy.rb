GiangVienPolicy = Struct.new(:user, :giang_vien) do
  
  def truongkhoa?
    gv = user.imageable
    return true if gv.is_a?(GiangVien) and gv.khoas.count > 0
    return false
  end
  def duyet?
    return true if daotao?
    if truongkhoa?
   		return true if user.imageable.khoas.map(&:id).include?(giang_vien.id)
    end
    return false
  end
end