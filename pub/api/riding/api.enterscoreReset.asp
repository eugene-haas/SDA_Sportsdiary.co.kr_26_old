<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''뒤로 가기 경기리셋

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스

	'#################################
	Set db = new clsDBHelper
	
	'검색해보고 경기가 종료 되었다면 리셋하지 말것 (수정상태임)
	SQL = "select stateno,gameMemberIDX1,gameMemberIDX2 from sd_TennisResult where stateno = 1 and resultIDX = " &scidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then

		
		setfield = " m1set1 = 0, m1set2 = 0, m1set3= 0,   m2set1 = 0, m2set2 = 0, m2set3= 0, tempRecorder =recorderName,recorderName = null , startserve = 0, secondserve = 0, startrecive = 0, secondrecive = 0,preresult = 'ING'   "
		setfield = setfield & " , court1playerIDX = null, court2playerIDX = null, court3playerIDX = null, court4playerIDX = null,gamestart=null,gamestop=null,gamerestart=null,leftetc=0,rightetc=0,lastupdate=getdate() "
		setfield = setfield & "  , set1end = null, set2end = null, set3end = null,stateno = 0,courtmode=0  "

		SQL = "UPDATE sd_TennisResult Set  "&setfield&"  where resultIDX = " & scidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Delete from sd_TennisResult_record where resultIDX = " & scidx
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		'라운드 결과 진출자 지우기( 결과가 나온상태에서 취소할때) 수정에서 특정영역 클릭시 실행 작업할것
		'SQL = "delete from sd_tennisMember where gameMemberIDX1 = "&rs(1)&"  or gameMemberIDX2 = "&rs(2)&" "		
	End if

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 