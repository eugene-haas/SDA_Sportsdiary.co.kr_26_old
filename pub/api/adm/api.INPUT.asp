<%
'#############################################
'저장
'#############################################


Set db = new clsDBHelper

	'request

	If hasown(oJSONoutput, "CNT") = "ok" then
		cnt= oJSONoutput.CNT
	End If
	
	n = 0
	For i = 1 To cnt
		If hasown(oJSONoutput, "mx_"&n ) = "ok" then

			Select Case n
			Case 0 : dbcode =  oJSONoutput.mx_0
			Case 1 : linecnt =  oJSONoutput.mx_1
			Case 2 : inputval =  oJSONoutput.mx_2
			Case 3 : inputquery =  oJSONoutput.mx_3
			Case 4  
			
			outputval =  Replace(oJSONoutput.mx_4,"'", "''")

			Case 5  : title =  oJSONoutput.mx_5
			Case 6  : useurl =  oJSONoutput.mx_6
			End Select 
		
		End If
	n = n + 1
	Next 

	
	SQL = "insert Into tblJSON (dbcode,inputval,inputq,outputval,outputcnt,title,useurl,makeid) values ('"&dbcode&"','"&inputval&"','"&inputquery&"','"&outputval&"','"&linecnt&"','"&title&"','"&useurl&"','"&Cookies_aID&"')"
	Call db.execSQLRs(SQL , null, B_ConStr)
	

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




db.Dispose
Set db = Nothing
%>
