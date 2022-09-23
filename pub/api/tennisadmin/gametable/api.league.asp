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
stateno =  oJSONoutput.StateNo '999 게임종료 모두 막음
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  예선 대진표</span>"

Set db = new clsDBHelper

SQL = " Select EntryCnt,attmembercnt,courtcnt,level,bigo,JooArea,JooDivision,joocnt,fee,fund from tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
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
  fee = rs("fee") '참가비
  fund = rs("fund") '기금
  acctotal = CDbl(fee) + CDbl(fund) '참가금액
  poptitle = poptitle & " - " & levelno
  'poptitle = poptitle & " <span class='txt'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & " ["&levelno&"]</span>"

  ' if bigo <>"" then
  '     poptitle = poptitle & " <p><span style='color:blue'> ※공지※</span><p><p<span>"&bigo&"</span><p>"
  ' end if
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

  '추가 참여자서 설정된경우 기존 설정을 바꾸지 않도록 한다.
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "


''입금상태 정보가져오기
''#############################
SQL =  "SELECT a.PaymentType,a.P1_PlayerIDX,a.P2_PlayerIDX,p.VACCT_NO,a.requestIDX FROM tblGameRequest as a left join TB_RVAS_LIST as p ON a.RequestIDX=p.CUST_CD WHERE  a.DelYN = 'N' and a.GameTitleIDX = "&tidx&" and a.Level =" & levelno
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




If Not rs.EOF Then
  If Not rs.EOF Then
  arrAT = rs.getrows()
  End If
End If
''#############################
Function findpaytype(ByVal pidx1, ByVal pidx2, ByVal arrat, ByVal acctotal, ByVal reqidx)
  Dim ct,pidxA,pidxB,payflag,vaccno,attridx
  If IsArray(arrat) Then
  For ct = LBound(arrat, 2) To UBound(arrat, 2)
    payflag = arrat(0,ct)
    pidxA = arrat(1,ct)
    pidxB = arrat(2,ct)
	vaccno = arrat(3,ct) '입금완료된 가상계좌번호
	attridx = arrat(4,ct)

	If isnull(pidxA) = True Or pidxA = "" Then
		pidxA = 0
	End if
	If isnull(pidxB) = True Or pidxB = "" Then
		pidxB = 0
	End if

	'If reqidx = "49833" Then
		'Call getrowsdrow(arrat)
		'findpaytype = pidxA & "-" & pidx1
		'Exit function
	'End if


	If reqidx = "" Or isnull(reqidx) = True then

		If CDbl(pidxA) = CDbl(pidx1) or CDbl(pidxB) = CDbl(pidx2) Then
		  If CDbl(acctotal) = 0 Then
			  findpaytype = payflag
		  else
			  If vaccno = "" Or isNull(vaccno) = True Then
				  findpaytype = payflag
			  Else
				  If vaccno = "1" Then
					  findpaytype = payflag
				  else
					  findpaytype = "V"
				  End if
			  End If
		  End If

		  Exit for
		End If

	Else
		If CDbl(attridx) = CDbl(reqidx) Then

		  If CDbl(acctotal) = 0 Then
			  findpaytype = payflag
		  else
			  If vaccno = "" Or isNull(vaccno) = True Then
				  findpaytype = payflag
			  Else
				  If vaccno = "1" Then
					  findpaytype = payflag
				  else
					  findpaytype = "V"
				  End if
			  End If
		  End If

		  Exit for

		End if
	End if


  Next
  End If
End Function

  '그룹번호, 소팅번호 생성 ################s
    SQL = "SELECT max(tryoutgroupno),count(*) FROM " & strtable & " where GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and  gubun in ( 0, 1) and tryoutgroupno >= 0 and delYN = 'N' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    maxgno = rs(0)
    attcnt  = rs(1)

    If isNull(maxgno) = False then

      If  CDbl(rs(0)) = 0 Then '편성다시
      '1보다 큰게 하나라도 없다면 업데이트 (이후엔 예선 자동 편성을 이용한다. 선수가 추가되었다면 랭킹 적용을 다시한다.)
        strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and  a.gubun in ( 0, 1) and a.delYN = 'N' "
        strsort = " order by totalRankpoint desc" '조별
        strfield = " tryoutgroupno, tryoutsortno, a.gamememberIDX, (a.rankpoint + b.rankpoint) as totalRankpoint,a.TeamANa,a.TeamBNa,b.TeamANa,b.TeamBNa "

        SQL = "select " & strfield & " from  " & strtable & " as a "
        SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
        SQL = SQL & "where " & strwhere & strsort
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        If Not rs.EOF Then
        arrRSsort = rs.getrows()
        End If

        t1no = 1
        t2no = joocnt
        t3no = joocnt

        If IsArray(arrRSsort) Then
        For ar = LBound(arrRSsort, 2) To UBound(arrRSsort, 2)
          rgamememberIDX = arrRSsort(2,ar)
          tnm1 = arrRSsort(4,ar)
          tnm2 = arrRSsort(5,ar)
          tnm3 = arrRSsort(6,ar)
          tnm4 = arrRSsort(7,ar)

          If ar < joocnt then
              SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 1, tryoutgroupno = " & t1no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
              Call db.execSQLRs(SQL , null, ConStr)
              t1no = t1no + 1
          End If

          If ar >= joocnt And ar < joocnt*2  Then
              SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 2, tryoutgroupno = " & t2no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
              Call db.execSQLRs(SQL , null, ConStr)
              t2no = t2no -1
          End If

          If ar >= joocnt*2 And ar < CDbl(UBound(arrRSsort, 2) + 1)  Then
              SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 3, tryoutgroupno = " & t3no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
              Call db.execSQLRs(SQL , null, ConStr)
              t3no = t3no -1
          End If

        Next
        END If
      End If

     End if


  '참가자 목록 =============================================s
		strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0  and a.gubun in ( 0, 1) and a.DelYN = 'N' "
		strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별

		strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint, a.rankpoint + b.rankpoint as totalPointWithPartner, a.AttFlag,  a.GiftFlag, a.gameMemberIDX, a.PlayerIDX as PlayerIDX, b.PlayerIDX as PatnerPlayerIDX, a.gubun,t_rank, a.areaChanging, A.SeedFlag, A.rndno1, A.rndno2, A.place, a.requestIDX, t_win, t_lose "  '끝번호 0 ~ 27
		strfield = strAfield &  ", " & strBfield

		SQL = "select " & strfield & " from  " & strtable & " as a "
		SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
		SQL = SQL & "where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
		arrRS = rs.getrows()
		End If
		Set rs = Nothing

	  '조편성 상태 확인하기
	  showordersell = True '현재 상태(전체노출상태)
	  placestate = True '장소가 모두 입력되었음
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
			chk_gn = arrRS(18,ar)
			chk_place = arrRS(24,ar)

			If chk_place = "" Then
				placestate = false
				'Exit For
			End if


			If chk_gn = 0 Then
				showordersell = False '전체 비노출 상태
				'Exit For
			End if
		Next
		End If
  '참가자 목록 =============================================e

'/////////////////////////////////////////////////
'S : 예선 조 코트 배정
'/////////////////////////////////////////////////
Sub DrowCourt_try(ByVal rd )
    %>
            <option value="0" selected >코트배정</option>
            <%
                for Cot=1 to courtcnt
                 useYnCourt ="N"
                 selectCourt =""
                 textCourt =""

                      If IsArray(useCourtRS) Then
                         For uC = LBound(useCourtRS, 2) To UBound(useCourtRS, 2)
                            if useCourtRS(4, uC) =1 then
                                if  useCourtRS(1, uC) =2 then
                                     if useCourtRS(0, uC) =Cot then
                                        useYnCourt ="Y"

                                        if useCourtRS(3, uC) =0 then
                                            textCourt="본선"
                                        else
                                            textCourt="예선"&useCourtRS(3, uC)&"조"
                                        end if

                                     end if
                                end if

                                if useCourtRS(1, uC) =2 and useCourtRS(3, uC) =rd  and  useCourtRS(0, uC) =Cot then
                                    selectCourt ="selected"
                                end if
                            end if
                         Next
                      end if

                    if useYnCourt ="N" then
                        %>
                          <option value="<%=Cot%>" style="background-color: #FFFFFF;" <%=selectCourt %> ><%=Cot %> 코트 배정
                        <%
                    else
                        %>
                          <option value="999" style="background-color: #FF0000;" <%=selectCourt %> ><%=Cot %> 코트 사용중(<%=textCourt %>)
                        <%
                    end if
                %>
                   </option>
                <%
                next
            %>
    <%
End Sub
'/////////////////////////////////////////////////
'E : 예선 조 코트 배정
'/////////////////////////////////////////////////
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

    <!-- S: league_tab -->
    <div class="league_tab clearfix">
      <div class="pull-left">
        <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>');" class = "btn_a btn btn_tab on">
		<%If showordersell = False then%>출전신고<%else%>
			<%If placestate = true then%>
			예선결과 입력/본선추첨
			<%else%>
			출전신고
			<%End if%>
		<%End if%>
		</a>
        <a href='javascript:mx.league_ing(<%=strjson%>)' class="btn_a btn btn_tab">예선경기진행</a>
        <!-- <a href="javascript:alert('<%'=bigo%>')" class="btn_a btn btn_tab">공지글 보기</a> -->

		<%If showordersell = True And placestate = true then%>
	    <%If CDbl(ADGRADE) > 500 then%>
		<a href="./gamerull3.asp?tidx=<%=tidx%>&ridx=<%=levelno%>" class="btn_a btn btn_tab">본선시드배정</a>
		<%End if%>
		<%End if%>

      </div>

      <div class="pull-right">
        <input type="text" placeholder="검색어를 입력해 주세요." class="search_btn" onkeydown="if(event.keyCode == 13){mx.docfindstr('search_btn','gametable tr td div a','#gametable' , 'table1');}" name="text-12" id="text-12" value="">

		<%If showordersell = True And placestate = true Then '모든조가 편성되었다면%>
		<a href="javascript:mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>')" class="btn_a btn btn_tab change_type">
          <span class="txt">본선</span>
          <span class="ic_deco">
            <i class="fa fa-angle-right" aria-hidden="true"></i>
          </span>
        </a>
		<%End if%>

      </div>

    <button id="reloadbtn" onclick="$('#loadmsg').text('&nbsp;선수 교체 중.....');mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>');"  style=" display:none;">새로고침</button><!-- 안보임 내부적으로 클릭사용 -->
    </div>
    <!-- E: league_tab -->

  </div>
  <!-- E: top_control -->

  <!-- S: scroll_box -->
  <div class="scroll_box" id="drowbody">
    <%
    If IsArray(arrRS) Then
	%>
    <div class="inner_sub_ctrl">
      <div class="ctr_table">
		  <%
		  '조나눔 합침 >> 화면 보임 막아둠 s
			endgroup = arrRs(0,UBound(arrRS, 2))
			Call oJSONoutput.Set("EndGroup", endgroup )
			strjson = JSON.stringify(oJSONoutput)
			IsChangeJoo =False

			if(Cdbl(JooDivision) <> 1) Then
			jorder = fc_tryoutGroupMerge(endgroup,JooDivision, JooArea)
			IsChangeJoo =True
			End IF
			%>

   	    <!-- 검색을 넣자 -->

		<%If showordersell = false Then '모든조가 편성X%>
		    <%If CDbl(ADGRADE) > 500 then%>
			<span class="txt">조 박스 나누기</span>
			<select  name="JooDivision" id="JooDivision">
			  <%
			  maxJooDivision = 8
			  if endgroup >= maxJooDivision Then
				maxJooDivision = 8
			  ELSE
				maxJooDivision = endgroup
			  END IF

			  For i = 1 To maxJooDivision  %>
			  <option value="<%=i%>"   <% IF i = Cdbl(JooDivision) Then %>selected="selected" <% End If%>><%=i%></option>
			  <% Next %>
			</select>
			<a href='javascript:mx.setJooDivision(<%=strjson%>);' class='btn_a btn btn_enter' >입력</a>

			<span class="txt">각 조로 합침</span>
			<select name="selJooArea" id="selJooArea">
			  <% For i = 1 To JooDivision %>
			  <option value="<%=i%>" <% IF i = Cdbl(JooArea) Then %> selected="selected"  <% End If%>>  <%=i%>  </option>
			  <% Next %>
			</select>
			<a href='javascript:mx.setJooArea(<%=strjson%>);' class='btn_a btn btn_enter' >입력</a>
		    <%End if%>
   	    <%End if%>
      </div>

      <%'조나눔 합침 >> 화면 보임 막아둠 e  %>
	  <%If showordersell = True Then '모든조가 편성되었다면%>
		  <a href='javascript:mx.initCourt(<%=strjson%>)' class="btn btn_func">코트 관리</a>
	  <%else%>
		  <%If CDbl(ADGRADE) > 500 then%>
		  <a href='javascript:mx.FillingEmptyEntry(<%=strjson%>);' class="btn btn_func">예선 재 편성</a>
		  <%End if%>
		  <a href='javascript:mx.updateMember(<%=strjson%>)' class="btn btn_func">선수 신규 등록</a>
		  <a href='javascript:mx.initCourt(<%=strjson%>)' class="btn btn_func">코트명/ 코트번호 등록</a>
	  <%End if%>

			<button id="opencourt" onclick='mx.initCourt(<%=strjson%>)'  style=" display:none;">안보임 코트오픈</button><!-- 안보임 내부적으로 클릭사용 -->
			 <%
			  oJSONoutput.POS = "newjoo"
			  strjson = JSON.stringify(oJSONoutput)
			  %>
		  <a href='javascript:mx.updateMember(<%=strjson%>)' class="btn btn_func">조[팀]생성</a>
	</div>


<%'예선 테이블######################################################################%>

<span id="loadmsg"><!-- 로딩 메시지 표시 -->

<table border="1" width="100%" id="gametable"

<%If showordersell = True then%>
	<%If placestate = True then%>
		class  ="table-list game-ctr type_2"
	<%else%>
		class  ="table-list game-ctr type_1"
	<%End if%>
<%else%>
		class  ="table-list game-ctr"
<%End if%>
>


  <thead>
    <th>조</th>
  <%If showordersell = True Then '모든조가 편성되었다면%>
    <%If placestate = True then%>
	<th>1위번호</th><th>2위번호</th>
	<%End if%>

  <%End if%>
  <th><a href='javascript:mx.inputRegion(<%=strjson%>);' class='btn_a' >지역 저장</a></th>
  <th>[출석/사은품/입금] 1팀</th><th>[출석/사은품/입금] 2팀</th><th>[출석/사은품/입금] 3팀</th><th>경기입력</th>
  </thead>

<%
	function setTeamLink(ByVal t1, ByVal t2,ByVal t3,ByVal t4)
		Dim tn
		If t1 <> "" Then
			tn = t1
		End If
		If t2 <> "" Then
			If tn = "" then
				tn = t2
			else
				tn = tn & "`~" & t2
			End if
		End If
		If t3 <> "" Then
			If tn = "" then
				tn = t3
			else
				tn = tn & "`~" & t3
			End if
		End If
		If t4 <> "" Then
			If tn = "" then
				tn = t4
			else
				tn = tn & "`~" & t4
			End if
		End If
		setTeamLink = tn
	End function



  '각조의 중복값을 찾아서 넣어둔다.####################################s
	If CDbl(joocnt) < CDbl(maxgno) then
		ReDim gteamArr(maxgno)
	    ReDim duparr(maxgno)
	Else
		ReDim gteamArr(joocnt)
	    ReDim duparr(joocnt)
	End if

'Response.write joocnt

    pregno = 1
    If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

		  g_no = arrRS(0,ar)
		  tnm1 = arrRS(4,ar)
		  tnm2 = arrRS(5,ar)
		  tnm3 = arrRS(9,ar)
		  tnm4 = arrRS(10,ar)

		  If pregno = g_no Then
			If ar = 0 then
			  tnstr =  setTeamLink(tnm1,tnm2,tnm3,tnm4)
			Else
			  If tnstr = "" Then
				  tnstr =  setTeamLink(tnm1,tnm2,tnm3,tnm4)
			  else
				  tnstr =  tnstr &"`~"& setTeamLink(tnm1,tnm2,tnm3,tnm4)
			  End if
			End if
		  Else
			gteamArr(g_no - 1) = tnstr
			tnstr =  setTeamLink(tnm1,tnm2,tnm3,tnm4)
		  End if

		  If ar = UBound(arrRS, 2) Then
			gteamArr(g_no) = tnstr
		  End if

		  pregno = g_no
		Next
    END If

'    ReDim duparr(joocnt)

    For d = 1 To Ubound(gteamArr)
	  arr = DuplValRemove( Split(gteamArr(d),"`~") )
	  duparr(d) = arr
	Next

  '각조의 중복값을 찾아서 넣어둔다.#####################################e


  'LoopCnt = 0
  '편성 완료 존재 여부
  DiffGubunYN = "N"

  tabno = 1
  tabno2 = 1

  For i = 1 To endgroup
%>
  <tr id="JoonoBox_<%If IsChangeJoo = True then%><%=jorder(i)%><%else%><%=i%><%End if%>">
  <td><font color="red"><%If IsChangeJoo = True then%><%=jorder(i)%><%else%><%=i%><%End if%></font></td>
<%
  tdcnt = 0
  '각 조의 1팀,2팀 존재여부
  For j = 1 To 3
    'Response.write "j : " & j & "</br>"
    chkdata = "N"
    For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
     Do
      gno = arrRS(0,ar)
      sortno = arrRS(1,ar)
      p1idx =  arrRS(2,ar)
      p1name = arrRS(3,ar)
      p2name = arrRS(8,ar)
      rpointsum = arrRS(12,ar)
      rAttFlag = arrRS(13,ar)
      rGiftFlag = arrRS(14,ar)
      rGameMemberIDX = arrRS(15,ar)
      rPlayerIDX = arrRS(16,ar)
      rPlayerIDXSUB = arrRS(17,ar)
      gubun = arrRS(18,ar)
      t_rank = arrRS(19,ar)
      rareaChanging = arrRS(20,ar)
      rSeedFlag = arrRS(21,ar)
      rRndNo1 = arrRS(22,ar)
      rRndNo2 = arrRS(23,ar)
      rPlace = arrRS(24,ar)
	  rreqidx = arrRS(25,ar)


	tnm1 = arrRS(4,ar)
    tnm2 = arrRS(5,ar)
    tnm3 = arrRS(9,ar)
    tnm4 = arrRS(10,ar)

	 t_win = arrRS(26,ar) '승수
	 t_lose = arrRS(27,ar) '패수


      oJSONoutput.GAMEMEMBERIDX = rGameMemberIDX
      oJSONoutput.PLAYERIDX = rPlayerIDX
      oJSONoutput.PLAYERIDXSUB = rPlayerIDXSUB

      if ISNULL(rRndNo1)  Then
        rRndNo1 = ""
      End If

      if isnull(rRndNo2)Then
        rRndNo2 = ""
      End If

      '3개 팀이 완료 되었을 경우 더 이상 돌지 않는다.
      if(tdcnt = 3) Then
        Exit for
      End if

      If IsChangeJoo = True  Then
        chkjoono = CDbl(jorder(i))
      Else
        chkjoono = i
      End if

      '현재 그룹에 맞지 않으면 Do While을 빠져나간다.
      if(gno <> chkjoono)Then
       Exit Do
      End if

      Call oJSONoutput.Set("JONO", chkjoono )
      strjson = JSON.stringify(oJSONoutput)

      If CDbl(sortno) = CDbl(j) And CDbl(gno) = CDbl(chkjoono) Then
        tdcnt = CDbl(tdcnt) + 1
        chkdata = "Y"
        chkgubun = gubun
        Call oJSONoutput.Set("GUBUN", chkgubun )
        strjson = JSON.stringify(oJSONoutput)
      %>

      <%
        '같은 조에 1번 2번 선수가 있어야 편성완료가 된다.
        IF(chkgubun = "1" And DiffGubunYN = "N")  Then
          DiffGubunYN="Y"
        END IF
      %>


  <%If showordersell = True Then '모든조가 편성되었다면%>

	<%If j = 1 and CDbl(tdcnt) = 1 Then%>
		<%If placestate = True then%>
		<td>
          <input type="number"  min="1" step="1" name="rndno1[]" id="rndno1_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","1",this);' onfocus="this.select();"  value="<%=rRndNo1%>"
          <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
		  class="tabable"
		   tabindex = "<%=tabno%>"
		   onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabable')}" >
        </td>
        <td>
          <input type="number" min="1" step="1"  name="rndno2[]" id="rndno2_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' onfocus="this.select();"  value="<%=rRndNo2%>"
          <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
	     class="tabable2"
		  tabindex = "<%=tabno%>"
		  onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabable2')}" >
        </td>
		  <%tabno = CDbl(tabno) + 1%>

		<%End if%>
	  <%End If%>
  <%End if%>

  <%If j = 1 and CDbl(tdcnt) = 1 Then%>
          <td>
          <input id="place_<%=chkjoono%>" type="text" style="font-size:12px;width:80px"  value="<%=rPlace%>" tabindex = "<%=tabno2%>" onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabarea',this.value)}" class="tabarea"
		  >
		  <%tabno2 = CDbl(tabno2) + 1%>
        </td>
  <%End if%>



      <td class="<%If CDbl(chkgubun) = 1 then%>make_comp chk_col<%else%>making_group chk_col<%end if%>">
    <%
    '클럽 중복체크 ###############################################################
      If CDbl(chkgubun) = 0  then
	  dupchk = duparr(gno)

      If IsArray(dupchk) Then
        For z = 0 To ubound(dupchk) '0부터 들어가있다 값이

          If dupchk(z) <> "" then
            If (tnm1 = tnm3 Or tnm1 = tnm4 Or tnm2 = tnm3 Or tnm2 = tnm4) Or (tnm1 = tnm2 Or tnm3 = tnm4)  Then '자기꺼가 같은애들도 있다...
				samjooteam = "★<br>"
			Else
				samjooteam = ""
            End if
			If tnm1 = dupchk(z) Or tnm2 = dupchk(z) Or tnm3 = dupchk(z) Or tnm4 = dupchk(z) then
            Response.write "<div class=""dupstr""  style=""word-break:break-all;width:10px;"">" &samjooteam&dupchk(z)& "</div>"
            End If

          End if
        Next
      End If
      End If



    '클럽 중복체크 ###############################################################
    %>

    <div
          <%If CDbl(chkgubun) = 0  then%>
          <% IF rareaChanging = "Y" then %>
            style='border: 1px solid #73AD21; width:100%; background-color: #f7dbdc;'
          <% Else %>
            style='border: 1px solid #73AD21; width:100%; height: 100%;'
          <% END IF %>
          onClick='mx.changeSelectArea(<%=rGameMemberIDX%>,this,<%=chkjoono%>,<%=j%>,<%=strjson%>)'
          <%else%>
          class='making_group chk_col'
          <%End if%>
          id='drag_<%=gno%>_<%=sortno%>'>
    <%if chkgubun = "0" then%><a href='javascript:mx.delTeam(<%=strjson%>)' class=" btn_del">X</a><%End if%>


    <%'if chkgubun = "0" then%>
    <%'If CDbl(ADGRADE) <= 500 then%>
	  <div class="chk_state">
      <%rPaymentFlag = findpaytype(rPlayerIDX,rPlayerIDXSUB,arrAT,acctotal ,rreqidx)%>
        <span >출석</span><label class="switch" title="출석">
        <input type="checkbox"  name="attCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"att",this);' <% if( rAttFlag = "Y") Then%> checked <%END IF%> >
        <span class="slider round"></span>
        </label>
		<span >사은품</span><label class="switch"  title="사은품">
        <input type="checkbox"  name="giftCheckBox"  class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"gift",this);' <% if( rGiftFlag = "Y") Then%> checked <%END IF%>>
        <span class="slider round"></span>
        </label>

		<%If rPaymentFlag = "V" Then '가상계좌 입금완료된 팀이라면%>
			<span style="color:red;">입금완료</span>
		<%else%>
			<span>
			<%
			'If rreqidx = "49833" Then
			'	Response.write rPaymentFlag  &"--"
			'End if

			%>입금</span>
			<label class="switch"  title="입금">
			<input type="checkbox"  name="paymentCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"payment",this);'  <% if( rPaymentFlag = "Y") Then%> checked  disabled<%END IF%>>
			<span class="slider round"></span>
			</label>
		<%End if%>

    </div>
    <%'End if%>
    <%'end if%>

      <!-- S: chk_state -->
      <div class="chk_state">

    <%If CDbl(chkgubun) = 1 then%>
      <%
        oJSONoutput.P1 = p1idx
        oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
        strjson = JSON.stringify(oJSONoutput)
      %>

	      <%'If showordersell = True And placestate = True Then '모든조가 편성되었다면%>
			  <select id="rankL_<%=chkjoono%>_<%=tdcnt%>" onchange='javascript:mx.SetGameLeagueRanking(<%=strjson%>)'
			  <%
			  if Cdbl(t_rank) >= 1 and Cdbl(t_rank) < 3 Then
			  %>style="background-color:#3e7c00;color:<%if Cdbl(t_rank) = 1 then%>red<%else%>#fff<%End if%>;" <%
			  Else

			  END IF
			  %>>
				<option value="0"  <%If t_rank = "0" then%>selected<%End if%>>순위</option>
				<option value="1"  <%If t_rank = "1" then%>selected<%End if%>>1위</option>
				<option value="2"  <%If t_rank = "2" then%>selected<%End if%>>2위</option>
				<%If Right(levelno,3) = "007" then%>
				<option value="3"  <%If t_rank = "3" then%>selected<%End if%>>3위</option>
				<%End if%>
			  </select>
	      <%'End if%>
    <%End if%>

      <a href='javascript:mx.updateMember(<%=strjson%>)'
    role="button"
    <%If CDbl(chkgubun) = 1 then%>style="border:1px solid #DEBA29;"<%else%>class="btn_a btn_updateMember"  <%End if%>
    ><%=p1name%>&nbsp;<%=p2name%></a>

    <%If CDbl(ADGRADE) > 500 then%>
    <input type="text" style="width:50px;" onblur='mx.update_rpoint(<%=strjson%>,<%=p1idx%>,this.value);' value="<%=rpointsum%>" title="포인트합: 수정후 포커스가 이동되면 수정됩니다.">
	<%End if%>

	<br><br><%=tnm1%>&nbsp;<%=tnm2%> : <%=tnm3%>&nbsp;<%=tnm4%>	(<span style="color:red"><%=t_win%>:<%=t_lose%></span>)
    </div>
    <!-- E: chk_state -->
      </td>
      <%
          '데이터를 찾을 경우 For문을 빠져나간다.
          Exit for
        End If
        'Response.Write "gno : " & gno
       Loop While False
    Next

    If chkdata = "N" Then
      tdcnt = CDbl(tdcnt) + 1
      If j = 1 and CDbl(tdcnt) = 1 Then
      SQL = " select Top 1 A.gubun, A.rndno1, A.rndno2, A.place"
      SQL = SQL & " from sd_TennisMember as a LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX"
      SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.gamekey3 = "& levelno & " and a.tryoutgroupno = " & chkjoono & " and a.gubun in ( 0, 1) and a.DelYN = 'N' "
      Set gubunRS = db.ExecSQLReturnRS(SQL , null, ConStr)

      Do Until gubunRS.EOF
        chkgubun = gubunRS("gubun")
        rRndNo1 = gubunRS("rndno1")
        rRndNo2 = gubunRS("rndno2")
        rPlace = gubunRS("place")
        gubunRS.movenext
      Loop

      Set gubunRS = Nothing

      if ISNULL(rRndNo1)  Then
        rRndNo1 = 0
        End If
      if isnull(rRndNo2)Then
        rRndNo2 = 0
      End If
      Call oJSONoutput.Set("GUBUN", chkgubun )
      strjson = JSON.stringify(oJSONoutput)
    %>

	<%If placestate = True then%>

	  <td>
        <input type="text"  name="rndno1[]" id="rndno1_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","1",this);' onfocus="this.select();" value="<%=rRndNo1%>"
        <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
		  class="tabable"
		  tabindex = "<%=tabno%>"
		  onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabable')}"   >
      </td>
      <td>
        <input type="text"  name="rndno2[]" id="rndno2_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' onfocus="this.select();"  value="<%=rRndNo2%>"
        <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
		  class="tabable2"
		  tabindex = "<%=tabno%>"
		  onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabable2')}"   >
      </td>
	  <%tabno = CDbl(tabno) + 1%>
	<%End if%>

	  <td>
		<input id="place_<%=chkjoono%>"type="text" style="font-size:12px;width:80px"  value="<%=rPlace%>"   tabindex = "<%=tabno2%>" onkeydown="if(event.keyCode == 13){mx.OnFocusOut(<%=joocnt%>, this,'tabarea')}" class="tabarea">
	    <%tabno2 = CDbl(tabno2) + 1%>
      </td>
	<%End If%>




    <%If CDbl(chkgubun) = 0 then%>

		<td class="making_group chk_col">
			<div style='border: 0px solid #73AD21; width:100%; height: 100%;padding: 2px 0px;' class="empty_col"   onClick='mx.changeSelectArea(0,this,<%=chkjoono%>,<%=j%>,<%=strjson%>)' id='drag_<%=chkjoono%>_<%=j%>'>
			<%
			oJSONoutput.GAMEMEMBERIDX = 0
			  oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
			  strjson = JSON.stringify(oJSONoutput)
			%>
			<a href='javascript:mx.updateMember(<%=strjson%>)' role="button" class="btn_a btn_updateMember" style="height:50%;width:80%;font-size:20px;">팀등록</a>
			</div>
		</td>

	<%ELSE%>

		<td class="make_comp chk_col" >
			<div style='border: 0px solid #73AD21; width:100%; height: 100%;padding: 2px 0px;' id='drag_<%=chkjoono%>_<%=j%>'>
			<%
			oJSONoutput.GAMEMEMBERIDX = 0
			  oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
			  strjson = JSON.stringify(oJSONoutput)
			%>
			<a href='javascript:mx.updateMember(<%=strjson%>)' role="button" class="btn_a btn_updateMember" style="height:100%;width:100%;font-size:20px;padding: 30px 0px;">BYE</a>
			</div>
		</td>

    <%END IF%>

    <%
      End If

    If tdcnt = 3 Then
    %>
      <td>
      <div style='width:100%;' >
    <%If CDbl(chkgubun) = 0 then%>
        <a href='javascript:mx.SetJoo(<%=strjson%>)' class="btn_a btn_toggle_show"   <%If CDbl(ADGRADE) > 500 then%>style="line-height:70px;"<%End if%>>경기대기</a>
        <!-- <a href='javascript:alert("<%=chkjoono%>조의 편성을 완료 후 실행해 주십시오.")' class="btn_a">입력</a> -->
      <%Else%>
        <a href='javascript:if (confirm("경기가 진행 중 입니다. 정말 해제 하시겠습니까?") == true) {mx.SetJoo(<%=strjson%>)}' class="btn_a" title="홈페이지노출 본선경기체크" style="color:red;">터치금지</a>
        <!-- <a href='javascript:mx.leagueJoo(<%=strjson%>)' class="btn_a">입력</a> -->
      <%End if%>
    </div>

  </td>
  <%
    End if
  Next
%>
  </tr>
<%
  Next
End If
%>
</table>
</div>
  <!-- E: scroll_box -->
</div>



<input type="hidden" id="diffGubun" value="<%=DiffGubunYN%>">

<%
db.Dispose
Set db = Nothing
'response.write "LoopCnt : " & LoopCnt
%>
