class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :timeoutable,
    :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :daily_records, dependent: :destroy
  has_many :social_profiles, dependent: :destroy
  # 自己結合の多対多の関連付け
  has_many :being_supported_relationships, class_name: "CareRelation", foreign_key: :supported_id, dependent: :destroy
  has_many :supporting_relationships, class_name: "CareRelation", foreign_key: :supporter_id, dependent: :destroy
  has_many :supporters, through: :being_supported_relationships, source: :supporter
  has_many :supportings, through: :supporting_relationships, source: :supported

  attr_accessor :social_login

  INVITATION_EXPIRATION_MINUTES = 15.minutes.freeze

  validates :name, presence: { message: "を入力してください。" },
    length: { maximum: 12, message: "は12文字以内にしてください。" },
    unless: :social_login?,
    on: :create
  validates :email, presence: { message: "を入力してください。" },
    format: {
      with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/,
      message: "の形式を満たしてください。"
    },
    unless: :social_login?,
    on: :create
  validates :password, presence: { message: "を入力してください。" }, confirmation: true,
    length: {
      in: 8..72,
      too_short: "は8文字以上にしてください。",
      too_long: "は72文字以下にしてください。"
    },
    format: {
      # 少なくとも1つ 英字小文字, 大文字, 数字 が含まれる
      with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[!-~]+\z/,
      message: "は、英字小文字・英字大文字・数字がそれぞれ1つ以上含まれるようにしてください。"
    },
    unless: :social_login?,
    on: :create
  validates :invitation_token, format: { with: /\A[A-Za-z0-9]{12}\Z/ }, on: :update
  validates :invitee_role, presence: true, inclusion: { in: [ "supported", "supporter" ], message: "を選択してください。" }, on: :update

  def already_recorded_today?
    daily_records.where(created_at: Date.today.all_day).exists?
  end

  def self.from_google_oauth(auth)
    social_profile = SocialProfile.find_by(provider: auth.provider, uid: auth.uid)

    if social_profile.present?
      user = social_profile.user
    else
      transaction do
        user = User.new(name: auth.info.name || nil)
        user.social_login = true
        user.save!
        user.social_profiles.create!(provider: auth.provider, uid: auth.uid)
      end
    end
    user
  end

  def social_login?
    social_login
  end

  def self.assign_care_relation_ids(inviter:, invitee:)
    if inviter.invitee_role == "supported"
      [ invitee.id, inviter.id ]
    else
      [ inviter.id, invitee.id ]
    end
  end

  def invitation_token_expired?
    self.invitation_created_at <= INVITATION_EXPIRATION_MINUTES.ago
  end
end
