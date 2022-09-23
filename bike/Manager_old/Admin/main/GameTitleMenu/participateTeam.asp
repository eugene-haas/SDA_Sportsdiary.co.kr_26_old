<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameTitleMenu/participateTeam.js"></script>

<%
  tidx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tIdx =crypt.EncryptStringENC(tidx)
  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))
  crypt_tGameLevelIdx= crypt.EncryptStringENC(tGameLevelIdx)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 20  ' 한화면에 출력할 갯수
  BlockPage = 20      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0

  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
%>

<script type="text/javascript">
  /**
  * left-menu 체크
  */
    var bigCate = 2; // 대회정보
    var midCate = 0; // 대회운영
    var lowCate = 0; // 대회
    var locationStr = "GameTitleMenu/index";  // 대회
  /* left-menu 체크 */


  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./participateTeam.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./participateTeam.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    
    post_to_url('./participateTeam.asp', { 'i2': i2,'tGameLevelIdx' : "<%=crypt_tGameLevelIdx%>",'tIDX' : "<%=crypt_tIdx%>" ,'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./participateTeam.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>

<%
  LSQL = " SELECT Top 1 GameTitleName, EnterType  "
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRS("GameTitleName")
      tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF

  LSQL = " SELECT Top 1 e.PubName as GroupGameGbNm, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when  'man'then  '남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayType, a.Level, d.LevelNm as LevelNm, a.GroupGameGb "
  LSQL = LSQL & "  FROM tblGameLevel a "
  LSQL = LSQL & "  LEFT JOIN tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN ='N' "
  LSQL = LSQL & "  LEFT JOIN tblPubcode c on a.PlayType = c.PubCode and  c.DelYN ='N' "
  LSQL = LSQL & "  LEFT JOIN tblLevelInfo d on a.Level  = d.Level and d.DelYN = 'N' "
  LSQL = LSQL & "  LEFT JOIN tblPubcode e on a.GroupGameGb= e.PubCode and e.DelYN ='N' "  
  LSQL = LSQL & " WHERE a.DelYN = 'N' and GameTitleIDX = " & tidx & " and a.GameLevelidx = " & tGameLevelIdx
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeamGbNm = LRS("TeamGbNm")
      tSex = LRS("Sex")
      En_tSex = crypt.EncryptStringENC(tSex)
      tPlayType = LRS("PlayType")
      tLevelNm = LRS("LevelNm")
      tLevel = LRS("Level")
      En_tLevel = crypt.EncryptStringENC(tLevel)
      tGroupGameGb = LRS("GroupGameGb")
      En_tGroupGameGb = crypt.EncryptStringENC(tLevel)
      tGroupGameGbNm = LRS("GroupGameGbNm")
      LRs.MoveNext
    Loop
  End IF

  iType = 2
  LSQL = "EXEC tblGameRequestTeam_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If
%>

<%

  'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxIdxtIdx : " & crypt_tIdx  & "<br>"
  'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx  : " & crypt_tGameLevelIdx  & "<br>"
  'Response.Write "NowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPage  : " & NowPage   & "<br>"
  'Response.Write "iSearchTextiSearchTextiSearchTextiSearchTextiSearchTextiSearchTextiSearchText  : " & iSearchText   & "<br>"
  'Response.Write "iSearchColiSearchColiSearchColiSearchColiSearchColiSearchColiSearchCol   : " & iSearchCol    & "<br>"
  
  


%>


  <div id="content" class="participate_team">
    <!-- 내용 시작 -->
    <div class="contents">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>대회 신청팀(단체전)</h2>
        <!-- <a href="javascript:href_back('<%=crypt_tIdx%>',1);"  class="btn">대회종목 - 뒤로가기</a> -->
        <a href="javascript:href_back('<%=crypt_tIdx%>',1);" class="btn btn-back">뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li><a href="./level.asp">대회 종별 등록</a></li>
            <li><a href="./participate.asp">대회 신청팀(단체전)</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
      <strong id="Depth_GameTitle"> <%=tGameTitleName%></strong>
      <!-- S: top-table-wrap -->
      <div class="top-table-wrap" id="gamelevelinput_area">
            <h3 class="top-navi-tit"></h3>
            
            <!-- S: registration_box -->
            <div class="registration_box" id="input_area">
              <table class="navi-tp-table">
                <!-- <caption class="sr-only">대회정보관리 기본정보</caption> -->
                <colgroup>
                  <col width="64px">
                  <col width="*">
                  <col width="64px">
                  <col width="*">
                  <col width="94px">
                  <col width="*">
                  <col width="94px">
                  <col width="*">
                </colgroup>
                <tbody>
                  <tr>
                  </tr>

                  <tr>
                    <th scope="row"><span class="l_con"></span>대회명</th>
                    <td><%=tGameTitleName%></td>
                    <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
                    <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=crypt_tIdx%>">
                    <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=crypt_tGameLevelIdx%>">
                    <th scope="row"><span class="l_con"></span>구분</th>
                    <td><%=tGroupGameGbNm%></td>
                    <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=En_tGroupGameGb%>">
                    <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
                  </tr>

                  <tr>
                    <th scope="row"><span class="l_con"></span>종목</th>
                    <td><%=tLevelNm%></td>
                    <input type="hidden" name="Level" id="Level" value="<%=En_tLevel%>">
                    <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
                    <th scope="row"></th>
                    <td></td>
                  </tr>

                  <tr>
                    <th scope="row"><span class="l_con"></span>팀명</th>
                    <td>
                      <span class="con"><input type="text" name="strTeam" id="strTeam" placeholder="검색할 팀명을 입력해 주세요."></span>
                      <input type="hidden" name="hiddenTeam" id="hiddenTeam" value="">
                      <input type="hidden" name="hiddenTeamName" id="hiddenTeamName" value="">
                    </td>
                    <th scope="row"><span class="l_con"></span>세부 팀명</th>
                    <td>
                      <span class="con"><input type="text" name="strTeamDtl" id="strTeamDtl" placeholder="세부팀명을 입력해주세요."></span>
                    </td>
                  </tr>
                </tbody>
              </table>

              <!-- S: table_btn btn-center-list -->
              <div class="table_btn btn-center-list">
                <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputGameParticipateTeam_frm(<%=NowPage%>);" accesskey="i">등록(I)</a>
                <a href="#" id="btnupdate" class="btn" onclick="updateGameParticipateTeam_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
                <a href="#" id="btndel" class="btn btn-red" onclick="delGameParticipateTeam_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
              </div>
              <!-- E: table_btn btn-center-list -->

            </div>
            <!-- E: registration_box -->

            <!-- S: total_count -->
            <div class="total_count">
              <span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
            </div>
            <!-- E: total_count -->
     
        
          <table class="table-list">
            <thead>
              <tr>
                <th>번호</th>
                <th>고유번호</th>
                <th>팀명</th>
                <th>출전선수</th>
                <th>-</th> 
                <th>신청날짜</th> 
              </tr>
            </thead>
            <colgroup>
              <col width="30px">
              <col width="30px">
              <col width="auto">
              <col width="50px">
              <col width="50px">
              <col width="50px">
            </colgroup>
              <tbody id="contest">
              <%
                iType =   1
                LSQL = "EXEC tblGameRequestTeam_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"

                'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
                'LSQL = LSQL & " FROM  tblGameTitle a "
                'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
                'LSQL = LSQL & " WHERE a.DELYN = 'N' "
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                'response.End
                
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                   LCnt = LCnt + 1
                  tNum = LRs("Num")
                  tGameRequestTeamIDX = LRs("GameRequestTeamIDX")
                  crypt_tGameRequestTeamIDX = crypt.EncryptStringENC(tGameRequestTeamIDX)
                  tGameRequestGroupIDX = LRs("GameRequestGroupIDX")
                  crypt_tGameRequestGroupIDX = crypt.EncryptStringENC(tGameRequestGroupIDX)
                  tGameTitleIDX  = LRs("GameTitleIDX")
                  crypt_tGameTitleIDX= crypt.EncryptStringENC(tGameTitleIDX)
                  tGameLevelIDX = LRs("GameLevelIDX")
                  crypt_tGameLevelIDX = crypt.EncryptStringENC(tGameLevelidx)
                  tGameTitleName = LRs("GameTitleName")
                  tTeam = LRs("Team")
                  tTeamDtl = LRs("TeamDtl") 
                  tTeamName = LRs("TeamName")
                  tDelYN = LRs("DelYN")
                  tEditDate = LRs("EditDate")
                  tWriteDate = LRs("WriteDate")
                  tRequestPlayerCnt = LRs("RequestPlayerCnt")
                      %>
                    <tr>
                       <td  style="cursor:pointer" onclick='javascript:SelParticipateTeam("<%=crypt_tGameRequestTeamIDX%>","<%=NowPage%>")'>
                         <%=tNum%>
                       </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipateTeam("<%=crypt_tGameRequestTeamIDX%>","<%=NowPage%>")'>
                        <%=tGameRequestTeamIDX%>
                       </td>
                       <td  style="cursor:pointer" onclick='javascript:SelParticipateTeam("<%=crypt_tGameRequestTeamIDX%>","<%=NowPage%>")'>
                         <%=tTeamName%> 
                          <% IF tTeamDtl <> "0" Then %> 
                            <% Response.Write " - " & tTeamDtl %> 
                          <%End if%>
                       </td>
                      <td>
                        <a href="javascript:href_ParticipateForTeam('<%=crypt_tGameTitleIDX%>','<%=crypt_tGameLevelIDX%>','<%=crypt_tGameRequestTeamIDX%>','<%=crypt_tGameRequestGroupIDX%>');"  class="btn btn-blue"> 출전선수 관리 <%=tRequestPlayerCnt%></a>
                      </td>
                      <td>
                        <a href="javascript:Copy_ParticipateForTeam('<%=crypt_tGameTitleIDX%>','<%=crypt_tGameLevelIDX%>','<%=crypt_tGameRequestTeamIDX%>','<%=NowPage%>');"  class="btn btn-blue"> 복사 </a>
                      </td>

                      <td  style="cursor:pointer" onclick='javascript:SelParticipateTeam("<%=crypt_tGameRequestTeamIDX%>","<%=NowPage%>")'>
                        <%=tWriteDate%>
                      </td>
                     </tr>
                      <%
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
              %>
            </tbody>
          </table>

        <!-- S : bullet-wrap 리스트형 20개씩 노출 -->
        <div class="bullet-wrap">
          <%
          if cdbl(iTotalCount) > 0 then
          %>
            <!-- S: page_index -->
            <div class="page_index">
              <!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
            </div>
            <!-- E: page_index -->
          <%
          ELSE
          %>
          <div class="board-bullet Non-pagination" >
              데이터가 존재하지 않습니다.
          </div>
          <%
          End If
          %>
          </div>
          <!-- E: bullet-wrap -->
        </div>
        <!-- E: top-table-wrap -->
      </div>
      <!-- E: contents -->
    </div>
    <!-- E: participate_team  -->


<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>