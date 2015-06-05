class SessionsController < ApplicationController
  def new
  end

  def create
    member = Member.find_by(email: params[:session][:email].downcase)
    if member && member.authenticate(params[:session][:password])
      sign_in member # sessions_helperのsign_inメソッドで@current_memberにmemberインスタンスを設定
      redirect_back_or member # リクエストしたURLがあれば、そこに、なければ、memberだから member_path だから MembersControllerのshowかな。
    else
      flash.now[:error] = "パスワードが違います"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
