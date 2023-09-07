class Admin::MembersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @members = Member.all.page(params[:page]).per(15)
  end

  def show
    @member = Member.find(params[:id])
    @ideas = @member.ideas.page(params[:page]).per(8)
    @today = Date.today #今日の日付を取得
    @now = Time.now     #現在時刻を取得
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    member = Member.find(params[:id])
    member.update(member_params)
    flash[:notice] = "会員情報を更新しました。"
    redirect_to admin_members_path
  end

  private

  def member_params
    params.require(:member).permit(:is_deleted)
  end
end
