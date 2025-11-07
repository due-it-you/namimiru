module ChartsHelper
  def daily_record_x_share_url(latest_record)
    text = <<~TEXT
      【#{mood_display(latest_record.mood_score)}】

      ナミミルで今日の記録が出来ました！
      合計記録: #{latest_record.user.daily_records.count}回達成
    TEXT
    "https://twitter.com/intent/tweet?text=#{CGI.escape(text)}&url=https://namimiru.com&hashtags=双極症,ナミミル"
  end
end
