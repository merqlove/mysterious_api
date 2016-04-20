FactoryGirl.define do
  factory :comment do
    content "MyString"
    association(:post)
    association(:user)
  end
end
