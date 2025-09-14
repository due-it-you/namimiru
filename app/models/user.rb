class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  validates :name, presence: { message: 'を入力してください。' }, length: { maximum: 12, message: "は12文字以内にしてください。" }
  validates :email, presence: { message: 'を入力してください。' }, format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/, message: "の形式を満たしてください。" }
  validates :password, presence: { message: 'を入力してください。' }, confirmation: true, length: { 
    in: 8..72,
    too_short: "は8文字以上にしてください。",
    too_long: "は72文字以下にしてください。"
  },
    format: {
      # 少なくとも1つ 英字小文字, 大文字, 数字 が含まれる
      with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[!-~]+\z/,
      message: "は、英字小文字・英字大文字・数字がそれぞれ1つ以上含まれるようにしてください。"
    }
end
