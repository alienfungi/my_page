class Comment
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :email, :message

  def persisted?
    false
  end

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  validates_presence_of :email, :name
end
