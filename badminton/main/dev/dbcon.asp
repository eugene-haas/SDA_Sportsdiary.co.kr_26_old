<!-- #include virtual = "/library/DbPath.inc"-->
<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
		
		Dim DBCon, strConnect, adStateOpen
		Dim DBCon2, strConBK
	
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

	Sub DBOpen2()    '#### DB Open
		Err.Clear
		Set DBCon2 = Server.CreateObject("ADODB.Connection")
		DBCon2.CommandTimeout = 1000
		DBCon2.Open strConBK
	End Sub
	
	Sub DBClose2()   '##### DB Close
	
		If DBCon2.State = adStateOpen Then 
			DBCon2.Close
		End If
		Set DBCon2 = Nothing
	
	End Sub
%>