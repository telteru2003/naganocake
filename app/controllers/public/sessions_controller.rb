# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  # before_actionを設定しpublic/sessions_controllerのcreateアクションが実行される前に確認を行う
  before_action :reject_customer, only: [:create] # create アクションが実行される前に行わないといけない処理

  protected

  def reject_customer
      # find by => ID をもとに検索を行う find メソッドに対し、ID 以外のカラムからも検索を行い該当する1件を取得するメソッド
        # 今回の場合は、Customer モデルから入力された email を検索し、該当する 1 件を取得する用途で使用
      # downcase => 与えられた文字列を小文字に変換するRubyプログラム
        # これにより、データベース内のすべてのメールアドレスが同じ形式で保存されている必要がなくなり、検索の一貫性が確保される
    @customer = Customer.find_by(email: params[:customer][:email].downcase) # ログイン画面から送られたemailを確認し、Customerモデルに該当するemailのアカウントが存在するかを検索する
    if @customer
      # 「1」のアカウントが存在している場合、そのアカウントのパスワードとログイン画面で入力されたパスワードが一致しているかを確認する
      # 「1」と「2」の処理が真(true)だった場合、そのアカウントのis_deletedカラムに格納されている値を確認する
        # trueだった場合、退会しているのでサインアップ画面に遷移する
        # falseだった場合、退会していないのでそのままcreateアクションを実行させる処理を実行する

      # valid_password? => 特定のアカウントのパスワードと入力されたパスワードが一致しているかを確認するためのDevise が用意しているメソッド
        # 今回の場合は、find_by メソッドで特定したアカウントのパスワードとログイン画面で入力されたパスワードが一致しているかを確認する用途で使用
          # 特定したアカウントのパスワードと、ログイン画面で入力されたパスワードが一致しているかを確認できる
      # active_for_authentication? => 顧客のアカウントが有効か無効かをチェックするために使用するメソッド
        # もしアカウントが無効な場合は、active_for_authentication?はfalseを返す
      # && => 論理演算子のAND
        # 条件式の2つの部分がともにtrueの場合に全体の条件式をtrueと評価
          # 1つ目の条件（パスワードが一致するか）と2つ目の条件（アカウントが無効であるか）がともにtrueである場合、全体の条件式がtrueになる
      # 「&& (@customer.active_for_authentication? == false)」の役割は、顧客のパスワードが正しく、かつアカウントが無効である場合に条件を満たすということ
      if (@customer.valid_password?(params[:customer][:password]) && (@customer.active_for_authentication? == false))
      # is_deletedの値が
        # trueだった場合、サインアップ画面に遷移する処理を実行する
        # falseだった場合、createアクションを実行させる
        　# falseの場合は何も処理をせず、trueの場合のみサインアップ画面にリダイレクトするという処理が必要になる
        flash[:alert] = "このアカウントは退会済みです。"
        redirect_to new_customer_session_path
      end
    else
      flash[:alert] = "必須項目を入力してください"
    end
  end
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


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
