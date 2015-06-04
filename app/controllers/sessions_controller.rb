class SessionsController < ApplicationController
  def new
  end

  def create
    member = Member.find_by(email: params[:session][:email].downcase)
    if member && member.authenticate(params[:session][:password])
      sign_in member
      redirect_to member
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
