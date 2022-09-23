<%
'#############################################
'대진표 리그 조별 대진표
'#############################################
'request
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
stateno =  oJSONoutput.StateNo '999 게임종료 모두 막음
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  예선 대진표</span>"

Set db = new clsDBHelper

 '#############################################
  Call oJSONoutput.Set("MIDX1", 0 ) '1팀
    Call oJSONoutput.Set("MIDX2", 0 ) '2팀
    Call oJSONoutput.Set("RIDX", 0 ) '결과
    Call oJSONoutput.Set("NOWCTNO", 0 ) '현재 지정된 코트번호
 '#############################################


strtable = " sd_TennisMember "
strtablesub =" sd_TennisMember_partner "
strtablesub2 = " tblGameRequest "
strresulttable = " sd_TennisResult "


SQL = " Select EntryCnt,attmembercnt,courtcnt,level,bigo,JooArea,JooDivision,joocnt from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



If Not rs.eof then
  entrycnt = rs("entrycnt") '참가제한인원수
  attmembercnt = rs("attmembercnt") '참가신청자수
  courtcnt = rs("courtcnt") '코트수
  levelno = rs("level")

  If gibo <> "" Then '지워도 되지만
  bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
  bigo = Replace(bigo ,vbCr ,"\n")
  bigo = Replace(bigo ,vbLf ,"\n")
  End If
  
  JooArea = rs("JooArea")
  JooDivision = rs("JooDivision")
  joocnt = rs("joocnt")



  if(Cdbl(JooDivision) <> 1) Then
    jorder = fc_tryoutGroupMerge(joocnt,JooDivision, JooArea)
    IsChangeJoo =True
  End If

  'poptitle = poptitle & " <span class='txt'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & " ["&levelno&"]</span>"
End if

'총라인수
'#############################
  SQL = "select count(*),tryoutgroupno,max(place) from sd_TennisMember where GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and tryoutgroupno > 0 and gubun =1 and DelYN='N' group by tryoutgroupno"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then 
  arrLN = rs.getrows()
  End If
'#############################
  

'예선 참가자 정보
'#############################
  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0 and a.gubun =1 and a.DelYN='N' " 'a.tryoutgroupno 부전승 허수 맴버
  strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순

  strAfield = " a. gamememberIDX, a.userName, a.tryoutgroupno, a.tryoutsortno, a.teamAna, a.teamBNa, a.tryoutstateno, a.t_rank,a.key3name ,isnull(a.Courtno,0) Courtno "
  strBfield = " b.partnerIDX, b.userName, b.teamANa, b.teamBNa "
  strfield = strAfield &  ", " & strBfield 

  strfield = strfield & " , a.t_win,a.t_tie,a.t_lose  ,isnull(a.place,'') place "

  SQL = "select "& strfield &" from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then 
  arrRS = rs.getrows()
  End If
'#############################

'코트정보
'#############################
  SQL = "select idx,no,courtname,courtuse,courtstate,areaname from sd_TennisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and courtuse = 'Y'  order by areaname,idx  "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then 
  arrCT = rs.getrows()
  End If
'#############################

'스코어 입력 정보 가져오기
'#############################
  strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun = 1 " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료
  strsort = " order by  a.Round asc, a.SortNo asc"
  strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX  " '열 인덱스(기준)
  strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX,b.winIDX " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
  strfield = strAfield &  ", " & strBfield 

  SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then 
    arrRT = rs.GetRows() 'RIDX, CIDX, GSTATE
  End if
'#############################

Function t_ing(ByVal rcourtidx, winidx)
  If CDbl(rcourtidx) = 0 Then
    t_ing = ""
  else
    If winidx = "" Or winidx = "0" Or isnull(winidx) = true Then
      t_ing = "class='playing'"
    else
      t_ing = "class='finish'"
    End if
  End if
End function

Function t_winchk(ByVal winidx,ByVal midx1,ByVal midx2)

  If winidx = "" Or winidx = "0" Or isnull(winidx) = true Then
    t_winchk = array("","","승","승")
  Else
    If CDbl(midx1) = CDbl(winidx) then
      t_winchk = array(" win","","승","패")
    ElseIf CDbl(midx2) = CDbl(winidx) then
      t_winchk = array(""," win","패","승")
    else
      t_winchk = array("","","승","승")
    End If  
  End if

End Function


Sub tryoutVS(ByVal gno, ByVal gcnt, ByVal mrs,ByVal crs,ByVal rrs , ByVal place_notice)
  Dim ar, i, gmem, g_no, s_no, c_no, m1_idx,m2_idx, m1_nm, m2_nm
  Dim drowtype, t1p1,t1p2,t2p1,t2p2,gameno
  Dim arrFR, ridx, rstate, rcourtidx,winidx,arrwin,win1,win2,win1str,win2str
  Dim ct ,ct_idx,ct_no,ct_courtname,ct_courtstate,selectedstr,waitmode,stateclass,ct_area
  ReDim gmem(10,gcnt) 'gcnt 총참가팀수

  i = 0
  If IsArray(mrs) Then
    For ar = LBound(mrs, 2) To UBound(mrs, 2)
      g_no = mrs(2,ar)
      s_no = mrs(3,ar)
      c_no = mrs(9,ar) '코트 번호

      m1_idx = mrs(0,ar)
      m1_nm = mrs(1,ar)
      m2_idx = mrs(10,ar) '파트너
      m2_nm = mrs(11,ar)
	  'place_notice = mrs(17,ar) '장소공지

      If CDbl(g_no) = CDbl(gno) Then
      gmem(0, i) = s_no
      gmem(1, i) = c_no
      gmem(2, i) = m1_idx
      gmem(3, i) = m2_idx
      gmem(4, i) = m1_nm
      gmem(5, i) = m2_nm
      i = i + 1
      Else
      'Exit for
      End if
    Next
  End If
  %>
    <tr>
      <th><%=gno%></th>
      <td><%=place_notice%></td>

      <%
      For ar = LBound(gmem, 2) To UBound(gmem, 2) - 1
        gameno = ar
        Select Case ar
        Case 0
          drowtype = "basic"
          t1midx = gmem(2,ar)
          t2midx = gmem(2,ar+1)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)

          t1p1 = gmem(4,ar)
          t1p2 = gmem(5,ar)
          t2p1 = gmem(4,ar+1)
          t2p2 = gmem(5,ar+1)
          stateclass = t_ing(rcourtidx, winidx)
          arrwin = t_winchk(winidx, t1midx, t2midx)
          win1 = arrwin(0)
          win2 = arrwin(1)
          win1str = arrwin(2)
          win2str = arrwin(3)
        Case 1
        If CDbl(gcnt) = 3 Then
          drowtype = "basic"
          t1midx = gmem(2,ar-1)
          t2midx = gmem(2,ar+1)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)

          t1p1 = gmem(4,ar-1)
          t1p2 = gmem(5,ar-1)
          t2p1 = gmem(4,ar+1)
          t2p2 = gmem(5,ar+1)
          stateclass = t_ing(rcourtidx, winidx)
          arrwin = t_winchk(winidx, t1midx, t2midx)
          win1 = arrwin(0)
          win2 = arrwin(1)
          win1str = arrwin(2)
          win2str = arrwin(3)
        else
          drowtype = "empty"        
        End If
        Case 2
        If CDbl(gcnt) = 3 then
          drowtype = "basic"
          t1midx = gmem(2,ar-1)
          t2midx = gmem(2,ar)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)
          
          t1p1 = gmem(4,ar-1)
          t1p2 = gmem(5,ar-1)
          t2p1 = gmem(4,ar)
          t2p2 = gmem(5,ar)
          stateclass = t_ing(rcourtidx, winidx)

          arrwin = t_winchk(winidx, t1midx, t2midx)
          win1 = arrwin(0)
          win2 = arrwin(1)
          win1str = arrwin(2)
          win2str = arrwin(3)
        else
          drowtype = "empty"        
        End if
        End Select %>

			<%If drowtype = "basic" Then
			  oJSONoutput.MIDX1 = t1midx
			  oJSONoutput.MIDX2 = t2midx
			  oJSONoutput.RIDX = ridx
			  oJSONoutput.JONO = gno
			  oJSONoutput.NOWCTNO = rcourtidx '현재코트인덱스
			  strjson = JSON.stringify(oJSONoutput)
			%>
				<td colspan="2" id="ting_<%=gno%>_<%=gameno%>" <%=stateclass%> >
				<div class="groupbtn">
					<a href='javascript:mx.league_win(<%=t1midx%>,<%=strjson%>)' class="team team_a<%=win1%>">
					  <ul class="clearfix">
					  <li><span class="player"><%=t1p1%></span></li>
					  <li><span class="player"><%=t1p2%></span></li>
					  </ul>
					  <p class="result_txt"><%=win1str%></p>
					</a>
					<a href='javascript:mx.league_win(<%=t2midx%>,<%=strjson%>)' class="team team_b <%=win2%>">
					  <ul class="clearfix">
					  <li><span class="player"><%=t2p1%></span></li>
					  <li><span class="player"><%=t2p2%></span></li>
					  </ul>
					  <p class="result_txt"><%=win2str%></p>
					</a>
				</div>
				<div class="selectbtn" id="ts_<%=gno%>_<%=gameno%>" >
				



					<%
					'경기종료 화면이떠서 winidx 체크 추가 (어디가 이상인걸까 안나오네 )
					If CDbl(rstate) = 1  And winidx <> "" And win1&win2 <> "" then%>
							  <select id="gcourt_<%=gno%>_<%=gameno%>" disabled  style="font-weight: bold;">
								<option>경기종료</option>
							  </select>
					<%else%>
							  <select id="gcourt_<%=gno%>_<%=gameno%>"  onchange='mx.league_court("<%=gno%>_<%=gameno%>",<%=strjson%>)'>
								<%
								waitmode = "yes"
								If IsArray(crs) Then
								For ct = LBound(crs, 2) To UBound(crs, 2) 
								  ct_idx = crs(0,ct)
								  ct_no = crs(1,ct)
								  ct_courtname = crs(2,ct)
								  ct_courtstate = crs(4,ct)
								  ct_area = crs(5,ct)

								  If CDbl(rcourtidx) > 0 And CDbl(rcourtidx) = CDbl(ct_idx) Then
									Response.write "<option value='"&ct_idx&"' selected>"& ct_area & " " & ct_courtname&"</option>"
									waitmode = "no"
								  Else
									If CDbl(ct_courtstate) = 0 Then '사용가능한 코트
									  Response.write "<option value='"&ct_idx&"'>"& ct_area & " " & ct_courtname&"</option>"
									End if
								  End if
								Next
								End If
								%>
								<option <%If waitmode = "yes" then%>selected<%End if%> value="0">대기중</option>
							  </select>
					<%End if%>

				</div>
				</td>
			<%else%><%'여러개가 그려져서 뺌%>
				 <!-- <td colspan="2"></td>
				 <td colspan="2"></td> -->
			<%End if%>

      <%next%>
    </tr>
  <%
End Sub

'#####################################################################
%>



<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=poptitle%></h3>
  </div>
<!-- 헤더 코트e -->

<div class='modal-body game-ctr'>
  <!-- S: top_control -->
  <div class="top_control">
    <%strjson = JSON.stringify(oJSONoutput)%>

    <div class="league_tab clearfix">
      <div class="pull-left">
		<a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>');" class = "btn_a btn btn_tab">예선결과 입력/본선추첨</a>
		<a href='javascript:mx.league_ing(<%=strjson%>)' class="btn_a btn btn_tab on">예선경기진행</a>
		<button id="tryouting" style=" display:none;" onclick='mx.league_ing(<%=strjson%>)'>예선진행숨김버튼</button>
	    <%If CDbl(ADGRADE) > 500 then%>
		<a href="./gamerull3.asp?tidx=<%=tidx%>&ridx=<%=levelno%>" class="btn_a btn btn_tab">본선시드배정</a> 
		<%End if%>
	  	<a href='javascript:mx.initCourt(<%=strjson%>)' class="btn btn_func" style="margin-left:20px;">코트 관리</a>

		&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:$("#showreloadbtn").text("Loading...");mx.league_ing(<%=strjson%>)' class="btn_a btn btn_tab on" id="showreloadbtn">새로고침</a>	  
	  </div>

      <div class="pull-right">
			<input type="text" placeholder="검색어를 입력해 주세요." class="search_btn" onkeydown="if(event.keyCode == 13){mx.docfindstr('search_btn','gametable tbody tr td div a ul li span','#gametable' , 'table2');}" name="text-12" id="text-12" value="">
			<a href="javascript:mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>')" class="btn_a btn btn_tab change_type">
			  <span class="txt">본선</span>
			  <span class="ic_deco">
				<i class="fa fa-angle-right" aria-hidden="true"></i>
			  </span>
			</a>
	  </div>

      <button id="reloadbtn" onclick="$('#loadmsg').text('&nbsp;선수 교체 중.....');mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>');"  style=" display:none;">새로고침</button><!-- 안보임 내부적으로 클릭사용 -->
    </div>
  </div>
  <!-- E: top_control -->


  <!-- S: scroll_box -->
    <table class="table table-striped set_league_table " style="margin-top:90px;margin-bottom:0px;">
      <thead>
        <tr><th>조</th><th>조코트명</th><th>1번 vs 2번</th><th>코트지정</th><th>1번 vs 3번</th><th>코트지정</th><th>2번 vs 3번</th><th>코트지정</th></tr>
      </thead>
	</table>

  <div class="scroll_box" id="drowbody" style="margin-top:0px;">
  <!-- S: set_league -->
  <div class="set_league">

	<table class="table table-striped set_league_table" id="gametable">
      <tbody>
<%If IsChangeJoo = true then%>

<%
	For i = 1 To ubound(jorder)

		If IsArray(arrLN) Then
			For ar = LBound(arrLN, 2) To UBound(arrLN, 2) 
			gcnt = arrLN(0,ar) '총명수
			g_no = arrLN(1,ar) '조
			placenotice = arrLN(2,ar)
			If CDbl(jorder(i)) = CDbl(g_no) then
				Call tryoutVS(g_no, gcnt, arrRS,arrCT, arrRT,placenotice)
			End if
			Next
		End if		
	next
%>

<%else%>
			
			<%
				If IsArray(arrLN) Then
				For ar = LBound(arrLN, 2) To UBound(arrLN, 2) 
				  gcnt = arrLN(0,ar) '총명수
				  g_no = arrLN(1,ar) '조
				  placenotice = arrLN(2,ar)
				  Call tryoutVS(g_no, gcnt, arrRS,arrCT, arrRT,placenotice)
				Next
			  End if
			%>
<%End if%>
	  </tbody>
    </table>
	<br><br>
  </div>
  <!-- E: set_league -->

  </div>
  <!-- E: scroll_box -->
</div>
<!-- E: modal-body game-ctr -->





<%
db.Dispose
Set db = Nothing
%>