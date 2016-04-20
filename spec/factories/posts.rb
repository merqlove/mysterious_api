FactoryGirl.define do
  sequence :title do |n|
    "some#{n}"
  end

  factory :post do
    title { generate(:title) }
    content "MyText"
    meta_keywords "MyString"
    meta_desc "MyString"
    association(:owner, factory: :user)
  end
end
