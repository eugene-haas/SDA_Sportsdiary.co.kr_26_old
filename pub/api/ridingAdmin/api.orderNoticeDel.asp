<%
'#############################################
'선수 정보 수정 ( 이름은 변경 되지 않습니다.)
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX 'tblRGameLevel 인덱스
	End if

	If hasown(oJSONoutput, "SNO") = "ok" Then
		r_sno = oJSONoutput.SNO '클릭된곳의 sortno
	End if



	Set db = new clsDBHelper 

	'삭제
	SQL = "delete from  tblGameNotice where RgameLevelIDX = '"&r_idx&"' and sortno = '"&r_sno&"' "
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
  %>