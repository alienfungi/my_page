FactoryGirl.define do
  factory :contact_message do
    name "Paul"
    email "paul@paul.com"
    message "This is a message from Paul"
  end

  factory :score do
    name "Paul"
    total 123
  end

  factory :user do
    email "email@email.com"
    username "username"
    password "password"
    admin false
  end
end
