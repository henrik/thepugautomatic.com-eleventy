// Remove certain third-party service ads.
if (window.removeAds) {
  var adInt = setInterval(function() {
    var adFrame = document.querySelector("iframe[src*=ads-iframe]");

    if (adFrame) {
      adFrame.remove();
      clearInterval(adInt);
    }
  }, 500);
}
