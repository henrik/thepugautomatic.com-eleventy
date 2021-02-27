// Remove certain third-party service ads.
setInterval(function() {
  var adFrame = document.querySelector("iframe[src*=ads-iframe]");
  adFrame && adFrame.remove()
}, 5000);
