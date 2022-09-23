<%
	'여러사이트 등록
		session_scode = session("scode")
		if session_scode <> "" then
			sitecode = session_scode
		end if
	'여러사이트 등록

	seq = oJSONoutput.get("SEQ")
	sval = oJSONoutput.get("SVAL")
	btntypeno = oJSONoutput.get("BTNTYPENO")

	Select Case CDbl(btntypeno)
	Case 0 : btnfield = "Link"
	Case 1 : btnfield = "RoleDetailNm"
	Case 3 : btnfield = "UserPhone"
	Case 4 : btnfield = "Email"
	case 5 : btnfield = "ImgLink"
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
	case 5
		TN = "tbladminmenulist "
		SQL = "update tbladminmenulist Set ImgLink = '"&sval&"' where roledepth = 1 and sitecode = '"&sitecode&"' "
		SQL = SQL & " and RoleDetailGroup1 = ( select RoleDetailGroup1 from tbladminmenulist where sitecode = '"&sitecode&"' and AdminMenuListIDX =  "&seq&")	"
		Call db.execSQLRs(SQL , null, B_ConStr)		

	End Select 
		
	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>