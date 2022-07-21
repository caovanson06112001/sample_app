class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true,
    length: {minium: Settings.min_email, maximum: Settings.max_email},
    format: {with: Settings.email_regex}, uniqueness: {case_sensitive: false}

  validates :name, presence: true, length: {maximum: Settings.max_name}

  has_secure_password

  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true

  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
