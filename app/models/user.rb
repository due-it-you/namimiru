class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :timeoutable,
    :omniauthable, :recoverable, omniauth_providers: %i[google_oauth2]

  has_many :daily_records, dependent: :destroy
  has_many :action_items, dependent: :destroy
  has_many :social_profiles, dependent: :destroy
  # 自己結合の多対多の関連付け
  has_many :being_supported_relationships, class_name: "CareRelation", foreign_key: :supported_id, dependent: :destroy
  has_many :supporting_relationships, class_name: "CareRelation", foreign_key: :supporter_id, dependent: :destroy
  has_many :supporters, through: :being_supported_relationships, source: :supporter
  has_many :supportings, through: :supporting_relationships, source: :supported
  has_many :action_tags, dependent: :destroy

  attr_accessor :social_login

  INVITATION_EXPIRATION_MINUTES = 15.minutes.freeze

  validates :name, presence: { message: "を入力してください。" },
    length: { maximum: 12, message: "は12文字以内にしてください。" },
    unless: :social_login?,
    on: :create
  validates :email, presence: { message: "を入力してください。" },
    uniqueness: { message: "は既に登録されています。" },
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
  validates :invitation_token, format: { with: /\A[A-Za-z0-9]{12}\Z/ }, on: :invitation
  validates :invitee_role, inclusion: { in: [ "supported", "supporter" ], message: "を選択してください。" }, on: :invitation

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
        user.social_login = false
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

  def generate_unique_invitation_token
    loop do
      token = SecureRandom.alphanumeric(12)
      break token unless User.exists?(invitation_token: token)
    end
  end

  def absent_from_the_care_relation?(care_relation)
    # アクセスしようとしている連携情報にアクセス者のidがあるかどうかの判定
    care_relation.supported != self && care_relation.supporter != self
  end

  def get_action_item_lists_by(mood_score, selected_tag_name)
    latest_mood_score = self.daily_records.order(created_at: :desc).first&.mood_score
    action_items_with_tag = self.action_items.includes(:action_tag)
    if selected_tag_name.present?
      # 選択されたタグの項目だけを絞り込み
      selected_tag = self.action_tags.find_by(name: selected_tag_name)
      current_can_items, current_cannot_items = selected_tag.action_items.dynamic.capable(mood_score),  selected_tag.action_items.dynamic.incapable(mood_score)
      latest_can_items, latest_cannot_items = selected_tag.action_items.dynamic.capable(latest_mood_score), selected_tag.action_items.dynamic.incapable(latest_mood_score)
      avoid_items = selected_tag.action_items.avoid
    else
      # タグが選択されていない場合、全選択
      current_can_items, current_cannot_items = action_items_with_tag.dynamic.capable(mood_score),  action_items_with_tag.dynamic.incapable(mood_score)
      latest_can_items, latest_cannot_items = action_items_with_tag.dynamic.capable(latest_mood_score), action_items_with_tag.dynamic.incapable(latest_mood_score)
      avoid_items = action_items_with_tag.avoid
    end

    # 最新の記録の気分のリストと比べての項目の差分
    diff_can_items = current_can_items - latest_can_items
    not_diff_can_items = current_can_items - diff_can_items
    diff_cannot_items = current_cannot_items - latest_cannot_items
    not_diff_cannot_items = current_cannot_items - diff_cannot_items

    # やらない方がいいリストの項目
    avoid_groups = avoid_items.group_by(&:action_tag)

    # できるかも/できないかもリストの差分と非差分の項目
    diff_can_groups, not_diff_can_groups = diff_can_items.group_by(&:action_tag), not_diff_can_items.group_by(&:action_tag)
    diff_cannot_groups, not_diff_cannot_groups = diff_cannot_items.group_by(&:action_tag), not_diff_cannot_items.group_by(&:action_tag)

    groups = {
        diff_can_groups: diff_can_groups,
        not_diff_can_groups: not_diff_can_groups,
        diff_cannot_groups: diff_cannot_groups,
        not_diff_cannot_groups: not_diff_cannot_groups,
        avoid_groups: avoid_groups
      }

    groups
  end
end
