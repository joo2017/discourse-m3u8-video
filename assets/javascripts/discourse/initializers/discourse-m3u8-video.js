import { withPluginApi } from "discourse/lib/plugin-api";
import loadScript from "discourse/lib/load-script";

function initializeM3u8Video(api) {
  api.onPageChange(() => {
    const videoElements = document.querySelectorAll('.video-js');
    if (videoElements.length > 0) {
      loadScript("https://vjs.zencdn.net/8.10.0/video.min.js").then(() => {
        videoElements.forEach((element) => {
          videojs(element);
        });
      });
    }
  });
}

export default {
  name: "discourse-m3u8-video",

  initialize() {
    withPluginApi("0.8.31", initializeM3u8Video);
  }
};
