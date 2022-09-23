<!--#include virtual="/tennis/M_player/Library/DbPath.inc"-->
<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
	
	dim DBCon, DBCon2, DBCon3, DBCon4, DBCon6
	dim strConnect, strConnect2, strConnect3, strConnect4, strConnect6

	
	
	'===============================================================================
	' DB OPEN/CLOSE SUB DIFINITION 유도
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
	'===============================================================================
	'SMS발송을 위해 아이템센터 DB 사용		
	'===============================================================================
	Sub  Itemcenter_DBOpen()    '#### DB Open
		
		Err.Clear
		
		SET DBCon2 = Server.CreateObject("ADODB.Connection")
			DBCon2.CommandTimeout = 1000
			DBCon2.Open strConnect2
	End Sub
	
	
	Sub Itemcenter_DBClose()   '##### DB Close
	
		IF DBCon2.State = adStateOpen Then 
			DBCon2.Close
		End If 

		SET DBCon2 = Nothing
	
	End Sub
	'===============================================================================
	'통합회원DB(SD_Member)
	'===============================================================================
	 Sub  DBOpen3()    '#### DB Open
	
	 	Err.Clear
		
	 	SET DBCon3 = Server.CreateObject("ADODB.Connection")
	 		DBCon3.CommandTimeout = 1000
	 		DBCon3.Open strConnect3
		
	 End Sub
	
	 Sub DBClose3()   '##### DB Close
	
	 	IF DBCon3.State = adStateOpen Then 
	 		DBCon3.Close
	 	End IF
		
	 	SET DBCon3 = Nothing
	
	 End Sub
	 
	 
	'===============================================================================
	'테니스(SD_tennis)
	'===============================================================================
	 Sub  DBOpen4()    '#### DB Open
	 	Err.Clear
	 	SET DBCon4 = Server.CreateObject("ADODB.Connection")
	 		DBCon4.CommandTimeout = 1000
	 		DBCon4.Open strConnect4
	 End Sub

	 Sub DBClose4()   '##### DB Close
	 	IF DBCon4.State = adStateOpen Then 
	 		DBCon4.Close
	 	End IF

		SET DBCon4 = Nothing

	 End Sub
	'===============================================================================


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