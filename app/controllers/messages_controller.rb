class MessagesController < ApplicationController

  def index
    @received_messages = current_user.received_messages.where(
      removed_by_recipient: false
    ).paginate( page: params[:received_messages_page])

    @sent_messages = current_user.sent_messages.where(
      removed_by_sender: false
    ).paginate(page: params[:sent_messages_page])

    @active_tab = session.delete(:active_tab) ||  params.delete(:active_tab) || "received"
    prep_new_message
  end

  def show
    @message = Message.find(params[:id])
    unless @message.valid_user(current_user)
      flash[:error] = "Invalid message."
      redirect_to users_path
    end
  end

  def new
    prep_new_message
  end

  def create
    @message = Message.new(message_params)
    return_to = session.delete(:return_to)
    if @message.save
      session[:active_tab] = 'sent'
      flash[:success] = "Message sent."
      track_activity @message, [@message.recipient, @message.sender]
      redirect_to messages_path
    else
      session[:message] = message_params
      session[:active_tab] = 'new'
      flash[:error] = "Message failed to send."
      redirect_to :back
    end
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
    params.require(:message).permit(:recipient_identifier, :sender_id, :subject, :message)
  end

  def prep_new_message
    if session[:message]
      @message = Message.new(session.delete(:message))
    elsif params[:recipient]
      recipient = User.find(params.delete(:recipient)).username
      @message = Message.new(recipient_identifier: recipient)
    else
      @message = Message.new
    end
  end
end
