class MessagesController < ApplicationController
  def index
    @received_messages = current_user.received_messages.paginate(
      page: params[:received_messages_page], per_page: 10)
    @sent_messages = current_user.sent_messages.paginate(
      page: params[:sent_messages_page], per_page: 10)
    @active_tab = params[:active_tab] || "received"
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @recipient = params[:recipient] ? User.find(params[:recipient]) : nil
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to users_path, flash: { success: "Message sent." }
    else
      flash.now[:error] = "Message failed to send."
      render 'new'
    end
  end

private

  def message_params
    params.require(:message).permit(:recipient_id, :recipient_email, :sender_id, :subject, :message)
  end
end
