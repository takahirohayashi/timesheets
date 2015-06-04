class MembersController < ApplicationController
  attr_accessor :name, :email

  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    # 空のインスタンスを作る
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      sign_in @member
      flash[:success] = "メンバー登録しました！"
      redirect_to @member
    else
      render 'new'
    end
  end

  def updadte
  end

  def destroy
  end

  private

    def member_params
      params.require(:member).permit(:name, :email, :password, :password_confirmation, :image, :image_cache, :remove_image)
    end
end
