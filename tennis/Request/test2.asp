<html>
<head>
   
</head>
<body>

<form id='form2' action='http://biz.moashot.com/EXT/URLASP/mssendutf.asp' method='post'>
    <input type='hidden' name='uid' value='widline' />
    <input type='hidden' name='pwd' value='line0282' />
    <input type='hidden' name='commType' value='0' /><!--보안설정 0-일반,1-MD5-->
    <input type='hidden' name='commCode' value='' /><!--보안코드(비밀번호를 MD5로 변환한값)-->
    <input type='hidden' name='sendType' value='5' />
    <input type='hidden' name='title' value='test' />
    <input type='hidden' name='toNumber' id='toNumber' value='01072907647' />
    <input type='hidden' name='contents' id='contents' value='test&#13;test' />
    <input type='hidden' name='fileName' value='' />
    <input type='hidden' name='fromNumber' value='18000523' />
    <input type='hidden' name='nType' value='3' />
    <input type='hidden' name='indexCode' value='20170906' /><!--전송건에 대한 고유 값(동보 전송일 경우 ‘,’로 구분하여 입력)-->
    <input type='hidden' name='returnUrl' id='returnUrl' value=''  /><!--전송결과를 호출 받을 웹 페이지의 URL주소-->
    <input type='hidden' name='returnType' value='2' /><!--2. redirectUrl 에 입력한 경로로 이동합니다(Redirect)-->
    <input type='hidden' name='redirectUrl' value='http://tennis.sportsdiary.co.kr/tennis/request/list_repair.asp' /><!--전송(접수)후 페이지 이동경로http:// 또는 https:// 를 포함한 풀경로를 입력합니다.-->
</form>
<script>
	document.forms['form2'].submit(); 
</script>

</body>
</html>