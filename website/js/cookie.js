(function () {

  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag("js", new Date());

  var analytics_activated = false;

  var banner_div = document.querySelector(".alert-cookie");
  var banner_button = document.querySelector(".alert-cookie .button");

  if (banner_button) {
    banner_button.addEventListener("click", function (e) {
      e.preventDefault();
      setupga();
      banner_div.style.display = "none";
    });
  }

  function setupga() {
    if (!analytics_activated) {
      // avoid multiple activations!
      gtag("config", window.env.GOOGLE_ANALYTICS_ID);
      analytics_activated = true;
      document.cookie = "banner=accepted; max-age=" + 60 * 60 * 24 * 365;
    }
  }

  function checkAccepted() {
    try {
      var cookieValue = document.cookie.replace(
        /(?:(?:^|.*;\s*)banner\s*\=\s*([^;]*).*$)|^.*$/,
        "$1"
      );

      if (cookieValue !== "accepted") banner_div.style.display = "block";
      else setupga();
    } catch (e) {
      console.log("checkAccepted error");
      console.log(e);
      //	setupga()
    }
  }

  checkAccepted();
})();
