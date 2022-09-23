<%
'#############################################
'대진표 리그 조별 대진표
'#############################################
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
joonum =  oJSONoutput.JONO

stateno =  oJSONoutput.StateNo '999 게임종료 모두 막음
poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"

Set db = new clsDBHelper

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	'Response.Write SQL &"<br>"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		entrycnt = rs("entrycnt") '참가제한인원수
		attmembercnt = rs("attmembercnt") '참가신청자수
		courtcnt = rs("courtcnt") '코트수
		levelno = rs("level")
		poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
	End if

'#############################################
gamekey3 = Left(levelno,5)
gamekeyname = teamnm '부명칭

'	SQL = "select a.gameMemberIDX from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
'	SQL = SQL & "where a.gubun = 1 and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno & "  and a.tryoutgroupno =  " & joonum & " and DelYN = 'N' order by a.tryoutsortno asc" 
'	'Response.Write SQL &"<br>"
'	sd_TennisMemberCnt = 0
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	Do Until rs.eof
'	sd_TennisMemberCnt = sd_TennisMemberCnt + 1
'		if(CDbl(sd_TennisMemberCnt) = 1) Then
'			oneIdx = rs(0)
'		ELSEIF(CDbl(sd_TennisMemberCnt) = 2) Then
'			twoIdx  = rs(0)
'		ELSEIF(CDbl(sd_TennisMemberCnt) = 3) Then
'			treeIdx = rs(0)
'		END IF
'	rs.movenext
'	Loop
'
'	'Response.Write sd_TennisMemberCnt &"<br>"
'
'	IF CDbl(sd_TennisMemberCnt) = 3 Then
'		SQL = " SELECT Count(*) as Cnt FROM sd_TennisResult "
'		SQL = SQL & " where gameMemberIDX1 = " & oneIdx &" or gameMemberIDX1 = " & twoIdx &" or gameMemberIDX1 = " & treeIdx &" and delYN = 'N'"
'		'Response.Write SQL &"<br>"
'		'Response.Write "<br>"
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		ResultCnt = rs(0)
'		'Response.Write "ResultCnt:" & ResultCnt &"<br>"
'
'		IF CDbl(ResultCnt) = 0 Then
'				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
'				insertvalue = " "&oneIdx&","&twoIdx&",1,0,getdate(),"&oneIdx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &joonum 
'				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
'				'Response.Write "SQL:" & SQL &"<br>"
'				Call db.execSQLRs(SQL , null, ConStr)	
'
'				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
'				insertvalue = " "&oneIdx&","&treeIdx&",1,0,getdate(),"&oneIdx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &joonum
'				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
'				Call db.execSQLRs(SQL , null, ConStr)	
'				'Response.Write "SQL:" & SQL &"<br>"
'
'				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
'				insertvalue = " "&twoIdx&","&treeIdx&",1,0,getdate(),"&twoIdx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &joonum
'				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
'				Call db.execSQLRs(SQL , null, ConStr)	
'				'Response.Write "SQL:" & SQL &"<br>"
'			End if
'	ELSEIF CDbl(sd_TennisMemberCnt) = 2  Then
'			SQL = " SELECT Count(*) as Cnt FROM sd_TennisResult "
'			SQL = SQL & " where gameMemberIDX1 = " & oneIdx &" or gameMemberIDX1 = " & twoIdx &" and delYN = 'N'"
'			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'			ResultCnt = rs(0)
'			'Response.Write SQL &"<br>"
'			'Response.Write "<br>"
'			IF CDbl(ResultCnt) = 0 Then
'				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno "
'				insertvalue = " "&oneIdx&","&twoIdx&",1,0,getdate(),"&oneIdx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &joonum 
'				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
'				Call db.execSQLRs(SQL , null, ConStr)	
'				'Response.Write "SQL:" & SQL &"<br>"
'			END IF
'	END IF

	


	'추가 참여자서 설정된경우 기존 설정을 바꾸지 않도록 한다.

	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strresulttable = " sd_TennisResult "

	'참가자 목록 (예선 리그)
	strwhere = " a.gubun in ( 0 ,1 ) and a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno = " & joonum
	strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별
	strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint,a.gamekey1,a.gamekey2,a.gamekey3,t_win,t_lose,t_rank "
	strfield = strAfield &  ", " & strBfield 

	SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount '선수

	If Not rs.EOF Then 
		arrRS = rs.getrows()
	End If

	'조에 모든 사람의 gubun 값이 1인지 확인
	'아니라면 result 값을 보내서 경고


	'각결과 및 결과입력 상태값 
	strwhere = " a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and b.gubun in (0,1)  and a.tryoutgroupno = " & joonum 'gubun 0 예선
	strsort = " order by a.tryoutsortno asc"
	strAfield = " a. gamememberIDX as RIDX " '열 인덱스(기준)
	strBfield = " b.resultIDX as IDX, b.gameMemberIDX2 as CIDX, b.stateno as GSTATE,b.courtno,b.leftetc,b.rightetc " '1P인덱스 ,결과인덱스, 2P인덱스 ,게임상태 ( 1, 진행 , 2, 종료 여부), 코트번호
	strfield = strAfield &  ", " & strBfield 

	'SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 or a.gameMemberIDX = b.gameMemberIDX2   where " & strwhere & strsort
	SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 where " & strwhere & strsort

	'Response.Write "SQL :" & SQL & "</BR>"
	'Response.ENd
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		resultRS = rs.GetRows() 'RIDX, CIDX, GSTATE, COURTNO
	End if

	'경기 종료 확인
	gameend = true
	endgamecnt = 0
	If IsArray(resultRS) Then
		For r = LBound(resultRS, 2) To UBound(resultRS, 2)
			gamestate = resultRS(3,r)
			If gamestate = "1" Then
				endgamecnt = endgamecnt + 1
			End if
		Next
		
		If CDbl(rscnt) = CDbl(endgamecnt) Or ( CDbl(rscnt) = 2 And CDbl(endgamecnt) = 1 )  Then
			gameend = true
		End if
	End If

	'Response.Write "게임 끝났나요? :" & gameend & "</BR>"
	'경기 종료 확인

	'사용 중 (지정된 코트) 종료된경기도 보여줘야
	SQL = "Select courtno,stateno from sd_TennisResult where delYN = 'N' and GameTitleIDX = " & tidx & " and Level = '"& levelno &"' "'and preresult = 'ING' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		useCourtRS = rs.GetRows()
	End if

'#############################################
	Call oJSONoutput.Set("SCIDX", 0 ) '결과테이블 인덱스
	Call oJSONoutput.Set("P1", 0 )
	Call oJSONoutput.Set("P2", 0 )
	Call oJSONoutput.Set("P1NM", 0 )
	Call oJSONoutput.Set("P2NM", 0 )
	Call oJSONoutput.Set("WINIDX", 0 )
	Call oJSONoutput.Set("S1KEY", 0 )
	Call oJSONoutput.Set("S2KEY", 0 )
	Call oJSONoutput.Set("S3KEY", 0 )
	Call oJSONoutput.Set("POS", 0 )
	Call oJSONoutput.Set("STATENO", 0 )




	Sub vsData(ByVal arrRS, ByVal lineno, ByVal joono,ByVal courtcnt, ByVal useCourtRS, ByVal courtno, ByVal resultRS)
		Dim gno, sortno, p1idx,p1name,p1team1,p1team2,p1rpoint,p2idx,p2name,p2team1,p2team2,p2rpoint,courtstate,win,lose
		Dim c_p1idx,c_p1name,c_p1team1,c_p1team2,c_p1rpoint,c_p2idx,c_p2name,c_p2team1,c_p2team2,c_p2rpoint
		Dim m,x,c,r,selectstr,usestr,usecolor
		Dim r_m1idx, r_m2idx,r_ridx,r_state,r_courtno,leftetc,rightetc,chk_m1idx, chk_m2idx

		r_ridx = 0
		r_m1idx = 0
		r_m2idx = 0
		r_state = 0
		r_courtno = 0   
		r_leftetc = 0
		r_rightetc = 0
		'@@
			gno =			arrRS(0,lineno)
			sortno =		arrRS(1,lineno)
			p1idx =			arrRS(2,lineno)
			p1name =		arrRS(3,lineno)
			p1team1 =		arrRS(4,lineno)
			p1team2 =		arrRS(5,lineno)
			p1rpoint =		arrRS(6,lineno)

			p2idx =			arrRS(7,lineno)
			p2name =		arrRS(8,lineno)
			p2team1 =		arrRS(9,lineno)
			p2team2 =		arrRS(10,lineno)
			p2rpoint =	arrRS(11,lineno)

			key1  =	arrRS(12,lineno)
			key2  =	arrRS(13,lineno)
			key3  =	arrRS(14,lineno)
			win = arrRS(15,lineno)
			lose = arrRS(16,lineno)
			rank = arrRS(17,lineno)
		'@@
		%>
	  <td>
			<span class="player"><%=p1name%> + <%=p2name%></span>
	  </td>
	  <%For x = LBound(arrRS, 2) To UBound(arrRS, 2)
			'@@
				c_p1idx =			arrRS(2,x)
				c_p1name =		arrRS(3,x)
				c_p1team1 =		arrRS(4,x)
				c_p1team2 =		arrRS(5,x)
				c_p1rpoint =		arrRS(6,x)

				c_p2idx =			arrRS(7,x)
				c_p2name =		arrRS(8,x)
				c_p2team1 =		arrRS(9,x)
				c_p2team2 =		arrRS(10,x)
				c_p2rpoint =	arrRS(11,x)
		  
				oJSONoutput.P1 = p1idx
				oJSONoutput.P2 = c_p1idx
				oJSONoutput.P1NM = p1name & " " & p2name
				oJSONoutput.P2NM = c_p1name& " " & c_p2name

				oJSONoutput.S1KEY = key1
				oJSONoutput.S2KEY = key2
				oJSONoutput.S3KEY = key3
			'@@

			If IsArray(resultRS) Then
			'P1, RTIDX,P2, GSTATE, COURTNO '인덱스 >> 1P인덱스 ,결과인덱스, 2P인덱스 ,게임상태 ( 1, 진행 , 2, 종료 여부), 코트번호
			For r = LBound(resultRS, 2) To UBound(resultRS, 2)
				chk_m1idx = resultRS(0,r) 'p1
				chk_m2idx = resultRS(2,r) 'c_p1

				'If (CStr(r_m1idx) = CStr(p1idx) and CStr(r_m2idx) = CStr(c_p1idx)) Or (CStr(r_m2idx) = CStr(p1idx) and CStr(r_m1idx) = CStr(c_p1idx))  then
				If (CStr(chk_m1idx) = CStr(p1idx) and CStr(chk_m2idx) = CStr(c_p1idx))  then
					r_m1idx = resultRS(0,r) 'p1
					r_ridx = resultRS(1,r) 'resultIDX
					r_m2idx = resultRS(2,r) 'c_p1
					r_state = resultRS(3,r)
					r_courtno = resultRS(4,r)
					r_leftetc = resultRS(5,r)
					r_rightetc = resultRS(6,r)
				End if
			Next
			End if
	  %>
	  <td  <%If  p1name = c_p1name then%>class="backslash"<%End if%> <%If CDbl(x) > CDbl(lineno) then%>style="text-align:right;padding-right:5px;"<%End if%>>
			<span id="p_<%=x%>_<%=lineno%>">
			<%If  p1name = c_p1name then%>
				&nbsp;
			<%else%>



				<%If CDbl(x) > CDbl(lineno) then%>
					<!-- :::판정결과를 찍자:::<%=r_m1idx%> / <%=r_m2idx%> / <%=r_ridx%>  -->
					<!--<select id="c_<%=x%>_<%=lineno%>">-->
					<%
					If r_ridx = "" Then
						r_ridx = 0
					End if
					oJSONoutput.SCIDX = r_ridx
					oJSONoutput.POS = "c_" & x & "_" & lineno
					strjson = JSON.stringify(oJSONoutput)		

					For m = 1 To courtcnt
						selectstr = ""
						usestr = ""
						usecolor = ""

						If IsArray(useCourtRS) Then
							For c = LBound(useCourtRS, 2) To UBound(useCourtRS, 2) 
								usecourt = useCourtRS(0, c) 
								courtstate =  useCourtRS(1, c) 
								If m = CDbl(usecourt) And m <> CDbl(r_courtno)  then
									If courtstate = "1" Then
									usestr = "종료"
									usecolor = " style='color:red'"
									else
									usestr = "사용"			'사용중
									usecolor = " style='color:orange'"
									End if
								End If
								If m = CDbl(r_courtno) Then
									selectstr = "selected"	'선택된
									usestr = "선택"			'선택중
									usecolor = " style='color:green'"
								End if
							Next
						End If

						%>
						<!--<option value="<%=m%>" <%=selectstr%> <%=usecolor%>><%=m%>번 코트 <%=usestr%></option>-->
						<%
					Next
					%>
					
					<!--</select>	-->
					<!--
				<a href='javascript:mx.SetCourt(<%=strjson%>)' class="btn_a" style="text-align:center;">OK</a>
				<br>-->
				<%End if%>

				<%
				oJSONoutput.STATENO = r_state
				If r_ridx = "" Then
					r_ridx = 0
				End if				
				oJSONoutput.SCIDX = r_ridx
				oJSONoutput.WINIDX = p1idx
				oJSONoutput.POS = "l_" & x & "_" & lineno
				strjson = JSON.stringify(oJSONoutput)		
				%>
				<%=p1name%> + <%=p2name%>
				
				<%If CDbl(x) > CDbl(lineno) then%>
				<select id="l_<%=x%>_<%=lineno%>"  style="width:100px;font-size:11px;" onchange='javascript:mx.SetGameResult(<%=strjson%>)'>
				  <option value="0" <%If r_leftetc = "0" then%>selected<%End if%>>=판정=</option>
				  <option value="100"  <%If r_leftetc = "100" then%>selected<%End if%>>승리</option>
				  <option value="1"  <%If r_leftetc = "1" then%>selected<%End if%>>부전승</option>
				  <option value="2"  <%If r_leftetc = "2" then%>selected<%End if%>>기권승</option>
				  <option value="3"  <%If r_leftetc = "3" then%>selected<%End if%>>실격승</option>
				  <option value="4"  <%If r_leftetc = "4" then%>selected<%End if%>>양선수 불참</option>
				  <option value="5"  <%If r_leftetc = "5" then%>selected<%End if%>>양선수 기권패</option>
				  <option value="6"  <%If r_leftetc = "6" then%>selected<%End if%>>양선수 실격패</option>
				</select>
				<%
				'If r_courtno = 0 then
				%>
				<!--<a href='javascript:alert("코트를 먼져 지정하여 주십시오.")' class="btn_a" style="text-align:center;">OK</a></a>-->
				<%
				'else
				%>
				<!--<a href='javascript:mx.SetGameResult(<%=strjson%>)' class="btn_a" style="text-align:center;">OK</a>-->
				<%
				'End if
				%>				
				<br>
				<%End if%>

				<%If CDbl(x) < CDbl(lineno) then%>
				<br>vs<br>
				<%End if%>

				<%
				oJSONoutput.STATENO = r_state
				If r_ridx = "" Then
					r_ridx = 0
				End if
				oJSONoutput.SCIDX = r_ridx
				oJSONoutput.WINIDX = c_p1idx
				oJSONoutput.POS = "r_" & x & "_" & lineno
				strjson = JSON.stringify(oJSONoutput)		
				%>
				<%=c_p1name%> + <%=c_p2name%>

				<%If CDbl(x) > CDbl(lineno) then%>
				<select id="r_<%=x%>_<%=lineno%>"  style="width:100px;font-size:11px;"  onchange='javascript:mx.SetGameResult(<%=strjson%>)'>
				  <option value="0" <%If r_rightetc = "0" then%>selected<%End if%>>=판정=</option>
				  <option value="100"  <%If r_rightetc = "100" then%>selected<%End if%>>승리</option>
				  <option value="1"  <%If r_rightetc = "1" then%>selected<%End if%>>부전승</option>
				  <option value="2"  <%If r_rightetc = "2" then%>selected<%End if%>>기권승</option>
				  <option value="3"  <%If r_rightetc = "3" then%>selected<%End if%>>실격승</option>
				  <option value="4"  <%If r_rightetc = "4" then%>selected<%End if%>>양선수 불참</option>
				  <option value="5"  <%If r_rightetc = "5" then%>selected<%End if%>>양선수 기권패</option>
				  <option value="6"  <%If r_rightetc = "6" then%>selected<%End if%>>양선수 실격패</option>
				</select>
				<%
				'If r_courtno = 0 then
				%>
				<!--<a href='javascript:alert("코트를 먼져 지정하여 주십시오.")' class="btn_a" style="text-align:center;">OK</a></a>-->
				<%
				'else
				%>
				<!--<a href='javascript:mx.SetGameResult(<%=strjson%>)' class="btn_a" style="text-align:center;">OK</a>-->
				<%
				'End if
				%>
				<br>
				<%
				End if
				%>

			<%End if%>
			</span>
	  </td>
	  <%
		r_ridx = 0
		r_m1idx = 0
		r_m2idx = 0
		r_state = 0
		r_courtno = 0   
		r_leftetc = 0
		r_rightetc = 0
		Next%>
	  <td>
		<%=win%>승 <%=lose%>패
	  </td>
	  <td>
		<%If gameend = false then%>
			-
		<%Else
			oJSONoutput.POS = "rank_" & lineno		
			strjson = JSON.stringify(oJSONoutput)		
		%>
			<select id="rank_<%=lineno%>"  style="width:80px;font-size:11px;" onchange='javascript:mx.SetGameRanking(<%=strjson%>)'>
			<option value="0" <%If rank = "0" then%>selected<%End if%>>=순위=</option>
			<option value="1"  <%If rank = "1" then%>selected<%End if%>>1위</option>
			<option value="2"  <%If rank = "2" then%>selected<%End if%>>2위</option>
			<option value="3"  <%If rank = "3" then%>selected<%End if%>>3위</option>
			</select>
			<!--<a href='javascript:mx.SetGameRanking(<%=strjson%>)' class="btn_a" style="text-align:center;">OK</a>-->
		<%End if%>
	  </td>
		<%
	End Sub
'#############################################
%>




<%
	strjson = JSON.stringify(oJSONoutput)		
%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'><a href="javascript:mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>')" class="btn_a"> << 조별목록</a> <%=poptitle%></h3></div>

<div class='modal-body'>
<a href='javascript:$("#loadmsg").text("&nbsp;새로 고침 중.....");mx.leagueJoo(<%=strjson%>);' class = "btn_a" style="border:1px solid black">새로고침</a>
<span id="loadmsg">

		<!--<table border="0" width="100%" >-->
			<%
				'Response.write "<tr>"
				For m = 1 To courtcnt
					%>
					<!--<td align="center"><%=m%>코트<td>-->
					
					<%
				next
				'Response.write "</tr>"
				'Response.write "<tr>"
				For m = 1 To courtcnt
					%>
					<!--
					<td align="center"><img src="http://tennisadmin.sportsdiary.co.kr/images/tennis/tennis_court.jpg"><td>
					-->
					<%
				next
				'Response.write "</tr>"

				'Response.write "<tr>"
				For m = 1 To courtcnt
					usestr = "빈 코트"
					usecolor = "style='color:green'"
					
					If IsArray(useCourtRS) Then

						For c = LBound(useCourtRS, 2) To UBound(useCourtRS, 2) 
							usecourt = useCourtRS(0, c) 
							courtstate =  useCourtRS(1, c) 
							If m = CDbl(usecourt)   then
								If courtstate = "1" Then
								usestr = "빈 코트"
								usecolor = " style='color:green'"
								else
								usestr = "사용 중"			'사용중
								usecolor = " style='color:orange'"
								End if
							End If
						Next

					End If
					%>
					<!--<td align="center" <%=usecolor%>><%=usestr%><td>--><%
				Next
				'Response.write "</tr>"
				%>
		<!--</table>-->


	  <table border="1" width="100%" class="table-list" id="gametable">
		<%
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

				If ar = 1 Then
					%>
					<thead>
						<tr>
						  <th>제<%=joonum%>조</th>
						  <%For x = LBound(arrRS, 2) To UBound(arrRS, 2)
								c_p1name =		arrRS(3,x)
								c_p2name =		arrRS(8,x)
						  %>
						  <th>
								<span class="player"><%=c_p1name%> + <%=c_p2name%></span>
						  </th>
						  <%Next%>
						  <th>
						  <p class="tit">승패(점수)</p>
						  </th>
						  <th>
						  <p class="tit">순위</p>
						  </th>
						<tr>
					<thead>
					<tbody>
						<tr>
						 <%Call vsData(arrRS,ar, joonum, courtcnt,useCourtRS, courtno, resultRS)%>
						</tr>
					<%
				Else
				%>
				<tr>
					 <%Call vsData(arrRS,ar, joonum, courtcnt,useCourtRS, courtno ,resultRS)%>
				</tr>
				<%
				End If
		Next	
%>




		    </tbody>
      </table>


</div>


<!-- #include virtual = "/pub/api/swimAdmin/gametable/inc.jobtn.asp" --><%

db.Dispose
Set db = Nothing
%>