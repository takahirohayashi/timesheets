module SessionsHelper

  # remember_tokenを作成 ⇒ remember_token変数に入れる
  # 永続化クッキー(cookies.permanent;有効期間が20年に設定されたクッキー)を設定する。
  # cookies.permanent[クッキー名] = 値 :remember_tokenという名前で設定。クッキー側には非暗号化して保存。
  # 該当レコードのremember_tokenのカラムを暗号化したremember_tokenでアップデート。
  # 下にあるcurrent_member=(member)メソッドに該当レコードを引数として渡して、インスタンス変数@current_memberに代入する。
  # サインインの処理としてまとめると、
  # ①remeber_token生成
  # ②クッキーに暗号化せずにそれを保存
  # ③該当ユーザのレコードのremember_tokenを暗号化したヤツでアップデート
  # ④インスタンス変数@current_memberに引数でもらったMemberインスタンスを設定
  def sign_in(member)
    remember_token = Member.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    member.update_attribute(:remember_token, Member.encrypt(remember_token))
    self.current_member = member
  end

  def signed_in?
    !current_member.nil?
  end

  def current_member=(member)
    @current_member = member
  end

  # ブラウザからクッキーのトークンを受け取り、暗号化する。
  # 暗号化したトークンをキーにDBからメンバーを検索
  # ヒットしたら、@current_memberに該当レコードを入れる
  # ヒットしない場合は、nilかな。
  def current_member
    remember_token = Member.encrypt(cookies[:remember_token])
    @current_member ||= Member.find_by(remember_token: remember_token)
  end

  # コントローラから params[:id] で DBからユーザレコードを取得(これが引数)
  # 上の current_member メソッド で クッキーベースで取得したユーザと比較
  # マッチしたら true
  # アンマッチは false
  def current_member?(member)
    member == current_member
  end

  def sign_out
    self.current_member = nil
    cookies.delete(:remember_token)
  end

  ######## フレンドリーフォワーディング ########

  # リダイレクト先を保存するメカニズムは、Railsが提供するsession機能を使用しています。
  # ブラウザを閉じたときに自動的に破棄されるcookies変数のインスタンスと同様のもの。

  # 下のメソッドでセットしたsessionインスタンスのキー:return_toを見て
  # nilじゃない場合(リクエストされたURLが存在する場合)はそこにリダイレクトし、
  # ない場合は何らかのデフォルトのURLにリダイレクトします。
  # nilであれば与えられたデフォルトのURLを使用します
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to) # 削除
  end

  # requestオブジェクト；リクエストヘッダの情報を取得することができます。
  # リクエストされたURLを:return_toというキーでsession変数に保存しています。
  # Rails4では、デフォルトでセッション情報はブラウザのクッキーに保存されます。
  # そして、コントローラーでsessionインスタンスを使うことで、
  # セッションに値を設定/取得といったアクセスができます。
  def store_location
    session[:return_to] = request.url
  end
end
