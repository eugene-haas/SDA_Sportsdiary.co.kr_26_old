<%

'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request



	rgameMemberIDX = oJSONoutput.GAMEMEMBERIDX
	rpoint1 = oJSONoutput.RPOINT

	Set db = new clsDBHelper

	updatevalue = " rankpoint = " & rpoint1 
	SQL = " Update sd_tennismember Set  " & updatevalue & " WHERE DelYN = 'N' AND gameMemberIDX= " & rgameMemberIDX

	Call db.execSQLRs(SQL , null, ConStr)

	updatevalue = " rankpoint = 0"
	SQL = " Update sd_TennisMember_partner Set  " & updatevalue & " WHERE gameMemberIDX= " & rgameMemberIDX
	
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
