<%
'#############################################
'사유 실격등
'#############################################
	
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then 
		lidx = oJSONoutput.LIDX
	End if	
	If hasown(oJSONoutput, "GNO") = "ok" Then 
		gno = oJSONoutput.GNO
	End if	

	If hasown(oJSONoutput, "INVAL") = "ok" Then  'a b c 또는 공백
		inval = oJSONoutput.INVAL
	Else
		inval = "00000" '숫자로 저장
	End if	
	
	Set db = new clsDBHelper 
	SQL = " select gametitleidx,gbidx,  gubunam,gubunpm,gameno,gameno2     from tblRGameLevel where RgameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		tidx = rs(0)
		gbidx = rs(1)
		gubunam = rs(2)
		gubunpm = rs(3)
		gameno = rs(4)
		gameno2 = rs(5)
	End if

	SQL = " select starttype,tryoutgroupno,roundno from SD_gameMember where gameMemberIDX = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		starttype = rs(0)
		tryoutgroupno = rs(1)
		roundno = rs(2)
	End if



	'개인결과 저장
		SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
		updatetype = "A" 
		Call db.execSQLRs(SQL , null, ConStr)


	'(경기번호) 부별 순위 산정
		resultfld = "tryoutresult"
		gnofld = "tryoutgroupno"
		groupno = tryoutgroupno
		orderfld = "tryoutOrder"


		wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and "&resultfld&" > 0  and tryoutresult < 'a'  " '업데이트 대상
		Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By tryoutresult asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>