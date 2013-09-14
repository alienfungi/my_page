class MessagesController < ApplicationController

  def index
    @received_messages = current_user.received_messages.where(removed_by_recipient: false).paginate(
      page: params[:received_messages_page], per_page: 10)
    @sent_messages = current_user.sent_messages.where(removed_by_sender: false).paginate(
      page: params[:sent_messages_page], per_page: 10)
    @active_tab = session.delete(:active_tab) ||  params.delete(:active_tab) || "received"
  end

  def show
    @message = Message.find(params[:id])
    unless @message.valid_user(current_user)
      flash[:error] = "Invalid message."
      redirect_to users_path
    end
  end

  def new
    @recipient = params[:recipient] ? User.find(params[:recipient]) : nil
  end

  def create
    @message = Message.new(message_params)
    session[:active_tab] = 'new'
    return_to = session.delete(:return_to)
    if @message.save
      flash[:success] = "Message sent."
    else
      flash[:error] = "Message failed to send."
    end
    redirect_to :back
  end

  def destroy
    begin
      @message = Message.find(params[:id])
      raise unless @message.valid_user(current_user)
      session[:active_tab] = @message.recipient == current_user ? 'received' : 'sent'
      @message.remove_user(current_user)
      flash[:success] = "Message deleted."
    rescue
      flash[:error] = "Record not found."
    end
    redirect_to messages_path
  end

private

  def message_params
    params.require(:message).permit(:recipient_id, :recipient_email, :sender_id, :subject, :message)
  end
end
