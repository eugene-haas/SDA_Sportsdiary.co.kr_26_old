<%
'#############################################
'플레이어 목록 검색
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "searchtxt") = "ok" then
		searchtxt = fInject(oJSONoutput.searchtxt)
	else
	searchtxt = ""
	End if

	SQL = "select top 20 playeridx as pidx,kskey as kidx ,(username +' : '+ teamnm) as title from tblplayer where delyn = 'N' and userType = 'I'  and username like '"&searchtxt&"%' "
	Set rs = db.ExecSQLReturnRS(sql , null, ConStr)


	
	If  rs.eof Then
		response.write "{""jlist"": ""nodata""}"
		Set rs = Nothing
		db.Dispose
		Set db = Nothing	
		response.end
	Else

			listarr = jsonTors_arr(rs)

			Set list = JSON.Parse( join(array(listarr)) )
			strjson = JSON.stringify(list)
			strjson = "{""jlist"":" & strjson & "}"
			Response.Write strjson
	End if

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
%>
