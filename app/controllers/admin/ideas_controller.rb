class Admin::IdeasController < ApplicationController
  before_action :authenticate_admin!
  def index
    @today = Date.today  # 今日の日付を取得
    @now = Time.now      # 現在時刻を取得
    if params[:old]
      @ideas = Idea.old.page(params[:page]).per(15)                          # 古い順
    elsif params[:week_likes]
      ideas = Idea.week_likes
      @ideas =  Kaminari.paginate_array(posts).page(params[:page]).per(15)   # 過去1週間のいいね数順に表示される
    else
      @ideas = Idea.latest.page(params[:page]).per(15)                       # 新着順
    end
  end

  def show
    @today = Date.today #今日の日付を取得
    @now = Time.now     #現在時刻を取得
    @idea = Idea.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    idea = Idea.find(params[:id])
    idea.destroy
    redirect_to admin_ideas_path
  end
  
end
