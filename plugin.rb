# name: discourse-m3u8-video
# about: Adds support for m3u8 video links in Discourse
# version: 0.1
# authors: Your Name
# url: https://github.com/yourusername/discourse-m3u8-video

enabled_site_setting :discourse_m3u8_video_enabled

register_asset 'stylesheets/discourse-m3u8-video.scss'

after_initialize do
  module ::DiscourseMp3u8Video
    class Engine < ::Rails::Engine
      engine_name "discourse_m3u8_video"
      isolate_namespace DiscourseMp3u8Video
    end
  end

  require_dependency "onebox/engine/video_onebox"

  class ::Onebox::Engine::VideoOnebox
    alias_method :old_to_html, :to_html

    def to_html
      return old_to_html unless SiteSetting.discourse_m3u8_video_enabled

      if @url.match(%r{.m3u8$})
        random_id = "video_#{SecureRandom.hex(8)}"
        <<-HTML
          <div class="onebox video-onebox videoWrap">
            <video id='#{random_id}' class="video-js vjs-default-skin vjs-16-9" controls preload="auto" width="100%" data-setup='{"fluid": true}'>
              <source src="#{@url}" type="application/x-mpegURL">
            </video>
          </div>
        HTML
      else
        old_to_html
      end
    end
  end
end
