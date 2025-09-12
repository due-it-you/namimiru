class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  validates :email, presence: true, format: { with: /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/}
  validates :password, presence: true, confirmation: true, length: { in: 8..72 }, 
    format: {
      # 少なくとも1つ 英字小文字, 大文字, 数字 が含まれる / 合計で8文字以上
      with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[!-~]{8,}+\z/,
      message: 'は8文字以上で、大文字・小文字・数字を含めて入力してください。'
    }
end
