<%
	seq = oJSONoutput.get("SEQ")
	sval = oJSONoutput.get("SVAL")
	btntypeno = oJSONoutput.get("BTNTYPENO")

	TN = "tbladminmenulist "
	idxfield = "AdminMenuListIDX"


	Set db = new clsDBHelper

	Select Case CDbl(btntypeno)
	Case 0 : btnfield = "PopupYN"
	Case 1 : btnfield = "UseYN"
	Case 10 
		btnfield = "UseYN"
		TN = "tblAdminMember "
		idxfield = "AdminMemberIDX"
	case 20
 
		''DisplayKey aID userid or aNM adminname 필드명으로 
		SQL = "update tblAdminMember Set displaykey =  case when displaykey = 'aID' then 'aNM' else 'aID' end  where AdminMemberIDX =  " & seq
		Call db.execSQLRs(SQL , null, B_ConStr)

		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		db.Dispose
		Set db = Nothing
		response.end


	Case Else
		Call oJSONoutput.Set("result", "100" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End Select 


	

	SQL = "update " & TN & " Set "&btnfield&" =  case when "&btnfield&" = 'Y' then 'N' else 'Y' end  where "&idxfield&" =  " & seq
	Call db.execSQLRs(SQL , null, B_ConStr)
	
	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>