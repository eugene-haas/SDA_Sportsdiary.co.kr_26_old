<%
	'###### S: DB Connection String ######

	strConnect = strConnect & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect = strConnect & "Data Source=49.247.9.88;"
	strConnect = strConnect & "User ID=Korbm;"
	strConnect = strConnect & "Password=qoemalsxjs;"
	strConnect = strConnect & "Initial Catalog=KoreaBadminton;"

	strConBK = strConBK & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConBK = strConBK & "Data Source=49.247.9.88;"
	strConBK = strConBK & "User ID=KorBadmin;"
	strConBK = strConBK & "Password=dkzniuqjza831!$;"
	strConBK = strConBK & "Initial Catalog=Bad_Korea_BAK;"

  strConTEST = strConTEST & "Provider=SQLOLEDB.1;Persist Security Info=True;"
  strConTEST = strConTEST & "Data Source=49.247.9.88;"
  strConTEST = strConTEST & "User ID=KorbadtestUser;"
  strConTEST = strConTEST & "Password=TestUser!@#KorBadminton;"
  strConTEST = strConTEST & "Initial Catalog=koreaTEST1;" 

	'###### E: DB Connection String ######
%>
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