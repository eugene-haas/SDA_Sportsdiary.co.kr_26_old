<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "NM") = "ok" then
		nm = oJSONoutput.Get("NM")
	End if
	If hasown(oJSONoutput, "MOBILENO") = "ok" then
		mobileno = oJSONoutput.Get("MOBILENO")
	End If
	If hasown(oJSONoutput, "BIRTHDAY") = "ok" then
		birthday =  oJSONoutput.Get("BIRTHDAY")
	End if

	Set db = new clsDBHelper

	tempAuth =  rndno(10, 4)

	'Response.write mobileno
	'Response.end

	'tblPlayer usertype #####
		'userType P 사람 H 말 G 그룹, J 심판, S 스튜어드

		'G	단체(릴레이용)
		'S	1	12 '음
		'H	3281	YK막시무스 말
		'J	326	황혜신 '장애물심판
		'P	858	TAKADA KENTA '선수

		'M	6	테스트  '음 장애물설치자? 가물가물
		'X	124	황인경 '음
	'tblPlayer usertype #####

	'1. 가입여부 확인 (아이디당 한가지 상태만 가진다)  지도자,선수이면서 심판이 될수는 없다.
	'REFEREE################################
	'1:심판 2:노심판(지도자,선수) 0:없음
	reg_member = false
	fld = "Playeridx as PIDX ,ksportsno as KNO , REFEREE,  username as UNM, dbo.FN_DEC_TEXT(phone_number) as MOBILENO ,  userid  as WEBID  "
	SQL = "select top 1 "&fld&" from  tblWebMember where  delyn = 'N' and username = '"&nm&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		pidx = rs(0)
		kno = rs(1)
		referee = rs(2) '1:심판 2:기타관계자 0:없음 (선수는 playeridx  가 존재함)
		unm = rs(3)
		phonenumber = rs(4)
		webid = rs(5)

		'내번호 일딴 패스
		If CStr(phonenumber) = CStr(mobileno) and mobileno <> "01047093650" then
			reg_member = True
		End if
	End if

	'Response.write SQL
	'Response.end

	If reg_member = True Then '가입정보가 있다면 상태가 변경된다면 탈퇴 후 재가입 으로 처리 (또는 개인정보 인증 후 변경)

		Call oJSONoutput.Set("result", "3" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.end


	Else '가입할수 있는 요건 완료

		'선수인지
		chkwhere = " and username = '"&nm&"' and userphone = '"&mobileno&"' and nowyear = '"&year(date)&"' "
		fld = " '선수' as REGTYPE , username as UNM ,userphone as MNO , '"&birthday&"' as BIRTHDAY,playeridx ,ksportsno,team as TCD, teamnm as TNM"
		SQL = "select top 1 "&fld&" from tblPlayer where delyn = 'N' and usertype = 'P' " & chkwhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			Session("pinfoOBJ") = jsonTors_arr(rs)
		Else
			'지도자인지
			chkwhere = " and username = '"&nm&"' and userphone = '"&mobileno&"' and nowyear = '"&year(date)&"' "
			fld = " '지도자' as REGTYPE , username as UNM ,userphone as MNO , '"&birthday&"' as BIRTHDAY,'' as playeridx ,ksportsno,team as TCD, teamnm as TNM "
			SQL = "select top 1 "&fld&" from tblLeader where delyn = 'N' and usertype ='T' " & chkwhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				Session("pinfoOBJ") = jsonTors_arr(rs)
			Else

				'심판등록여부 (심판과 player 는 연결시키지 않는다)

				'기타다
				fld = " '기타' as REGTYPE , '"&nm&"' as UNM ,'"&mobileno&"' as MNO , '"&birthday&"' as BIRTHDAY ,'' as playeridx ,'' as ksportsno,'' as TCD, '' as TNM "
				SQL = "select top 1 "&fld&" from tblPlayer "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					Session("pinfoOBJ") = jsonTors_arr(rs)
				End If
			End If

		End if


	End if


	'세션으로 번호를 생성해 둔다. ( 인증번호 확인시 사용)
	session("chkrndno") = tempAuth


	SMS_title = "["&CONST_GROUPNAME&"] 회원가입 인증번호"
	SMSMsg = "["&CONST_GROUPNAME&"]  인증번호 ["&tempAuth&"] 를 입력해 주세요."

	'If pno = "01047093650" Then
		'패스 내번호 테스트용
	'else
		Call sendPhoneMessage(db,3, SMS_title, SMSMsg, sitecode, CONST_SENDPHONENO, mobileno)
	'End if

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
