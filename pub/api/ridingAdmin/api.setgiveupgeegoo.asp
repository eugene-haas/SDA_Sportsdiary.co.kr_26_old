<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX 
	End If
	If hasown(oJSONoutput, "IDX") = "ok" Then 'gamememberidx
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" then
		r_ridx= oJSONoutput.RIDX
	End If
	If hasown(oJSONoutput, "SAYOU") = "ok" then
		r_sayou= oJSONoutput.SAYOU
	End If

	If hasown(oJSONoutput, "CHKTYPE") = "ok" then
		r_chktype= oJSONoutput.CHKTYPE '진행중에 넘어왔는지 확인 (ING)
	End If


	'@@@@@@@@@@@@@@@@@@@@@@@@	
		'gameresult, docYN
		If r_sayou = "" then
			SQL = "Update SD_tennisMember Set tryoutresult = 0  where gameMemberIDX = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "Update tblGameRequest Set gameresult = 0 where RequestIDX = " & r_ridx '기권실격 0기본 ERWD
			Call db.execSQLRs(SQL , null, ConStr)
		Else
			SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_sayou) &"'  where gameMemberIDX = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "Update tblGameRequest Set gameresult = '"& LCase(r_sayou) &"' where RequestIDX = " & r_ridx
			Call db.execSQLRs(SQL , null, ConStr)
		End if



		If r_chktype = "ING" Then '심사입력에서 넘어온경우 집계 다시 호출 ( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType)


			Select Case  LCase(r_sayou) 
			Case "h" : resultno = 201 '대사검사 불합격(출혈 및 부종)
			Case "i" : resultno = 202 '대사검사 불합격(출혈)
			Case "j" : resultno = 203 '대사검사 불합격(피로도)
			Case "k" : resultno = 204 '보행검사 불합격
			Case "l" : resultno = 205 '보행검사, 대사검사 불합격(피로 및 파행)
			Case "e" : resultno = 200 '실권
			Case "r" : resultno = 300 '기권 진행중
			Case "w" : resultno = 400 ' 기권 시작전
			Case "d" : resultno = 500 '실격
			Case Else : resultno = "" 
			end select 

			SQL = "update sd_gameMember_geegoo Set total_result = '"&resultno&"'  where GameMemberIDX = " &  r_idx
			Call db.execSQLRs(SQL , null, ConStr)

			groupno = "(select top 1 groupno from sd_gameMember_geegoo where gameMemberIDx = "&r_idx&" )"
			'순위 산정  -- or ( tryoutresult in ('r','e') )) 
			wherestr = " total_result <= 300 and groupno = " & groupno    '업데이트 대상 (R, E 는 대상 )

			Selecttbl = "( SELECT total_order,RANK() OVER (Order By case when total_result > 200 then 200 else total_result end asc, ordersortdata asc) AS RowNum FROM sd_gameMember_geegoo where "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)

		End if


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
