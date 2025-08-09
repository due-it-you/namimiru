require "net/http"
require "uri"

class LogsController < ApplicationController
  def new
  end

  def create
    # IDトークンの検証 / UIDの取得
    id_token = log_params[:id_token]
    mood_score = log_params[:mood_score]
    channel_id = ENV["LINE_LIFF_CHANNEL_ID"]
    res = Net::HTTP.post_form(URI.parse("https://api.line.me/oauth2/v2.1/verify"), { "id_token" => id_token, "client_id" => channel_id })
    result = JSON.parse(res.body)
    uid = result["sub"]
    logger.info "LINE UID: #{uid.inspect}"
    logger.info "ID Token: #{id_token.inspect}"
    logger.info "Channel ID: #{channel_id.inspect}"

    current_user = User.find_by(line_user_id: uid)
    log = current_user.logs.new(mood_score: mood_score)
    if log.save
      render json: { status: "success", message: "記録の保存に成功しました！" }
    else
      render json: { status: "error" }
    end
  end

  private

  def log_params
    params.require(:log).permit(:id_token, :mood_score)
  end
end
