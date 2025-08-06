class UsersController < ApplicationController
  def new
  end

  def create
    # IDトークンの検証 / UIDの取得
    id_token = params[:id_token]

    uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/x-www-form-urlencoded"
    req.set_form_data({ "id_token" => id_token, "client_id" => ENV["LINE_LIFF_CHANNEL_ID"] })
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    res = http.start { |http| http.request(req) }
    result = JSON.parse(res.body)
    uid = result["sub"]
  end

  private

  def user_params
    params.require(:user).permit(:id_token, :role)
  end
end
