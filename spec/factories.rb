FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :friendship do
    user_id 1
    friend_id 2
  end

  factory :message do
    sender_id 1
    recipient_id 2
    subject "subject"
    message "message"
    read false
  end

  factory :user do
    email
    username
    password "password"
    admin false
    confirmed true
  end
end
