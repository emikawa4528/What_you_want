class Idea < ApplicationRecord
  belongs_to :member
  has_many :likes, dependent: :destroy
  has_many :like_members, through: :likes, source: :member
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :title, length: { minimum: 2, maximum: 30 }, presence: true
  has_many_attached :idea_images

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  # 過去1週間のいいね数順に表示される
  to = Time.current.at_end_of_day
  from = (to - 6.day).at_beginning_of_day
  scope :week_likes, -> {includes(:member).sort {|a,b| b.likes.where(created_at: from...to).size <=> a.likes.where(created_at: from...to).size}}

  def liked_by?(member)
    likes.exists?(member_id: member.id)
  end

  def self.looks(search, word)
    @idea = Idea.where("title LIKE?","%#{word}%")  #部分一致のみ
  end

  def create_notification_like!(current_member)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and idea_id = ? and action = ? ", current_member.id, member_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_member.active_notifications.new(
        idea_id: id,
        visited_id: member_id,
        action: 'like'
      )
      # データが有効のときはtrueを返す
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_member, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    # distinctメソッドは重複レコードを1つにまとめるためのメソッド
    temp_ids = Comment.select(:member_id).where(idea_id: id).where.not(member_id: current_member.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_member, comment_id, temp_id["member_id"])
    end
    # まだ誰もコメントしていない場合、投稿者に通知を送る
    save_notification_comment!(current_member, comment_id, member_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_member, comment_id, visited_id)
    # コメントは複数回することもある
    notification = current_member.active_notifications.new(
      idea_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
