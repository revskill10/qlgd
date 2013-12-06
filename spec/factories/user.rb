FactoryGirl.define do
  factory :user do
    email "revskill09@gmail.com"
    password "12345678"
    username "revskill09@gmail.com"  
  end

  factory :sinhvien, class: User do
    email "sinhvien1@gmail.com"    
    password "12345678"
    username "sinhvien1@gmail.com"    
    association :imageable, factory: :sinh_vien
  end

  factory :giangvien, class: User do
    email "giangvien@hpu.edu.vn"    
    password "12345678"
    username "giangvien@hpu.edu.vn"    
    association :imageable, factory: :giang_vien
  end
  
  factory :admin, class: User do
    username "dungth@hpu.edu.vn"    
  end


  factory :sinh_vien do
    ho "ho1"
    dem "dem1"
    ten "ten1"
    code "sv1"  
    #user
  end
  factory :giang_vien do    
    code "gv1"        
    ho "hogv1"
    dem "demgv1"
    ten "tengv1"    
    #user
  end
end