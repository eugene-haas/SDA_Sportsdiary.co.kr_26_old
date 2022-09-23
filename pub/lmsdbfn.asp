<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
'Response.end

Sub sendPhoneMessage(db,sendType, title, msg, sitecode, fromphone, tophone)
	Dim SQL 
	fromphone = Replace(fromphone,"-","")
	tophone = Replace(tophone,"-","")
	msg = Replace(msg,"\n",vbLf)

	'sendType 7 LMS 3, MMS
	If sendType = "" Then
		sendType = 3
	End if
	SQL  = " INSERT INTO SD_TENNIS.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode)  "
	SQL = SQL & " VALUES ('"& title &"', '"& sendType &"', 0, '"& tophone &"', 0, '"& msg &"', '"& fromphone &"', GETDATE(), '"& sitecode &"') "
	Call db.execSQLRs(SQL , null, ConStr)
End Sub


Set db = new clsDBHelper

	SMS_Subject = "제목이고ajwlal"
	sitecode = "BB99"
	fromNumber = "0222496130"
	toNumber = "01047093650"
	SMS_Msg = "[스포츠다이어리] 테니스 대회 참가신청 안내\n"
	SMS_Msg = SMS_Msg & "2017 KATA회장배 KATA TOUR 대회  (신인부 목동)에 참가신청이 접수되었습니다.\n"
	SMS_Msg = SMS_Msg & "- 참가자 : 최보라(강서어택) / 파트너 : 김길복(목동1단지,테니스매니아)\n"
	SMS_Msg = SMS_Msg & "- 참가자 : 이진복(강서어택) / 파트너 : 김진희(목동1단지)\n"
	SMS_Msg = SMS_Msg & "아래 주소를 클릭하여 본인 확인을 해주셔야 대회 참가신청이 완료됩니다.\n"

	Call sendPhoneMessage(db, "7", SMS_Subject, SMS_Msg, sitecode,fromNumber,  toNumber)

db.Dispose
Set db = Nothing
%>

