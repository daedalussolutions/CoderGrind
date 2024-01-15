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
        streak = 0

        log_entries.each do |log_entry|
            total_xp += calculate_xp(log_entry)
            total_time += calculate_time(log_entry)
        end

        statistic.update(time_active: total_time)

        statistic.update(streak: daily_streak)

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

    def leveling_progress
        current_xp = statistic.xp
        current_level, next_level = calculate_level_threshold(statistic.level)

        total_xp_needed = next_level - current_level
        xp_progress = current_xp - current_level

        result = (xp_progress.to_f / total_xp_needed * 100).clamp(0, 100).round(0)

        result
    end

    def xp_toward_next_level
        current_xp = statistic.xp
        current_level, next_level = calculate_level_threshold(statistic.level)
    
        xp_toward_next_level = [current_xp - current_level, 0].max
        xp_toward_next_level
    end
    
    def xp_needed_for_next_level
        current_level, next_level = calculate_level_threshold(statistic.level)
    
        xp_needed_for_next_level = next_level - current_level
        xp_needed_for_next_level
    end

    def most_used_language
        language_time = Hash.new(0)

        log_entries.each do |log_entry|
            language_time[log_entry.language] += log_entry.time 
        end

        most_used_language = language_time.max_by {|_language, time| time}

        most_used_language&.first
    end

    def daily_streak
        log_entries_by_date = log_entries.group_by(&:date)
        current_date = Date.current
        streak = statistic.streak

        if !log_entries_by_date[current_date.day - 1].present?
            streak = 0
        end

        while log_entries_by_date[current_date].present?
            streak += 1
            current_date -= 1.day 
        end
        streak
    end

    private

    def create_default_statistic
    Statistic.create(user: self, xp: 0, level: 1, time_active: 0)
    end

    def calculate_xp(log_entry)
        xp_earned = log_entry.time * 250

        if log_entry.characters.present?
          xp_earned += log_entry.characters * 1
        elsif log_entry.lines.present?
          xp_earned += log_entry.lines * 20
        end

        xp_earned
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
end