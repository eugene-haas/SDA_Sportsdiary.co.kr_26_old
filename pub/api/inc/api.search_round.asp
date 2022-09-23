
<%


liveYn="N"
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
        if  CDbl(arrRS(5, ar)) = 2 then 
            liveYn="Y"
            Call oJSONoutput.Set("livecid",   CDbl(arrRS(4, ar)))
        Exit for
        end if 
	Next
End if

if liveYn ="N" then 
    SQL = "select RGameLevelidx from tblRGameLevel  where   GameTitleIDX ='"&gameidx&"'  and  Level='"&strs3&"'  and GameDay =  convert(date,GETDATE()) "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then 
	    liveYn="Y"
    End if
    SQL=""
end if 
'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("drd_No",  CDbl(datalen) + 1 )
Call oJSONoutput.Set("liveYn",  liveYn)

strjson = JSON.stringify(oJSONoutput)

Response.Write strjson
Response.write "`##`"
%>

    <%If tabletype ="1" then%>
      <!-- S: color-guide -->  
		<%If cmd <> CMD_GAMESEARCH_Home Then%>
      <section class="color-guide" id="DP_Guide">
      <!-- <H2> <% 'rESPONSE.wRITE sql1 %></H2>
      <H2> <% 'rESPONSE.wRITE sql2 %></H2> -->
      <ul class="guide-cont"> 
        <%If cmd = CMD_GAMESEARCH_app Then%>
            <%if liveYn="Y" then  %>
            <li><a class="btn btn-danger btn-look time-in"></a><p>라이브스코어</p></li>
            <%end if  %>
            <li><a class="btn btn-danger btn-look time-out no-movie-clip"></a><p>종료(영상 미등록)</p></li> 
            <li><a class="btn btn-danger btn-look time-out"></a><p>종료(영상 등록)</p></li> 
		<%ElseIf cmd = CMD_GAMESEARCH_Home Then%>

        <%else %>
            <li><a class="btn btn-danger btn-look time-in">1</a><p>경기중</p></li>
            <li><a class="btn btn-danger btn-look time-out">2</a><p>경기종료</p></li>
            <li><a class="btn btn-danger btn-look handy">3</a><p>양측부전패(불참)</p></li>
        <%End If%>
      </ul>
      </section>
		<%End If%>
	  <%End If%>
      <!-- E: color-guide -->



	  <div class="preli">
		<!-- S: btn-list --> 

	<!-- S: tourney-->
		<div class="tourney clearfix round_part tourn">
	<!-- S: include tennis-tourney -->
				<%
				'강수 네비게이션
				'rndcnt = array(3,5,7,9,11,13,15,17,19,21)
				roundno  = datalen + 1 '몇강인지
				leftmembercnt = FIX(CDbl(datalen + 1))

				Select Case roundno
					Case 4 : rndcnt = 1
					Case 8 : rndcnt = 2
					Case 9,10,11,12,13,14,15,    16 
						 rndcnt = 3
						tempmembercnt = 16 -  roundno
					Case 32 : rndcnt = 4
					Case 64 : rndcnt = 5
					Case 128 : rndcnt = 6
					Case 256 : rndcnt = 7
				End Select

				
				if roundno >2 and roundno<=4 then  
					rndcnt = 1
				elseif roundno >4 and roundno<=8 then
					rndcnt = 2
				elseif roundno >8 and roundno<=16 then
					rndcnt = 3
				elseif roundno >16 and roundno<=32 then
					rndcnt = 4
				elseif roundno >32 and roundno<=64 then
					rndcnt = 5
				elseif roundno >64 and roundno<=128 then
					rndcnt = 6
				elseif roundno >128 and roundno<=256 then
					rndcnt = 7
				end if 

				harfno = roundno
				if roundno >0 then 
				%>
			<div class="game_number">
			  <ul class="clearfix">
					<li>
					  <a href="javascript:score.gameSearch(1);" class="btn btn_white">전체</a>
					</li>
					<%
					for i=0 to rndcnt
			
					if i>0 then 
						harfno = harfno / 2
					end if 
					
					Select Case harfno
						Case 2 : harfnm="결승전"
					End Select
					
					if harfno >2 and harfno<=4 then 
						harfnm="4강"
						harfno =4
					elseif harfno >4 and harfno<=8 then
						harfnm="8강" 
						harfno =8
					elseif harfno >8 and harfno<=16 then
						harfnm="16강" 
						harfno =16
					elseif harfno >16 and harfno<=32 then
						harfnm="32강" 
						harfno =32
					elseif harfno >32 and harfno<=64 then
						harfnm="64강" 
						harfno =64
					elseif harfno >64 and harfno<=128 then
						harfnm="128강" 
						harfno =128
					elseif harfno >128 and harfno<=256 then
						harfnm="256강" 
						harfno =256
					end if 


					if Round_s-1 =  i then 
						Round_s_nm = harfno
						Round_s_n_nm = harfno/2
					end if 
					%>
					<li>
					  <a href="javascript:score.gameSearch(1000<%=i+1%>);" class="btn btn_white <%if Round_s-1 = i then%>on<%end if%>"><%=harfnm%></a>
					</li>
					<%
					Next
				%>
			  </ul>
			</div>
				<%
				  end if
				%> 

		
<%
	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "
	strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3  & " and gubun = "&checkgubun&" " 'gubun  0예선 1예선종료 2 본선대기 3 본선입력완료 4 본선종료 ...
	strsort = " order by a.Round asc,a.SortNo asc"

	strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo,a.playerIDX "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & " and sortno > 0  " 
	if Round_s <> "" then 
		SQL = SQL & "  and a.Round between " & Round_s & " and " & Round_s_n  
		SQL = SQL & strsort
	else
		SQL = SQL & "  and Round = 1  " 
		SQL = SQL & strsort
	end if 

'Response.write SQL 

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount

'Response.write rscnt 
	ReDim JSONarr_round(rscnt-1)

	i = 0
	Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			'rsarr("GNO") = rs("groupno")

			rsarr("CO") = rs("COL") '라운드

			If rs("ROW") = "" Or isNull(rs("ROW")) = True Or rs("ROW") = "0" Then
				rsarr("RO") = i +1
			Else
				rsarr("RO") = rs("ROW")
			End if

			rsarr("ATANM") = rs("aNTN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("PIDXA") = rs("playerIDX")

		Set JSONarr_round(i) = rsarr
	i = i + 1
	rs.movenext
	Loop

	datalen_round = Ubound(JSONarr_round)
	Set ojson_round= JSON.Parse(toJSON(JSONarr_round))
%>
<!-- S: left-side -->
		<div class="game_tourn <% if Round_s_n_nm = 1 then %> final <%end if %>clearfix">

			<!-- S: match-list -->
			<div class="left_side">
				<% 
				for i= 1 to Round_s_nm 
					if i mod 2 = 1  then 
						Call setRoundIn(Round_s,  i, "L",ojson_round,datalen_round)    
					end if 
				next
				%>
			</div>

			<div class="right_side">
				<% 
				for i= 1 to Round_s_n_nm  
					if i mod 2 = 1  then 
						Call setRoundIn(Round_s_n,  i, "R",ojson_round,datalen_round)    
					end if 
				next
				%> 
			</div>
		</div>
		<!-- E: left-side -->
	<!-- E: include tennis-tourney -->
	</div>
	<!-- E: tourney-->
<%
sub setRoundIn(ByVal roundN, ByVal sortno, ByVal intype, ByVal dataArr, ByVal Lenth) 

	mem1idx = ""
	aname = ""
	bname = ""
	ateamA = ""
	ateamB = ""
	bteamA = ""
	bteamB = ""
	postionno = ""

	ateamprint=""
	bteamprint=""

	mem1idx_1 = ""
	aname_1 = ""
	bname_1 = ""
	ateamA_1 = ""
	ateamB_1 = ""
	bteamA_1 = ""
	bteamB_1 = ""
	postionno_1 = ""

	ateamprint_1=""
	bteamprint_1=""

	checkRoundIn_1=""
	checkRoundIn_2=""

	laststate_1 = ""
	resultidx_1 = ""
	win_1 = ""
	MLink_A_1 = ""

	laststate_2 = ""
	resultidx_2 = ""
	win_2 = ""
	MLink_A_2 = ""

	for c1 = 0 to Lenth 
		col = dataArr.Get(c1).CO
		row = dataArr.Get(c1).RO

		if roundN = col and sortno=Cdbl(row) then 
			mem1idx = dataArr.Get(c1).AID
			aname = dataArr.Get(c1).ANM
			bname = dataArr.Get(c1).BNM

			ateamA = dataArr.Get(c1).ATANM
			ateamB = dataArr.Get(c1).ATBNM
			bteamA = dataArr.Get(c1).BTANM
			bteamB = dataArr.Get(c1).BTBNM
			postionno = dataArr.Get(c1).PNO  ' 파트너의 시작위치 정보 

			If ateamA <>"" then
				ateamprint = ateamA
				If ateamB <> "" Then
					ateamprint = ateamprint & "," & ateamB
				End if
			End If

			If bteamA <>"" then
				bteamprint = bteamA
				If bteamB <> "" Then
					bteamprint = bteamprint & "," & bteamB
				End if
			End If

			checkRoundIn_1=checkRoundIn(mem1idx)
			laststate_1 = checkRoundIn_1(0)
			resultidx_1 = checkRoundIn_1(1)
			win_1 = checkRoundIn_1(2)
			MLink_A_1 =  checkRoundIn_1(3)

		end if 

		if roundN = col and CDbl(sortno)+1=Cdbl(row) then 
			mem1idx_1 = dataArr.Get(c1).AID
			aname_1 = dataArr.Get(c1).ANM
			bname_1 = dataArr.Get(c1).BNM

			ateamA_1 = dataArr.Get(c1).ATANM
			ateamB_1 = dataArr.Get(c1).ATBNM
			bteamA_1 = dataArr.Get(c1).BTANM
			bteamB_1 = dataArr.Get(c1).BTBNM
			postionno_1 = dataArr.Get(c1).PNO  ' 파트너의 시작위치 정보 

			If ateamA_1 <>"" then
				ateamprint_1 = ateamA_1
				If ateamB_1 <> "" Then
					ateamprint_1 = ateamprint_1 & "," & ateamB_1
				End if
			End If

			If bteamA_1 <>"" then
				bteamprint_1 = bteamA_1
				If bteamB_1 <> "" Then
					bteamprint_1 = bteamprint_1 & "," & bteamB_1
				End if
			End If

			checkRoundIn_2=checkRoundIn(mem1idx_1)
			laststate_2 = checkRoundIn_2(0)
			resultidx_2 = checkRoundIn_2(1)
			win_2 = checkRoundIn_2(2)
			MLink_A_2 =  checkRoundIn_2(3)

		end if 

	next
		
	match_class = "match"

	if Round_s_n_nm =1 and intype <>"R"   then
		match_class = "final"
	elseif Round_s_n_nm =1 and intype ="R"   then
		match_class = "no_match"
	else
		if ((mem1idx ="" or mem1idx_1 ="") and intype ="L")    then
			match_class = "no_match"
		end if 
	end if 

'laststate_1 laststate_2 게임상태 (0진행전,  2, 진행 , 1, 종료)
'Response.write checkRoundIn_2(0)  
%>
<!-- S: match -->
<div class="<%=match_class%>">
  <!-- S: team_list -->
  <div class="team_list">
	<!-- S: table -->
	<table class="table <%if sortno mod 4 <=2 and intype="L" then %>down_line <%else%>up_line <%end if%>">
	  <tbody>
		<% if aname <>"" then %>
		  <tr class="team team_a <% if win_1 ="left" and  intype ="L" then %> win<%end if %>">
				<td class="player">
				  <!-- S: up_floor -->
				  <div class="up_floor">
					<span class="name"><%=aname%> </span>
					<span class="club">(<%=ateamprint%>)</span>
				  </div>
				  <!-- E: up_floor -->

				  <!-- S: down_floor -->
				  <div class="down_floor">
					<span class="name"><%=bname%></span>
					<span class="club">(<%=bteamprint%>)</span>
				  </div>
				  <!-- E: down_floor -->
				</td>
				<td class="seed"><%=laststate_1%></td>
				<td class="point"><%=MLink_A_1%></td>
		  </tr>
		<%end if %>

		<% if (intype ="L" and aname_1 <>"") or intype ="R" then %>
		  <% if (intype ="R" and  Round_s_n_nm <> 1 ) or( intype = "L")  then  %>
		  <tr class="team team_a  <% if win_1 ="right" and  intype ="L" then %> win<%else%> <%if win_2 ="right" then%>win<%end if %><%end if %>">
			<td class="player">
				  <!-- S: up_floor -->
				  <div class="up_floor">
					<span class="name"><%=aname_1%></span>
					<span class="club">(<%=ateamprint_1%>)</span>
				  </div>
				  <!-- E: up_floor -->

				  <!-- S: down_floor -->
				  <div class="down_floor">
					<span class="name"><%=bname_1%></span>
					<span class="club">(<%=bteamprint_1%>)</span>
				  </div>
				  <!-- E: down_floor -->
			</td>
				<td class="seed"><%=laststate_2%></td>
				<td class="point"><%=MLink_A_2%></td>
		  </tr>
		 <%end if %>
		<%end if%>
	  </tbody>
	</table>
	<!-- E: table -->
  </div>
  <!-- E: team_list -->
</div>
<!-- E: match -->
<%
End sub



Function checkRoundIn(ByVal p1_F)
	Dim row, col,midx1,midx2,ridx,stateno,laststate,resultidx,winresult,win
	Dim MIDX,MLink,Subject,Contents,ILink,STime,ETime,ViewCnt

	'라운드 상태와 인덱스 찾기 펑션
	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) '***결과들어간 애들만있슴****
		row = arrRS(0, ar)  '행 라운드
		col =  arrRS(1, ar)  '열
		midx1 = arrRS(2, ar)  '기준 선수1
		midx2 = arrRS(3, ar)  '기준 선수2
		ridx = arrRS(4, ar)  '결과 인덱스
		stateno = arrRS(5, ar) '게임상태 (0진행전,  2, 진행 , 1, 종료)
		winresult = arrRS(6, ar)  'left right (top bottom) tie
	
		'미디어 링크 
		MIDX = arrRS(7, ar)  
		MLink = arrRS(8, ar)  
		Subject = arrRS(9, ar)  
		Contents = arrRS(10, ar)  
		ILink = arrRS(11, ar)  
		STime = arrRS(12, ar)  
		ETime = arrRS(13, ar)  
		ViewCnt = arrRS(14, ar)  

		If p1_F <> "" then
			If CDbl(midx1) = CDbl(p1_F) Then
				win= winresult
				laststate = stateno ' 0 진행전 1 종료 2 진행중
				resultidx = ridx
				MLink_A = MLink
				Exit for
			End If
		End if
	Next
	End if
	checkRoundIn = array(laststate, resultidx, win,MLink_A)
End Function

%>