FactoryGirl.define do
  sequence :email do |n|
    "some#{n}@example.com"
  end

  sequence :login do |n|
    "some#{n}"
  end

  factory :guest, class: 'User' do
    email { generate(:email) }
    login { generate(:login) }
    password 'test password'

    factory :user do
      role 1
    end

    factory :admin do
      role 2
    end
  end
end
