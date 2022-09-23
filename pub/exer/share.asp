<!DOCTYPE html>
<html>
<head>
	
  <title>대한수영연맹</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=3, maximum-scale=3" />
  <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1" />
  <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
  <meta name="format-detection" content="telephone=no" />
  <meta http-equiv="Cache-Control" content="No-Cache" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="pragma" content="no-store" />
  <meta http-equiv="Expires" content="-1" />


<body>

<div id="msg"></div>
<button id="shareButton">공유</a>


<script type="text/javascript">
<!--
if (typeof navigator.share === "undefined") {
	document.getElementById("msg").innerHTML = "기능없음" + navigator.share;
  alert(1);
  // 공유하기 버튼을 지원하지 않는 경우에 대한 폴백 처리
  shareButton.hidden = true;
}


	window.navigator.share({
  title: '', // 공유될 제목
  text: '', // 공유될 설명
  url: '', // 공유될 URL
  files: [], // 공유할 파일 배열
});


var shareButton = document.getElementById("shareButton");


shareButton.addEventListener("click", async () => {
  try {
    await navigator.share({
      title: "재그지그의 개발 블로그",
      text: "디자인과 UI, UX에 관심이 많은 주니어 웹 프론트엔드 개발자입니다.",
      url: "http://www.naver.com",
    });
    console.log("공유 성공");
  } catch (e) {
    console.log("공유 실패");
  }
});




//url 프로퍼티에 빈 스트링("")을 넣으면 현재 URL이 자동으로 설정됩니다.
//-->



</script>



</body>
</html>

