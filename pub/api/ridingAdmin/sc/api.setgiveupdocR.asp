<%
'#############################################
'기권 문서제출
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX 
	End If
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "LR") = "ok" Then '왼쪽인지 오른쪽인지
		r_lr= oJSONoutput.LR
	End If
	If hasown(oJSONoutput, "SAYOUDOC") = "ok" then
		r_sayou= oJSONoutput.SAYOUDOC
	End If






	If r_sayou = "" Then '정상으로 초기화
		SQL = "Update SD_gameMember_vs Set errDoc"&r_lr&" = ''  where idx = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
	Else

		'사유소팅순서 구하기 fn_riding.asp
		orderno = getSayooSortno(r_sayou)
		SQL = "Update SD_gameMember_vs Set errDoc"&r_lr&" = '"& r_sayou &"' where idx = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if
	'#########################################################################################


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
