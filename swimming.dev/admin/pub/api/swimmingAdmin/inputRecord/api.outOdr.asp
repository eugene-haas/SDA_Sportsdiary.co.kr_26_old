<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" Then 
		ridx = oJSONoutput.RIDX
	End if	
	If hasown(oJSONoutput, "PIDX") = "ok" Then 
		pidx = oJSONoutput.PIDX
	End if	

	Set db = new clsDBHelper 

	'출전삭제
	SQL = "delete from sd_gameMember_partner where partnerIDX = '" & idx & "'"
	Call db.execSQLRs(SQL , null, ConStr)

	'플레그 업데이트 
	SQL = "update tblGameRequest_r set startMember = 'N' where delyn = 'N' and requestIDX = " & ridx & " and playeridx = " & pidx
	Call db.execSQLRs(SQL , null, ConStr)

	'소팅번호 업데이트 
	orderfld = "odrno"
	wherestr = "  delyn = 'N' and requestIDX =  '"&ridx&"'  " '업데이트 대상
	Selecttbl = "( SELECT "&orderfld&",ROW_NUMBER() OVER (Order By odrno asc) AS RowNum FROM sd_gameMember_partner where "&wherestr&" ) AS A "
	SQL = "UPDATE A  SET A."&orderfld&" = A.RowNum FROM " & selecttbl
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>