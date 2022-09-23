<!--#include file="./DbPath.inc"-->
<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
		
		Dim DBCon, DBCon2, strConnect, strConnect2, adStateOpen, adStateOpen2
	
	'===============================================================================
	' DB OPEN/CLOSE SUB DIFINITION
	'===============================================================================	
	Sub  DBOpen()    '#### DB Open
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
	
	'SMS발송을 위해 아이템센터 DB 사용		
	Sub  Itemcenter_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon2 = Server.CreateObject("ADODB.Connection")
		DBCon2.CommandTimeout = 1000
		DBCon2.Open strConnect2
	End Sub
	
	Sub Itemcenter_DBClose()   '##### DB Close
	
		If DBCon2.State = adStateOpen2 Then 
			DBCon2.Close
		End If 
		Set DBCon2 = Nothing
	
	End Sub



%>