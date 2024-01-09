class Statistic < ApplicationRecord
    belongs_to :user

    validates :xp, presence: true
    validates :level, presence: true
    validates :time_active, presence: true
    validates :streak, presence: true
end
