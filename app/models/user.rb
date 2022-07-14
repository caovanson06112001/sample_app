class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :downcase_email

  validates :email, presence: true, length: {minium: 10, maximum: 40},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :name, presence: true, length: {maximum: 10}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
