module ChartsHelper
  def daily_record_x_share_url(latest_record)
    text = <<~TEXT
      【#{mood_display(latest_record.mood_score)}】

      今日の記録が出来ました！
    TEXT
    "https://twitter.com/share?text=#{CGI.escape(text)}&url=https://namimiru.com"
  end
end
