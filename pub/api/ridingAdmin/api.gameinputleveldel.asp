<%
'#############################################

'종목 전체 업데이트

'#############################################
	'request
	e_idx = oJSONoutput.IDX
	Set db = new clsDBHelper


	'subSQL = " (select top 1 GbIDX from tblRGameLevel where RGameLevelidx = " & e_idx & ")"
	SQL = "select top 1 GbIDX,GameTitleIDX from tblRGameLevel where RGameLevelidx = " & e_idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then

		'통합부에서 합침때 복구됨 (추후 트리거 생성 요) 삭제에도....
		d_gbidx = rs("gbidx")
		d_tidx = rs("gametitleidx")



		'############진행된 경기가 있는 지 확인 리턴
		Sql = "select top 1 *  from  sd_tennisMember  where gamekey3 = " & d_gbidx & " and GameTitleIDX = " & d_tidx & " and score_total > 0 "
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr) 'B_ConStr (종목관리가 설정되어있어야한다.)

		'먼저 들어가 있어야한다.
		If Not rs2.EOF Then
			Call oJSONoutput.Set("result", "9999" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.end
		End if
		'############진행된 경기가 있는 지 확인 리턴






		'Sql = "update  tblRGameLevel Set   DelYN = 'Y' where gbIDX = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		SQL = "Delete from tblRGameLevel where gbIDX = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		Call db.execSQLRs(SQL , null, ConStr)



		'참가자도 지우자.
		'Sql = "update  tblGameRequest Set   DelYN = 'Y' where gbIDX = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		Sql = "Delete from tblGameRequest where gbIDX = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		Call db.execSQLRs(SQL , null, ConStr)



		'대회 진행 통합으로 변경
		'Sql = "update  sd_tennisMember Set DelYN = 'Y' where gamekey3 = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		Sql = "Delete from  sd_tennisMember  where gamekey3 = " & d_gbidx & " and GameTitleIDX = " & d_tidx
		Call db.execSQLRs(SQL , null, ConStr)

	End if


   e_idx = ""
	%><!-- #include virtual = "/pub/html/riding/gameinfolevelform.asp" --><%

  db.Dispose
  Set db = Nothing
%>
