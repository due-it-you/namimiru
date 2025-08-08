require "net/http"
require "uri"

class UidSessionsController < ApplicationController
  def create
    id_token = idtoken_params[:id_token]
    channel_id = ENV["LINE_LIFF_CHANNEL_ID"]
    res = Net::HTTP.post_form(URI.parse("https://api.line.me/oauth2/v2.1/verify"), { "id_token" => id_token, "client_id" => channel_id })
    result = JSON.parse(res.body)
    uid = result["sub"]

    if User.find_by(line_user_id: uid)
      render json: { status: "ok" }
    else
      render json: { status: "error" }
    end
  end

  private

  def idtoken_params
    params.require(:uid_session).permit(:id_token)
  end
end
