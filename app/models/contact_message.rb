class ContactMessage
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates_presence_of :email, :name
end
