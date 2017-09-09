# Returns a string formatted table
# of videos thata are queued for
# all users.
#
class ShowQueue
  include Interactor

  class VideoPresenter < SimpleDelegator
    def self.wrap(videos)
      videos.map{ |v| new(v) }
    end

    def self.print(videos)
      wrap(videos).map(&:print).join("\n")
    end

    def print
      user_name = user.name.present? ? user.name : "John Doe"
      video_title = title ? title : "Title unknown"
      video_url = url ? url : "#"

      "#{user_name} - <#{video_url}|#{video_title}>"
    end
  end

  # Expects:
  # team
  # user
  # dj
  # playlist
  # command string
  #
  def call
    context.message = queued_videos_report
  end

  def self.match?(command)
    command =~ /^queue/
  end

  private

  def queued_videos_report
    if queued_videos.any?
      report = "Next up\n"
      report << VideoPresenter.print(queued_videos)
    else
      report = "Queue is empty"
    end
    report
  end

  def queued_videos
    context.playlist.queued(5)
  end
end