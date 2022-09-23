<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
</head>
<body>
<script type="text/javascript">
<!--
//	다운로드 경로
//	android URL : https://goo.gl/zDJ5Vu
//	ios URL : https://goo.gl/Af6tN6
//	https://play.google.com/store/apps/details?id=com.sportsdiary.player.sportsdiaryplayer    안드
//	https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8	 아이폰
//	다운로드 경로


//market://details?id=com.sportsdiary.player.sportsdiaryplayer

if( /Android/i.test(navigator.userAgent)) {
//	location.href = "https://goo.gl/zDJ5Vu";
	location.href= "market://details?id=com.sportsdiary.player.sportsdiaryplayer";
} else if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
	location.href = "https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8";
	
	//"https://goo.gl/Af6tN6";
}	
//-->
</script>
</body>
</html>