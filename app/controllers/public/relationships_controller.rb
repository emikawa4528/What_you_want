class Public::RelationshipsController < ApplicationController
  before_action :authenticate_member!
  def create
    @member = Member.find(params[:member_id])
    current_member.follow(@member)
    #通知の作成
	  @member.create_notification_follow!(current_member)
		redirect_to request.referer
  end

  def destroy
    member = Member.find(params[:member_id])
    current_member.unfollow(member)
		redirect_to request.referer
  end

  def followings
    member = Member.find(params[:member_id])
    @members = member.followings.page(params[:page]).per(15)
    @member = Member.find(params[:member_id])
  end

  def followers
    member = Member.find(params[:member_id])
    @members = member.followers.page(params[:page]).per(15)
    @member = Member.find(params[:member_id])
  end
end
