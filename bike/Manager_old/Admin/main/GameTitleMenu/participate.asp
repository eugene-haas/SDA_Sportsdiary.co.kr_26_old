<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script type="text/javascript" src="../../js/GameTitleMenu/participate.js"></script>

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  tidx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tidx =crypt.EncryptStringENC(tidx)

  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))
  crypt_tGameLevelIdx= crypt.EncryptStringENC(tGameLevelIdx)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  pType = fInject(Request("pType"))  ' 현재페이지
  
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))
  beforeNowPage = fInject(Request("beforeNowPage"))


  IF ( pType ="plevel") Then
    tPGameLevelIdx =  fInject(crypt.DecryptStringENC(Request("tPGameLevelIdx")))
    crypt_tPGameLevelIdx= crypt.EncryptStringENC(tPGameLevelIdx)
  End IF
  

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  IF Len(beforeNowPage) = 0 Then
    beforeNowPage = 1
  End if 

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
%>

<script type="text/javascript">
  /**
  * left-menu 체크
  */
  var locationStr = "GameTitleMenu/index";  // 대회
  /* left-menu 체크 */

  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./participate.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./participate.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./participate.asp', { 'i2': i2,'tGameLevelIdx' : '<%=crypt_tGameLevelIdx%>','tIDX' : '<%=crypt_tidx%>' ,'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./participate.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
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

  LSQL = " SELECT Top 1 e.PubName as GroupGameGbNm, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when 'man'then '남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayTypeNm, a.PlayType, a.Level, d.LevelNm as LevelNm, a.GroupGameGb  "
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
      crypt_tPlayType = crypt.EncryptStringENC(tPlayType)
      tPlayTypeNm = LRS("PlayTypeNm")
      tLevelNm = LRS("LevelNm")
      tLevel = LRS("Level")
      crypt_tLevel = crypt.EncryptStringENC(tLevel)
      tGroupGameGb = LRS("GroupGameGb")
      crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
      tGroupGameGbNm = LRS("GroupGameGbNm")
      LRs.MoveNext
    Loop
  End IF

  iType = 2
  LSQL = "EXEC tblGameRequestGroup_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If

  Call oJSONoutput.Set("tIdx", crypt_tIdx )
  Call oJSONoutput.Set("tGameLevelIdx", crypt_tGameLevelIdx )
  Call oJSONoutput.Set("tPGameLevelIdx", crypt_tPGameLevelIdx )
  Call oJSONoutput.Set("NowPage", NowPage )

  
  Call oJSONoutput.Set("i2", NowPage )
  Call oJSONoutput.Set("pType", pType )
  Call oJSONoutput.Set("iSearchText", iSearchText )
  Call oJSONoutput.Set("iSearchCol", iSearchCol )
  strjson = JSON.stringify(oJSONoutput)  
  'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdx:" & tIdx & "<br>"
  'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx:" & tGameLevelIdx & "<br>"
  'Response.Write "tPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdx:" & tPGameLevelIdx & "<br>"
  'Response.Write "pTypepTypepTypepTypepTypepTypepTypepTypepTypepType:" & pType & "<br>"\
  'Response.Write "beforeNowPagebeforeNowPagebeforeNowPagebeforeNowPagebeforeNowPagebeforeNowPage:" & beforeNowPage & "<br>"
%>
<div id="content" class="participate">
    <!-- S : 내용 시작 -->
<div class="contents">
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>대회 신청팀(개인전)</h2>
    <!-- <a href="javascript:href_back('<%=crypt_tIdx%>',1);"  class="btn">대회종목 - 뒤로가기</a> -->
    
    <% if pType = "plevel" Then %>
    <a href="javascript:href_back2('<%=crypt_tIdx%>','<%=crypt_tPGameLevelIdx%>','<%=crypt_tGameLevelIdx%>','<%=beforeNowPage%>');"  class="btn btn-back">뒤로가기</a>
    <%Else%>
    <a href="javascript:href_back('<%=crypt_tIdx%>','<%=crypt_tGameLevelIdx%>','<%=beforeNowPage%>');"  class="btn btn-back">뒤로가기</a>
    <%End IF%>

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <span class="ic_deco">
        <i class="fas fa-angle-right fa-border"></i>
      </span>
      <ul>
        <li>대회정보</li>
        <li>대회운영</li>
        <li><a href="./level.asp">대회 종별 등록</a></li>
        <li><a href="./participate.asp">대회 신청팀(개인전)</a></li>
      </ul>
    </div>
    <!-- E: 네비게이션 -->
  </div>
  <!-- E: page_title -->
      <div id="gamelevelinput_area">
          <div class="tp-table-wrap">
            <h3 class="top-navi-tit">
              <!-- <strong id="Depth_GameTitle"> <%=tGameTitleName%></strong> -->
            </h3>
           
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
                      <th scope="row"><span class="l_con"></span>대회명</th>
                      <td><%=tGameTitleName%></td>
                      <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
                      <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=crypt_tidx%>">
                      <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=crypt_tGameLevelIdx%>">
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
                      <th scope="row"><span class="l_con"></span>타입</th>
                      <td>
                        <%=tPlayTypeNm%>
                        <input type="hidden" name="hiddenPlayType" id="hiddenPlayType" value="<%=crypt_tPlayType%>">
                        <input type="hidden" name="hiddenPlayTypeNm" id="hiddenPlayTypeNm" value="<%=tPlayTypeNm%>">
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><span class="l_con"></span>선수명</th>
                      <td>
                        <span class="con"><input type="text" name="strMember1" id="strMember1" placeholder="검색할 선수명을 입력해 주세요." class="ipt-word"></span>
                        <input type="hidden" name="hiddenMemberName1" id="hiddenMemberName1" value="">
                        <input type="hidden" name="hiddenMemberIdx1" id="hiddenMemberIdx1" value="">
                        <input type="hidden" name="hiddenGameRequestPlayerIDX1" id="hiddenGameRequestPlayerIDX1">
                      </td>
                      <th scope="row"><span class="l_con"></span>소속</th>
                      <td>
                        <div id="tdTeam1" name ="tdTeam1"></div>
                        <input type="hidden" name="hiddenTeam1" id="hiddenTeam1" value="">
                        <input type="hidden" name="hiddenTeamName1" id="hiddenTeamName1" value="">
                        <label>
                          <input type="radio" name="majorTeam" value="Team1" checked> 대표팀 지정 </label>
                      </td>
                    </tr>
                    <% IF tPlayType <> "B0020001" Then%>
                    <tr>
                      <th scope="row"><span class="l_con"></span>선수명</th>
                      <td>
                        <span class="con"><input type="text" name="strMember2" id="strMember2" placeholder="검색할 선수명을 입력해 주세요."  class="ipt-word"></span>
                        <input type="hidden" name="hiddenMemberName2" id="hiddenMemberName2" value="">
                        <input type="hidden" name="hiddenMemberIdx2" id="hiddenMemberIdx2" value="">
                        <input type="hidden" name="hiddenGameRequestPlayerIDX2" id="hiddenGameRequestPlayerIDX2" >
                      </td>
                      <th scope="row"><span class="l_con"></span>소속</th>
                      <td>
                        <div id="tdTeam2" name ="tdTeam2"></div>
                        <input type="hidden" name="hiddenTeam2" id="hiddenTeam2" value="">
                        <input type="hidden" name="hiddenTeamName2" id="hiddenTeamName2" value="">
                        <label><input type="radio" name="majorTeam" value="Team2"> 대표팀 지정</label>
                      </td>
  
                    </tr>
                    <% End IF %>
                  </tbody>
                </table>

                <!-- S: table_btn btn-center-list -->
               <div class="table_btn btn-center-list">
                  <a href="#" id="btnsave" class="btn btn-add" onclick='inputGameParticipate_frm(<%=strjson%>);' accesskey="i">등록(I)</a>
                  <a href="#" id="btnupdate" class="btn btn-confirm" onclick='updateGameParticipate_frm(<%=strjson%>);' accesskey="e">수정(E)</a>
                  <a href="#" id="btndel" class="btn btn-red" onclick='delGameParticipate_frm(<%=strjson%>);' accesskey="r">삭제(R)</a>
                </div>
                <!-- E: table_btn btn-center-list -->
              </div>
              <!-- E: registration_box -->
                 
      <div class="sub_search">
        <div class="l_con">
          <ul>
            <li>
              <span class="l_txt">선수명</span>
            </li>
            <li>
             <input type="text"  placeholder="검색할 선수명을 입력해 주세요." style="height:30px;width:300px" >
            </li>
            <li>
              <span class="l_txt">클럽명</span>
            </li>
            <li>
             <input type="text"  placeholder="검색할 클럽명 입력해 주세요." style="height:30px;width:300px" >
            </li>
          </ul>
        </div>
        <div class="r_search_btn">
          <a href="#" class="btn btn-search">검색</a>
        </div>
      </div>

        <div class="total_count">
          <span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
        </div>    
        
        <table class="table-list participate">
          <thead>
            <tr>
              <th>번호</th>
              <th>팀 번호</th>    <!-- 경기 방법 (단식 ,복식,혼합 복식)-->
              <th>대표 팀</th>
              <th>이름</th>
              <th>등록일자</th> 
            </tr>
          </thead>
         
            <tbody id="contest">
            <%
              iType = 1
              LSQL = "EXEC tblGameRequestGroup_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"

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
                    tMemberNames = LRs("MemberNames")
                    tTeam = LRs("Team")
                    tTeamNm = LRs("TeamNm")
                    
                    tEditDate = LRs("EditDate")
                    tDelYN = LRs("DelYN")
                    tWriteDate = LRs("WriteDate")
                    %>
                    <tr>
                    <td  style="cursor:pointer;width:10px;" onclick='javascript:SelParticipate(<%=strjson%>,"<%=crypt_tGameRequestGroupIDX%>","<%=NowPage%>")'>
                      <%=RNum%>
                    </td>
                    <td  style="cursor:pointer;width:10px;" onclick='javascript:SelParticipate(<%=strjson%>,"<%=crypt_tGameRequestGroupIDX%>","<%=NowPage%>")'>
                      <%=tGameRequestGroupIDX%>
                    </td>
                    <td  style="cursor:pointer;width:20%;" onclick='javascript:SelParticipate(<%=strjson%>,"<%=crypt_tGameRequestGroupIDX%>","<%=NowPage%>")'>
                      <%=tTeamNm%>
                    </td>
                    <td  style="cursor:pointer;width:60%;" onclick='javascript:SelParticipate(<%=strjson%>,"<%=crypt_tGameRequestGroupIDX%>","<%=NowPage%>")'>
                      <%=tMemberNames%>
                    </td>
                    <td  style="cursor:pointer;width:30px;" onclick='javascript:SelParticipate(<%=strjson%>,"<%=crypt_tGameRequestGroupIDX%>","<%=NowPage%>")'>
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

        <!-- E : 리스트형 20개씩 노출 -->
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



<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>