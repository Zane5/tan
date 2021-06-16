# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  is_public              :boolean
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :first_name, presence: true
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "must be a valid email address."
  }
  # validates :must_not_be_underage
  # validates :hashed_password

  has_many :posts

  has_many :bonds

  has_many :followings,
           -> { Bond.following },
           through: :bonds,
           source: :friend

  has_many :follow_requests,
           -> { Bond.requesting },
           through: :bonds,
           source: :friend

  has_many :inward_bonds,
           class_name: "Bond",
           foreign_key: :friend_id

  has_many :followers,
           -> { Bond.following },
           through: :inward_bonds,
           source: :user

  # def must_not_be_underage
  #   age = birthday.year - Time.current.year
  #   return if age < 18

  #   errors.add(:base, "must be at least 17 years old")
  # end

  # def password_never_be_used_before
  #   reutrn if PastPassword.where(
  #     user: self,
  #     hashed_password: Digest::MD5.hexdigest(password)
  #   ).blank?

  #   errors.add(:password, "must be a new password")
  # end

  before_save :ensure_proper_name_case

  private

  def ensure_proper_name_case
    self.first_name = first_name.capitalize
  end
end
