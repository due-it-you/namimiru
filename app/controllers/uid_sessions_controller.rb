require "net/http"
require "uri"

class UidSessionsController < ApplicationController
  def create
    id_token = params[:id_token]

    uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/x-www-form-urlencoded"
    req.set_form_data({ "id_token" => id_token, "client_id" => ENV["LINE_LIFF_CHANNEL_ID"] })
    res = Net::HTTP.new(uri.hostname, uri.port).start { |http| http.request(req) }
    res_json = JSON.parse(res.body)
  end

  private

  def idtoken_params
    params.require(:uid_session).permit(:id_token)
  end
end
