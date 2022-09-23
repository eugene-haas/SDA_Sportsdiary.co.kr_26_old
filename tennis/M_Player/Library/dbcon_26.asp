<!--#include file = "../Library/DbPath_26.inc"-->

<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
	
	Dim DBCon, DBCon2, DBCon3, strConnect, strConnect2, strConnect3, adStateOpen, adStateOpen2, adStateOpen3
	
	
	'===============================================================================
	' DB OPEN/CLOSE SUB DIFINITION
	'===============================================================================
	
	Sub  DBOpen()    '#### DB Open
	
		Err.Clear
		
		SET DBCon = Server.CreateObject("ADODB.Connection")
			DBCon.CommandTimeout = 1000
			DBCon.Open strConnect
		
	End Sub
	
	
	Sub DBClose()   '##### DB Close
	
		IF DBCon.State = adStateOpen Then 
			DBCon.Close
		End IF
		
		SET DBCon = Nothing
	
	End Sub
	
	
	'SMS발송을 위해 아이템센터 DB 사용		
	Sub  Itemcenter_DBOpen()    '#### DB Open
		
		Err.Clear
		
		SET DBCon2 = Server.CreateObject("ADODB.Connection")
			DBCon2.CommandTimeout = 1000
			DBCon2.Open strConnect2
	End Sub
	
	
	Sub Itemcenter_DBClose()   '##### DB Close
	
		IF DBCon2.State = adStateOpen2 Then 
			DBCon2.Close
		End If 

		SET DBCon2 = Nothing
	
	End Sub

	'통합회원DB
	' Sub  DBOpen3()    '#### DB Open
	
	' 	Err.Clear
		
	' 	SET DBCon3 = Server.CreateObject("ADODB.Connection")
	' 		DBCon3.CommandTimeout = 1000
	' 		DBCon3.Open strConnect3
		
	' End Sub
	
	' Sub DBClose3()   '##### DB Close
	
	' 	IF DBCon3.State = adStateOpen3 Then 
	' 		DBCon3.Close
	' 	End IF
		
	' 	SET DBCon3 = Nothing
	
	' End Sub

%>