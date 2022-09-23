<!--#include virtual="/Library/DbPath.inc"-->

<%
'===============================================================================
' DB CONNECTION DEFINITION
'===============================================================================
	
	Dim DBCon, strConnect, adStateOpen

'===============================================================================
' DB OPEN/CLOSE SUB DIFINITION
'===============================================================================

    SUB DBOpen()    '#### DB Open

		Err.Clear

        Set DBCon = Server.CreateObject("ADODB.Connection")
		DBCon.CommandTimeout = 1000
        DBCon.Open strConnect


    End Sub
 

	Sub DBClose()   '##### DB Close

		If DBCon.State = adStateOpen Then 
			DBCon.Close
		end if
		Set DBCon = Nothing

	End Sub
    
%>