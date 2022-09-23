<script>
  //Simple Code

  var request=require('request');

  var optionParams={
  q:"kakao",
  part:"snippet",
  key:"mdDar8JTohwwQ25vZ80DUmkn",
  maxResults:2
  };
  var url="https://www.googleapis.com/youtube/v3/channels?";
  for(var option in optionParams){
  url+=option+"="+optionParams[option]+"&";
  }

  url=url.substr(0, url.length-1);

  request(url, function(err, res, body){
  console.log(body)
  });
</script>
