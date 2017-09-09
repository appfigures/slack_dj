class Playlist < ApplicationRecord

  has_many :videos, dependent: :destroy
  belongs_to :team, optional: true

  def next_video
    videos.unplayed.oldest_first.limit(1).take
  end

  def add_video!(attr={})
    videos.create!(attr)
  end

  def any_unplayed?
    videos.unplayed.any?
  end

  def all_played?
    videos.unplayed.none?
  end

  def last_played(amount=20)
    videos.played.order(played_at: :desc).limit(amount)
  end

  def queued(amount=5)
    videos.unplayed.order(created_at: :asc).limit(amount)
  end

  def queue_length
      videos.unplayed.count
  end
end