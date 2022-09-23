<%
	If hasown(oJSONoutput, "SEQ") = "ok" Then 
		seq = oJSONoutput.SEQ
	End If	

	If hasown(oJSONoutput, "SVAL") = "ok" Then 
		sval = oJSONoutput.SVAL
	End If	

	If hasown(oJSONoutput, "BTNTYPENO") = "ok" Then 
		btntypeno = oJSONoutput.BTNTYPENO
	End If	

	Select Case CDbl(btntypeno)
	Case 0 : btnfield = "Link"
	Case 1 : btnfield = "RoleDetailNm"
	Case 3 : btnfield = "UserPhone"
	Case 4 : btnfield = "Email"
	Case Else
		Call oJSONoutput.Set("result", "100" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End Select 

	Set db = new clsDBHelper

	Select Case CDbl(btntypeno)
	Case 3,4
		TN = "tblMember "
		SQL = "update " & TN & " Set "&btnfield&" =  '"&sval&"'  where MemberIDX =  " & seq
		Call db.execSQLRs(SQL , null, T_ConStr)
	Case 0,1
		TN = "tbladminmenulist "
		SQL = "update " & TN & " Set "&btnfield&" =  '"&sval&"'  where AdminMenuListIDX =  " & seq
		Call db.execSQLRs(SQL , null, B_ConStr)
	End Select 
		
	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>