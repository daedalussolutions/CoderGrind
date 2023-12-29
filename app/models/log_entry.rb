class LogEntry < ApplicationRecord
    belongs_to :user

    validates :title, length: { maximum: 180 }, presence: true
    validates :project, length: { maximum: 50 }, allow_blank: true
    validates :time, presence: true
    validates :lines, length: { maximum: 20 }, allow_blank: true
    validates :characters, length: { maximum: 20 }, allow_blank: true
    validates :language, presence: true
    validates :framework, length: { maximum: 20 }, allow_blank: true
    validates :contributions, length: { maximum: 20 }, allow_blank: true
end
