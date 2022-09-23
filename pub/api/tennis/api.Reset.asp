<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''1서브 지정후 수정버튼 클릭시 초기화

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스

	Set db = new clsDBHelper
	
	setfield = " m1set1 = 0, m1set2 = 0, m1set3= 0,   m2set1 = 0, m2set2 = 0, m2set3= 0, startserve = 0, secondserve = 0, startrecive = 0, secondrecive = 0,preresult = 'ING'   "
	setfield = setfield & " , court1playerIDX = null, court2playerIDX = null, court3playerIDX = null, court4playerIDX = null,gamestart=null,gamestop=null,gamerestart=null,leftetc=0,rightetc=0,lastupdate=getdate() "
	setfield = setfield & "  , set1end = null, set2end = null, set3end = null,stateno = 2,courtmode=0  "

	SQL = "UPDATE sd_TennisResult Set  "&setfield&"  where resultIDX = " & scidx
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "Delete from sd_TennisResult_record where resultIDX = " & scidx
	Call db.execSQLRs(SQL , null, ConStr)
	'###################




	Call oJSONoutput.Set("targeturl", "enter-score.asp" )
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 