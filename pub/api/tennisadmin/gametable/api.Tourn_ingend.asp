<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  본선 진행 대진표</span>"
resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.
onemore = oJSONoutput.ONEMORE

courtarea = oJSONoutput.COURTAREA '코트 장소 0 전체

If hasown(oJSONoutput, "roundSel") = "ok" then
  roundsel = oJSONoutput.roundSel 'select 라운드
  if roundsel ="" then
    roundsel=0
  end if
Else
  Call oJSONoutput.Set("roundSel", 0 )
  roundsel=0
End if


Call oJSONoutput.Set("T_M1IDX", 0 )
Call oJSONoutput.Set("T_M2IDX", 0 )
Call oJSONoutput.Set("T_SORTNO", 0 )
Call oJSONoutput.Set("T_RD", 0 )
Call oJSONoutput.Set("S3KEY", 0 )
Call oJSONoutput.Set("RIDX", 0 ) '결과테이블 인덱스
Call oJSONoutput.Set("NOWCTNO", 0 ) '현재 지정된 코트번호

Set db = new clsDBHelper

'기본정보#####################################
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "

  SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,joocnt,lastroundmethod from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    entrycnt = rs("entrycnt")         '참가제한인원수
    attmembercnt = rs("attmembercnt")   '참가신청자수
    courtcnt = rs("courtcnt")         '코트수
    levelno = rs("level")             '레벨
    lastjoono = rs("lastjoono")         '마지막에 편성된 max 조번호
    bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
    bigo = Replace(bigo ,vbCr ,"\n")
    bigo = Replace(bigo ,vbLf ,"\n")

    endround = rs("endround")         '진행될 최종라운드
    joocnt = rs("joocnt")             '예선에 생성된 조수
    lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트

    If Left(levelno,3) = "200" Then
      joinstr = " left "
      singlegame =  true
    Else
      joinstr = " left "
      singlegame = false
    End if
  End if
'기본정보#####################################


'최종라운드
lastroundcheck = Right(levelno,3)
tn_last_rd = false

'If lastroundcheck = "007" Then
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
  tn_last_rd = True
  SQL = "select max(tryoutgroupno) from sd_TennisMember where  GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and delYN = 'N' "
  Set rsm = db.ExecSQLReturnRS(SQL , null, ConStr)

  If isNull(rsm(0)) = False Then
    lastjoono = rsm(0)
  End if

  If CDbl(lastroundmethod) = 1 And CDbl(lastjoono) = 1 Then
    Call oJSONoutput.Set("result", 4001 ) '리그1 조로 편성되었습니다.
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.end
  End if

  If CDbl(lastroundmethod) = 1 And CDbl(lastjoono) > 1 Then
    tn_last_rd = False
  End if
End if

If tn_last_rd = False Then '최종라운드 토너먼트가 아니라면

    'endround 2 , 4 ,8 , 16, 32, 64
    Select Case CDbl(endround) '진행될 마지막 라운드
    Case 1,2 : hideRDcnt = 0
    Case 4 : hideRDcnt = 1
    Case 8 : hideRDcnt = 2
    Case 16 : hideRDcnt = 3
    Case 32 : hideRDcnt = 4
    Case 64 : hideRDcnt = 5
	Case 128 :  hideRDcnt = 6
    End Select


Else '최종라운드
  drowCnt = 4
  depthCnt = 3
End if

	'###################################
    jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면
    SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
        drowCnt=rs("gang")
        depthCnt = rs("round")
		depthCnt = CDbl(depthCnt - hideRDcnt)
	End if
	'###################################


If CDbl(levelno) = 20104001 And CDbl(tidx) = 32 Then
drowCnt=128
depthCnt = 8
 depthCnt = CDbl(depthCnt - hideRDcnt)
End If



'본선 정보 호출 (이거 장소에 맞추어서)

  If courtarea = "0" then
	  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and stateno = 1 and a.gubun >= "&TOURNSET&"  " 'TOURNSET 2 본선대기 3 본선입력완료 (짝이 있다면 stateno = 1)
  Else
	  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and stateno = 1 and a.gubun >= "&TOURNSET&"  and place like '" & courtarea & "%' "
  End if

  strsort = " order by a.writedate asc,round asc,  SortNo asc"
  strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
  strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno,a.place,a.writedate "
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  rscnt =  rs.RecordCount

'Response.write sql
' Call rsdrow(rs)
' Response.end

  If Not rs.EOF Then
  arrT = rs.getrows()
  End If
'본선 정보 쿼리 재호출


'스코어 입력 정보 가져오기 ( 코트 정보를 가져와야 하는구나 여기부터 작업 ~~~~~
'#############################
  strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun >= "&TOURNSET&"  " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료 b.stateno 경기종료
  strsort = " order by  a.Round asc, a.SortNo asc"
  strAfield = "  a.gamememberIDX, a.Round , a.SortNo,b.courtno,b.waitcourtno  " '열 인덱스(기준)
  strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX,b.winIDX,m1set1,m2set1 " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
    arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
  End if

'#############################

'코트정보
'#############################
  SQL = "select idx,no,courtname,courtuse,courtstate,areaname,settime from sd_TennisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and courtuse = 'Y'  "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
	  arrCT = rs.getrows()
  End If

  SQL = "select areaname,count(*) from sd_TennisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and courtuse = 'Y'  group by areaname"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
	  arrAR = rs.getrows()
  End If


'#############################
'function
'#############################

  waitorderno = 1
  Sub tournInfo_ing_end(ByVal arrRS , ByVal rd , ByVal sortno, ByVal arrRT, ByVal rdstr , ByVal crs) ' 대진표배열 , 라운드 , 소트, 스코어입력배열, 코트배열
	  Dim ar ,at, ct, m1idx,m1name,mrd,msortno,m2idx,m2name,m1pidx,cnt,r_midx,r_stateno,ridx,wmidx
	  Dim chkpass,chkcnt
	  Dim waitmode, ct_idx, ct_no, ct_courtname, ct_courtstate,rcourtidx,waitcourtidx           ,tst,tst2,ct_courtarea,playerplace
	  Dim wdate,hh,mm,ss,ct_courtsettime,settimecolor
	  settimecolor = "blue" '매칭되었을때 색

	  chkpass = True

	  If IsArray(arrRS) Then
		cnt = 1
		chkcnt = 0 '짝이 있는지

		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
		  m1idx       = arrRS(0, ar)
		  m1name      = arrRS(1, ar)
		  mrd         = arrRS(4, ar)
		  msortno     = arrRS(5, ar)


		  If isnumeric(msortno) = False Then
			Exit sub
		  End if

		  If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno)-1 Then
			m1idx = m1idx
		  End If
		  If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) Then
			m2idx = m1idx
		  End if

		  '출력 조건 검사
		  If CDbl(rd) = CDbl(mrd) And (CDbl(msortno) = CDbl(sortno) Or CDbl(msortno) = CDbl(sortno)-1) Then
			chkcnt = chkcnt + 1
			If m1name = "부전" Or  m1name = "--" Or m1name = "" Then
			  chkpass = False
			  Exit For
			End If

			'종려된 경기인지 확인
			If IsArray(arrRT) Then
					For at = LBound(arrRT, 2) To UBound(arrRT, 2)
					r_midx      = arrRT(0, at)  '1번맴버인덱스
					r_stateno      = arrRT(7, at)  ' 1경기종료

					If CDbl(r_midx) = CDbl(m1idx) Then
					  If CDbl(r_stateno) = 1  then
						chkpass = False
						rcourtidx = arrRT(3, at)
						wmidx      = arrRT(11, at)
						mscoreA =  arrRT(12, at)
						mscoreB =  arrRT(13, at)
						Exit For
					  End if
					End if
					Next
			End if

		  End if
		Next
	   End If



	  If chkpass = false And chkcnt > 1 Then '종료된것이 있고 짝지어진것이 한개라도 있다면
	  If IsArray(arrRS) Then
		  cnt = 1
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
			m1pidx      = arrRS(11, ar)
			m1idx       = arrRS(0, ar)
			m1name      = arrRS(1, ar)
			mrd         = arrRS(4, ar)
			msortno     = arrRS(5, ar)
			m2name      = arrRS(6, ar)
			playerplace  = arrRS(16,ar)
		    wdate = arrRS(17, ar)
			hh = hour(wdate)
			mm = minute(wdate)
			ss = Second(wdate)


		If CDbl(rd) = CDbl(mrd) And (CDbl(msortno) = CDbl(sortno) Or CDbl(msortno) = CDbl(sortno)-1) Then

		  If  CDbl(cnt) = 1 then%>
			<tr  class="playing">
			  <th><%=waitorderno%></th>
			  <td>
				<%
				oJSONoutput.T_M1IDX = m1idx
				oJSONoutput.T_M2IDX = m2idx
				oJSONoutput.T_RD = rd
				oJSONoutput.T_SORTNO = sortno
				oJSONoutput.S3KEY = levelno
				oJSONoutput.RIDX = ridx
				oJSONoutput.NOWCTNO = rcourtidx '현재코트인덱스
				strjson = JSON.stringify(oJSONoutput)

				If IsArray(crs) Then
					For ct = LBound(crs, 2) To UBound(crs, 2)
					  ct_idx = crs(0,ct)
					  ct_no = crs(1,ct)
					  ct_courtname = crs(2,ct)
					  ct_courtstate = crs(4,ct)
					  ct_courtarea = crs(5,ct)
					  ct_courtsettime = crs(6,ct)

					  If CDbl(rcourtidx) = CDbl(ct_idx) Or CDbl(rcourtidx) = 0  Then
						  '코트 지정시간
						  If isdate(ct_courtsettime) = True Then
							settimecolor = "green" '매칭시간
							hh = hour(ct_courtsettime)
							mm = minute(ct_courtsettime)
							ss = Second(ct_courtsettime)
						  End If

						  If CDbl(rcourtidx) = 0 then
							  Response.write  "지정하지 않음"
							  Exit for
						  Else
							  Response.write  ct_courtarea & "&nbsp;" & ct_courtname
							  Exit for
						  End if
					  End if
					Next
				End If
				%>

			  </td>
			  <td style="color:<%=settimecolor%>;" title="<%=wdate%>"><%=hh%>:<%=mm%>:<%=ss%>
			  </td>
			  <td><%=rdstr%>강</td>

			  <td class="score_line"><%=mscoreA%>:<%=mscoreB%></td>

			  <td>
				<div class="groupbtn" id="cell_<%=rd%>_<%=sortno%>">
		  <%
		  waitorderno = waitorderno + 1
		  End If
		  %>
				  <%If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno)-1 then%>



					<a  class="team team_a <%If CDbl(wmidx) = CDbl(m1idx) then%>win<%End if%>">
					  <ul class="clearfix">
						<li><span class="player"><%=Left(m1name,4)%></span></li><li><span class="player"><%=Left(m2name,4)%></span></li>
					  </ul>
					  <p class="result_txt">승</p>
					</a>
				  <%End if%>

				  <%If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) then%>
					<a  class="team team_b <%If CDbl(wmidx) = CDbl(m2idx) then%>win<%End if%>">
					  <ul class="clearfix">
						<li><span class="player"><%=Left(m1name,4)%></span></li><li><span class="player"><%=Left(m2name,4)%></span></li>
					  </ul>
					  <p class="result_txt">승</p>
					</a>
				  <%End if%>

		  <%If cnt = 2 then%>
			  </div>
			  </td>
			</tr>
		  <%End if%>

				<%
			  If cnt = 2 then
			Exit For
		  End If

		  cnt = CDbl(cnt) + 1
			End If
		  Next

		End If
	  End if

  End Sub
'#############################
%>



<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=levelno%>-- <%=poptitle%></h3>
  </div>
<!-- 헤더 코트e -->

<div class='modal-body game-ctr'>
  <div class="top_control">

    <%strjson = JSON.stringify(oJSONoutput)%>

    <div class="league_tab clearfix">
	  <div class="pull-left">
		    <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" class = "btn_a btn btn_tab">본선대진표</a>
		    <a href="javascript:mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" class="btn_a btn btn_tab on">본선경기진행</a>


			<select id="court_areaname" onchange="mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')"  style="width:200px;height:38px;"   >
			<option value="0" <%If courtarea = "0" then%>selected<%End if%>>코트명 선택</option>
				<%
				If IsArray(arrAR) Then
					For ar = LBound(arrAR, 2) To UBound(arrAR, 2)
						  areaname  = arrAR(0, ar)
						  areacnt = arrAR(1,ar)

						  If courtarea = Left(areaname,Len(courtarea)) Then
							areaselected = "selected"
						  Else
							areaselected = ""
						  End if
						  Response.write "<option value="""&areaname&""" "&areaselected&">" & areaname & " (" & areacnt &  ")</option>"
					Next
				End if
				%>
			</select>
		    <button id="tourning" style=" display:none;" onclick="mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')">본선진행숨김버튼</button>
	  </div>



      <div class="pull-right">
        <input type="text" placeholder="검색어를 입력해 주세요." class="search_btn" onkeydown="if(event.keyCode == 13){mx.docfindstr('search_btn','t2_drowbody span','#t2_drowbody' , 'table4');}" name="text-12" id="text-12" value="">

		<a href="javascript:mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','0')" class="btn_a btn btn_tab change_type">
          <span class="txt">예선</span>
          <span class="ic_deco"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
        </a>
	    <button id="reloadbtn" onclick="$('#loadmsg').text('&nbsp;로딩 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel');"  style=" display:none;">새로고침</button><!-- 안보임 내부적으로 클릭사용 -->
      </div>
	</div>
  </div>



  <!-- S: set_tourney -->
  <div class="set_tourney">
    <table class="table table-striped set_tourney_table" style="margin-bottom:0px;">
      <thead><tr><th>진행순번</th><th>코트배정</th><!-- <th>예정코트</th> --><th>지정/매칭</th><th>강수</th><th class="score">스코어</th><th>

	  <a href="javascript:mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" class="btn btn_func">경기진행</a>
	  <a href="javascript:mx.tournament_ing_end(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" class="btn btn_func">완료</a>

	  </th></tr></thead>
	</table>









  <div class="scroll_box"  id="t2_drowbody" style="margin-top:0px;">
	<table class="table table-striped set_tourney_table">
    <tbody>

		  <%'본선#################%>
			<%
					If IsArray(arrT) Then

						For ar = LBound(arrT, 2) To UBound(arrT, 2)
							m1idx			= arrT(0, ar)
							m1name		= arrT(1, ar)
							mrd			= arrT(4, ar)
							msortno		= arrT(5, ar)

							If isnumeric(msortno) = True then
							If CDbl(msortno) Mod 2 = 0 then

							  Select Case CDbl(mrd)
							  Case 1 : roundcnt = Fix(drowCnt)
							  Case 2 : roundcnt = Fix(drowCnt/2)
							  Case 3 : roundcnt = Fix(drowCnt/2/2)
							  Case 4 : roundcnt = Fix(drowCnt/2/2/2)
							  Case 5 : roundcnt = Fix(drowCnt/2/2/2/2)
							  Case 6 : roundcnt = Fix(drowCnt/2/2/2/2/2)
							  Case 7 : roundcnt = Fix(drowCnt/2/2/2/2/2/2)
							  Case 8 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2)
							  Case 9 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2/2)
							  Case 10 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2/2/2)
							  End Select

							Call tournInfo_ing_end(arrT, mrd, msortno, arrRS, roundcnt,arrCT) ' 대진표배열 , 라운드 , 소트, 스코어입력배열, 코트배열
							End If
							End if
						Next

					End if
			%>
		  <%'본선#################%>

      </tbody>
    </table>
	<br><br>
  </div>
  </div>
  <!-- E: set_tourney -->

</div>

<%
db.Dispose
Set db = Nothing
%>
