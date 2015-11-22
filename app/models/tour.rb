class Tour < ActiveRecord::Base

  validates_presence_of :name

  belongs_to :user
  belongs_to :company
  has_many :tour_entries, dependent: :destroy

  scope :since, -> (since) { since.present? ? where('updated_at > ?', since.to_datetime) : all }

  def self.options_for_select(current_ability)
    accessible_by(current_ability).pluck(:name, :id)
  end

  def to_s
    name
  end

  def self.to_csv(current_ability)
    require 'csv'
    CSV.generate do |csv|
      csv << [:name, :user, :active, :started, :completed, :created_at, :updated_at]

      accessible_by(current_ability).each do |tour|
        csv << [tour.name, tour.user.try(:login), tour.active, tour.started,
          tour.completed, tour.created_at.strftime('%Y-%m-%d %H:%M:%S'), tour.updated_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end
end
