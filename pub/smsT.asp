<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
'Response.end

SMS_Subject = "제목이고"
'toNumber = "01047093650"
toNumber = "01043693442"

SMS_Msg = "dddddddddddd"
'SMS_Msg = "[스포츠다이어리] 테니스 대회 참가신청 안내\n\n"
'SMS_Msg = SMS_Msg & "2017 KATA회장배 KATA TOUR 대회  (신인부 목동)에 참가신청이 접수되었습니다.\n\n"
'SMS_Msg = SMS_Msg & "- 참가자 : 최보라(강서어택) / 파트너 : 김길복(목동1단지,테니스매니아)\n\n"
'SMS_Msg = SMS_Msg & "- 참가자 : 이진복(강서어택) / 파트너 : 김진희(목동1단지)\n\n"
'SMS_Msg = SMS_Msg & "아래 주소를 클릭하여 본인 확인을 해주셔야 대회 참가신청이 완료됩니다.\n\n"
'SMS_Msg = SMS_Msg & "http://tennis.sportsdiary.co.kr/tennis/request/req_comp.asp?UserInfo=31323839342C3031303633313236363535\n\n"

'SMS_Msg = replace(SMS_Msg, "{PlayerInfo}", PlayerInfo)			'참가자 정보
'SMS_Msg = replace(SMS_Msg, "\n", "&#13;")						'줄바꿈 변환
contents = SMS_Msg
indexCode = now()
%>



<form id='form2' action='http://biz.moashot.com/EXT/URLASP/mssendutf.asp' method='post'>
	<input type='hidden' name='uid' value='rubin500' />
	<input type='hidden' name='pwd' value='rubin0907' />
	<input type='hidden' name='commType' value='0' /><!--보안설정 0-일반,1-MD5-->
	<input type='hidden' name='commCode' value='' /><!--보안코드(비밀번호를 MD5로 변환한값)-->
	<input type='hidden' name='sendType' value='3' /><!--전송구분 3-단문문자, 5-LMS(장문문자), 6-MMS(Image포함문자) -->
	<input type='hidden' name='title' value='test' /><!--전송제목-->
	<input type='hidden' name='toNumber' id='toNumber' value='<%=toNumber%>' /><!--수신처 핸드폰 번호(동보 전송일 경우‘,’로 구분하여 입력)-->
	<input type='hidden' name='contents' id='contents' value='<%=contents%>' /><!--전송할 문자나 MMS 내용(문자 80byte, MMS 2000byte)-->
	<input type='hidden' name='fileName' value='' /><!--이미지 전송시 파일명(JPG이미지만 가능)-->
	<input type='hidden' name='fromNumber' value='027040282' /><!--발신자 번호(휴대폰,일반전화 번호 가능)-->
	<input type='hidden' name='nType' value='4' /><!--결과전송 타입 1. 전송건 접수 여부, 2. 전송건 성공 실패 여부(1~8), 3. 위 1,2 모두 확인, 4. 모두 확인 안함-->
	<input type='hidden' name='indexCode' value='<%=indexCode%>' /><!--전송건에 대한 고유 값(동보 전송일 경우 ‘,’로 구분하여 입력)-->
	<input type='hidden' name='returnUrl' id='returnUrl' value='' /><!--전송결과를 호출 받을 웹 페이지의 URL주소-->
	<input type='hidden' name='returnType' id='returnType' value='2' /><!--0 또는 NULL 호출페이지 Close, 1. 호출페이지 유지, 2. redirectUrl 에 입력한 경로로 이동합니다(Redirect)-->
	<input type='hidden' name='redirectUrl' id='redirectUrl' value='' /><!--전송(접수)후 페이지 이동경로http:// 또는 https:// 를 포함한 풀경로를 입력합니다.-->
</form>

<script type="text/javascript">
<!--
function send(){
	//document.getElementById("form2").submti();
	document.forms['form2'].submit();
}	
//-->
</script>

<input type="button" onclick="send()" value="보내기">