module ApplicationHelper
  def default_meta_tags
    {
      site: 'ナミミル',
      charset: 'utf-8',
      description: 'ナミミルは、双極性障害の方が気分の波を記録し、日々の変化を可視化して自己理解を深めるためのWebアプリです。記録を通じて自分に合った生活リズムを見つけられます。',
      keywords: '双極性障害,躁鬱,記録アプリ',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
#        image: image_url('top_image.jpg'),# 配置するパスやファイル名によって変更する
        local: 'ja-JP',
      },
#      twitter: {
#        card: 'summary_large_image', # Twitterで表示する場合は大きいカードに変更
#        site: '@あなたのツイッターアカウント', # アプリの公式Twitterアカウントがあれば、アカウント名を記載
#        image: image_url('top_image.jpg'),# 配置するパスやファイル名によって変更
#      }
    }
  end
end
