<%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "BASEDATE") = "ok" then
		fidx = oJSONoutput.BASEDATE
	End if
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if

	Set db = new clsDBHelper

	'진행상태 확인하고 변경 불가 한지 파악한다.

	'날짜 정보 가져오기
		SQL = "select idx,gamedate,am,pm,selectflag,gameno from sd_gameStartAMPM where idx = "& fidx 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			gamedate = rs(1)
			gamedate = Replace(gamedate,"/","-")
			am = rs(2)
			pm = rs(3)
			dayno = rs(5) '경기 날짜 순서 번호 (경기번호 조합에 쓴다)
		End If

	
		updatefld1 = " gubunam=0 ,tryoutgamedate = null ,tryoutgamestarttime = null ,tryoutgameingS = '0' ,gameno= '0',joono='0' "
		updatefld2 = " ,gubunpm=0, finalgamedate = null ,finalgamestarttime = null ,finalgameingS='0',gameno2= '0',joono2='0'  "
		SQL = "update tblRGameLevel Set "& updatefld1 & updatefld2 &" where gametitleidx = "&tidx&" and (tryoutgamedate = '"&gamedate&"' or finalgamedate = '"&gamedate&"' )"
		Call db.execSQLRs(SQL , null, ConStr)

		'해당 날짜도 삭제
		SQL = "delete from sd_gameStartAMPM  where idx = "& fidx 
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


