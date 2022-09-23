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

	TN = "tbladminmenulist "
	idxfield = "AdminMenuListIDX"

	Select Case CDbl(btntypeno)
	Case 0 : btnfield = "PopupYN"
	Case 1 : btnfield = "UseYN"
	Case 10 
		btnfield = "UseYN"
		TN = "tblAdminMember "
		idxfield = "AdminMemberIDX"
	Case Else
		Call oJSONoutput.Set("result", "100" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End Select 


	Set db = new clsDBHelper

	SQL = "update " & TN & " Set "&btnfield&" =  case when "&btnfield&" = 'Y' then 'N' else 'Y' end  where "&idxfield&" =  " & seq
	Call db.execSQLRs(SQL , null, B_ConStr)
	
	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>