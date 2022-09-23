<!--#include file="./DbPath.inc"-->
<%
	'===============================================================================
	' DB CONNECTION DEFINITION
	'===============================================================================
		
		dim DBCon, DBCon2, DBCon3, DBCon4, DBCon5, DBCon6, DBCon7, DBCon8
        dim strConnect, strConnect2, strConnect3, strConnect4, strConnect5, strConnect6, strConnect7, strConnect8
        dim adStateOpen , adStateOpen2, adStateOpen3, adStateOpen4, adStateOpen5, adStateOpen6, adStateOpen7, adStateOpen8
	
	'===============================================================================
	' DB OPEN/CLOSE SUB DIFINITION
	'===============================================================================
	
	Sub  DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon = Server.CreateObject("ADODB.Connection")
		DBCon.CommandTimeout = 1000
		DBCon.Open strConnect    'strConnect
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



	Sub Tennis_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon5 = Server.CreateObject("ADODB.Connection")
		DBCon5.CommandTimeout = 1000
		DBCon5.Open strConnect5
	End Sub
	
	Sub Tennis_DBClose()   '##### DB Close
	
		If DBCon5.State = adStateOpen5 Then 
			DBCon5.Close
		end if
		Set DBCon5 = Nothing
	
	End Sub


  Sub AD_DBOpen()    '#### DB Open
		Err.Clear
		Set DBCon6 = Server.CreateObject("ADODB.Connection")
		DBCon6.CommandTimeout = 1000
		DBCon6.Open strConnect6
	End Sub
	
	Sub AD_DBClose()   '##### DB Close
	
		If DBCon6.State = adStateOpen6 Then 
			DBCon6.Close
		end if
		Set DBCon6 = Nothing
	
	End Sub


    Sub ADADMIN_DBOpen()    '#### DB Open
        Err.Clear
        Set DBCon7 = Server.CreateObject("ADODB.Connection")
        DBCon7.CommandTimeout = 1000
                             
        DBCon7.Open strConnect7
    End Sub

    Sub ADADMIN_DBClose()   '##### DB Close

        If DBCon7.State = adStateOpen7 Then 
            DBCon7.Close
        end if
   
        Set DBCon7 = Nothing

    End Sub

    Sub DBOpen8()    '#### DB Open
        Err.Clear
                              
        SET DBCon8 = Server.CreateObject("ADODB.Connection")
            DBCon8.CommandTimeout = 1000                             
            DBCon8.Open strConnect8
                              
    End Sub

    Sub DBClose8()   '##### DB Close

        IF DBCon8.State = adStateOpen8 Then 
            DBCon8.Close
        END IF
   
        SET DBCon8 = Nothing

    End Sub
%>