<!DOCTYPE html>
<html>

 
 <head>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
  <meta name="format-detection" content="telephone=no" />
  <meta charset="utf-8">
  <title>자전거</title>


<script type="text/javascript">
<!--
var SCHEME_FOR_TEST = 'intent://open#Intent;scheme=;end';
var ua = navigator.userAgent,
    isAndroid = /android/i.test(ua),
    isIOS = /iphone|ipad|ipod/i.test(ua),
    isSupportingIntent = (
        tui.util.browser.chrome &&
        +(tui.util.browser.version) > 24 &&
        !(/firefox|opr|fb_iab/i.test(ua))
    );

var loader = tui.util.defineModule('appLoader', {
    isPrepared: false,

    isNotSupportedFallbackURL: false,

    initialize: function() {
        if (isAndroid) {
            if (isSupportingIntent) {
                this._checkSupportingFallbackURL();
                this.load = this._launchAppViaIntent;
            } else {
                this.load = this._launchAppViaIframe;
            }
        } else if (isIOS) {
            //...
        } else {
            alert('run in mobile');
        }
    },

    setParams: function(params) {
        this.appURI = params.appURI;
        this.fallbackURL = params.fallbackURL;
    },

    _createHiddenIframe: function() {
        var iframe = document.createElement('IFRAME');

        iframe.style.display = 'none';
        return iframe;
    },

    _launchAppViaIframe: function() {
        var iframe = this._createHiddenIframe(),
            start = +new Date(),
            self = this;

        iframe.src = self.appURI;
        iframe.addEventListener('load', function onload() {
            iframe.removeEventListener('load', onload);
            document.body.removeChild(iframe);
        });
        document.body.appendChild(iframe);

        setTimeout(function() {
            var now = +new Date();
            if (now - start < 2000) {
                top.location.href = self.fallbackURL;
            }
        }, 500);
    },

    _checkSupportingFallbackURL: function() {
        var iframe = this._createHiddenIframe(),
            self = this;

        iframe.addEventListener('load', function onload() {
            if (iframe.src === SCHEME_FOR_TEST) {
                self.isNotSupportedFallbackURL = true;
            } else {
                iframe.removeEventListener('load', onload);
                document.body.removeChild(iframe);
                self.isPrepared = true;
            }
        });
        iframe.src = SCHEME_FOR_TEST;

        document.body.appendChild(iframe);
        setTimeout(function() {
            iframe.src = '';
        }, 100);
    },

    _launchAppViaIntent: function() {
        var popup,
            self = this;

        if (!this.isPrepared) {
            setTimeout(this.load.bind(this), 100);
            return;
        }

        if (!this.isNotSupportedFallbackURL) {
            window.location.href = self.appURI;
            return;
        }

        popup = window.open('');
        if (popup) {
            popup.addEventListener('unload', function onUnload() {
                setTimeout(function () {
                    if (popup.opener) {
                        popup.opener.location.href = self.fallbackURL;
                    }
                }, 10);
                popup.close();
                popup.removeEventListener('unload', onUnload);
            });
            popup.location.href = this.appURI.replace(/package=.*?;/, '');
        } else {
            alert('팝업 허용해주세요');
        }
    },

    load: function() {
        alert('load() is not implemented!');
    }
});



        loader.setParams({
            appURI: [
                'intent://open#Intent',
                'scheme=xxpayco',
                'package=com.sportsdiary.player.sportsdiaryplayer',
                'S.browser_fallback_url=http%3A%2F%2Fwww.payco.com',
                'end'
            ].join(';'),

            fallbackURL: 'http://www.sportsdiray.co.kr'
        });
        loader.load();
//-->
</script>



</head>
<body>
</body>
</html>