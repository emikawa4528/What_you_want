class Public::HomesController < ApplicationController
  def top
  end

  def about
  end

  def guest_sign_in
    member = Member.guest
    sign_in member   # 会員をログインさせる
    flash[:notice] = "ゲストユーザーとしてログインしました。"
    redirect_to member_path(member)
  end
end
