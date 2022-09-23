<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  NowPage = fInject(Request("i2"))  ' 현재페이지
  tidx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tidx =crypt.EncryptStringENC(tidx)
  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))
  crypt_tGameLevelIdx= crypt.EncryptStringENC(tGameLevelIdx)
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(Request("tGameRequestTeamIdx")))
  crypt_tGameRequestTeamIdx= crypt.EncryptStringENC(tGameRequestTeamIdx)
  
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
    post_to_url('./participateTeamMember.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./participateTeamMember.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./participateTeamMember.asp', { 'i2': i2,'tGameLevelIdx' : "<%=crypt_tGameLevelIdx%>",'tidx' : "<%=crypt_tidx%>" ,'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'tGameRequestTeamIdx' : "<%=crypt_tGameRequestTeamIdx%>" });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./participateTeamMember.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>


<script type="text/javascript" src="../../js/GameTitleMenu/participateTeamMember.js"></script>

<%
 
  PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
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


  LSQL = " SELECT Top 1 b.Team, b.TeamNm "
  LSQL = LSQL & " FROM tblGameRequestTeam a "
  LSQL = LSQL & " Left Join tblTeamInfo b on a.Team = b.Team and b.DelYN='N' "
  LSQL = LSQL & "   Where a.DelYN = 'N' and GameRequestTeamIDX =" & tGameRequestTeamIdx 

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeam = LRS("Team")
      tTeamNm = LRS("TeamNm")
      LRs.MoveNext
    Loop
  End IF
  

  

  LSQL = " SELECT TOP 1 GameRequestGroupIDX "
  LSQL = LSQL & " FROM tblGameRequestGroup a "
  LSQL = LSQL & "   Where a.DelYN = 'N' and GameRequestTeamIDX =" & tGameRequestTeamIdx 

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameRequestTeamGroupIdx = LRS("GameRequestGroupIDX")
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
      crypt_tSex = crypt.EncryptStringENC(tSex)
      tPlayType = LRS("PlayType")
      tLevelNm = LRS("LevelNm")
      tLevel = LRS("Level")
      crypt_tLevel = crypt.EncryptStringENC(tLevel)
      tGroupGameGb = LRS("GroupGameGb")
      crypt_tGroupGameGb = crypt.EncryptStringENC(tLevel)
      tGroupGameGbNm = LRS("GroupGameGbNm")
      LRs.MoveNext
    Loop
  End IF

  '경기타입 (단식,복식,혼합복식)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B002'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameType = LRs.getrows()
  End If

  iType = 2
  LSQL = "EXEC tblGameRequestTeamGroupMember_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & tGameRequestTeamGroupIdx & "','" & iTemp & "','" & iLoginID & "'"
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

  <!-- S: content participate_team_member -->
  <div id="content" class="participate_team_member">
    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>출전선수 등록</h2>
        <!-- <a href="javascript:href_back('<%=crypt_tIdx%>',1);"  class="btn">대회종목 - 뒤로가기</a> -->
        <a  href="javascript:href_back('<%=crypt_tIdx%>','<%=crypt_tGameLevelIdx%>',1);" class="btn btn-back">뒤로가기</a>

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
            <li><a href="./participateTeamMember.asp">출전선수 등록</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->

      <strong id="Depth_GameTitle"> <%=tGameTitleName%></strong>
      <div class="navi-tp-table-wrap" id="gamelevelinput_area">
        <!-- S: top-table-wrap -->
        <div class="top-table-wrap">
          <div class="top-navi-btm">
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
                    <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=crypt_tidx%>">
                    <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=crypt_tGameLevelIdx%>">
                    <input type="hidden" name="selGameRequestTeamIdx" id="selGameRequestTeamIdx" value="<%=crypt_tGameRequestTeamIdx%>">
                    <th scope="row"><span class="l_con"></span>구분</th>
                    <td><%=tGroupGameGbNm%></td>
                    <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=crypt_tGroupGameGb%>">
                    <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
                  </tr>
                  <tr>
                    <th scope="row"><span class="l_con"></span>성별</th>
                    <td> <%=tSex%> </td>
                    <input type="hidden" name="Sex" id="Sex" value="<%=tSex%>">
                    <th scope="row"><span class="l_con"></span>종목</th>
                    <td><%=tLevelNm%></td>
                    <input type="hidden" name="Level" id="Level" value="<%=crypt_tLevel%>">
                    <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
                  </tr>
                  <tr>
                    <th scope="row"><span class="l_con"></span>팀명</th>
                    <td> <%=tTeamNm%> </td>
                    <input type="hidden" name="hiddenTeam" id="hiddenTeam" value="<%=tTeam%>">
                    <input type="hidden" name="hiddenTeamNm" id="hiddenTeamNm" value="<%=tTeamNm%>">
                    <th scope="row"><span class="l_con"></span>팀코드</th>
                    <td> <%=tTeam%> </td>
                  <tr>
                  <tr>
                    <th scope="row"><span class="l_con"></span>선수명</th>
                    <td>
                      <span class="con"><input type="text" name="strMember" id="strMember" class="ipt-word" placeholder="검색할 선수명을 입력해 주세요."></span>
                      <input type="hidden" name="hiddenMemberName" id="hiddenMemberName" value="">
                      <input type="hidden" name="hiddenMemberIdx" id="hiddenMemberIdx" value="">
                      <input type="hidden" name="hiddenGameRequestPlayerIDX" id="hiddenGameRequestPlayerIDX">
                    </td>
                    <th scope="row"><span class="l_con"></span>팀명</th>
                    <td id="tdTeam" name ="tdTeam"></td>
                    <input type="hidden" name="hiddenTeamCode" id="hiddenTeamCode" value="">
                    <input type="hidden" name="hiddenTeamName" id="hiddenTeamName" value="">
                  </tr>
                </tbody>
              </table>

             <!-- S: table_btn btn-center-list -->
             <div class="table_btn btn-center-list">
                  <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputGameParticipateTeamMember_frm(1);" accesskey="i">등록(I)</a>
                  <a href="#" id="btnupdate" class="btn" onclick="updateGameParticipateTeamMember_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
                  <a href="#" id="btndel" class="btn btn-red" onclick="delGameParticipateTeamMember_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
                </div>
              <!-- E: table_btn btn-center-list -->

            </div>
            <!-- E: registration_box -->

            <!-- S: total_count -->
            <div class="total_count">
              <span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
            </div>
            <!-- E: total_count -->

          </div>
          <!-- E: top-navi-btm -->
      </div>
      <!-- E: top-table-wrap -->

     
       
        
        
       
        <table class="table-list">
          <thead>
            <tr>
              <th>번호</th>
              <th>출전선수</th>
              <th>등록일자</th> 
            </tr>
          </thead>
          <colgroup>
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
             <tbody id="contest">
            <%
              iType = 1
              LSQL = "EXEC tblGameRequestTeamGroupMember_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & tGameRequestTeamGroupIdx & "','" & iTemp & "','" & iLoginID & "'"

              'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
              'LSQL = LSQL & " FROM  tblGameTitle a "
              'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
              'LSQL = LSQL & " WHERE a.DELYN = 'N' "
              'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
              'response.End
              LCnt = 0
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    LCnt = LCnt + 1
                    RNum = LRs("Num")
                    tGameRequestGroupIDX = LRs("GameRequestGroupIDX")
                    crypt_tGameRequestGroupIDX =  crypt.EncryptStringENC(tGameRequestGroupIDX)
                    tGameRequestPlayerIDX = LRs("GameRequestPlayerIDX")
                    crypt_tGameRequestPlayerIDX =  crypt.EncryptStringENC(tGameRequestPlayerIDX)
                    tMemberNames = LRs("MemberName")
                    tEditDate = LRs("EditDate")
                    tDelYN = LRs("DelYN")
                    tWriteDate = LRs("WriteDate")
                    Call oJSONoutput.Set("NowPage", NowPage )
                    Call oJSONoutput.Set("tGameRequestTeamPlayerIdx", crypt_tGameRequestPlayerIDX )
                    strjson = JSON.stringify(oJSONoutput)  
                    %>

                     <tr>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipateTeamMember(<%=strjson%>)' >
                        <%=RNum%>
                      </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipateTeamMember(<%=strjson%>)' >
                        <% Response.Write tMemberNames%>
                      </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipateTeamMember(<%=strjson%>)' >
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
  <!-- E: participate_team_manager -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>