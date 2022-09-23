<%
'######################
'참가신청완료
'######################

'{"pg":1,"tidx":23,"name":"참가종목선택","subtype":"2","chkgame":"121,루키:122,CAT3:","CMD":300,"levelidx":121,"teamnm":"팀명칭"}

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If

	If hasown(oJSONoutput, "levelidx") = "ok" Then 
		levelidx = oJSONoutput.levelidx
	End If

	If hasown(oJSONoutput, "teamnm") = "ok" Then '팀명칭
		teamnm = oJSONoutput.teamnm
	End If

	'##############################
	Set db = new clsDBHelper


'	If stateRegExp(teamnm ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
'		Call oJSONoutput.Set("result", "300" ) '사용하면 안되는 문자발생
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.end
'	End if

	'팀명칭 중복확인
	SQL = "select  teamnm from  sd_bikeRequest as a inner join sd_bikeLevel as b ON a.titleIDX = b.titleIDX and a.levelno = b.levelno  where a.titleIDX = "&tidx&" and b.levelIDX = " & levelidx & " and a.teamnm = '"&teamnm&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "300" ) '중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
