<%
'response.write v_datetime & "<br />"
'response.write v_timestamp & "<br />"
'response.write v_datetime2 & "<br />"

'//p_date : "2015-01-02 00:00:00"
Function getTimestamp(ByVal p_date)
 If LCase(typename(p_date)) = "string" Then
  p_date = CDate(p_date)
 End If

 getTimestamp = DateDiff("s", "1970-01-01 00:00:00", p_date)
End Function

'//p_timestamp : timestamp값
Function convertTimestampDatetime(ByVal p_timestamp)
 convertTimestampDatetime = DateAdd("s", p_timestamp, "1970-01-01 00:00:00")
End Function



v_datetime = "2018-04-05 15:11:28"
v_timestamp = getTimestamp(v_datetime)
v_datetime2 = convertTimestampDatetime(v_timestamp)

%>


<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>JS-SDK Demo</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
</head>
<body ontouchstart="">
</body>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
	wx.config({
		debug: true,
		appId: 'wx7e1d114e148afc7a',
		timestamp: <%=v_timestamp%>,
		nonceStr: 'ABCDEFGHIJ123456',
		signature: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa',
		jsApiList: [
			'checkJsApi',
			'onMenuShareTimeline',
			'onMenuShareAppMessage'
		  ]
	});
	wx.ready(function () {
		var shareData = {
			title: 'title',
			desc: '<iframe frameborder="0" width="640" height="498" src="https://v.qq.com/iframe/player.html?vid=r0617tp1hdu&tiny=0&auto=0" allowfullscreen></iframe>',
			link: 'http://www.daum.com',
			imgUrl: 'http://ikata.sportsdiary.co.kr/front/dist/imgs/public/header/logo_sub.png'
		};
		wx.onMenuShareAppMessage(shareData);
		wx.onMenuShareTimeline(shareData);
	});
	wx.error(function (res) {
	  alert(res.errMsg);
	});
</script>
</html>