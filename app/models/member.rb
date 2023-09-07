class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :ideas, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, presence: true
  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : "no-image.PNG"
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |member|
      member.password = SecureRandom.urlsafe_base64
      member.password_confirmation = member.password
      member.name = "ゲスト"
    end
  end

  def follow(member)
    relationships.create(followed_id: member.id)
  end

  def unfollow(member)
    relationships.find_by(followed_id: member.id).destroy
  end

  def following?(member)
    followings.include?(member)
  end

  def self.looks(search, word)
    @member = Member.where("name LIKE?","%#{word}%")
  end

  def create_notification_follow!(current_member)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_member.id, id, "follow"])
    if temp.blank?
      notification = current_member.active_notifications.new(
        visited_id: id,
        action: "follow"
      )
      notification.save if notification.valid?
    end
  end
end
