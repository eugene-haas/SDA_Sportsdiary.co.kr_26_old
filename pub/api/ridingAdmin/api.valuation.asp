<%
'#############################################

'순서항목추가.

'#############################################
	'request
	If hasown(oJSONoutput, "BOXNO") = "ok" Then '입력 박스번호 
		boxno= oJSONoutput.BOXNO
	End If
	If hasown(oJSONoutput, "TYPENO") = "ok" Then  '1 운동과목, 2 종합관찰
		typeno= oJSONoutput.TYPENO
	End If
	If hasown(oJSONoutput, "IDXS1") = "ok" Then 
		idxs1= oJSONoutput.IDXS1
	End If
	If hasown(oJSONoutput, "MIDX") = "ok" Then 'gamememberidx
		midx= oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "INPUT") = "ok" Then '입력값
		input= htmlEncode(oJSONoutput.INPUT)
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then
		gbidx= oJSONoutput.GBIDX
	End If
	If hasown(oJSONoutput, "AREA") = "ok" Then
		area= oJSONoutput.AREA
	End If
	If hasown(oJSONoutput, "IDX") = "ok" Then
		idx= oJSONoutput.IDX
	End If

	If input = "" Then
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	Set db = new clsDBHelper 

	Select Case CStr(typeno)
	Case "1","2" '운동과목 ,종합관찰

		SQL = "IF EXISTS (Select top 1 seq from tblJudgeDetail where gamememberidx = "&midx&" and idxs1 = "&idxs1&" and areanm = '"&area&"' )  "
		Select Case CStr(boxno)
		Case "1" '채점
		SQL = SQL & " update tblJudgeDetail Set val1 = " & input  & " where gamememberidx = "&midx&" and idxs1 = "&idxs1&" and areanm = '"&area&"' "
		SQL = SQL & " ELSE  insert into tblJudgeDetail (areanm, tidx,gbidx, gamememberidx , idxs1, testtype , val1 ) values ('"&area&"',"&tidx&","&gbidx&", "&midx&","&idxs1&","&typeno&","&input&") "
		Case "2" '수정
		SQL = SQL & " update tblJudgeDetail Set val2 = " & input  & " where gamememberidx = "&midx&" and idxs1 = "&idxs1&" and areanm = '"&area&"' "
		SQL = SQL & " ELSE  insert into tblJudgeDetail (areanm, tidx,gbidx, gamememberidx , idxs1, testtype , val2 )  values  ('"&area&"',"&tidx&","&gbidx&","&midx&","&idxs1&","&typeno&","&input&") "
		Case "3" '비고
		SQL = SQL & " update tblJudgeDetail Set rmk = '" & input  & "' where gamememberidx = "&midx&" and idxs1 = "&idxs1&" and areanm = '"&area&"' "
		SQL = SQL & " ELSE  insert into tblJudgeDetail (areanm, tidx,gbidx, gamememberidx , idxs1, testtype , rmk )  values  ('"&area&"',"&tidx&","&gbidx&","&midx&","&idxs1&","&typeno&",'"&input&"') "
		End Select 
		Call db.execSQLRs(SQL , null, ConStr)

	Case "3" '감점사항, 경로위반 저장

		SQL = "IF EXISTS (Select top 1 seq from tblJudgeDetail where gamememberidx = "&midx&" and idx = "&idx&" and areanm = '"&area&"' )  " 'tblTeamGbInfoDetail.idx
		Select Case CStr(boxno)
		Case "4" '감점
		SQL = SQL & " update tblJudgeDetail Set val1 = " & input  & " where gamememberidx = "&midx&" and idx = "&idx&" and areanm = '"&area&"' "
		SQL = SQL & " ELSE  insert into tblJudgeDetail (areanm, tidx,gbidx, gamememberidx , idx, testtype , val1 ) values ('"&area&"',"&tidx&","&gbidx&", "&midx&","&idx&","&typeno&","&input&") "
		Case "5" '경로위반횟수
		SQL = SQL & " update tblJudgeDetail Set val2 = " & input  & " where gamememberidx = "&midx&" and idx = "&idx&" and areanm = '"&area&"' "
		SQL = SQL & " ELSE  insert into tblJudgeDetail (areanm, tidx,gbidx, gamememberidx , idx, testtype , val2 )  values  ('"&area&"',"&tidx&","&gbidx&","&midx&","&idx&","&typeno&","&input&") "
		End Select 
		Call db.execSQLRs(SQL , null, ConStr)

	End Select 

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
