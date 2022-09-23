<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''경기중단 , 중단 시간업데이트(gamestop) , 기록관 temprecorder로 복사 후 초기화

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스

	'#################################
	Set db = new clsDBHelper
	
	SQL = "UPDATE sd_TennisResult Set  gamestop = getdate(),temprecorder = recorderName, recorderName = null  where resultIDX = " & scidx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 