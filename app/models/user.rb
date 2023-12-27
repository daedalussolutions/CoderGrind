class User < ApplicationRecord
    has_secure_password

    validates :username, presence: true

    validates :email, presence: true
    normalizes :email, with: -> email { email.downcase.strip }

    generates_token_for :password_reset, expires_in: 15.minutes do
        password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
        email
    end

    has_one :statistic, dependent: :destroy
    after_create :create_default_statistic

    private

    def create_default_statistic
    Statistic.create(user: self, xp: 0, level: 1, time_active: 0)
    end
end
