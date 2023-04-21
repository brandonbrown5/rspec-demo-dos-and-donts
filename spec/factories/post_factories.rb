FactoryBot.define do
  factory :post, class: 'Post' do
    association :user
    is_published { false }
  end
end
