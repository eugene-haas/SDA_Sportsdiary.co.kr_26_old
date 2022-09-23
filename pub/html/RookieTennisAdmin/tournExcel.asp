<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<head>
<title>excel</title>
</head>
<body >

<%
'request
idx = chkInt(chkReqMethod("idx", "GET"), 1)
tidx = chkInt(chkReqMethod("tidx", "GET"), 1)

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = "select GameTitleName  from sd_TennisTitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gametitle = rs(0)


	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,teamGbnm from  tblRGameLevel  where DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
        bigo=rs("bigo")
		endround = rs("endround") '진행될 최종라운드
		teamgbnm = rs("teamGbnm")
	End if
'기본정보#####################################

	'예선총명수로 참가자 명수 확정
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (0, 1)  and DelYN = 'N' "
		SQL = "SELECT  COUNT(*) as gcnt,max(tryoutgroupno) from "&strtable&" where "&strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		tcnt = 0
		attmembercnt = 0
		joono = 1

		If CDbl(rs(0)) > 0 Then
			attmembercnt = rs("gcnt")			'총참가자(sorting 마지막 번호)
			joono = rs(1)	'조번호
			tcnt = CDbl(joono) * 2				'토너먼트 총참가자
		End If

	'예선총명수로 참가자 명수 확정

		'endround 2 , 4 ,8 , 16, 32, 64
		Select Case CDbl(endround)
		Case 2 : hideRDcnt = 0
		Case 4 : hideRDcnt = 1
		Case 8 : hideRDcnt = 2
		Case 16 : hideRDcnt = 3
		Case 32 : hideRDcnt = 4
		Case 64 : hideRDcnt = 5
		End Select 

	'강수 계산##############
		if tcnt <=2 then
		drowCnt = 2
		depthCnt = 2
		elseif tcnt >2 and tcnt <=4 then
		drowCnt = 4
		depthCnt = 3
		elseif tcnt >4 and tcnt <=8 then
		drowCnt=8
		depthCnt = 4
		elseif tcnt >8 and  CDbl(tcnt) <=16 then
		drowCnt=16
		depthCnt = 5
		elseif tcnt >16 and  tcnt <=32 then
		drowCnt=32
		depthCnt = 6
		elseif tcnt >32 and  tcnt <=64 then
		drowCnt=64
		depthCnt = 7
		elseif tcnt >64 and  tcnt <=128 then
		drowCnt=128
		depthCnt = 8
		elseif tcnt >128 and  tcnt <=256 then
		drowCnt=256
		depthCnt = 9
		end if 
	'강수 계산##############


'본선정보
'#############################
	strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= 2  and a.playerIDX > 1 " 
	strsort = " order by a.Round asc,a.SortNo asc"

	strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
	strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount


'Call rsdrow(rs)
'Response.end


	If Not rs.EOF Then 
	arrT = rs.getrows()
	End If
'#############################


'본선 정보, 스코어 정보 function
'#############################

	
	ranknames = ""
	Sub tournInfo(ByVal arrRS , ByVal rd, i)
		Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
		Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
		Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno,n
		chkmember = False
		temp_sortno = 0
		
		If IsArray(arrRS) Then

			For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
				m1pidx			= arrRS(11, ar) 
				m1idx				= arrRS(0, ar) 
				m1name			= arrRS(1, ar)  
				m1teamA			= arrRS(2, ar) 
				m1teamB			= arrRS(3, ar) 
				mrd					= arrRS(4, ar) 
				msortno			= arrRS(5, ar) 
				m2name			= arrRS(6, ar) 
				m2teamA			= arrRS(7, ar) 
				m2teamB			= arrRS(8, ar) 
				mgubun			= arrRS(9, ar) 
				mchange			= arrRs(10,ar)
				nextround		= CDbl(mrd) + 1

				mrndno1			= arrRs(12,ar)
				mrndno2			= arrRs(13,ar)
				mtrank			= arrRs(14,ar)
				mtryoutgroupno = arrRs(15,ar)

				If m1teamB = "" Then
					m1team = m1teamA
				else
					m1team = m1teamA & ", " & m1teamB
				End If
				If m2teamB = "" Then
					m2team = m2teamA
				else
					m2team = m2teamA & ", " & m2teamB
				End If


				If CDbl(rd) = CDbl(mrd) Then

					'다음 라운드 진출자로 등록 되었는지 확인
					'프린트한 선수는 다음 검색에서 제외
					notprint = false
					If ranknames <> "" then
						rksplit = Split(ranknames, ",")
						For n = 0 To ubound(rksplit)
							If rksplit(n) = m1name Then
									notprint = True
									Exit for
							End if
						Next
					End if
					
							
					If notprint = False then
						%>
						<tr>
							<%If i = 1 then%>
							<td><%=1%></td>
							<%else%>
							<td><%=2^(i-1)%></td>
							<%End if%>

							<td><%=m1name%></td>
							<td><%=m1team%></td>
							<td><%=m2name%></td>
							<td><%=m2team%></td>
						</tr>
					<%
					End If
					
					'다음 라운드 진출자로 등록 되었는지 확인
					'프린트한 선수는 다음 검색에서 제외
					If ranknames = "" then
						ranknames = m1name
					Else
						ranknames = ranknames & "," & m1name
					End if


				End if
			Next


		End If
	End Sub
	

'#############################

'32강까지의 round 값을 구한다.
Dim roundnoArr(6)
n = 1
For i = depthCnt To 1 Step -1
	roundnoArr(n) = i
	If n = 6 Then
		Exit for
	End if
n = n + 1
Next

'xlsConnString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & xlsFile & "; Extended Properties=Excel 12.0;"

Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename="&gametitle&"("&teamgbnm&")_"&date()& ".xls"



%>

<table border="1">
<tr>
	<td>순위</td>
	<td>이름</td>
	<td>팀</td>
	<td>이름</td>
	<td>팀</td>
<tr>
<%For i = 1 To 6%>
	<%Call tournInfo(arrT, roundnoArr(i), i )%>
<%Next%>
</table>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
