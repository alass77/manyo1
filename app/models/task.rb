class Task < ApplicationRecord
    belongs_to :user
    validates :title, presence: true
    validates :content, presence: true
    validates :deadline_on, presence: true
    validates :status, presence: true
    validates :priority, presence: true

    enum priority: {
    Faible: 0,
    Moyenne: 1,
    Elevee: 2
    }
    enum status: {
    Non_démarré: 0,
    Démarré: 1,
    Terminé: 2
    }
    scope :sort_deadline_on, -> { order(:deadline_on) }
    scope :sort_priority, -> { order(priority: :desc) }
    scope :sort_created_at, -> { order(created_at: :desc) }

    scope :search_status, -> (status) { where(status: status) }
    scope :search_title, -> (title) { where("title LIKE ?", "%#{title}%") }

end
