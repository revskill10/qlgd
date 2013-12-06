FactoryGirl.define do
  factory :tenant do
    hoc_ky "1"
    nam_hoc "2013-2014"
    ngay_bat_dau DateTime.new(2013, 8, 12)
    ngay_ket_thuc DateTime.new(2013, 12, 1)
    name "t1"
  end
end