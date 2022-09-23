<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

' 포인트 입력화면 진입

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'request
scoreresultIDX = oJSONoutput.SCIDX
p1idx = oJSONoutput.P1 '맴버 1 인덱스
p2idx = oJSONoutput.P2 '맴버 2 인덱스
s2key = oJSONoutput.S2KEY '단식 복식 구분
entertype = oJSONoutput.ETYPE '엘리트 E 아마추어 A
gubun = oJSONoutput.GN '예선 구분 0
serveno = oJSONoutput.SERVE '서브위치 번호


'/////////////////////////////////서브인덱스 가져오기
'가져와
'/////////////////////////////////서브인덱스 가져오기

If s2key = "200" Then
joinstr = " left "
singlegame =  True
classname = "solo"
Else
joinstr = " inner "
singlegame = False
classname = "group"
End if  

Set db = new clsDBHelper

  strtable = " sd_TennisMember "
  strtablesub =" sd_TennisMember_partner "
  strwhere = "  a.gamememberIDX = " & p1idx & " or a.gamememberIDX = " & p2idx

  If gubun = "0" Then
    strsort = " order by a.tryoutsortno asc"
  else
    strsort = " order by a.SortNo asc"
  End if
  
  strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN  "
  strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  i = 0
  Set tuser =Server.CreateObject("Scripting.Dictionary")

  Do Until rs.eof
    midx = rs("gamememberIDX")
    mname = rs("aname")
    pidx = rs("partnerIDX")
    pname = rs("bname")
    mteam1 = rs("aNTN")
    mteam2 = rs("aBTN")
    pteam1 = rs("bATN")
    pteam2 = rs("bBTN")

    If i = 0 then
      tuser.Add "p1", midx & "#$" & mname  & "#$" & mteam1  & "#$" & mteam2
    Else
      tuser.Add "p2", midx & "#$" & mname  & "#$" & mteam1  & "#$" & mteam2
    End If

    If singlegame = false then
      If i = 0 then
        tuser.Add "p3", pidx & "#$" & pname  & "#$" & pteam1  & "#$" & pteam2
      Else
        tuser.Add "p4", pidx & "#$" & pname  & "#$" & pteam1  & "#$" & pteam2
      End If
    End if
  i = i + 1
  rs.movenext
  Loop

  
  '마지막 입력 정보 확인 확인
  strfield = " rcIDX, midx,name,point, setno,gameno,playsortno, skill1, skill2,skill3,skill4,servemidx,gameend,leftscore,rightscore "
  SQL = "Select top 1 "&strfield&"  from sd_TennisResult_record where resultIDX = " & scoreresultIDX & " order by rcIDX desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  
  If rs.eof Then
    startmode = True
    orderno = 0 '보여주기 순서
    left_sc = 0
    right_sc = 0
    strjson = "{'SCIDX':'"&scoreresultIDX&"','INMODE':'0','RKEY':'','MKEY':'','MNM':'','PT':'','GSET':'','GAME':'','PNO':'','SK1':'','SK2':'','SK3':'','SK4':'','SERVE':'"&serveno&"'}" 'INMODE 0 1셋트 첫번째 최초 입력

    sk1_hide = True
    sk2_hide = true
    sk3_hide = true
    sk4_hide = true

  Else
    startmode = False
    
    idx = rs("rcIDX")
    playeridx=rs("midx")
    playername=rs("name")
    getpoint=rs("point")      '획득여부
    setno=rs("setno")
    gameno=rs("gameno")
    playsortno=rs("playsortno")
    skill1=rs("skill1") '스킬1 SHOT
    skill2=rs("skill2") '스킬2 TECHNIC
    skill3=rs("skill3") '스킬3 COURSE
    skill4=rs("skill4")  '스킬4  득실
    serveidx = rs("servemidx")
    gameend = rs("gameend")
    left_score = rs("leftscore")
    right_score = rs("rightscore")

    'INMODE 구하기
    If gameend = "1" Then
      orderno = 0 
      skp_hide = False '보임
    Else
      orderno = 1 '이름
      skp_hide = true
    End If
  
    sk1_hide = true
    sk2_hide = true
    sk3_hide = true
    sk4_hide = true

    If gameend = "0" Then 
      If isNull(midx) = false Then
        orderno = 1 '이름
        sk1_hide = false
      End if

      If isNull(skill1) = false Then
        orderno = 2 '스킬1
        sk1_hide = true
        sk2_hide = false
      End if

      If isNull(skill2) = false Then
        orderno = 3 
        sk1_hide = true
        sk2_hide = true
        sk3_hide = false
      End if

      If isNull(skill3) = false Then
        orderno = 4 
        sk1_hide = true
        sk2_hide = true
        sk3_hide = true
        sk4_hide = false
      End If
    End if


    Set oJSONoutput = Nothing

    Set oJSONoutput = JSON.Parse("{""INMODE"":"""&orderno&"""}") '업데이트 순서 1,2,3,4,5 이름, 스킬1 스킬2 스킬3 스킬4 ( 1번인경우 다시 인서트해야함)

    Call oJSONoutput.Set("SCIDX", scoreresultIDX )
    Call oJSONoutput.Set("RKEY", idx )
    Call oJSONoutput.Set("MKEY", playeridx)
    Call oJSONoutput.Set("MNM", playername)
    Call oJSONoutput.Set("PT", getpoint )
    Call oJSONoutput.Set("GSET", setno )
    Call oJSONoutput.Set("GAME", gameno )
    Call oJSONoutput.Set("PNO", playsortno )
    Call oJSONoutput.Set("SK1", skill1 )
    Call oJSONoutput.Set("SK2", skill2 )
    Call oJSONoutput.Set("SK3", skill3 )
    Call oJSONoutput.Set("SK4", skill4 )
    Call oJSONoutput.Set("SERVE",  serveidx)

    strjson = JSON.stringify(oJSONoutput)
    strjson = Replace(strjson , """", "'")  
  

    '마지막 점수를 가져온다.
    left_score = 0
    right_score = 0 

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
      End Select        
      
      Select Case left_score
      Case "0": left_sc = "0"
      Case "1": left_sc = "15"
      Case "2": left_sc = "30"
      Case "3": left_sc = "40"
      Case Else

        If left_score = right_score Then
          left_sc = 40
          right_sc = 40
        Else
          If left_score > right_score Then '두점차라면 다음 게임 입력 안됨...처음부터 시작작업
            left_sc = "AD"
            right_sc = 40         
          Else
            left_sc = 40
            right_sc = "AD"
          End if
        End if
      End Select 
    End If

  
  
  
  End if





'Response.write sql


db.Dispose
Set db = Nothing
'######################################################################
%>



  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content" >
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: state -->
        <section class="state clearfix">
          <h3>득점선수</h3>
          <!-- S: log -->
          <div class="log" id="logarea">
            <!-- <span>최보라</span>
            <span>F.스트로크</span>
            <span>퍼스트서브</span>
            <span>스트레이트</span>
            <span class="now">ACE</span> -->
          </div>
          <!-- E: log -->
        </section>
        <!-- E: state -->


















        <!-- S: skill-box -->
        <div class="enter skill-box">















<table  width="80%" border=1 height="100%" background="#ffffff" align="center" style="text-align:center;color:#fff;display:none;<%If skp_hide = True then%>display:none;<%End if%>"  id="sk_player">
    <tr>
  <%For i = 1 To 4%>
      <td><a href="javascript:score.choiceButton(score.cplayers[<%=i-1%>].cidx + '#$' + score.cplayers[<%=i-1%>].cname  + '#$<%=i%>', <%=strjson%>)" id="courtplayer_<%=i%>">pp</a></td>
    <%If i = 2 then%>
    </tr>
    </tr>
    <%End if%>
  <%next%>
</tr>
</table>






<%'##################################%>
<%If test = True then%>
                  <!-- S: court -->
                  <div class="court">
                    <!-- S: player-box -->
                    <div class="player-box left-box clearfix">
                      <!-- S: l-side -->
                      <ul class="l-side">

            <li class="player-sel">
              <span id="courtidx_1" style="display:none;" ><%=c1idx%></span>
              <a class="btn player-btn"  id="court_1">선수이름</a>

                          <a href="javascript:score.setServe('serve_1')" class="serve" id="servelink_1" <%If courtmode = "1" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                            <span class="ic-deco">
                              <img src="images/tournerment/public/tennis_ball_<%If startserve = "1" then%>on<%else%>off<%End if%>@3x.png" alt  id="serve_1">
                            </span>
                          </a>
                        </li>


                        <li class="player-sel">
                          <span id="courtidx_3" style="display:none;" ><%=c3idx%></span>
              <a class="btn player-btn"  id="court_3">선수이름</a>
                          
              <a href="javascript:score.setServe('serve_3')" class="serve"  id="servelink_3" <%If courtmode = "1" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                            <span class="ic-deco">
                              <img src="images/tournerment/public/tennis_ball_<%If startserve = "3" then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_3">
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

                        <span id="courtidx_2" style="display:none;" ><%=c2idx%></span>
              <a class="btn player-btn"  id="court_2" >선수이름</a>
              
              <a href="javascript:score.setServe('serve_2')" class="serve"  id="servelink_2" <%If courtmode = "1" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                            <span class="ic-deco">
                              <img src="images/tournerment/public/tennis_ball_<%If startserve = "2" then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_2">
                            </span>
                          </a>
                        </li>
                        <li class="player-sel">
                          <span id="courtidx_4" style="display:none;" ><%=c4idx%></span>
              <a class="btn player-btn"  id="court_4">선수이름</a>

              <a href="javascript:score.setServe('serve_4')" class="serve"  id="servelink_4" <%If courtmode = "1" then%>style="pointer-events: none;cursor: default;"<%End if%>>
                            <span class="ic-deco">
                              <img src="images/tournerment/public/tennis_ball_<%If startserve = "4" then%>on<%else%>off<%End if%>@3x.png" alt   id="serve_4">
                            </span>
                          </a>
                        </li>
                      </ul>
                      <!-- E: r-side -->
                    </div>
                    <!-- E: player-box -->


                  </div>
                  <!-- E: court -->
<%End if%>
<%'##################################%>









      <!-- S: SHOT -->
          <div class="skill-item line-3 shot" <%If sk1_hide = True then%>style="display:none;"<%End if%> id="sk_shot">
            <!-- S: skill-list -->
            <ul class="skill-list clearfix" >
              <li><a href="javascript:score.choiceSkillButton('퍼스트서브')" class="btn btn-skill">퍼스트서브</a></li>
              <li><a href="javascript:score.choiceSkillButton('F.리턴')" class="btn btn-skill">F.리턴</a></li>
              <li><a href="javascript:score.choiceSkillButton('F.스트로크')" class="btn btn-skill">F.스트로크</a></li>
              <li><a href="javascript:score.choiceSkillButton('F.발리')" class="btn btn-skill">F.발리</a></li>
              <li><a href="javascript:score.choiceSkillButton('세컨서브')" class="btn btn-skill">세컨서브</a></li>
              <li><a href="javascript:score.choiceSkillButton('B.리턴')" class="btn btn-skill">B.리턴</a></li>
              <li><a href="javascript:score.choiceSkillButton('B.스트로크')" class="btn btn-skill">B.스트로크</a></li>
              <li><a href="javascript:score.choiceSkillButton('B.발리')" class="btn btn-skill">B.발리</a></li>
              <li><a href="javascript:score.choiceSkillButton('스매싱')" class="btn btn-skill">스매싱</a></li>
              <li class="mr0 so-on long-2"><a href="javascript:score.choiceSkillButton('기타')" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: SHOT -->

          <!-- S: TECHNIC -->
          <div class="skill-item line-2 technic"  id="sk_technic" style="display: none;"> <%If sk2_hide = false then%>style="display:block;"<%End if%>>
            <!-- S: skill-list -->
            <ul class="skill-list clearfix">
              <li><a href="javascript:score.choiceSkillButton('일반/수비')" class="btn btn-skill">일반/수비</a></li>
              <li><a href="javascript:score.choiceSkillButton('패싱')" class="btn btn-skill">패싱</a></li>
              <li><a href="javascript:score.choiceSkillButton('드롭')" class="btn btn-skill">드롭</a></li>
              <li><a href="javascript:score.choiceSkillButton('어프로치')" class="btn btn-skill">어프로치</a></li>
              <li class="mr0 so-on long-2"><a href="javascript:score.choiceSkillButton('기타')" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: TECHNIC -->

          <!-- S: COURSE -->
          <div class="skill-item line-2 course" id="sk_course" <%If sk3_hide = false then%>style="display:block;"<%End if%>>
            <!-- S: skill-list -->
            <ul class="skill-list clearfix">
              <li><a href="javascript:score.choiceSkillButton('크로스')" class="btn btn-skill">크로스</a></li>
              <li><a href="javascript:score.choiceSkillButton('스트레이트')" class="btn btn-skill">스트레이트</a></li>
              <li><a href="javascript:score.choiceSkillButton('로브')" class="btn btn-skill">로브</a></li>
              <li><a href="javascript:score.choiceSkillButton('역크로스')" class="btn btn-skill">역크로스</a></li>
              <li><a href="javascript:score.choiceSkillButton('센터')" class="btn btn-skill">센터</a></li>
              <li class="mr0 so-on"><a href="javascript:score.choiceSkillButton('기타')" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: COURSE -->

          <!-- S: point-result -->
          <div class="skill-item line-3 point-result" id="sk_result" <%If sk4_hide = false then%>style="display:block;"<%End if%>>
            <!-- S: win -->
            <dl class="win">
              <dt>WIN</dt>
              <dd>
                <a href="javascript:score.choiceSkillButton('IN')" class="btn btn-skill">IN</a>
                <a href="javascript:score.choiceSkillButton('ACE')" class="btn btn-skill">ACE</a>
              </dd>
            </dl>
            <!-- E: win -->

            <!-- S: error -->
            <dl class="error">
              <dt>ERROR</dt>
              <dd>
                <a href="javascript:score.choiceSkillButton('NET')" class="btn btn-skill">NET</a>
                <a href="javascript:score.choiceSkillButton('OUT')" class="btn btn-skill">OUT</a>
              </dd>
            </dl>
            <!-- E: error -->
          </div>
          <!-- E: point-result -->

        </div>
        <!-- E: enter skill-box -->

        <!-- S: btn-footer -->
        <div class="btn-footer">
          <a href="#" class="btn btn-prev">
            <span class="ic-deco"><img src="images/tournerment/public/btn-prev@3x.png" alt></span>
            <span class="txt">이전 단계</span>
          </a>
          <a href="#" class="btn btn-out" data-dismiss="modal">나가기</a>
        </div>
        <!-- E: btn-footer -->







        <!-- S: point-board -->
        <div class="point-board clearfix">
          <!-- S: ctrl-btn -->
          <div class="ctrl-btn">
            <a href="#" class="open-record">포인트기록</a>
          </div>
          <!-- E: ctrl-btn -->
          
          <!-- S: content -->
          <div class="content">
            <a href="#" class="btn btn-close"><img src="images/tournerment/public/x@3x.png" alt="닫기"></a>
            <h3>포인트 기록</h3>
            <!-- S: point-list -->
            <ul class="point-list">
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">GAME WIN</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score you">40 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">30 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score you">15 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">15 : 0</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
            </ul>
            <!-- E: point-list -->
          </div>
          <!-- E: content -->
        </div>
        <!-- E: point-board -->




      </div>
      <!-- E: modal-body -->
    </div>
    <!-- E: modal-content -->
  </div>


<%
Set tuser  = nothing
%>