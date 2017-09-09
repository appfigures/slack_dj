# Expects a youtube url to a video. Uses the url
# to hit youtube api to find the video's title
# and then adds it to the playlist.

require 'uri'
require 'cgi'

class PlayVideo
  include Interactor

  # Expects:
  # team
  # user
  # dj
  # playlist
  # command e.g. "find http://youtube.com?watch=....."
  #
  def call
    if url.valid? and video.present?
      context.playlist.add_video!(
        title: video.title,
        url: url.to_s,
        user: context.user
      )

      context.dj.new_video_added!

      ql = context.playlist.queue_length
      position = "<#{url}|Video> will play next"

      if ql > 1
        position = "<#{url}|Video> has been queued! There are #{ql} videos ahead"
      end if

      context.message = position
    else
      context.fail!
      context.errors = "That doesn't look like a valid youtube url. "
    end
  end

  def self.match?(command)
    command =~ /^play/
  end

  private

  def extract_url
    urls = URI.extract(context.command)
    YouTubeUrl.new(urls.first || "")
  end

  def fetch_video
    @video = Yt::Video.new(url:  url.to_s)
  end

  def url
    @url ||= extract_url
  end

  def video
    @video ||= fetch_video
  end
end