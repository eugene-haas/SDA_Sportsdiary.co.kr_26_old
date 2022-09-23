<!--#include file="./DbPath_bn.inc"-->
<%
		
		Dim DBCon6, strConnect6
	

  Sub AD_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon6 = Server.CreateObject("ADODB.Connection")
		DBCon6.CommandTimeout = 1000
		DBCon6.Open strConnect6
	End Sub
	
	Sub AD_DBClose()   '##### DB Close
	
		If DBCon6.State = adStateOpen Then 
			DBCon6.Close
		end if
		Set DBCon6 = Nothing
	
	End Sub

%>