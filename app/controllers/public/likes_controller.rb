class Public::LikesController < ApplicationController
  before_action :authenticate_member!
  def create
    @idea = Idea.find(params[:idea_id])
    @like = current_member.likes.new(idea_id: @idea.id)
    @like.save
    # 通知の作成
    @idea.create_notification_like!(current_member)
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
  end

  def destroy
    @idea = Idea.find(params[:idea_id])
    like = current_member.likes.find_by(idea_id: @idea.id)
    like.destroy
  end
  end
end  
