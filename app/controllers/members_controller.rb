class MembersController < ApplicationController
  before_action :signed_in_member
  before_action :correct_member, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # paginateは、キーが:pageで値がリクエストページに等しいハッシュ引数を取る必要があります。
    # Member.paginateは、:pageパラメーターに基いて、データベースからひとかたまりのデータ (デフォルトでは30)
    # を取り出します。従って、1ページ目は1から30のユーザー、2ページ目は31から60のユーザーという具合に
    # データが取り出されます。ページがnilの場合、 paginateは単に最初のページを返します。
    # ここで:pageパラメーターにはparams[:page]が使用されていますが、
    # これはwill_paginateによって自動的に生成されます。
    # http://localhost:3000/members にアクセスした時はnilで、最初のページになるのかな。
    # その後はページをクリックするたびにwill_paginateでparams[:page]を生成するという事。たぶん。
    @members = Member.paginate(page: params[:page])
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    # 空のインスタンスを作る
    @member = Member.new
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

  def edit
  end

  def update
    if @member.update_attributes(member_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @member
    else
      render 'edit'
    end
  end

  def destroy
    # findメソッドとdestroyメソッドを1行で書くために2つのメソッドを連結 (chain) しています。
    Member.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to members_url
  end

  private

    # 編集してもよい属性だけを許可するように処理されたパラメータを渡すことが重要になります。
    # Strong Parametersを使用してこれを行います。
    # 具体的には、以下のようにparamsハッシュに対してrequireとpermitを呼び出します。
    # 許可された属性リストにadminが含まれていないことに注目してください。
    # これにより、任意のユーザーが自分自身にアプリケーションの管理者権限を与えることを防止できます。
    def member_params
      params.require(:member).permit(:name, :email, :password, :password_confirmation, :image, :image_cache, :remove_image)
    end

    def signed_in_member
      unless signed_in?
        store_location # sessions_helperのメソッド。sessionインスタンスに:return_toというキーでリクエストしたURLを保存
        redirect_to signin_url, notice: "サインインしてください"
      end
    end

    def correct_member
      @member = Member.find(params[:id])
      redirect_to(root_path) unless current_member?(@member)
    end

    # destroyアクションから管理者へのアクセスを制限する
    def admin_user
      redirect_to(root_path) unless current_member.administrator?
    end
end
