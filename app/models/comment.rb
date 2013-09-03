class Comment
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :email, :message

  def persisted?
    false
  end

  def initialize(attributes = {})
    default_message = 'none provided'
    id = attributes.fetch(:id, 1)
    name = attributes.fetch(:name, default_message)
    email = attributes.fetch(:email, default_message)
    message = attributes.fetch(:message, default_message)
  end

  validates_presence_of :email, :name
end
