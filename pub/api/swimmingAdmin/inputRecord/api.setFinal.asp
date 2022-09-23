<%
'#############################################
'결승레인배정
'#############################################

'게임 참여자의 순위 8명 (체크박스 value 값은 무조건 포함하여서) 8명을 선발한다.
'예선 기록에 따라서 결승레인을 베정 한다.
'위에 쿼리에서 바꿔야하는 값을 찾아서 업데이트 한다.

'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "GNO") = "ok" Then  '게임번호 gameno1 or gameno2
		gameno = oJSONoutput.GNO
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then  '종목키
		lidx = oJSONoutput.LIDX
	End if	
	If hasown(oJSONoutput, "GUBUN") = "ok" Then  '오전오후
		ampm = oJSONoutput.GUBUN
	End if	

	If hasown(oJSONoutput, "QMARR") = "ok" Then '선택된 sd_gameMember.gameMemberIDX
		Set midxs = oJSONoutput.QMARR

		addmembercnt = oJSONoutput.QMARR.length '추가된 명수 (이아디들은 뒤로 붙이자)
		
		For i = 0 To oJSONoutput.QMARR.length-1
				If i = 0 Then 
					chk_midx = midxs.Get(i)
				Else
					chk_midx = chk_midx & "," & midxs.Get(i)
				End if
		Next
		
		If chk_midx <> "" Then
			midxwhere = " and gameMemberIDX in ( "&chk_midx&" ) "
			notmidxwhere = " and gameMemberIDX not in ( "&chk_midx&" ) "
		End if
	End if	


	Set db = new clsDBHelper 

	'8명가져오자
	ranearr = Array(4,5,3,6,2,7,1,8) '레인배정순서

	'기록이 입력된것이 있다면 백시킨다.
	SQL =" select  count(*) from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delyn='N' and b.delyn='N' where  b.RgameLevelidx =  '"&Lidx&"' and gameresult > 0 and  gameResult < 'a' "
'Response.write sql
'Response.end
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If CDbl(rs(0)) > 0 Then
		Call oJSONoutput.Set("result", 500 ) '결승입력값 있음 결승이 진행중입니다. 
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	End if


	'결승 정보 초기화
	SQL =" update sd_gameMember set roundno = 1, sortno = 0  where gameMemberIDX in ( select gamememberidx from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  b.RgameLevelidx =  '"&Lidx&"' ) "
	Call db.execSQLRs(SQL , null, ConStr)



	'예선을 거쳐서 본선을 온거이므로...예선순위로 
	'with 해서 둘 붙여서 쓰자.	

	'합집합 UNION
	'순위멤버
	topmember = 8 - addmembercnt
	strFld = " a.gameMemberIDX,a.gubun,a.tryouttotalorder,a.tryoutresult "
	If addmembercnt > 0 Then
	strWhere = "b.RgameLevelidx =  '"&Lidx&"' and a.starttype = 1 and a.tryoutOrder > 0 " & notmidxwhere
	else
	strWhere = "b.RgameLevelidx =  '"&Lidx&"' and a.starttype = 1 and a.tryoutOrder > 0 "
	End if
	strSort = "cast(tryouttotalorder as int) asc"

	
	SQL = "		  ;with rnk_tbl1 as ("
	SQL = SQL & "Select top " &topmember& " " &strFld& " from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  "&strWhere&" order by " & strSort
	SQL = SQL & ")"


	'체크한멤버
	If addmembercnt > 0 then
		strWhere = "b.RgameLevelidx =  '"&Lidx&"' " & midxwhere
		SQL = SQL & ", rnk_tbl2 as ("	
		SQL = SQL &"Select top  "&addmembercnt&" " &strFld& " from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  "&strWhere&" order by " & strSort
		SQL = SQL & ")"
		
		SQL = SQL & "Select * from ( Select * from rnk_tbl1   union all select * from rnk_tbl2 ) as t1  order by cast(t1.tryouttotalorder as int) asc "
	Else
		SQL = SQL & "Select * from rnk_tbl1 as t1 order by cast(t1.tryouttotalorder as int) asc "	
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	i = 0

	If IsArray(arrR) Then
		For ari = LBound(arrR, 2) To UBound(arrR, 2) 
			midx =  arrR(0,ari)  'midx
			SQL = SQL & " update sd_gameMember set roundno = 1, sortno = '"&ranearr(i)&"'  where gamememberidx = '"&midx&"' "		'starttype = 3 이면 이걸로 결승부터 시작하는지 판단
			i = i + 1

		pregno = gno
		Next 
	End if
	Call db.execSQLRs(SQL , null, ConStr)





	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>