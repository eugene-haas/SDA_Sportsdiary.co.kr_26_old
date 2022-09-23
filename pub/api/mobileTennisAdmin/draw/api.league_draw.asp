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


'입금상태 정보가져오기
SQL =  "SELECT a.PaymentType,a.P1_PlayerIDX,a.P2_PlayerIDX,p.VACCT_NO,a.requestIDX FROM tblGameRequest as a left join TB_RVAS_LIST as p ON a.RequestIDX=p.CUST_CD WHERE  a.DelYN = 'N' and a.GameTitleIDX = "&tidx&" and a.Level =" & levelno
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
  arrAT = rs.getrows()
End If

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
    End If

  End If
End if

'S:참가자 목록 =============================================
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
'E:참가자 목록 =============================================

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
<header class="header clear">
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button">대회정보관리</button>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con"><%=poptitle%></h1>
  <div class="header__side-con">
    <button class="header__side-con__btn header__btn-reset t_ico" id="reloadbtn" onclick="mx.league_draw(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>')">
    <img src="./Images/mobile_ico_reset.svg" alt="새로고침"></button>
  </div>
</header>

<div class="l_modal__con draw-lots">
  <h2><strong class="hide">콘텐츠 시작</strong></h2>
  <table class="draw-lots__tbl">
    <caption>본선 추첨 표</caption>
    <thead>
      <tr>
        <th>조</th>
        <th>1위번호</th>
        <th>2위번호</th>
        <th><button type="button" name="button" onclick='mx.inputRegion(<%=strjson%>)'>지역저장</button></th>
      </tr>
    </thead>
    <tbody>
      <%
      'S:각조의 중복값을 찾아서 넣어둔다.####################################s
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
      End If

      For d = 1 To Ubound(gteamArr)
        arr = DuplValRemove( Split(gteamArr(d),"`~") )
        duparr(d) = arr
      Next
      'E:각조의 중복값을 찾아서 넣어둔다.#####################################

      DiffGubunYN = "N"

      tabno = 1
      tabno2 = 1

      For i = 1 To endgroup
      %>

      <tr id="JoonoBox_<%If IsChangeJoo = True then%><%=jorder(i)%><%else%><%=i%><%End if%>">
      <th><font color="red"><%If IsChangeJoo = True then%><%=jorder(i)%><%else%><%=i%><%End if%></font></th>

      <%
        tdcnt = 0
        '각 조의 1팀,2팀 존재여부
        For j = 1 To 3
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

              '같은 조에 1번 2번 선수가 있어야 편성완료가 된다.
              IF(chkgubun = "1" And DiffGubunYN = "N")  Then
                DiffGubunYN="Y"
              END IF %>

              <%If showordersell = True Then '모든조가 편성되었다면%>
              	<%If j = 1 and CDbl(tdcnt) = 1 Then%>
              		<%If placestate = True then%>
                		<td>
                      <input type="number"  min="1" step="1" name="rndno1[]" id="rndno1_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","1",this);' onfocus="this.select();"  value="<%=rRndNo1%>"
                      <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
                		  class="tabable" tabindex = "<%=tabno%>" >
                    </td>
                    <td>
                      <input type="number" min="1" step="1"  name="rndno2[]" id="rndno2_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' onfocus="this.select();"  value="<%=rRndNo2%>"
                      <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
                	    class="tabable2" tabindex = "<%=tabno%>" >
                    </td>
              		  <%tabno = CDbl(tabno) + 1%>
                  <%Else ' 모든장소가 입력안되었을때%>
                    <td>
                      <input type="number" style="background-color:gainsboro" disabled>
                    </td>
                    <td>
                      <input type="number" style="background-color:gainsboro" disabled>
                    </td>
              		<%End if%>
            	  <%End If%>
              <%Else '모든조 편성 x 일때 모양잡기%>
                <td>
                  <input type="number" style="background-color:gainsboro" disabled>
                </td>
                <td>
                  <input type="number" style="background-color:gainsboro" disabled>
                </td>
              <%End if%>

              <%If j = 1 and CDbl(tdcnt) = 1 Then%>
                  <td>
                    <input id="place_<%=chkjoono%>" type="text" style="font-size:12px;width:80px"
                    value="<%=rPlace%>" tabindex = "<%=tabno2%>" class="tabarea">
            		    <%tabno2 = CDbl(tabno2) + 1%>
                  </td>
              <%End if%>

    	      <%End if%>
          <%
                '데이터를 찾을 경우 For문을 빠져나간다.
               Exit for
            Loop While False
          Next

          If chkdata = "N" Then
            tdcnt = CDbl(tdcnt) + 1
            If CDbl(tdcnt) = 1 Then
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
      		    class="tabable" tabindex = "<%=tabno%>" >
            </td>
            <td>
              <input type="text"  name="rndno2[]" id="rndno2_<%=chkjoono%>" onchange='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' onfocus="this.select();"  value="<%=rRndNo2%>"
              <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
        		  class="tabable2" tabindex = "<%=tabno%>" >
            </td>
        	  <%tabno = CDbl(tabno) + 1%>
          <% Else %>
            <td>
              <input type="number" style="background-color:gainsboro" disabled>
            </td>
            <td>
              <input type="number" style="background-color:gainsboro" disabled>
            </td>
        	<%End if%>

      	  <td>
      		  <input id="place_<%=chkjoono%>"type="text" style="font-size:12px;width:80px"  value="<%=rPlace%>"
            tabindex = "<%=tabno2%>" class="tabarea">
      	    <%tabno2 = CDbl(tabno2) + 1%>
          </td>
          <%
              End If
            End If
          Next
          %>
        </tr>
      <%
        Next
      %>
    </tbody>
  </table>
</div>

<input type="hidden" id="diffGubun" value="<%=DiffGubunYN%>">
<%
db.Dispose
Set db = Nothing
%>
