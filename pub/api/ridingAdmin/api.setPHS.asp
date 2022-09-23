<%
	'request 처리##############
	
	tidx = oJSONoutput.TIDX
	gbidx = oJSONoutput.GBIDX
	gtype = oJSONoutput.GTYPE
	selectvalue = oJSONoutput.VALUE

	Set db = new clsDBHelper

	If gtype = "1" then
	SQL = "update tblRGameLevel Set horselimit = '"&selectvalue&"' where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
	Else
	SQL = "update tblRGameLevel Set horselimit2 = '"&selectvalue&"' where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
	End if
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>