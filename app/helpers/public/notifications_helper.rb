module Public::NotificationsHelper

  def notification_form(notification)
    @visitor = notification.visitor
    @visited = notification.visited
    @comment = nil  # 最初は空にしておく
    @visitor_comment = notification.comment_id
    # notification.actionがfollowかlikeかcommentか
    case notification.action
      when "follow" then
        tag.a(notification.visitor.name, href: member_path(@visitor), style: "font-weight: bold;")+"さんがあなたをフォローしました。"
      when "like" then
        tag.a(notification.visitor.name, href: member_path(@visitor), style: "font-weight: bold;")+"さんが"+tag.a("あなたの投稿", href: post_path(notification.post_id), style: "font-weight: bold;")+"にいいねしました。"
      when "comment" then
        @comment = Comment.find_by(id: @visitor_comment)&.comment
        if notification.post.member_id == @visited.id
          tag.a(@visitor.name, href: member_path(@visitor), style: "font-weight: bold;")+"さんが"+tag.a("あなたの投稿", href: post_path(notification.post_id), style: "font-weight: bold;")+"にコメントしました。"
        else
          tag.a(@visitor.name, href: member_path(@visitor), style: "font-weight: bold;")+"さんが"+tag.a("#{notification.post.member.name}さんの投稿", href: post_path(notification.post_id), style: "font-weight: bold;")+"にコメントしました。"
        end
    end
  end

	def unchecked_notifications
	   @notifications = current_member.passive_notifications.where(checked: false)
	end

end