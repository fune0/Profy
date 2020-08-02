class User < ApplicationRecord
  #accessor
  attr_accessor :group_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,  # :confirmable
  # 認証を行いたいキー
         authentication_keys: [:email, :group_key]

  #association
  belongs_to :group

  #validation
  before_validation :group_key_to_id, if: :has_group_key?

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    group_key = conditions.delete(:group_key)
    group_id = Group.where(key: group_key).first
    email = conditions.delete(:email) || conditions.delete(:unconfirmed_email)

    # devise認証を、emailの他にgroup_idにも対応させる
    if group_id && email
      find_by(group_id: group_id, email: email)
    elsif conditions.has_key?(:confirmation_token)
      where(conditions).first
    elsif email
      where(email: email).first
    else
      false
    end
  end

  private
  def has_group_key?
    group_key.present?
  end

  # 検索条件に合致するレコードが存在する場合にはそのレコードを参照し、無ければ検索条件の内容で新しいレコードを新規保存
  def group_key_to_id
    group = Group.where(key: group_key).first_or_create
    self.group_id = group.id
  end
end
