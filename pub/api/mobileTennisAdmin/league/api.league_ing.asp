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
selectedGno = oJSONoutput.Gno
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  예선 대진표</span>"


If selectedGno = 0 Then
	selectedGno = 1
End if

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
  bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
  bigo = Replace(bigo ,vbCr ,"\n")
  bigo = Replace(bigo ,vbLf ,"\n")
  JooArea = rs("JooArea")
  JooDivision = rs("JooDivision")
  joocnt = rs("joocnt")

  if(Cdbl(JooDivision) <> 1) Then
    jorder = fc_tryoutGroupMerge(joocnt,JooDivision, JooArea)
    IsChangeJoo =True
  End If

  'poptitle = poptitle & " <span class='txt'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & " ["&levelno&"]</span>"
End if

'#############################################
Call oJSONoutput.Set("S3KEY", levelno )
Call oJSONoutput.Set("P1", 0 )
Call oJSONoutput.Set("POS", 0 )
Call oJSONoutput.Set("JONO", 0 )
Call oJSONoutput.Set("GAMEMEMBERIDX",0 )
Call oJSONoutput.Set("PLAYERIDX",0 )
Call oJSONoutput.Set("PLAYERIDXSub", 0 )
strjson = JSON.stringify(oJSONoutput)
'#############################################

'총라인수
'#############################
  SQL = "select count(*),tryoutgroupno,max(place) from sd_TennisMember where delyn='N' and GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and tryoutgroupno > 0 and gubun =1 and DelYN='N' group by tryoutgroupno"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
  arrLN = rs.getrows()
  End If
'#############################


'예선 참가자 정보
'#############################
'If tidx = "25" Then
  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno = "&selectedGno&" and a.gubun =1 and a.DelYN='N' " 'a.tryoutgroupno 부전승 허수 맴버
  strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순
'else
'  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0 and a.gubun =1 and a.DelYN='N' " 'a.tryoutgroupno 부전승 허수 맴버
'  strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순
'End if

  strAfield = " a. gamememberIDX, a.userName, a.tryoutgroupno, a.tryoutsortno, a.teamAna, a.teamBNa, a.tryoutstateno, a.t_rank,a.key3name ,isnull(a.Courtno,0) Courtno "
  strBfield = " b.partnerIDX, b.userName, b.teamANa, b.teamBNa "
  strfield = strAfield &  ", " & strBfield

  strfield = strfield & " , a.t_win,a.t_tie,a.t_lose  ,isnull(a.place,'') place "

  'SQL = "select "& strfield &" from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
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
  strwhere = " a.delyn = 'N' and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun = 1 and a.tryoutgroupno = "&selectedGno&"  " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료
  strsort = " order by  a.Round asc, a.SortNo asc"
  strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX  " '열 인덱스(기준)
  strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX,b.winIDX,b.m1set1,b.m2set1" '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a "
  SQL = SQL & " INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 and b.delyn = 'N' "
  SQL = SQL & " where " & strwhere & strsort

  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
    arrRT = rs.GetRows() 'RIDX, CIDX, GSTATE
  End if
'#############################

strjson = JSON.stringify(oJSONoutput)
' mrs = arrRs
' rrs = arrRt
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
      <%
      For ar = LBound(gmem, 2) To UBound(gmem, 2) - 1
        gameno = ar
        Select Case ar
        Case 0
          drowtype = "basic"
          t1midx = gmem(2,ar)
          t2midx = gmem(2,ar+1)
          sortno1 = gmem(0,ar)
          sortno2 = gmem(0,ar+1)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)
          t1score = arrFR(5)
          t2score = arrFR(6)

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
          sortno1 = gmem(0,ar-1)
          sortno2 = gmem(0,ar+1)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)
          t1score = arrFR(5)
          t2score = arrFR(6)

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
          sortno1 = gmem(0,ar-1)
          sortno2 = gmem(0,ar)
          arrFR = findResult(t1midx, t2midx, rrs)
          ridx = arrFR(1)
          rstate = arrFR(2)
          rcourtidx = arrFR(3)
          winidx = arrFR(4)
          t1score = arrFR(5)
          t2score = arrFR(6)

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
      <li class="tryout-match__list clear">
        <h3>
          <span><%=sortno1%>번</span><span><%=sortno2%>번</span>
        </h3>
        <div class="tryout-match__list__selc-box selc-box">
          <% if isnull(winidx) then winidx = 0 end if %>
          <% If CDbl(rstate) = 1  And winidx <> "" And win1&win2 <> "" then %>
							  <select id="gcourt_<%=gno%>_<%=gameno%>" disabled  style="font-weight: bold;">
								<option>경기종료</option>
							  </select>
					<% Else %>
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
        <div class="tryout-match__list__result">
          <div class="tryout-match__list__result__selc-box">
            <select name="" id="t1_score<%=ar%>">
              <%for i = 0 to 10%>
              <option value="<%=i%>" <%if t1score = i then%>selected<%end if%>><%=i%></option>
              <%next%>
            </select>
          </div>
          <h4><%=t1p1%><br><%=t1p2%></h4>
          <button class="<% if cdbl(winidx) = cdbl(t1midx) then %>s_win<% elseif cdbl(winidx) <> cdbl(t1midx) and cdbl(winidx) <> 0 then %>s_defeat<% end if %>"
            type="button" name="button" onclick='mx.league_win(<%=t1midx%>,<%=strjson%>,<%=ar%>)'>
          </button>
        </div>
        <div class="tryout-match__list__result right">
          <div class="tryout-match__list__result__selc-box">
            <select name="" id="t2_score<%=ar%>">
              <%for i = 0 to 10%>
              <option value="<%=i%>" <%if t2score = i then%>selected<%end if%>><%=i%></option>
              <%next%>
            </select>
          </div>
          <h4><%=t2p1%><br><%=t2p2%></h4>
          <button class="<% if cdbl(winidx) = cdbl(t2midx) then %>s_win<% elseif cdbl(winidx) <> cdbl(t2midx) and cdbl(winidx) <> 0 then %>s_defeat<% end if %>"
            type="button" name="button" onclick='mx.league_win(<%=t2midx%>,<%=strjson%>,<%=ar%>)'>
          </button>
        </div>

      </li>

			<%End if%>

      <%next%>
  <%
End Sub

'#####################################################################
%>
<header class="header clear">
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button">대회정보관리</button>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con"><%=poptitle%></h1>
  <div class="header__side-con">
    <button class="header__side-con__btn header__btn-reset t_ico" id="reloadbtn" onclick="mx.league_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>', '<%=selectedGno%>')">
      <img src="./Images/mobile_ico_reset.svg" alt="새로고침">
    </button>
  </div>
</header>

<div class="l_modal__con tryout-match">
  <div class="tryout-match__seach">
    <div class="tryout-match__seach__selc-box selc-box">
      <h2><strong class="hide">조 선택</strong></h2>
      <select name="" onchange='mx.changeLeagueGroup(<%=strjson%>)' id="groupSelect">


		<%If IsChangeJoo = True then%>
			<%If isarray(jorder) then%>
			<% For i = 1 To ubound(jorder) %>
			  <option value="<%=jorder(i)%>" <%if jorder(i) = Cdbl(selectedGno) then %>selected<%end if%>><%=jorder(i)%>조</option>
			<% Next %>
			<%End if%>
		<%else%>

			<% if IsArray(arrLN) then %>
			  <% For i = 1 To UBound(arrLN, 2)+1 %>
				<option value="<%=i%>" <%if i = Cdbl(selectedGno) then %>selected<%end if%>><%=i%>조</option>
			  <% Next %>
			<% end if%>

		<%End if%>

      </select>
    </div>
  </div>
  <h2><strong class="hide">리스트 시작</strong></h2>
  <ul>
  <%If IsChangeJoo = true then%>

  <%
  	'For i = 1 To ubound(jorder)
  		If IsArray(arrLN) Then
  			For ar = LBound(arrLN, 2) To UBound(arrLN, 2)
    			gcnt = arrLN(0,ar) '총명수
    			g_no = arrLN(1,ar) '조
    			placenotice = arrLN(2,ar)
    			If CDbl(selectedGno) = CDbl(g_no) then
    				Call tryoutVS(g_no, gcnt, arrRS,arrCT, arrRT,placenotice)
    			End if
  			Next
  		End if
  	'next
  %>

  <%else%>
    <%
    	If IsArray(arrLN) Then
      	For ar = LBound(arrLN, 2) To UBound(arrLN, 2)
      	  gcnt = arrLN(0,ar) '총명수
      	  g_no = arrLN(1,ar) '조
      	  placenotice = arrLN(2,ar)
          If CDbl(selectedGno) = CDbl(g_no) then
      	   Call tryoutVS(g_no, gcnt, arrRS,arrCT, arrRT,placenotice)
          End if
      	Next
      End if
    %>
  <%End if%>
  </ul>
</div>
