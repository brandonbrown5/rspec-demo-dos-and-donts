FactoryBot.define do
  factory :user, class: 'User' do
    is_admin { false }
    username { 'username' }
  end
end
