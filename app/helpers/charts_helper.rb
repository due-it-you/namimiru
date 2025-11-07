module ChartsHelper
  def daily_record_x_share_url(latest_record)
    text = <<~TEXT
      【#{mood_display(latest_record.mood_score)}】

      ナミミルで今日の記録が出来ました！
    TEXT
    "https://twitter.com/intent/tweet?text=#{CGI.escape(text)}&url=https://namimiru.com&hashtags=双極症,双極性障害,ナミミル"
  end
end
