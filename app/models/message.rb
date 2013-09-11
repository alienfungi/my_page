class Message < ActiveRecord::Base
  attr_accessor :recipient_email

  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id

  validates(:subject, presence: true, length: 1..30)
  validates(:message, presence: true)
  validates(:sender_id, presence: true)

  before_save :set_recipient

  default_scope order('created_at DESC')

private

  def set_recipient
    if recipient_email
      recipient = User.find_by(email: recipient_email)
      self.recipient_id = recipient.try(:id)
    end
    false unless self.recipient_id
  end
end
