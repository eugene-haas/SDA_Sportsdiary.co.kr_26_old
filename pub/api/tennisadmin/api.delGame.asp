<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2
levelno = Split(fstr2,",")(0)
boonm = Split(fstr2,",")(1)

Set db = new clsDBHelper


'######################

	'gubun 이 2 인것이 없다면 본선 진출된것이 없다면
	SQL = "select count(*) from sd_TennisMember where  delYN = 'N' and GameTitleIDX = "&tidx&" and  gamekey3 = '"&levelno&"' and gubun >= 2"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	chkcnt = rs(0)

'Response.write sql
'Response.end

	If CDbl(chkcnt) = 0 then
		SQL = "delete from tblGameRequest where SportsGb = 'tennis' and GameTitleIDX = "&tidx&" and Level = '"&levelno&"' and UserName = '운영자' "
		'Call db.execSQLRs(SQL , null, ConStr)

		strWhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " "
		SQL = "DELETE From sd_TennisMember From sd_TennisMember As a Left Join sd_TennisMember_partner As b On a.gameMemberIDX = b.gameMemberIDX Where " & strWhere
		'Call db.execSQLRs(SQL , null, ConStr)

		msg = "참가 등록된 선수가 삭제 되었습니다....완료<br>"
	Else
		msg = "본선 진출자가 있어 삭제 할 수 없습니다.<br>"
	End if
'######################


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

Response.write  msg


db.Dispose
Set db = Nothing
%>