class Public::MessagesController < ApplicationController
  before_action :authenticate_member!
  def create
    message = Message.new(message_params)
    message.member_id = current_member.id
    if message.save
      redirect_to room_path(message.room)
    else
      flash[:danger] = "メッセージを送信できませんでした。"
      redirect_back(fallback_location: idea_path) #直前のページにリダイレクト
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to room_path(message.room)
  end

  private

  def message_params
      params.require(:message).permit(:room_id, :message)
  end
end
