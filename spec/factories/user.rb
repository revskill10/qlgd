FactoryGirl.define do
  factory :user do
    username "revskill09@gmail.com"
    code "revskill09@gmail.com"    
  end

  factory :sinhvien, class: User do
    code "123"    
  end
  factory :giangvien, class: User do
    code "abc"
  end
  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    username "dungth@hpu.edu.vn"
    code "dungth@hpu.edu.vn"
  end
end