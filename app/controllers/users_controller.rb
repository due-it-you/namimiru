require "net/http"
require "uri"

class UsersController < ApplicationController
  def new
  end

  def create
    # IDトークンの検証 / UIDの取得
    id_token = user_params[:id_token]
    role = user_params[:role]
    channel_id = ENV["LINE_LIFF_CHANNEL_ID"]
    res = Net::HTTP.post_form(URI.parse("https://api.line.me/oauth2/v2.1/verify"), { "id_token" => id_token, "client_id" => channel_id })
    result = JSON.parse(res.body)
    uid = result["sub"]

    if User.find_by(line_user_id: uid)
      return render json: { status: "error", message: "このLINEアカウントはすでに登録されています。" }
    end

    user = User.new({ line_user_id: uid, role: role })
    if user.save
      render json: { status: "ok" }
    else
      render json: { status: "error", message: "保存処理に失敗しました。" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:id_token, :role)
  end
end
