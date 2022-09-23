<%
'request
	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If
	If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
		chkgame = oJSONoutput.chkgame
	End If

	If hasown(oJSONoutput, "bikeidx") = "ok" Then 'bike.tblmember.MemberIDX 입니당.
		bikeidx = oJSONoutput.bikeidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if	


	If hasown(oJSONoutput, "teamnm") = "ok" Then '팀명칭
		teamnm = oJSONoutput.teamnm
	End if	

	If hasown(oJSONoutput, "teamlist") = "ok" Then '참가선수 아이디
		teamlist = oJSONoutput.teamlist
	End if	

	If hasown(oJSONoutput, "adult") = "ok" Then '성인미성인 Y N 부모 동의 문자 발송여부
		adult = oJSONoutput.adult
	End if	
	If hasown(oJSONoutput, "agree") = "ok" Then 
		agree = oJSONoutput.agree
	End if	

	If hasown(oJSONoutput, "p_nm") = "ok" Then 
		p_nm = oJSONoutput.p_nm
	End if	
	If hasown(oJSONoutput, "p_phone") = "ok" Then 
		p_phone = oJSONoutput.p_phone
	End if	
	If hasown(oJSONoutput, "p_relation") = "ok" Then 
		p_relation = oJSONoutput.p_relation
	End if	

	If hasown(oJSONoutput, "lms") = "ok" Then 
		lmsstr = oJSONoutput.lms
	End if	
	If hasown(oJSONoutput, "lmsno") = "ok" Then 'bike.tblmember.MemberIDX 입니당.
		lmsno = oJSONoutput.lmsno
	End If

	If hasown(oJSONoutput, "ridx") = "ok" Then '참가신청인덱스
		ridx = oJSONoutput.ridx
	End If	

	If hasown(oJSONoutput, "gameidx") = "ok" Then 'sd_bikegame 게임정보
		gameidx = oJSONoutput.gameidx
	End If	
'request

	'##################
	'발송정보   "12816,이수진,010-6787-8723^12817,최정화,010-9001-4717^*보호자*,0000,010-0000-0000^"
	'##################
		lmsmember = Split(lmsstr,"^") 'playerIDX,이름,전화번호 (보호자 > *보호자* )
		lmsMinfo = Split(lmsmember(lmsno),",")
		m_midx = lmsMinfo(0) 'SD_member.memberIDX 또는 *보호자* 텍스트
		m_nm = lmsMinfo(1)
		m_pn = Replace(lmsMinfo(2),"-","")
	
'		SQL = "select attmidx,team_lmssend,p_lmssend sd_bikeMember where gameidx = " & gameidx & " and playeridx = "& m_pidx
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		
'		lmsm = rs("team_lmssend")
'		lmsp = rs("p_lmssend")
'		attmidx = rs("attmidx")
'
'		If lmsm = "N" Then
'			SQL = "update sd_bikeMember set team_lmssend = 'Y' where attmidx = " & attmidx
'			Call db.execSQLRs(SQL , null, ConStr)
'		End if
	'##################


	Set db = new clsDBHelper

	'##################
	'대회 및 종목 정보
	'##################
	chkgames = Split(chkgame,":") '단체 1개씩
	levelIDX  = Split(chkgames(0),",")(0)

	fieldstr = "a.GameTitleName,a.GameS,a.GameE,a.GameRcvDateS,a.GameRcvDateE,b.levelno,b.detailtitle,b.gameday "
	SQL = "SELECT TOP 1 "&fieldstr&"  FROM sd_bikeTitle as a INNER JOIN sd_bikeLevel as b ON a.titleIDX = b.titleIDX  where a.titleIDX = " & tidx & " and b.levelIDX = " & levelIDX & " and b.delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		title = rs("GameTitleName")
		games = Replace(rs("games"),"-",".")
		gamee = Replace(rs("gamee"),"-",".")
		GameRcvDateS = Replace(rs("GameRcvDateS"),"-",".")
		GameRcvDateE = Replace(rs("GameRcvDateE"),"-",".")
		detailTitle = rs("detailtitle")
	End If

	'##################
	'발신자 정보
	'##################
	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = "select " & fieldstr & " from tblMember where MemberIDX = " & Cookies_midx 
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	If Not rs.eof Then
	Uidx = rs("MemberIDX")
	userID		= rs("userID")
	UserName		= rs("UserName")
	userPhone		= rs("userPhone")
	birthday		= rs("birthday")
	sex		= LCase(rs("sex"))
	email		= rs("email")
	zipcode		= rs("zipcode")
	address				= rs("address")
	End if

	'문자내용
	If m_midx = "*보호자*" Then
		SMS_Subject = title & " " & detailtitle & " " & "  보호자 동의서"
		SMS_Msg = "안녕하십니까.\n"
		SMS_Msg = SMS_Msg & "스포츠다이어리입니다.\n\n"
		SMS_Msg = SMS_Msg & "귀하의자녀께서\n"
		SMS_Msg = SMS_Msg & "["&title & "]\n"
		SMS_Msg = SMS_Msg & ""&detailtitle & "\n"
		SMS_Msg = SMS_Msg & "참가신청을 진행 중 입니다.\n\n"
		SMS_Msg = SMS_Msg & "19세미만은 보호자의동의가 꼭필요하여 아래 링크로 동의해주셔야 참가신청이 완료됩니다.\n\n"
	else
		SMS_Subject = title & " " & detailtitle & " " & "참가신청 동의 요청"
		SMS_Msg = "안녕하십니까.\n"
		SMS_Msg = SMS_Msg & "스포츠다이어리입니다.\n\n"
		SMS_Msg = SMS_Msg & ""&UserName&" 님이 신청하신\n"
		SMS_Msg = SMS_Msg & "["&title & "]\n"
		SMS_Msg = SMS_Msg & ""&detailtitle & "\n"
		SMS_Msg = SMS_Msg & "참가신청을 진행중 입니다.\n\n"
		SMS_Msg = SMS_Msg & "아래링크로 해당 정보를 입력해 주셔야 참가신청이 진행됩니다.\n\n"	
	End if


	If m_midx = "*보호자*" Then

		'부모동의에 보낼키값 구하기
		SQL = "Select b.attmidx from sd_bikeTitle as a INNER JOIN  v_bikeGame_attm as b ON a.titleIDX = b.titleIDX  where a.titleIDX = "&tidx&" and  b.PlayerIDX = " & cbike_pidx & " and b.levelno = "&levelIDX   & " and b.gubun in (0,1) "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		attmidx = rs("attmidx") '참가자 업데이트 할 키(부모동의)
		
		Set pp = JSON.Parse("{}")
		Call pp.Set("attmidx",attmidx)
		ppjson = JSON.stringify(pp)
		SMS_Msg = SMS_Msg & "http://bike.sportsdiary.co.kr/bike/lms/pagree.asp?REQ="&attmidx&" \n\n"
	Else

		SMS_Msg = SMS_Msg & "http://bike.sportsdiary.co.kr/pub/dn.asp\n\n"
		'SMS_Msg = SMS_Msg & "https://goo.gl/zDJ5Vu\n\n"
	End if
	SMS_Msg = replace(SMS_Msg, "\n", "&#13;")						'줄바꿈 변환

	contents = SMS_Msg
	indexCode = now()

	
	'타입 석어서 보내기
	oJSONoutput.lmsno = CDbl(lmsno) + 1

	'If DEBUG_MODE  And InStr(DEBUG_IP, USER_IP) > 0 Then
	'	If lmsno = 1 then
	'		toNumber = "01067878723" 'm_pn
	'	Else
	'		toNumber = "01067878723" 'm_pn
	'	End If
	'Else
		toNumber = m_pn	
	'End if

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"

	db.Dispose
	Set db = Nothing
%>


<form id="lms_form" name="lms_form" action='http://biz.moashot.com/EXT/URLASP/mssendutf.asp' method='post' target="hiddenFrame">
	<input type='hidden' name='uid' value='rubin500' />
	<input type='hidden' name='pwd' value='rubin0907' />
	<input type='hidden' name='commType' value='0' /><!--보안설정 0-일반,1-MD5-->
	<input type='hidden' name='commCode' value='' /><!--보안코드(비밀번호를 MD5로 변환한값)-->
	<input type='hidden' name='sendType' value='5' /><!--전송구분 3-단문문자, 5-LMS(장문문자), 6-MMS(Image포함문자) -->
	<input type='hidden' name='title' value='<%=SMS_Subject%>' /><!--전송제목-->
	<input type='hidden' name='toNumber' id='toNumber' value='<%=toNumber%>' /><!--수신처 핸드폰 번호(동보 전송일 경우‘,’로 구분하여 입력)-->
	<input type='hidden' name='contents' id='contents' value='<%=contents%>' /><!--전송할 문자나 MMS 내용(문자 80byte, MMS 2000byte)-->
	<input type='hidden' name='fileName' value='' /><!--이미지 전송시 파일명(JPG이미지만 가능)-->
	<input type='hidden' name='fromNumber' value='027040282' /><!--발신자 번호(휴대폰,일반전화 번호 가능)-->
	<input type='hidden' name='nType' value='4' /><!--결과전송 타입 1. 전송건 접수 여부, 2. 전송건 성공 실패 여부(1~8), 3. 위 1,2 모두 확인, 4. 모두 확인 안함-->
	<input type='hidden' name='indexCode' value='<%=indexCode%>' /><!--전송건에 대한 고유 값(동보 전송일 경우 ‘,’로 구분하여 입력)-->
	<input type='hidden' name='returnUrl' id='returnUrl' value='' /><!--전송결과를 호출 받을 웹 페이지의 URL주소-->
	<input type='hidden' name='returnType' id='returnType' value='2' /><!--0 또는 NULL 호출페이지 Close, 1. 호출페이지 유지, 2. redirectUrl 에 입력한 경로로 이동합니다(Redirect)-->
	<input type='hidden' name='redirectUrl' id='redirectUrl' value=''/><!--전송(접수)후 페이지 이동경로http:// 또는 https:// 를 포함한 풀경로를 입력합니다.-->
</form>
 
