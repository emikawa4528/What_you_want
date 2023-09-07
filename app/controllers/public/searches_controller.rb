class Public::SearchesController < ApplicationController
  before_action :authenticate_member!
  def search
    @range = params[:range]
    if @range == "会員を探す"
      @members = Member.looks(params[:search], params[:word]).page(params[:page]).per(8)
    else
      @ideas = Idea.looks(params[:search], params[:word]).page(params[:page]).per(15)
    end
    @today = Date.today #今日の日付を取得
    @now = Time.now     #現在時刻を取得
  end
end
