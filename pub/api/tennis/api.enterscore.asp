<%
 '결과 테이블이 0 이라면 다시 호울 할 방법을 생각좀해보자..




  gameidx = oJSONoutput.SCIDX '결과테이블 인덱스
  p1idx = oJSONoutput.P1        '맴버 1 인덱스
  p2idx = oJSONoutput.P2        '맴버 2 인덱스
  gubun = oJSONoutput.GN      '예선 구분 0
  s2key = oJSONoutput.S2KEY   '단식 복식 구분
  entertype = oJSONoutput.ETYPE '엘리트 E 아마추어 A

  startsc = oJSONoutput.STARTSC '시작점수
  tiesc = oJSONoutput.TIESC '타이블레이크룰 점수
  deucest = oJSONoutput.DEUCEST '듀스 상태 0: 기본룰 ,1: 노에드, 2: 1듀스 노에드

  If s2key = "200" Then
    joinstr = " left "
    singlegame =  true
  Else
    joinstr = " left "
    singlegame = false
  End if  

  Set db = new clsDBHelper
  Set skilldef =Server.CreateObject("Scripting.Dictionary")
  '결과 다음 기술1
  skilldef.ADD  "IN", 2
  skilldef.ADD  "ACE", 2
  skilldef.ADD  "NET", 2
  skilldef.ADD  "OUT", 2

  '선수선택으로
  skilldef.ADD  "퍼스트서브", 0
  skilldef.ADD  "세컨서브", 0
  skilldef.ADD  "기타", 0
  skilldef.ADD  "스매싱", 0

  skilldef.ADD  "F.리턴", 3
  skilldef.ADD  "F.스트로크", 3
  skilldef.ADD  "F.발리", 3
  skilldef.ADD  "B.리턴", 3
  skilldef.ADD  "B.스트로크", 3
  skilldef.ADD  "B.발리", 3

  skilldef.ADD  "크로스", 0
  skilldef.ADD  "스트레이트", 0
  skilldef.ADD  "로브", 0
  skilldef.ADD  "역크로스", 0
  skilldef.ADD  "센터", 0
  skilldef.ADD  "쇼트", 0

  strtable = " sd_TennisMember "
  strtablesub =" sd_TennisMember_partner "
  strwhere = "  a.gamememberIDX = " & p1idx & " or a.gamememberIDX = " & p2idx

  If gubun = "0" Then
  strsort = " order by a.tryoutsortno asc"
  else
  strsort = " order by a.SortNo asc"
  End If


  strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
  strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  rscnt =  rs.RecordCount
  ReDim JSONarr(rscnt-1)

  i = 0
  Do Until rs.eof
    Set rsarr = jsObject() 
    rsarr("AID") = rs("gamememberIDX")
    rsarr("ANM") = rs("aname")
    'rsarr("GNO") = rs("groupno")

    rsarr("CO") = rs("COL")
    rsarr("RO") = rs("ROW")

    rsarr("ATANM") = rs("aNTN")
    rsarr("ATBNM") = rs("aBTN")
    rsarr("BID") = rs("partnerIDX")
    rsarr("BNM") = rs("bname")
    rsarr("BTANM") = rs("bATN")
    rsarr("BTBNM") = rs("bBTN")
    rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 

    Set JSONarr(i) = rsarr
    i = i + 1
  rs.movenext
  Loop

  teamcnt = Ubound(JSONarr)

  jsonstr = toJSON(JSONarr)
  Set ojson = JSON.Parse(jsonstr)

  '스코어 입력 정보 가져오기######################################

  '각결과 및 결과입력 상태값
    strresulttable = " sd_TennisResult "
    strwhere = " resultIDX = " & gameidx
    strsort = " "
    fieldA = " stateno, gubun,courtno,courtkind,m1set1,m1set2,m1set3,  m2set1,m2set2,m2set3  "
    fieldB = " gameMemberIDX1,gameMemberIDX2,winIDX,winResult,recorderName,startserve,secondserve,court1playerIDX,court2playerIDX,court3playerIDX,court4playerIDX,leftetc,rightetc,courtmode " 
  '최초정해진 서브사용자 인덱스
    strfield = fieldA &  ", " & fieldB 

    SQL = "select "& strfield &" from  " & strresulttable & " where " & strwhere & strsort
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



    If Not rs.EOF Then 
      'arrRS = rs.GetRows()
      midx1       = rs("gameMemberIDX1") '1번팀 기준인덱스
      midx2       = rs("gameMemberIDX2")  '2번팀 기준인덱스


   
   '세트 번호에 따라 홀수 때마다 코트 변경 마다 자체 계산해서 변경되어야한다.
	  c1idx       = rs("court1playerIDX") ' 위 1,2   아래  3, 4 > 코트 정보 판단기준
      c2idx       = rs("court2playerIDX")
      c3idx       = rs("court3playerIDX")
      c4idx       = rs("court4playerIDX")

	 '세트 번호에 따라 홀수 때마다 코트 변경 마다 자체 계산해서 변경되어야한다.


      leftetc       = rs("leftetc")        '판정정보
      rightetc        = rs("rightetc")
      startserve      = rs("startserve")   '서브위치 번호
    secondserve = rs("secondserve") '상대팀 서브 시작

      courtmode   = rs("courtmode")   'courtmode 0 초기, 1 저장완료 2 수정모드

      stateno       = rs("stateno")     '결과종료 1
      gubun       = rs("gubun")       '0 예선 1본선
      courtno     = rs("courtno")
      courtkind     = rs("courtkind")

    m1set1        = rs("m1set1")
      m1set2        = rs("m1set2")
      m1set3        = rs("m1set3")

    m2set1        = rs("m2set1")
      m2set2        = rs("m2set2")
      m2set3        = rs("m2set3")

    winIDX        = rs("winIDX")      '승자인덱스
      winResult     = rs("winResult")
      recorderName  = rs("recorderName") '기록관
    End if
  '스코어 입력 정보 가져오기######################################


  '마지막 입력 정보 확인
  strfield = " rcIDX, midx,name, setno,gameno,playsortno, skill1, skill2,skill3,servemidx,gameend,leftscore,rightscore "
  SQL = "Select top 1 "&strfield&"  from sd_TennisResult_record where resultIDX = " & gameidx & " order by rcIDX desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  skp_hide = "감춤"
  sk1_hide = "감춤"
  sk2_hide = "감춤"
  sk3_hide = "감춤"
    setno= "1"
    gameno= "1"
  left_score = 0
  right_score = 0 

  If rs.eof Then
  skp_hide = "보임"
  else
    idx = rs("rcIDX")
    playeridx=rs("midx")
    playername=rs("name")
    setno=rs("setno")
    gameno=rs("gameno")
    playsortno=rs("playsortno")
    skill1=rs("skill1") '스킬1 득실
    skill2=rs("skill2") '스킬2 SHOT
    skill3=rs("skill3") '스킬3 COURSE
    serveidx = rs("servemidx")
    gameend = rs("gameend")
    left_score = rs("leftscore")
    right_score = rs("rightscore")

    'INNO 구하기
'    If gameend = "1" Then '마지막이 게임 종료라면
'      skp_hide = "보임"

' else

    If idx <> "" Then
        skp_hide = "감춤"
    sk1_hide = "보임"
      End If
      
      If skill1 <> "" Then
        skp_hide = "감춤"
    sk1_hide = "감춤"
    sk2_hide = "보임"
      End if

'      If skill2 <> "" Then
'        skp_hide = "감춤"
'    sk1_hide = "감춤"
'        sk2_hide = "감춤"
'    sk3_hide = "보임"
'      End If


      If skill2 <> "" Then
        skp_hide = "보임"
    sk1_hide = "감춤"
        sk2_hide = "감춤"
    sk3_hide = "감춤"
      End If

      
      If skill3 <> "" Then
        skp_hide = "보임"
    sk1_hide = "감춤"
        sk2_hide = "감춤"        
    sk3_hide = "감춤"
      End If
      
'    End If
    
  If skilldef(skill2) = "0" then
        skp_hide = "보임"
    sk3_hide = "감춤"
  End if

End if  
  
'////////////////////////////////////

If gameend = "1" Then '한게임 종료
  left_sc = 0
  right_sc = 0 
  gameno = CDbl(gameno) + 1
Else 
  Select Case right_score
    Case "0": right_sc = "0"
    Case "1": right_sc = "15"
    Case "2": right_sc = "30"
    Case "3": right_sc = "40"
    Case Else : right_sc = "40"
  End Select        

  Select Case left_score
    Case "0": left_sc = "0"
    Case "1": left_sc = "15"
    Case "2": left_sc = "30"
    Case "3": left_sc = "40"
    Case Else : right_sc = "40"
  End Select 

  If CDbl(left_score) >= 3 and CDbl(right_score) >= 3 then
    If CDbl(left_score) = CDbl(right_score) Then
      left_sc = 40
      right_sc = 40
    Else
      If CDbl(left_score) > CDbl(right_score) Then '두점차라면 다음 게임 입력 안됨...처음부터 시작작업
        left_sc = "AD"
        right_sc = 40         
      Else
        left_sc = 40
        right_sc = "AD"
      End if
    End If
  End if

End If  

'첫번째 , 두번째게임 시작 
If  ((CDbl(gameno) = 1 And skp_hide = "보임") Or  ( CDbl(gameno) = 2 And skp_hide = "보임")) And left_score = "0" And left_score = "0"  Then
  setserve = "ok"
Else
  setserve = ""
End if
%>

      <!-- S: score-enter-main -->
          <div class="score-enter-main clearfix">

      <%
      Dim tuser
      Set tuser =Server.CreateObject("Scripting.Dictionary")
      Set tuserkey =Server.CreateObject("Scripting.Dictionary")

      n = 0
      for i = 0 to teamcnt
			mem1idx = ojson.Get(i).AID
			mem2idx = ojson.Get(i).BID
			aname = ojson.Get(i).ANM
			bname = ojson.Get(i).BNM

			ateamA = ojson.Get(i).ATANM
			ateamB = ojson.Get(i).ATBNM
			bteamA = ojson.Get(i).BTANM
			bteamB = ojson.Get(i).BTBNM

			If i = 0 Then
			  pcolor = "orange"
		  score = left_sc
		  scoreno = left_score '타이브레이크 스코어 번호
			Else
			  pcolor = "green"
			  score = right_sc
			  scoreno = right_score
			End If

			If gameend = "1" Then
				scoreno = 0
			End if

			'tuser = 키 : 0,1 값  idx _ name_color
			If singlegame =  True Then
			  tuser.Add n, mem1idx & "#$" & aname  & "#$" & pcolor
			  tuserkey.Add mem1idx , aname  & "#$" &  pcolor  & "#$" & score & "#$" & scoreno

'Response.write tuserkey			
			Else
			  tuser.Add n, mem1idx & "#$" & aname & "#$" & pcolor
			  n = n + 1
			  tuser.Add n, mem2idx & "#$" & bname & "#$" & pcolor
			  n = n + 1

			  tuserkey.Add mem1idx , aname  & "#$" & pcolor   & "#$" & score & "#$" & scoreno
			  tuserkey.Add mem2idx , bname  & "#$" & pcolor  & "#$" & score & "#$" & scoreno
			End if
      Next
      
      n = 0
      for each key in tuser
        If n = 0 Then
        tuserarr = "['" & tuser(key) & "'"
        else
        tuserarr = tuserarr &  ",'" & tuser(key) & "'"
        End if
      n = n + 1
      next
      tuserarr = tuserarr &  "]"


      '/////////////////////////////////////////////


      for i = 0 to teamcnt
        mem1idx = ojson.Get(i).AID
        mem2idx = ojson.Get(i).BID
        aname = ojson.Get(i).ANM
        bname = ojson.Get(i).BNM

        'groupno = ojson.Get(i).GNO
        ateamA = ojson.Get(i).ATANM
        ateamB = ojson.Get(i).ATBNM
        bteamA = ojson.Get(i).BTANM
        bteamB = ojson.Get(i).BTBNM
        
        If courtmode = "0"  Then
            set1 = 0
            set2 = 0      
            set3 = 0      
        Else
          If mem1idx = midx1 Then '기준 1열인덱스
            set1 = m1set1
            set2 = m1set2     
            set3 = m1set3     
          Else
            set1 = m2set1
            set2 = m2set2     
            set3 = m2set3     
          End If  
        End if
        %>
      <!-- S: score-board -->
    
  





      <div class="score-board clearfix">

    <%If i = 0 Then %>
          <div class="group-a">
          <ul class="player-display clearfix">
            <li class="player-1">
            <span id="1_idx" style="display:none;" ><%=mem1idx%></span><%'인덱스번호숨김%>
            <span class="name cut-ellip" id="1_name"><%=aname%></span>
            <span class="belong">
              <span class="brace">(</span>
              <span class="player-school cut-ellip" id="1_circle"><%=ateamA%>,<%=ateamB%></span>
              <span class="brace">)</span>
            </span>
            </li>
            <li class="player-3">
            <span id="3_idx" style="display:none;" ><%=mem2idx%></span><%'인덱스번호숨김%>
            <span class="name cut-ellip"  id="3_name"><%=bname%></span>
            <span class="belong">
              <span class="brace">(</span>
              <span class="player-school cut-ellip"  id="3_circle"><%=bteamA%>,<%=bteamB%></span>
              <span class="brace">)</span>
            </span>
            </li>
          </ul>
          <!-- S: group-a score -->
          <div class="score group-a clearfix">
            <dl class="total">
            <dt>TOTAL</dt>
            <dd id="left_settotal">0</dd>
            </dl>
            <dl>
            <dt>3SET</dt>
            <dd><%If entertype = "A" then%>-<%else%>  <%=set3%><%If CDbl(set3d) > 0 then%>(<%=set3d%>)<%End if%>  <%End if%></dd>
            </dl>
            <dl>
            <dt>2SET</dt>
            <dd><%If entertype = "A" then%>-<%else%> <%=set2%><%If CDbl(set2d) > 0 then%>(<%=set2d%>)<%End if%>   <%End if%></dd>
            </dl>
            <dl class="playing">
            <dt>1SET</dt>
            <dd><span id="l_set1"><%=m1set1%></span><span class="sub-point" id="left_tiebreak"><%If CDbl(m2set1) > CDbl(tiesc) And CDbl(m1set1) = CDbl(tiesc)  then%>(<%=left_score%>)<%End if%></span></dd>
            </dl>
          </div>
          <!-- E: group-a score -->
         </div>
        
    <span class="v-s">vs</span>
       <%End if%>

        <!-- S: group-b -->

        <%If i = 1 Then%>
          <div class="group-b">
            <ul class="player-display clearfix">
            <li class="player-2">
              
              <span id="2_idx" style="display:none;" ><%=mem1idx%></span><%'인덱스번호숨김%>
              <span class="name cut-ellip"  id="2_name"><%=aname%></span>
              <span class="belong">
              <span class="brace">(</span>
              <span class="player-school cut-ellip"  id="2_circle"><%=ateamA%>,<%=ateamB%></span>
              <span class="brace">)</span>
              </span>

            </li>
            <li class="player-4">
              
              <span id="4_idx" style="display:none;" ><%=mem2idx%></span><%'인덱스번호숨김%>
              <span class="name cut-ellip"  id="4_name"><%=bname%></span>
              <span class="belong">
              <span class="brace">(</span>
              <span class="player-school cut-ellip"  id="4_circle"><%=bteamA%>,<%=bteamB%></span>
              <span class="brace">)</span>
              </span>

            </li>
            </ul>
            <!-- E: group-b -->
            <!-- S: group-b score -->
            <div class="score group-b clearfix">
              <dl class="playing">
              <dt>1SET</dt>
              <dd><span id="r_set1"><%=m2set1%></span><span class="sub-point" id="right_tiebreak"><%If CDbl(m1set1) > CDbl(tiesc) And CDbl(m2set1) = CDbl(tiesc) then%>(<%=right_score%>)<%End if%></span></dd>
              </dl>
              <dl>
              <dt>2SET</dt>
              <dd><%If entertype = "A" then%>-<%else%> <%=m2set2%><%End if%></dd>
              </dl>
              <dl>
              <dt>3SET</dt>
              <dd><%If entertype = "A" then%>-<%else%>  <%=m3set3%><%End if%></dd>
              </dl>
              <dl class="total">
              <dt>TOTAL</dt>
              <dd id="right_settotal">0</dd>
              </dl>
            </div>
            <!-- E: group-b score -->
          </div>
        <%End if%>
      <%
      Next
      %>
      </div>


    <%If CDbl(courtmode) > 0 then%>
    <span id="baseplayer_c1idx" style="display:none;" ><%=c1idx%></span><%'처음 배치 코트 1번선수%>
    
    <span id="last_gameno" style="display:none;" ><%=gameno%></span><%'마지막게임번호%>
    <span id="courtchange" style="display:none;" ><%=courtchange%></span><%'코트변경여부%>
    <span id="left_gamescore" style="display:none;" ><%=Split(tuserkey(c1idx),"#$")(2)%></span><%'왼쪽 현재점수%>
    <span id="right_gamescore" style="display:none;" ><%=Split(tuserkey(c2idx),"#$")(2)%></span>
    <span id="left_breakscore" style="display:none;" ><%=Split(tuserkey(c1idx),"#$")(3)%></span><%'타이브레이크 점수%>
    <span id="right_breakscore" style="display:none;" ><%=Split(tuserkey(c2idx),"#$")(3)%></span>
    <%else%>
    <span id="last_gameno" style="display:none;" ><%=gameno%></span><%'마지막게임번호%>
    <span id="courtchange" style="display:none;" ><%=courtchange%></span><%'코트변경여부%>
    <span id="left_gamescore" style="display:none;" >0</span><%'왼쪽 현재점수%>
    <span id="right_gamescore" style="display:none;" >0</span>
    <%End if%>
      <!-- E: score-board -->


<%'################################################################################################%>

  
          <!-- S: sb_bar -->
          <div class="sb_bar">
<%
'Response.write gameno &"-<br>"
'Response.write courtchange &"-<br>"
'Response.write skill1 &"-<br>"
'Response.write skill2 &"-<br>"
'Response.write tuserkey(c1idx)   &"-<br>"
%>

      <ul class="another-list clearfix" id= "etcresult" <%If skp_hide = "감춤" then%>style="display:none;"<%End if%>>
              <li class="decide-result">
                <select id="leftresult" onchange="score.etcResult(this)" ><%If courtmode = "1" then%><!-- disabled class="def" --><%End if%>
                  <option value="0" <%If leftetc = "0" then%>selected<%End if%>>::그 외 판정결과 선택::</option>
                  <option value="7"  <%If leftetc = "7" then%>selected<%End if%>>승</option>
				  <option value="1"  <%If leftetc = "1" then%>selected<%End if%>>부전승</option>
                  <option value="2"  <%If leftetc = "2" then%>selected<%End if%>>기권승</option>
                  <option value="3"  <%If leftetc = "3" then%>selected<%End if%>>실격승</option>
                  <option value="4"  <%If leftetc = "4" then%>selected<%End if%>>양선수 불참</option>
                  <option value="5"  <%If leftetc = "5" then%>selected<%End if%>>양선수 기권패</option>
                  <option value="6"  <%If leftetc = "6" then%>selected<%End if%>>양선수 실격패</option>
                </select>
              </li>
              <li class="recorder">
                <span class="tit">기록관</span>
                <span id="rc_name" class="name"><%=recorderName%></span>
              </li>
              <li class="decide-result">
                <select id="rightresult" onchange="score.etcResult(this)"><%If courtmode = "1" then%><!-- disabled class="def" --><%End if%>
                  <option value="0"  <%If rightetc = "0" then%>selected<%End if%>>::그 외 판정결과 선택::</option>
                  <option value="7"  <%If rightetc = "7" then%>selected<%End if%>>승</option>
				  <option value="1"  <%If rightetc = "1" then%>selected<%End if%>>부전승</option>
                  <option value="2"  <%If rightetc = "2" then%>selected<%End if%>>기권승</option>
                  <option value="3"  <%If rightetc = "3" then%>selected<%End if%>>실격승</option>
                  <option value="4"  <%If rightetc = "4" then%>selected<%End if%>>양선수 불참</option>
                  <option value="5"  <%If rightetc = "5" then%>selected<%End if%>>양선수 기권패</option>
                  <option value="6"  <%If rightetc = "6" then%>selected<%End if%>>양선수 실격패</option>
                </select>
              </li>
            </ul>

            
      <!-- S: state -->
            <section class="state clearfix" id="sk_showarea" <%If skp_hide = "감춤" then%>style="display:block;"<%End if%>>
              <h3 id="point_history">득점결과</h3>
              <!-- S: log -->
              <div class="log" id="logarea"><span class='now'><%=playername%></span>
        <%If skill1  <> "" then%><span><%=skill1%></span><%End if%>
        <%If skill2  <> "" then%><span><%=skill2%></span><%End if%>
        <%If skill3  <> "" then%><span><%=skill3%></span><%End if%></div>
              <!-- E: log -->
            </section>
            <!-- E: state -->

          </div>
          <!-- E: sb_bar -->
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <!-- S: court-field -->
            <div class="court-field">

        <!-- S: player-court -->
        <div class="player-court"  id="sk_player" <%If skp_hide = "감춤" then%>style="display:none;"<%End if%>>

                  <!-- S: court-header -->
                  <div class="court-header">
            <h2 class="clearfix">
              <span class="ic-deco"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt></span><span>PLAYER COURT CHOICE</span>
            </h2>
            <%If courtmode = "0" Or courtmode = "2"  then%>
            <span id="court_btn"><a href="javascript:score.saveCourt()" class="btn-modify">저장</a></span>
            <%else%>
            <span id="court_btn"><a href="javascript:score.modeChange()" class="btn-modify">수정</a></span>
            <%End if%>
                  </div>
                  <!-- E: court-header -->

                  <!-- S: court###################### -->
                  <div class="court">

            <!-- S: player-box -->
            <div class="player-box left-box clearfix">
              <!-- S: l-side -->
                <ul class="l-side">
                <li class="player-sel">
                  <select id="leftcourt" onchange="score.setCourt(this,<%=tuserarr%>)" <%If courtmode = "1" then%>style="display:none"<%End if%>>
                   <%
                  for each key in tuser
                    If courtmode = "2" Then
                      If CStr(Split(tuser(key),"#$")(0)) = CStr(c1idx) Then
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   selected>" & Split(tuser(key),"#$")(1) &  " </option>"
                      else
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   >" & Split(tuser(key),"#$")(1) & " </option>"
                      End if
                    else
                    Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   >" & Split(tuser(key),"#$")(1) & " </option>"
                    End if
                  next
                  %>
                  </select>
<%
'Response.write tuserkey(c1idx)  & c1idx & "################"
'Response.End

%>            
                  <%If courtmode = "0" then%>
                  <span id="courtidx_1" style="display:none;" ><%=Split(tuser(0),"#$")(0)%></span><%'인덱스번호숨김%>
                  <a href="javascript:score.enterScore('0',0)"  class="orange" id="court_1" style="display:none;"><%=Split(tuser(0),"#$")(1)%></a>
                  <%else%>
                  <span id="courtidx_1" style="display:none;" ><%=c1idx%></span>
                  <a href="javascript:score.enterScore(score.cplayers[0].cidx + '#$' + score.cplayers[0].cname,0)" class="<%=Split(tuserkey(c1idx),"#$")(1)%>"  id="court_1" <%If courtmode = "2" then%>style="display:none;"<%End if%>><%=Split(tuserkey(c1idx),"#$")(0)%></a>
                  <%End if%>

                  <a href="javascript:score.setServe('serve_1')" class="serve" id="servelink_1" <%If setserve = "" then%>style="pointer-events: none;cursor:default;"<%End if%>>
                  <span class="ic-deco">
                    <img src="images/tournerment/public/tennis_ball_<%If startserve = c1idx  then%>on<%else%>off<%End if%>@3x.png" alt  id="serve_1">
                  </span>
                  </a>
                </li>




                <li class="player-sel">
                  <%If courtmode = "0" then%>
                   <span id="courtidx_3" style="display:none;" ><%=Split(tuser(1),"#$")(0)%></span><%'인덱스번호숨김%>
                   <a href="javascript:score.enterScore('2',0)"  class="orange" id="court_3" style="pointer-events:none;"><%=Split(tuser(1),"#$")(1)%></a>
                  <%else%>
                  <span id="courtidx_3" style="display:none;" ><%=c3idx%></span>
                  <a href="javascript:score.enterScore(score.cplayers[2].cidx + '#$' + score.cplayers[2].cname,0)" class="<%=Split(tuserkey(c3idx),"#$")(1)%>"  id="court_3"><%=Split(tuserkey(c3idx),"#$")(0)%></a>
                  <%End if%>
                  
                  <a href="javascript:score.setServe('serve_3')" class="serve"  id="servelink_3" <%If setserve = "" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                  <span class="ic-deco">
                    <img src="images/tournerment/public/tennis_ball_<%If  startserve = c3idx then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_3">
                  </span>
                  </a>
                </li>
                </ul>
              <!-- E: l-side -->
            </div>
            <!-- E: player-box -->

            <!-- S: player-box -->
            <div class="player-box right-box clearfix">
                <!-- S: r-side -->
                <ul class="r-side">
                <li class="player-sel">
          
                  <select id="rightcourt" onchange="score.setCourt(this,<%=tuserarr%>)"  <%If courtmode = "1" then%>style="display:none"<%End if%>>
                    <%
                    i = 0 
                    for each key in tuser

                      If courtmode = "2" Then
                      If CStr(Split(tuser(key),"#$")(0)) = CStr(c2idx) Then
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   selected>" & Split(tuser(key),"#$")(1) & " </option>"
                      else
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   >" & Split(tuser(key),"#$")(1) & " </option>"
                      End if
                      Else
                      If i = 2 Then '초기 설정시 ( 수정은 별도로)
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   selected>" & Split(tuser(key),"#$")(1) & " </option>"
                      else
                        Response.Write "<option value=""" & Split(tuser(key),"#$")(0) & """   >" & Split(tuser(key),"#$")(1) & " </option>"
                      End if
                      End if
                    i = i + 1
                    next
                    %>
                  </select>

                  <%If courtmode = "0" then%>
                  <span id="courtidx_2" style="display:none;" ><%=Split(tuser(2),"#$")(0)%></span><%'인덱스번호숨김%>
                  <a href="javascript:score.enterScore('1',0)"  class="green" id="court_2" style="display:none;"><%=Split(tuser(2),"#$")(1)%></a>
                  <%else%>
                  <span id="courtidx_2" style="display:none;" ><%=c2idx%></span>
                  <a href="javascript:score.enterScore(score.cplayers[1].cidx + '#$' + score.cplayers[1].cname,0)" class="<%=Split(tuserkey(c2idx),"#$")(1)%>"  id="court_2" <%If courtmode = "2" then%>style="display:none;"<%End if%>><%=Split(tuserkey(c2idx),"#$")(0)%></a>
                  <%End if%>              
            
                  <a href="javascript:score.setServe('serve_2')" class="serve"  id="servelink_2" <%If setserve = "" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                  <span class="ic-deco">
                    <img src="images/tournerment/public/tennis_ball_<%If  startserve = c2idx then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_2">
                  </span>
                  </a>
                </li>
                <li class="player-sel">
                  <%If courtmode = "0" then%>
                  <span id="courtidx_4" style="display:none;" ><%=Split(tuser(3),"#$")(0)%></span><%'인덱스번호숨김%>
                  <a href="javascript:score.enterScore('3',0)"  class="green" id="court_4" style="pointer-events:none;"><%=Split(tuser(3),"#$")(1)%></a>
                  <%else%>
                  <span id="courtidx_4" style="display:none;" ><%=c4idx%></span>
                  <a href= "javascript:score.enterScore(score.cplayers[3].cidx + '#$' + score.cplayers[3].cname,0)" class="<%=Split(tuserkey(c4idx),"#$")(1)%>"  id="court_4"><%=Split(tuserkey(c4idx),"#$")(0)%></a>
                  <%End if%>  

                  <a href="javascript:score.setServe('serve_4')" class="serve"  id="servelink_4" <%If setserve = "" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                    <span class="ic-deco">
                    <img src="images/tournerment/public/tennis_ball_<%If  startserve = c4idx then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_4">
                  </span>
                  </a>
                </li>
                </ul>
                <!-- E: r-side -->

                <!-- S: point-box -->
                <div class="point-box">
                <%If CDbl(courtmode) > 0 then%>

					  <div class="left_point">
						<a href="javascript:score.enterScore_easy('left', 'win')" class="add_point">▲</a>
						<span class="a-point" id="left_pt"><%=Split(tuserkey(c1idx),"#$")(2)%></span>
						<!-- <a href="#" class="reduce_point">▼</a> -->
					  </div>
				   

					  <div class="right_point">
						<a href="javascript:score.enterScore_easy('right', 'win')" class="add_point">▲</a>
						<span class="b-point" id="right_pt"><%=Split(tuserkey(c2idx),"#$")(2)%></span>
						<!-- <a href="#" class="reduce_point">▼</a> -->
					  </div>

				<%else%>

					  <div class="left_point">
						<a href="javascript:score.enterScore_easy('left', 'win')" class="add_point">▲</a>
						<span class="a-point" id="left_pt">0</span>
						<!-- <a href="#" class="reduce_point">▼</a> -->
					  </div>

					  <div class="right_point">
						<a href="javascript:score.enterScore_easy('right', 'win')" class="add_point">▲</a>
						<span class="b-point" id="right_pt">0</span>
						<!-- <a href="#" class="reduce_point">▼</a> -->
					  </div>


                <%End if%>
                </div>
                <!-- E: point-box -->
            </div>
            <!-- E: player-box -->

                  </div>
                  <!-- E: court###################### -->

                </div>
                <!-- E: player-court -->



                <!-- S: skill-box -->
                <div class="skill-box" id="sk_skillbox" <%If skp_hide = "감춤" then%>style="display:block;"<%End if%>>
                  <!-- S: point-result -->
                  <div class="skill-item line-2 point-result" id="sk_result" <%If sk1_hide = "감춤" then%>style="display:none"<%End if%>>
                    <!-- S: win -->
                    <dl class="win">
                      <dt>WIN</dt>
                      <dd>
                        <a href="javascript:score.enterScore('IN',1)" class="btn btn-skill">IN</a>
                        <a href="javascript:score.enterScore('ACE',1)" class="btn btn-skill">ACE</a>
                      </dd>
                    </dl>
                    <!-- E: win -->

                    <!-- S: error -->
                    <dl class="error">
                      <dt>ERROR</dt>
                      <dd>
                        <a href="javascript:score.enterScore('NET',1)" class="btn btn-skill">NET</a>
                        <a href="javascript:score.enterScore('OUT',1)" class="btn btn-skill">OUT</a>
                      </dd>
                    </dl>
                    <!-- E: error -->
                  </div>
                  <!-- E: point-result -->

                  <!-- S: SHOT -->
                  <div class="skill-item line-3 shot" <%If sk2_hide = "감춤" then%>style="display:none"<%End if%> id="sk_shot">
                    <!-- S: skill-list -->
                    <ul class="skill-list clearfix" >
                      <li><a href="javascript:score.enterScore('퍼스트서브',2)" class="btn btn-skill" id="shot_01">퍼스트서브</a></li>
                      <li><a href="javascript:score.enterScore('F.리턴',2)" class="btn btn-skill">F.리턴</a></li>
                      <li><a href="javascript:score.enterScore('F.스트로크',2)" class="btn btn-skill">F.스트로크</a></li>
                      <li><a href="javascript:score.enterScore('F.발리',2)" class="btn btn-skill">F.발리</a></li>
                      <li><a href="javascript:score.enterScore('세컨서브',2)" class="btn btn-skill" id="shot_05">세컨서브</a></li>
                      <li><a href="javascript:score.enterScore('B.리턴',2)" class="btn btn-skill">B.리턴</a></li>
                      <li><a href="javascript:score.enterScore('B.스트로크',2)" class="btn btn-skill">B.스트로크</a></li>
                      <li><a href="javascript:score.enterScore('B.발리',2)" class="btn btn-skill">B.발리</a></li>
                      <li><a href="javascript:score.enterScore('스매싱',2)" class="btn btn-skill">스매싱</a></li>
                      <li class="mr0 so-on long-2"><a href="javascript:score.enterScore('기타',2)" class="btn btn-skill">기타</a></li>
                    </ul>
                    <!-- E: skill-list -->
                  </div>
                  <!-- E: SHOT -->

                  <!-- S: COURSE -->
                  <div class="skill-item line-2 course" id="sk_course" <%If sk3_hide = "감춤" then%>style="display:none"<%End if%>>
                    <!-- S: skill-list -->
                    <ul class="skill-list clearfix">
                      <li><a href="javascript:score.enterScore('크로스',3)" class="btn btn-skill">크로스</a></li>
                      <li><a href="javascript:score.enterScore('역크로스',3)" class="btn btn-skill">역크로스</a></li>
                      <li><a href="javascript:score.enterScore('스트레이트',3)" class="btn btn-skill">스트레이트</a></li>
                      <li><a href="javascript:score.enterScore('로브',3)" class="btn btn-skill">로브</a></li>
                      <li><a href="javascript:score.enterScore('센터',3)" class="btn btn-skill">센터</a></li>
                      <li><a href="javascript:score.enterScore('쇼트',3)" class="btn btn-skill">쇼트</a></li>
                      <li class="mr0 so-on long-2"><a href="javascript:score.enterScore('기타',3)" class="btn btn-skill">기타</a></li>
                    </ul>
                    <!-- E: skill-list -->
                  </div>
                  <!-- E: COURSE -->
                </div>
                <!-- E: skill-box -->


                <div class="bot-btn">
                  
          <a class="btn btn-point-ipt non-act"  id="nextbtn_off"  <%If skp_hide = "감춤" then%>style="display:none"<%End if%>><span class="ic-deco"><img src="images/tournerment/enter/act_lrr_off@3x.png" alt></span> 이전 단계</a>

          
                  
          <a href="javascript:score.preState()" class="btn btn-point-ipt" <%If skp_hide = "보임" then%>style="display:none"<%End if%>  id="nextbtn_on"><span class="ic-deco"><img src="images/tournerment/enter/act_lrr_on@3x.png" alt></span> 이전 단계</a>

          <a href="javascript:score.gameStop();" class="btn btn-game-pause">경기중단</a>
          
          <a href="javascript:score.gameEnd();" class="btn btn-game-over">경기종료</a>
                </div>
                <!-- E: point-end-box -->
            </div>
            <!-- E: court-field -->






    <!-- S: point-board -->
        <div class="point-board clearfix" id="listpoint" ><!-- style="position:fixed;width:200px;right:0px;margin-right: -150px;" -->

          <!-- S: ctrl-btn -->
          <div class="ctrl-btn"  id="listpointbtn"><!-- style="position:fixed;" -->
            <a href="javascript:score.toggleBox('show')" class="open-record">포인트기록</a>
          </div>
          <!-- E: ctrl-btn -->  
      

          <!-- S: content -->
          <div class="content">
            <a href="javascript:score.toggleBox('hide')" class="btn btn-close"><img src="images/tournerment/public/x@3x.png" alt="닫기"></a>
            <h3>포인트 기록</h3>

      <div class="scroll-box" id="gamerc_area">
<%
  strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3 "
  SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & gameidx & " order by rcIDX asc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  Set gamescore =Server.CreateObject("Scripting.Dictionary")
  If Not rs.EOF Then 
    arrRSasc = rs.GetRows()
    leftscno = 0
    rightscno = 0
    For ar = LBound(arrRSasc, 2) To UBound(arrRSasc, 2)  '점수
      leftscore = arrRSasc(4, ar)
      rightscore = arrRSasc(5, ar)
      gameend = arrRSasc(6, ar)
      gameno = arrRSasc(10, ar)

      If gameend = "1" Then
        If leftscore > rightscore Then
          leftscno = leftscno + 1
        Else
          rightscno = rightscno + 1
        End if
        gamescore.ADD  gameno, leftscno & " : "& rightscno
      End if
    Next
  End if




  strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3 "
  SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & gameidx & " order by rcIDX desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


  If Not rs.EOF Then 
    arrRS = rs.GetRows()
  End if



  If IsArray(arrRS) Then
    For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

      rcIDX = arrRS(0, ar)
      resultIDX = arrRS(1, ar)
      midx = arrRS(2, ar)
      name = arrRS(3, ar)
      leftscore = arrRS(4, ar)
      rightscore = arrRS(5, ar)
      gameend = arrRS(6, ar)
      servemidx = arrRS(7, ar)
      servemname = arrRS(8, ar)
      setno = arrRS(9, ar)
      gameno = arrRS(10, ar)
      playsortno = arrRS(11, ar)
      skill1 = arrRS(12, ar)
      skill2 = arrRS(13, ar)
      skill3 = arrRS(14, ar)

      If gameno = "13" Then
        left_sc = leftscore
        right_sc = rightscore
      Else

        Select Case rightscore
          Case "0": right_sc = "0"
          Case "1": right_sc = "15"
          Case "2": right_sc = "30"
          Case "3": right_sc = "40"
          Case Else : right_sc = "40"
        End Select        

        Select Case leftscore
          Case "0": left_sc = "0"
          Case "1": left_sc = "15"
          Case "2": left_sc = "30"
          Case "3": left_sc = "40"
          Case Else : right_sc = "40"
        End Select 

        If CDbl(leftscore) > 3 And CDbl(rightscore) > 3 then
          If CDbl(leftscore) = CDbl(rightscore) Then
            left_sc = 40
            right_sc = 40
          Else
            If CDbl(leftscore) > CDbl(rightscore) Then
              left_sc = "AD"
              right_sc = 40
            Else
              left_sc = 40
              right_sc = "AD"
            End if
          End If
        End if
      End if
      %>
      <%If gameend = "1" then%>
            <div class="summary-rec" id="rcend_<%=rcIDX%>">
              <ul>
                <li class="round"><%=gameno%>경기</li>
                <li><%=Split(tuser(0),"#$")(1)%>,<%=Split(tuser(1),"#$")(1)%></li>
                <li class="score"><span><%=gamescore(gameno)%></span></li>
                <li><%=Split(tuser(2),"#$")(1)%>,<%=Split(tuser(3),"#$")(1)%></li>
              </ul>
            </div>
      <%End if%>


            <ul class="point-list" id="rc_<%=rcIDX%>">
              <li>
                <span class="name"><%=name%></span>
                <span class="serve on"><%If midx = servemidx then%><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"><%End if%></span>
                <span class="score <%If Split(tuserkey(midx),"#$")(1) = "orange" then%>me<%else%>you<%End if%>"><%If gameend = "1" then%>GAME WIN<%else%><%=left_sc%> : <%=right_sc%><%End if%></span>
                <span><%=skill1%> / </span>
                <span><%=skill2%><%If kill2 <> "" then%> / <%End if%></span>
                <span><%=skill3%><%If kill3 <> "" then%> / <%End if%></span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
            </ul>
      <%
    Next
  End If 
%>
      </div>


            <!-- E: point-list -->
          </div>
          <!-- E: content -->
        </div>
        <!-- E: point-board -->





<%

Set skilldef = nothing
Set tuser = Nothing
Set tuserkey = Nothing
Set gamescore = Nothing

db.Dispose
Set db = Nothing
%>











          </div>





          <!-- E: display-board -->
        </div>
        <!-- E: score-enter-main -->


