<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->


<script type="text/javascript" src="../../js/GameTitleMenu/plevel.js"></script>
<script>
  /**
 * left-menu 체크
 */
  var bigCate = 2; // 대회정보
  var midCate = 0; // 대회운영
  var lowCate = 0; // 대회
  /* left-menu 체크 */
</script>

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tIdx = crypt.EncryptStringENC(tIdx)
  tPGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tPGameLevelIdx")))  ' 현재페이지
  crypt_tPGameLevelIdx =crypt.EncryptStringENC(tPGameLevelIdx)

  if tidx = "" then
    Response.Write "<script>alert('잘못된 경로로 이동하셨습니다.')</script>"
    Response.Write "<script>location.href='./index.asp'</script>"
    Response.End
  End if

  if cdbl(tidx) = 0  then
    Response.Write "<script>alert('잘못된 경로로 이동하셨습니다.')</script>"
    Response.Write "<script>location.href='./index.asp'</script>"
    Response.End
  end if
  Dim pGameLevelCnt : pGameLevelCnt = 0
  LSQL = " SELECT Count(*) as pGameLevelCnt " 
  LSQL = LSQL & " FROM tblGameLevel " 
  LSQL = LSQL & "   WHERE DelYN='N' and PGameLevelidx = '" &  tPGameLevelIdx & "'" 
  'response.wRITE "LSQL" & LSQL& "<Br>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    pGameLevelCnt = LRs("pGameLevelCnt")
    LRs.MoveNext
  Loop
  End IF

  IF CDBL(pGameLevelCnt) = CDBL(0) Then
    Response.Write "<script>alert('분배된 조가 없습니다.')</script>"
    Response.Write "<script>post_to_url('./level.asp', {'i2': 1, 'tIdx': '" & crypt_tIdx & "'});</script>"
    Response.End
  END IF
%>

<%

  PagePerData = 30  ' 한화면에 출력할 갯수
  BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))


   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  LSQL = "SELECT GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType,PersonalPayment, GroupPayment"
  LSQL = LSQL & " FROM  tblGameTitle"
  LSQL = LSQL & " WHERE GameTitleIDX = " &  tidx
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleIDX = LRs("GameTitleIDX")
      tGameTitleEnterType = LRs("EnterType")
      tGameTitleName = LRs("GameTitleName")
      tGameS = LRs("GameS")
      tGameE = LRs("GameE")
      tEnterType = LRS("EnterType") 
      tPersonalPayment= LRS("PersonalPayment")
      tGroupPayment= LRS("GroupPayment")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "SELECT TOP 1  JooDivision "
  LSQL = LSQL & " FROM tblGameLevel "
  LSQL = LSQL & " WHERE GameTitleIDX = '" &  tidx & "' and GameLevelidx = '" & tPGameLevelIdx & "'"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tJooDivision = LRs("JooDivision")
      LRs.MoveNext
    Loop
  End If
  LRs.close


  Call oJSONoutput.Set("tIdx", crypt_tIdx )
  Call oJSONoutput.Set("tPGameLevelIdx", crypt_tPGameLevelIdx )
  Call oJSONoutput.Set("iEnterType", tEnterType )
  Call oJSONoutput.Set("iSearchText", iSearchText )
  Call oJSONoutput.Set("iSearchCol", iSearchCol )
  Call oJSONoutput.Set("NowPage", NowPage )
  strjson = JSON.stringify(oJSONoutput)  

  'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdx:" &   tIdx & "<br>"
  'Response.Write "tPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdx:" &   tPGameLevelIdx & "<br>"


%>
  <!-- 넘어온 셋팅 값-->
  <input type="hidden" id="selGameTitleIdx" value="<%=crypt_tidx%>">
  <input type="hidden" id="selGameTitleEnterType" value="<%=tEnterType%>">
  <input type="hidden" id="selGameTitleName" value="<%=tGameTitleName%>">
  <input type="hidden" id="selPGameLevelIdx" value="<%=crypt_tPGameLevelIdx%>">
  <input type="hidden" id="selGameLevelIdx" value="">

  <!-- S: content plevel -->
  <div id="content" class="plevel">
    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>조별 대진표</h2>
        <!-- <a href="javascript:href_back(1,'<%=crypt_tIdx%>');" class="btn">목록보기</a> -->
        <a href="javascript:href_back(1,'<%=crypt_tIdx%>');" class="btn btn-back">뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li><a href="./level.asp">대회 종별 등록</a></li>
            <li><a href="./plevel.asp">조별 대진표</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->

      <!-- S: left-head view-table -->
      <table class="left-head view-table">
        <tr class="tiny-line">
          <th>
            <label for="txtJooDivision">조 분배:</label>
          </th>
          <td>
            <div class="con">
              <input type="text" id="txtJooDivision" name="txtJooDivision" value="<%=tJooDivision%>">
            </div>
            <button onClick='javascript:ApplyLevelJooDIvision(<%=strjson%>);' class="btn btn-confirm">적용</button>
          </td>
        </tr>
      </table>
      <!-- E: left-head view-table -->

      <!-- S: btn-list-left -->
      <div class="btn-list-left">
        <a href="#" id="btndel" class="btn btn-red" onclick='delPGameLevel(<%=strjson%>);' accesskey="r">삭제(R)</a>
      </div>
      <!-- E: btn-list-left -->

        <table class="table-list push-top">
          <thead>
            <tr>
              <th>번호</th>
              <th>조 번호</th>
              <th>고유 번호</th>
              <th>종목</th> 
              <th>신청 인원</th> 
              <th>대진표</th> 
              <th>대회신청정보</th>
            </tr>
          </thead>
          <colgroup>
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="100px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
          </colgroup>
          <tbody id="levelContest">
            <%
                If(cdbl(tIdx) > 0) Then
                iType = 1
                LSQL = "EXEC tblPGameLevel_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & tIDX & "','" & tPGameLevelIdx & "','" & tGameTitleEnterType & "','" & iLoginID & "'"
                'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
                'LSQL = LSQL & " FROM  tblGameTitle a "
                'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
                'LSQL = LSQL & " WHERE a.DELYN = 'N' "
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      LCnt = LCnt + 1
                      
                      trownum = LRS("rownum")
                      tGameLevelidx2 = LRS("GameLevelidx")
                      crypt_tGameLevelidx2 =crypt.EncryptStringENC(tGameLevelidx2)
                      tPlayType = LRS("PlayTypeNm")
                      tGameType = LRS("GameTypeNm")
                      tTeamGb = LRS("TeamGbNm")
                      tLevel = LRS("LevelNm")
                      tLevelDtl = LRS("LevelDtl")
                      tSex = LRS("SexNm")
                      tEnterType = LRS("EnterType")
                      tEnterTypeNm = LRS("EnterTypeNm")
                      tPGameMatchCnt= LRS("PGameMatchCnt")
                      tGroupGameGbNm = LRS("GroupGameGbNm")
                      tGroupGameGb = LRS("GroupGameGb")
                      tGameDay = LRS("GameDay")
                      tPGameLevelidx = LRS("PGameLevelidx")
                      tGameTime = LRS("GameTime")
                      tOrderbyNum = LRS("OrderbyNum")
                      tLevelJooNum = LRS("LevelJooNum")
                      tLevelJooNumNm = LRS("LevelJooNumNm")
                      tLevelJooName = LRS("LevelJooName")
                      tLevelJooNameNm = LRS("LevelJooNameNm")
                      tJooDivision = LRS("JooDivision")
                      tSeedCnt = LRS("SeedCnt")
                      tJooRank = LRS("JooRank")
                      tDelYN = LRS("DelYN")
                      tEditDate = LRS("EditDate")
                      tUseYN = LRS("UseYN")
                      tWriteDate = LRS("WriteDate")
                      tGameLevelDtlCount = LRS("GameLevelDtlCount")
                      tRequestPlayerCnt = LRS("RequestPlayerCnt")
                      tRequestGroupCnt = LRS("RequestGroupCnt")
                      tRequestTeamCnt = LRS("RequestTeamCnt")
                      tViewYN = LRS("ViewYN")

                      Call oJSONoutput.Set("tGameLevelIdx", crypt_tGameLevelidx2 )
                      strjson = JSON.stringify(oJSONoutput)  

                      %>
                     <tr>
                        <td style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                            <%=trownum%>
                        </td>
                      
                        <td style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                            <%=tLevelJooNum%>
                        </td>

                        <td style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                            <%=tGameLevelidx2%>
                        </td>

                        <td style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                          <% IF tEnterType = "E" Then %>
                          <%=tSex%><%=tTeamGb%><% if tGroupGameGb <> "B0030002" Then %>&nbsp;<%=tPlayType%><% end if%>
                                <% IF tGroupGameGb <> "B0030002" Then %>
                                  (<%=tLevel%>)
                                  <%Else%>
                                  <%IF tTeamGb = tLevel Then%>
                                    (<%=tGroupGameGbNm%>)
                                  <%Else%>&nbsp;<%=tLevel%> (<%=tGroupGameGbNm%>)
                                  <% End if %>
                                <% End IF %>
                          <% End IF  %>

                          <% IF tEnterType = "A" Then %>
                            <%=LEFT(tSex, 1) %> <%=LEFT(tPlayType, 1)%>-<%=tLevel%>
                            <% if tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNm%><%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %><%End If%>
                            <% End IF  %>
                          <% End IF  %>
                        </td>
                        
                         <td style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                          <%=tRequestPlayerCnt%>명
                        </td>

                        <%' 대진표%>
                        <td width ="100px"  style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                          <% IF CDBL(tGameLevelDtlCount) = 0 Then%>
                            <a href='javascript:href_LevelDtl(<%=strjson%>);'  class="btn list-btn btn-blue"> 대진표 등록<i><img src="../images/icon_more_right.png" alt=""></i></a>
                          <% ELSE %>
                            <a href='javascript:href_LevelDtl(<%=strjson%>);'  class="btn list-btn btn-blue-empty"> 대진표 <%=tGameLevelDtlCount%><i><img src="../images/icon_more_right.png" alt=""></i></a>
                          <%END IF%>
                        </td>

                        <%'대회 신청정보 %>
                        <td width ="100px" style="cursor:pointer" onclick="javascript:selPGameLevel('<%=crypt_tGameLevelidx2%>')">
                          <% if(tGroupGameGb <> "B0030002") Then %>
                            <% if(cdbl(tRequestGroupCnt) > 0 ) Then %>
                              <a href='javascript:href_Participate(<%=strjson%>);'  class="btn list-btn btn-red-empty"> 대회 신청팀 <%=tRequestGroupCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%Else%>  
                              <a href='javascript:href_Participate(<%=strjson%>);'  class="btn list-btn btn-red"> 대회 신청팀 <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%End If%>
                          <%Else%>
                            <% if(cdbl(tRequestTeamCnt) > 0 ) Then %>
                              <a href="javascript:href_ParticipateTeam('<%=crypt_tidx%>','<%=crypt_tGameLevelidx2%>');"  class="btn list-btn btn-red-empty"> 대회 신청팀 <%=tRequestTeamCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%Else%>  
                              <a href="javascript:href_ParticipateTeam('<%=crypt_tidx%>','<%=crypt_tGameLevelidx2%>');"  class="btn list-btn btn-red"> 대회 신청팀 <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%End If%>
                          <%End If%>
                        </td>
                      </tr>
                      <%
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
              End IF
            %>
          </tbody>
        </table>
      <div>
      <!-- E: contents -->
  </div>
  <!-- E: content plevel -->
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>