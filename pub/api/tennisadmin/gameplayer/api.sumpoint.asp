<%
'#############################################
'동일 이름의 포인트 정보를 클릭한 아이디로 모두 합친다.
'#############################################
	'request
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	End If
	If hasown(oJSONoutput, "PNAME") = "ok" then
		pname = oJSONoutput.PNAME
	End If

	Set db = new clsDBHelper



	rnkquery = "(SELECT sum(getpoint) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹포인트' "
	rnkcount = "(SELECT count(*) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹갯수' "
	strTableName = " tblPlayer as a "
	strFieldName = " PlayerIDX,UserName as '이름',UserPhone as '핸드폰',Birthday as '생일',teamNm as '팀1',team2Nm as '팀2',WriteDate,dblrnk as '승급반영',levelup as '승급년도',openrnkboo  as '오픈부반영' "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&"  "
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"
	strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and playeridx = " & pidx

	SQL = "Select "&strFieldName&" from "&strTableName&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'>랭킹포인트내역통합</h3>
</div> 		
최종 통합될 선수<br>

<%Call rsDrow(rs)%>


<%
	rnkquery = "(SELECT sum(getpoint) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹포인트' "
	rnkcount = "(SELECT count(*) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹갯수' "
	strTableName = " tblPlayer as a "

	strFieldName = " '<input type=""checkbox"" name=""sm_nm"" value=""'+CAST(PlayerIDX AS varchar(12))+'"">',  "
	strFieldName = strFieldName & " PlayerIDX,UserName as '이름',UserPhone as '핸드폰',Birthday as '생일',teamNm as '팀1',team2Nm as '팀2',WriteDate,dblrnk as '승급반영',levelup as '승급년도',openrnkboo  as '오픈부반영' "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&"  "
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"
	strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and username = '" & pname & "' and playeridx <> " & pidx

	SQL = "Select "&strFieldName&" from "&strTableName&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>

통합하고 싶은 아이디를 선택해 주세요<br>
<%Call rsDrow(rs)%>

<div style="text-align:center;">
<%
	strjson = JSON.stringify(oJSONoutput)
%>
<a href='javascript:mx.sumPointOK(<%=strjson%>)' class="btn">체크된 값들 통합하기</a>
</div>
<%
	
'	'동명인이 있는지 검색
'	SQL = "Select playeridx from tblPlayer where username = '"&pname&"' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then 
'		arrRS = rs.GetRows()
'	End if
'
'	i = 0
'	If IsArray(arrRS) Then
'		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
'			s_pidx = arrRS(0, ar) 
'			If CDbl(s_pidx) = CDbl(pidx) Then
'				'유지할 랭킹로그 선수
'			Else
'				'바꿀 랭킹로그
'				If i = 0 then
'					w_pidx = s_pidx
'				Else
'					w_pidx = w_pidx & "," & s_pidx
'				End If
'				i = i + 1				
'			End if
'		Next
'	End if
'
'
'	SQL = "update sd_TennisRPoint_log_2018020664239 Set PlayerIDX = "&pidx&" where PlayerIDX in (" & w_pidx & ")"
'	'Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

'일딴 목록을 생성해서 

'========================
'통합할 번호, 이름, 연락처, 포인트정보
'========================
' ㅁ  합쳐질 번호, 이름, 연락처, 포인트
' ㅁ  합쳐질 번호, 이름, 연락처, 포인트
' ㅁ  합쳐질 번호, 이름, 연락처, 포인트
'========================

%>