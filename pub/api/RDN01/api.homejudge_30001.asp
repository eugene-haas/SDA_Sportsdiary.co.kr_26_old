<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'저정 심판등록
'#############################################

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '심판등급, 종목, tblWebmember.seq 3개받음
	End if
	
	'{""CMD"":30001,""SENDPRE"":""kor_"",""PARR"":[""2020"",""강택"",""6638"",""KANG TEAK"",""ATE0003139"",""강원도승마협회"",""200312004851"",""M"",""19871006"",""마장마술""]}
	Set db = new clsDBHelper 
		tablename = "tblPlayer"
		strFieldName = " ksportsno,startyear,nowyear,MemberIDX,userID,userType,UserName,UserPhone,Birthday,owner_id,email,Ajudgelevel, CDBNM,delyn  " 'owner_id 등록한 아이디 CDB 체육회 코드를 넣어야하는데 맞출수 가 없을듯

		For i = 0 To oJSONoutput.PARR.length-1 '받은거 기준 (입력값 준비)   '심판등급, 종목, tblWebmember.seq 3개받음
			Select Case i
			Case 0
				Ajudgelevel	= reqArr.Get(i)
			Case 1
				CDBNM	= reqArr.Get(i)
			Case 2
				webSeq	= reqArr.Get(i)
			End Select 
		next

		fld = " ksportsno,'"&year(date)&"','"&year(date)&"','"&webSeq&"','"&session_uid&"','J',username,dbo.FN_DEC_TEXT(PHONE_NUMBER),dbo.FN_DEC_TEXT(BIRTHDAY),'"&session_uid&"', EMAIL,'"&Ajudgelevel&"', '"&CDBNM&"'   ,'W' "  'delYN 의 상태를 하나 더두자 (W 대기상태)
		SelectSQL = "select top 1 "&fld&" from tblWebMember where seq = '"&webseq&"' and userid = '"&session_uid&"' "

		'대기상태로 들어가야함
		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&strFieldName&" )  " 'confirm 확인여부
		SQL = SQL & " " & SelectSQL & "  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		newpidx = rs(0)


		'GUBUN  1,(말) 2 (심판) ,3 (팀)
		REGNUM = "JNO" & newpidx
		SQL = " insert into tblWebRegLog (GUBUN, REGSEQ, TITLE, REGNUM, USERID,REGNUM,  state) values (2, "&newpidx&" , '"&session_unm&"', '', '"&session_uid&"' ,'"&REGNUM&"' , 0) " 'state  0 대기 , 1 완료
		Call db.execSQLRs(SQL , null, ConStr)


		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>