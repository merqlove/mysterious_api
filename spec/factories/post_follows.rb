FactoryGirl.define do
  factory :post_follow, class: 'Post::Follow' do
    association(:post)
    association(:user)
  end
end
