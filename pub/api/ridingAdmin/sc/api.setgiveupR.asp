<%
'#############################################
'기권 실격저장 (릴레이 라운드별 처리)
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX 
	End If
	If hasown(oJSONoutput, "IDX") = "ok" Then 'idx
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "SAYOU") = "ok" then
		r_sayou= oJSONoutput.SAYOU
	End If
	If hasown(oJSONoutput, "LR") = "ok" Then '왼쪽인지 오른쪽인지
		r_lr= oJSONoutput.LR
	End If

	If hasown(oJSONoutput, "CHKTYPE") = "ok" then
		r_chktype= oJSONoutput.CHKTYPE '진행중에 넘어왔는지 확인 (ING)
	End If



	'W인경우

	'@@@@@@@@@@@@@@@@@@@@@@@@	
		'tryoutresult, tryoutdocYN
		If r_sayou = "" Then '정상으로 초기화
			SQL = "Update SD_gameMember_vs Set err"&r_lr&" = ''  where idx = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)
		Else

			'사유소팅순서 구하기 fn_riding.asp
			orderno = getSayooSortno(r_sayou)
			SQL = "Update SD_gameMember_vs Set err"&r_lr&" = '"& LCase(r_sayou) &"' where idx = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		oJSONoutput.SAYOU = "W" '다시 reload 하려면



		'심사입력에서 넘어온 경우라면 랭킹처리
		If r_chktype = "ING" Then '심사입력에서 넘어온경우 집계 다시 호출 ( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType)
			'ordertype = GetOrderType( o_classHelp, o_teamgb, o_class)
			'Call orderUpdate( db, tidx, gbidx,  o_pubcode, o_roundno, ordertype) 'pubcode 0 으로 보내면 검색해서 각각 적용 A, A_1
		End if




  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
