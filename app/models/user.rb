# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  fullname        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :fullname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :stories,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: 'Story'

  has_many :responses,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: 'Response'

  has_many :follows

  has_many :follower_relationships, foreign_key: :followee_id, dependent: :destroy, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, dependent: :destroy, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  def follow(user)
    followers << user
  end

  def unfollow(user)
    followers.delete(user)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
