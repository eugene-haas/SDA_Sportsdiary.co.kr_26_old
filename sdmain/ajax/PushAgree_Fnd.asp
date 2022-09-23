<!--#include file="../Library/ajax_config.asp"-->
<%

	'===================================================================================
	'APP푸시알림 수신|거부 설정되었는지 체크
	'===================================================================================
  Check_Login() 

  dim UserID 		: UserID   	= fInject(trim(Request("UserID")))

	dim LSQL, LRs

	
	If UserID = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		'회원DB
		LSQL = "        SELECT CASE WHEN PushYN IS NULL OR PushYN = '' THEN '0' ELSE PushYN END PushYN"
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
		LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & "     AND UserID = '" & UserID & "'"
   
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			Response.Write "TRUE|" & LRs("PushYN")
		Else
			Response.Write "FALSE|99"
		End IF		
			LRs.Close
		SET LRs = Nothing

    DBClose3()	
   
	End If 

    
   
%>