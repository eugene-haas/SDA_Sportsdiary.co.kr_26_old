<!--#include virtual="/Manager/Library/Config.asp"-->
<script>
var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '360',
          width: '640',
          videoId: 'M7lc1UVf-VE',
          events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
          }
        });
      }

</script>
<iframe width="560" height="315" src="https://www.youtube.com/embed/wpbIs3CrK7U?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=wpbIs3CrK7U&enablejsapi=1" frameborder="0" allowfullscreen></iframe>
<input type="button" value="aaaa" onclick="aaa();">

