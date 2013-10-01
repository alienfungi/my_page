FactoryGirl.define do
  factory :user do
    email "email@email.com"
    username "username"
    password "password"
    admin false
  end
end
