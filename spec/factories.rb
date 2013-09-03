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
end
