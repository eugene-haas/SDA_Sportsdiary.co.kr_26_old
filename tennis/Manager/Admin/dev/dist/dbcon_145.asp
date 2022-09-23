<!--#include file="./DbPath.inc"-->
<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
		
		Dim DBCon, DBCon2, DBCon3, DBCon4, strConnect, strConnect2, strConnect3, strConnect4, adStateOpen , adStateOpen2, adStateOpen3, adStateOpen4
	
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
	
	
	Sub  Test_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon3 = Server.CreateObject("ADODB.Connection")
		DBCon3.CommandTimeout = 1000
		DBCon3.Open strConnect3
	End Sub
	
	Sub Test_DBClose()   '##### DB Close
	
		If DBCon3.State = adStateOpen3 Then 
			DBCon3.Close
		end if
		Set DBCon3 = Nothing
	
	End Sub

	Sub  JudoKorea_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon4 = Server.CreateObject("ADODB.Connection")
		DBCon4.CommandTimeout = 1000
		DBCon4.Open strConnect4
	End Sub
	
	Sub JudoKorea_DBClose()   '##### DB Close
	
		If DBCon4.State = adStateOpen4 Then 
			DBCon4.Close
		end if
		Set DBCon4 = Nothing
	
	End Sub
%>