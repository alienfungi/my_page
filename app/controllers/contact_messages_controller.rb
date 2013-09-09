class ContactMessagesController < ApplicationController
  skip_before_action :require_login
  
  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    notification = if @contact_message.valid?
      begin
        ContactMessageMailer.contact_message_email(@contact_message).deliver
        { success: "Message submitted." }
      rescue => e
        puts e.message
        { error: "Message failed to submit." }
      end
    else
      { alert: "Invalid information." }
    end

    redirect_to(contact_url, flash: notification)
  end

private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :message)
  end
end
