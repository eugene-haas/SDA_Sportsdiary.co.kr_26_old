<%
	pageno = oJSONoutput.NO

	Select Case pageno
	Case "1"
		Select Case ck_gubun
		Case "sd061001" : gook = 1
		Case "sd061002" : gook = 1
		Case "sd061003" : gook = 1
		Case Else
			gook = 0
		End select	
	Case "2"
		Select Case ck_gubun
		Case "sd061001" : gook = 1
		Case "sd061002" : gook = 1
		Case Else
			gook = 0
		End select	
	Case "3"
		Select Case ck_gubun
		Case "sd061001" : gook = 1
		Case "sd061002" : gook = 1
		Case Else
			gook = 0
		End select	
	Case "4"
		Select Case ck_gubun
		Case "sd061001" : gook = 1
		Case "sd061002" : gook = 1
		Case Else
			gook = 0
		End select	
	Case Else
	End Select 	

	jstr = "{""result"":""0"",""no"":""" & pageno & """,""go"":"""&gook&"""}"
	'jstr = "{""result"":""0"",""no"":""" & pageno & """,""go"":""1""}"
	Response.write jstr
%>