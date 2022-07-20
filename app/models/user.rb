class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true, length: {minium: Settings.min_email, maximum: Settings.max_email},
    format: {with: Settings.email_regex}, uniqueness: {case_sensitive: false}

  validates :name, presence: true, length: {maximum: Settings.max_name}

  has_secure_password

  validates :password, presence: true, length: { minimum: Settings.min_pass }, allow_nil: true

  private

  def downcase_email
    email.downcase!
  end
end
