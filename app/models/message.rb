class Message < ActiveRecord::Base
  attr_accessor :recipient_identifier

  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id

  validates(:recipient_identifier, presence: true, :if => "recipient_id.nil?")
  validates(:subject, presence: true, length: 1..30)
  validates(:message, presence: true)
  validates(:sender_id, presence: true)

  before_save :set_recipient

  default_scope { order('created_at DESC') }

  def remove_user(user)
    self.removed_by_sender = true if user == sender
    self.removed_by_recipient = true if user == recipient
    if removed_by_sender && removed_by_recipient
      self.destroy
    else
      self.save
    end
  end

  def valid_user(user)
    (sender == user && !removed_by_sender) || (recipient == user && !removed_by_recipient)
  end

private

  def set_recipient
    if recipient_identifier
      recipient = User.find_by_identifier(recipient_identifier)
      self.recipient_id = recipient.try(:id)
    end
    false unless self.recipient_id
  end

end
