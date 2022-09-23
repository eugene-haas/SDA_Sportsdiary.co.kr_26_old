<!--#include file="../Library/ajax_config.asp"-->
<%

	'===================================================================================
	'APP푸시알림 수신,거부
	'===================================================================================
	dim UserID 		: UserID   	= fInject(Request("UserID"))
	dim AgreeYN 	: AgreeYN 	= fInject(Request("AgreeYN"))
	
	dim LSQL, LRs, LogSQL, CSQL, CRs

	Dim strtype
	Dim strmessage

		
	If UserID = "" Or AgreeYN = "" Then 	
		Response.Write "FALSE|66"
		Response.End
	Else 
		'회원DB
		LSQL = "        SELECT UserID, getdate() AS NowDate "
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
		LSQL = LSQL & " WHERE UserID = '" & UserID & "'"
		LSQL = LSQL & "   AND DelYN = 'N'"
		
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 


			CSQL = "        UPDATE [SD_Member].[dbo].[tblMember] "
			CSQL = CSQL & " SET PushYN = '" & AgreeYN & "'"
			CSQL = CSQL & "    ,PushYNdt = getdate()"
			CSQL = CSQL & " WHERE UserID = '" & UserID & "'"
			CSQL = CSQL & "    AND DelYN = 'N'"

			DBCon3.Execute(CSQL)

			If AgreeYN = "Y" Then
				strtype = "동의"
			Else
				strtype = "거부"
			End If

			strmessage = "※ 앱 알림 수신" & strtype & "안내nn"
			strmessage = strmessage & "처리자 : 스포츠다이어리n"
			strmessage = strmessage & "수신"& strtype & "일자 : " & LEFT(LRs("NowDate"), 10) & "n"
      strmessage = strmessage & "(해당기기에서만 유효함)"
			'strmessage = strmessage & "처리내용 : 수신 " & strtype & " 처리 완료되었습니다."

			Response.Write "TRUE|" & AgreeYN & "|" & LEFT(LRs("NowDate"), 10) & "|" & strmessage
			Response.END
		
		Else
			Response.Write "FALSE|99"
			Response.End
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
		DBClose3()

	End If 

	
%>