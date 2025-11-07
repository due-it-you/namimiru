module ApplicationHelper
  def default_meta_tags
    {
      site: "ナミミル | 双極症の方のための記録・自己理解アプリ",
      charset: "utf-8",
      description: "気分の波を記録し、双極症の波に合わせた自分だけの生活リズムを見つけられます。また、記録した波を家族や友人と共有することも出来ます。",
      keywords: "双極症,双極性障害,躁鬱,記録アプリ",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("namimiru_logo_ogp.png"), # 配置するパスやファイル名によって変更する
        local: "ja-JP",
      },
      twitter: {
        card: "summary_large_image", # Twitterで表示する場合は大きいカードに変更
        site: "@namimiru_app", # アプリの公式Twitterアカウントがあれば、アカウント名を記載
        image: image_url("namimiru_logo_ogp.png"), # 配置するパスやファイル名によって変更
      }
    }
  end
end
