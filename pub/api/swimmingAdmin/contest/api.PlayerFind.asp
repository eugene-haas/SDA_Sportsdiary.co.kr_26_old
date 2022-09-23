<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 'level idx 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if

	Set db = new clsDBHelper

	IF LEN(searchText) = 1 Then
		top = "top 20"
	ELSEIF LEN(searchText) = 2 Then
		top = "top 20"
	END IF


	Set db = new clsDBHelper

	'참가 신청하지 않은 유저 중에 검색작업할것
	SQL = " Select top 20 playeridx,username,teamnm,userclass,kskey,team,sex,sido,sidocode,left(birthday,6) as birthday from tblplayer where username like '"& sval &"%' and delyn = 'N' and usertype = 'I' " '개인만 검색
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>