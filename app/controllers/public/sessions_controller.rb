# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_deleted_member, only: :create
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  def after_sign_in_path_for(resource)
    member_path(current_member)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # 退会しているかを判断するメソッド
  def reject_deleted_member
    ## 【処理内容1】 入力されたemailからアカウントを1件取得
    @member = Member.find_by(email: params[:member][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@member
    ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるか、かつ、退会ステータスがtrueであるか
    if @member.valid_password?(params[:member][:password]) && (@member.is_deleted == true)
      ##  上が真であるとき、新規会員登録画面に遷移する
      flash[:withdraw] = "お客様は退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。"
      redirect_to new_member_session_path
    end
  end

  def guest_sign_in
    member = Member.guest
    sign_in member   # 会員をログインさせる
    flash[:notice] = "ゲストユーザーとしてログインしました。"
    redirect_to member_path(member)
  end
end
