class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_digest

  validates :email, presence: true,
    length: {minium: Settings.min_email, maximum: Settings.max_email},
    format: {with: Settings.email_regex}, uniqueness: {case_sensitive: false}

  validates :name, presence: true, length: {maximum: Settings.max_name}

  has_secure_password

  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true

  attr_accessor :remember_token, :activation_token

  scope :latest_users, -> {order created_at: :desc}

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
