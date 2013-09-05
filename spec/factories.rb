FactoryGirl.define do
  factory :comment do
    name "Paul"
    email "paul@paul.com"
    message "This is a comment from Paul"
  end

  factory :score do
    name "Paul"
    total 123
  end

  factory :user do
    email "email@email.com"
    password "password"
    admin false
  end
end
