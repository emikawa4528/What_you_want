class Public::IdeasController < ApplicationController
  before_action :authenticate_member!
  def new
    @idea = Idea.new
  end

  def create
    idea = Idea.new(idea_params)
    idea.member_id = current_member.id
    if idea.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to ideas_path
    else
      @idea = Idea.new
      flash[:danger] = "タイトルは2～30字で入力してください。"
      render "new"
    end
  end

  def index
    @today = Date.today  # 今日の日付を取得
    @now = Time.now      # 現在時刻を取得
    if params[:old]
      @ideas = Idea.old.page(params[:page]).per(15)                          # 古い順
    elsif params[:week_likes]
      ideas = Idea.week_likes
      @ideas =  Kaminari.paginate_array(ideas).page(params[:page]).per(15)   # 過去1週間のいいね数順に表示される
    else
      @ideas = Idea.latest.page(params[:page]).per(15)                       # 新着順
    end
  end

  def show
    @today = Date.today  # 今日の日付を取得
    @now = Time.now      # 現在時刻を取得
    @idea = Idea.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @idea = Idea.find(params[:id])
    if @idea.member == current_member
      render :edit
    else
      redirect_to member_path(current_member)
    end
  end

  def update
    @idea = Idea.find(params[:id])
    # 添付画像を個別に削除
    if params[:idea][:idea_image_ids]
      params[:idea][:idea_image_ids].each do |idea_image_id|
        idea_image = @idea.idea_images.find(idea_image_id)
        idea_image.purge
      end
    end
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea, notice: "投稿を編集しました。" }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    idea = Idea.find(params[:id])
    idea.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to ideas_path
  end

  def likes
    idea = Idea.find(params[:id])
    @like_members = idea.like_members
  end

  private

  def idea_params
    params.require(:idea).permit(:title, :body, idea_images: [])
  end
end
