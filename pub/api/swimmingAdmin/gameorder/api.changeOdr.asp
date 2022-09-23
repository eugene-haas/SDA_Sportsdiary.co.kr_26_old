<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 'tblRGameLevel.RGameLevelidx
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "CNGTYPE") = "ok" Then '1위 2아래
		cngtype = oJSONoutput.CNGTYPE
	End if	

	If hasown(oJSONoutput, "AMPM") = "ok" Then 'AM,PM
		ampm = oJSONoutput.AMPM
	End if	


	Set db = new clsDBHelper

	'자기정보 AM
	If ampm = "AM" Then
		fld = " RgameLevelidx,gametitleidx, gubunam,tryoutgamedate,tryoutgamestarttime,gameno,tryoutgameingS "
		gnostr = " gameno "
		tmstr = " tryoutgamestarttime "
		gubunstr = " gubunam "
		dtstr = " tryoutgamedate "
	Else
		fld = " RgameLevelidx,gametitleidx, gubunpm,finalgamedate,finalgamestarttime,gameno2,finalgameingS "
		gnostr = " gameno2 "
		tmstr = " finalgamestarttime "
		gubunstr = " gubunpm "
		dtstr = " finalgamedate "
	End if

	  SQL = "Select "&fld&" from tblRGameLevel where RgameLevelidx = " & midx
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If

	'Call getrowsdrow(arrR)


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			tidx =  arrR(1,ari) 
			gubun = arrR(2,ari) '오전 오후
			gamedate = arrR(3,ari) '경기일자
			starttim = arrR(4,ari) '시작시간
			gno = arrR(5, ari) '경기번호
			gameing = arrR(6, ari) '내경기시간
		Next
	End if

	'1대1로만 바꾸자
	If cngtype = "1" Then '위로버튼

			'자기보자 tidx 에서 lidx 가 작은 1개와 바꾼다.
			'경기번호와 경기 진행을 계산해서 바꾼다.
			strwhere = " delyn = 'N' and gametitleidx = "&tidx&" and "&gubunstr&" > 0 and "&dtstr&" = '"&gamedate&"' and "&gnostr&" < "&gno&" order by " & gnostr & "  desc"
			SQL = "select top 1 "&fld&" from tblRGameLevel where " & strwhere 

'Response.write sql
'Response.end


			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			changeidx = rs(0)
			mytm = rs(4) '대상의 시간을 나한테
			targettm = getNextStartTime(mytm, gameing) '대상의 시간에 나의 진행시간을 더해서


			'위에 있던아이
			SQL = " update  tblRGameLevel set "&gnostr&" = "&gnostr&" + 1,"&tmstr&" = '"&targettm&"'  where RgameLevelidx =  " & changeidx

			'자기
			SQL = SQL &  " update  tblRGameLevel set "&gnostr&" = "&gnostr&" - 1,"&tmstr&" = '"&mytm&"'  where RgameLevelidx = " & midx 
			Call db.execSQLRs(SQL , null, ConStr)		

	Else '아래로 버튼

			strwhere = " delyn = 'N' and gametitleidx = "&tidx&" and "&gubunstr&" > 0 and "&dtstr&" = '"&gamedate&"' and "&gnostr&" > "&gno&" order by " & gnostr & "  asc"
			SQL = "select top 1 "&fld&" from tblRGameLevel where " & strwhere 

'Response.write sql
'Response.end


			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			changeidx = rs(0)
			targettm = rs(4) 
			targeting = rs(6)
			mytm = getNextStartTime(starttim, targeting)				

			'Response.write starttim
			'Response.end

			'아래 있던아이
			SQL = " update  tblRGameLevel set "&gnostr&" = "&gnostr&" - 1,"&tmstr&" = '"&starttim&"'  where RgameLevelidx =  " & changeidx

			'자기
			SQL = SQL &  " update  tblRGameLevel set "&gnostr&" = "&gnostr&" + 1,"&tmstr&" = '"&mytm&"'  where RgameLevelidx = " & midx 
			Call db.execSQLRs(SQL , null, ConStr)		

	End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>