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
    has_many :log_entries, dependent: :destroy
    after_create :create_default_statistic

    def update_statistics
        total_xp = 0
        total_time = 0
        level = 1

        log_entries.each do |log_entry|
            total_xp += calculate_xp(log_entry)
            total_time += calculate_time(log_entry)
        end

        statistic.update(time_active: total_time)

        current_level = statistic.level
        previous_level_threshold, current_level_threshold = calculate_level_threshold(current_level)

        if total_xp >= current_level_threshold
            statistic.update(xp: total_xp, level: current_level + 1)
        elsif total_xp >= previous_level_threshold
            statistic.update(xp: total_xp)
        else
            statistic.update(xp: total_xp, level: [current_level - 1, 1].max)
        end
  end

       
    end

    private

    def create_default_statistic
    Statistic.create(user: self, xp: 0, level: 1, time_active: 0)
    end

    def calculate_xp(log_entry)
        if log_entry.characters.present?
          log_entry.characters * 1
        elsif log_entry.lines.present?
          log_entry.lines * 50
        else
          log_entry.time * 250
        end
    end

    def calculate_time(log_entry)
        log_entry.time
    end

    def calculate_level_threshold(level)
        exponent = 1.5
        base_xp = 1000
    
        current_level_threshold = (base_xp * level**exponent).floor
        previous_level_threshold = (base_xp * (level - 1)**exponent).floor
    
        [previous_level_threshold, current_level_threshold]
      end

    



