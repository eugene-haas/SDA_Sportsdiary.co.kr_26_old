<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->



<script type="text/javascript" src="../../js/library/jquery.timepicker.min.js"></script>
<script type="text/javascript" src="../../js/GameTitleMenu/levelDtl.js"></script>

<%  
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(Request("tIdx")))  ' 현재페이지
  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))  ' 현재페이지
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)
  crypt_tIdx =crypt.EncryptStringENC(tIdx)

  pType = fInject(Request("pType"))  ' 현재페이지
  beforeNowPage = fInject(Request("beforeNowPage"))  ' 전 페이지의 페이지
  
  IF ( pType ="plevel") Then
    tPGameLevelIdx =  fInject(crypt.DecryptStringENC(Request("tPGameLevelIdx")))
    crypt_tPGameLevelIdx= crypt.EncryptStringENC(tPGameLevelIdx)
    Call oJSONoutput.Set("tPGameLevelIdx", crypt_tPGameLevelIdx )
  ELSE
    Call oJSONoutput.Set("tPGameLevelIdx", crypt_tGameLevelIdx )
    crypt_tPGameLevelIdx = crypt_tGameLevelIdx
  End IF

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))
   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  IF LEN(beforeNowPage) = 0 Then
    beforeNowPage = 1
  End IF

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
  var tIdx = "<%=crypt_tIdx%>";
  var tGameLevelIdx = "<%=crypt_tGameLevelIdx%>";
  var pType = "<%=pType%>"
  var beforeNowPage =  "<%=beforeNowPage%>"
  var tPGameLevelIdx = "<%=crypt_tPGameLevelIdx%>"

  function WriteLink(i2) {
    post_to_url('./levelDtl.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./levelDtl.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./levelDtl.asp', { 'i2': i2,'tGameLevelIdx' : '<%=tGameLevelIdx%>','iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'tIdx' : tIdx , 'tGameLevelIdx' : tGameLevelIdx , 'pType': pType, 'beforeNowPage' : beforeNowPage, 'tPGameLevelIdx': tPGameLevelIdx});
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./levelDtl.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
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
  Dim tStadiumNum  : tStadiumNum =0
  LSQL = " SELECT Top 1 e.PubName as GroupGameGb,a.StadiumNum, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when  'man'then '남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayType, d.LevelNm as Level, a.GroupGameGb "
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
      tStadiumNum = LRS("StadiumNum")
      tSex = LRS("Sex")
      tPlayType = LRS("PlayType")
      tLevel = LRS("Level")
      tGroupGameGb = LRS("GroupGameGb")
      LRs.MoveNext
    Loop
  End IF

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B010'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayPlayLevelType = LRs.getrows()
  End If

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B004'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameType = LRs.getrows()
  End If

  
  LSQL = "SELECT StadiumIDX, StadiumName, StadiumCourt   "
  LSQL = LSQL & "FROM  tblStadium " 
  LSQL = LSQL & "Where GameTitleIDX = '" & tIdx & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY WriteDate  DESC"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL=" & LSQL & "<bR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayStadiums = LRs.getrows()
  End If


  'Response.Write "tidxtidxtidxtidxtidxtidxtidtidxtidxtidxtidxtidxtidxxtidxtidxtidx =" & tidx & "<bR>"
  'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx =" & tGameLevelIdx & "<bR>"
  iType = 2
  LSQL = "EXEC tblGameLevelDtl_Searchd_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tGameLevelIdx & "','" & iTemp  & "','" & iLoginID & "'"
  'response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL="&LSQL&"<br>"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If 

   if(cdbl(iTotalPage) < cdbl(NowPage)) then
    NowPage  = iTotalPage
  end if
  'response.Write "iTotalCountiTotalCountiTotalCountiTotalCountiTotalCountiTotalCount="&iTotalCount&"<br>"
  'response.Write "iTotalPageiTotalPageiTotalPageiTotalPageiTotalPageiTotalPageiTotalPage="&iTotalPage&"<br>"

  'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdx : " & tIdx & "<br>"
  'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "tPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdx : " & tPGameLevelIdx & "<br>"
  'Response.Write "pTypepTypepTypepTypepTypepTypepTypepTypepTypepTypepTypepType : " & pType & "<br>"

  Call oJSONoutput.Set("tIdx", crypt_tIdx )
  Call oJSONoutput.Set("tGameLevelIdx", crypt_tGameLevelIdx )
  Call oJSONoutput.Set("beforeNowPage", beforeNowPage )
  Call oJSONoutput.Set("NowPage", NowPage )
  Call oJSONoutput.Set("i2", NowPage )
  Call oJSONoutput.Set("pType", pType )
  Call oJSONoutput.Set("iSearchText", iSearchText )
  Call oJSONoutput.Set("iSearchCol", iSearchCol )
  strjson = JSON.stringify(oJSONoutput)  
  
  'Response.Write "beforeNowPagebeforeNowPagebeforeNowPagebeforeNowPagebeforeNowPage : " & beforeNowPage & "<br>"
%>

  <!-- S: content level_dtl -->
  <div id="content" class="level_dtl">
  
     <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>대진표</h2>
        
        <% IF pType = "plevel" Then%>
          <a  href="javascript:href_back2('<%=crypt_tIdx%>','<%=crypt_tPGameLevelIdx%>','<%=beforeNowPage%>');" class="btn btn-back">뒤로가기</a>
        <%Else%>
          <a  href="javascript:href_back('<%=crypt_tIdx%>','<%=beforeNowPage%>');" class="btn btn-back">뒤로가기</a>
        <%End IF%>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li><a href="./index.asp">대회</a></li>
            <li><a href="./level.asp">대회종별관리</a></li>
            <li><a href="./levelDtl.asp">대진표</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->
      
      <input type="hidden" id="selGameLevelIdx" value="<%=crypt_tGameLevelIdx%>">
      <input type="hidden" id="selGameIdx" value="<%=crypt_tIdx%>">
      <input type="text" id="txtEntryCnt" value="0" style="visibility:hidden;">
      <!-- S : 내용 시작 -->
      <div class="contents">
        <strong id="Depth_GameTitle"><%=tGameTitleName%></strong>
        <div class="tp-table-wrap">
          <!-- S: registration_box, gamelevelinput_area -->
          <div class="registration_box" id="gameLevelDtlInput_area">
              <input type="hidden" id="selGameLeveDtlIIdx" value="">
              <table class="navi-tp-table">
              <caption class="sr-only">예선/본선 대진표</caption>
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
                <th scope="row"><span class="l_con"></span>신청팀현황</th>  
                  <%
                    IF tGroupGameGb = "B0030001" Then
                      LSQL = " SELECT count(*) as RequestCnt "
                      LSQL = LSQL & " FROM  tblGameRequestGroup "
                      LSQL = LSQL & " WHERE GameTitleIDX = '" &  tidx & "' AND  GameLevelidx = '" & tGameLevelIdx & "' AND DelYN='N' "
                    End If
                    IF tGroupGameGb = "B0030002" Then
                      LSQL = " SELECT count(*) as RequestCnt "
                      LSQL = LSQL & " FROM  tblGameRequestTeam  "
                      LSQL = LSQL & " WHERE GameTitleIDX = '" &  tidx & "' AND  GameLevelidx = '" & tGameLevelIdx & "' AND DelYN='N' "
                    End If
                    'Response.Write "LSQL : " & LSQL & "<BR/>"
                    Set LRs = DBCon.Execute(LSQL)
                    If Not (LRs.Eof Or LRs.Bof) Then
                      Do Until LRs.Eof
                          tRequestCnt = LRs("RequestCnt")
                        LRs.MoveNext
                      Loop
                    End If 
                  %>
                <td>
                  <div class="text-bold"><%=tRequestCnt%>팀</div>
                </td>

              <th scope="row"><span class="l_con"></span>구분</th>
              <td id="sel_PlayLevelType">
                <select id="selPlayLevelType" onchange="OnPlayLevelTypeChanged(this.value)" class="sel-ctr">
                  <% If IsArray(arrayPlayLevelType) Then
                      For ar = LBound(arrayPlayLevelType, 2) To UBound(arrayPlayLevelType, 2) 
                        playLevelTypeCode   = arrayPlayLevelType(0, ar) 
                        crypt_playLevelTypeCode = crypt.EncryptStringENC(playLevelTypeCode)
                        playLevelTypeName = arrayPlayLevelType(1, ar) 
                  %>
                        <option value="<%=crypt_playLevelTypeCode%>"><%=playLevelTypeName%></option>
                  <%
                      Next
                    End If      
                  %>
                </select>-
                <select id="selLevelJooNum" class="sel-ctr">
                  <option value="">미선택</option>
                  <%
                    For i = 1 To 40
                  %>
                    <option value="<%=i%>"><%=i%></option>
                  <%
                    Next
                  %>
                </select>조
              </td>
              
              <%
              GameTypeCnt = 0
              SelLeague = 0
              %>
              <th scope="row"><span class="l_con"></span>경기방식</th>
                <td id="sel_GameType">
                  <select id="selGameType" onchange="onGameTypeChanged(this.value)" class="sel-ctr">
                    <% If IsArray(arrayGameType) Then
                        For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                          GameTypeCnt = GameTypeCnt + 1
                          GameTypeCode    = arrayGameType(0, ar) 
                          crypt_GameTypeCode = crypt.EncryptStringENC(GameTypeCode)
                          GameTypeName  = arrayGameType(1, ar) 
                          If GameTypeCode = "B0040001" Then
                            SelLeague = 1
                    %>
                            <option value="<%=crypt_GameTypeCode%>" selected><%=GameTypeName%></option> 
                            <% else %>
                            <option value="<%=crypt_GameTypeCode%>"><%=GameTypeName%></option>
                    <%
                          END IF
                        Next
                      End If      
                    %>
                  </select> 

                  <select id="selTotalRound" <% if cdbl(SelLeague) = 1 Then %>style="visibility:hidden;"<% End IF%> class="sel-ctr">
                    <option value="512">512강</option>
                    <option value="256">256강</option>
                    <option value="128">128강</option>
                    <option value="64">64강</option>
                    <option value="32">32강</option>
                    <option value="16">16강</option>
                    <option value="8">8강</option>
                    <option value="4">4강</option>
                    <option value="2">2강</option> 
                  </select> 
                </td> 
              <tr>
                <th scope="row"><span class="l_con"></span>경기장</th>
                <td>
                  <!-- S: ymd-list -->
                <div class="ymd-list">
                  <select id="selStadiums" name="selStadiums">
                  <option value="0">==선택==</option>
                  <%
                    If IsArray(arrayStadiums) Then
                      For ar = LBound(arrayStadiums, 2) To UBound(arrayStadiums, 2) 
                        arrayStadiumCode    = arrayStadiums(0, ar) 
                        crypt_arrayStadiumCode = crypt.EncryptStringENC(arrayStadiumCode)
                        arrayStadiumName  = arrayStadiums(1, ar) 
                        arrayCourts = arrayStadiums(2, ar) 
                    
                    IF CDBL(arrayStadiumCode)= CDBL(tStadiumNum) Then
                  %>
                    <option value="<%=crypt_arrayStadiumCode%>" selected><%=arrayStadiumName%> 코트 : <%=arrayCourts%> (기본값)</option>
                    <%ELSE%>
                    <option value="<%=crypt_arrayStadiumCode%>"><%=arrayStadiumName%> 코트 : <%=arrayCourts%></option>
                  <%
                    END IF
                    Next
                    End If    
                  %>
                  </select>
                </div>
                <!-- E: ymd-list -->
                </td>
                <!--
                <th scope="row" style="visibility:hidden;">
                <span class="l_con">
                </span>최소인원</th>
                <td>
                <div class="ymd-list" >
                  
                </td>
                -->

                <th scope="row"><span class="l_con"></span>본선진출</th>
                <td>
                   <div class="ymd-list">
                    <span id="sel_JooRank">
                    <input type="text" id="txtJooRank" name="txtJooRank" value="1" >
                  </span>
                </td>

                <th scope="row" id="thJooDivision" <% if cdbl(SelLeague) = 0 Then %>style="visibility:hidden;"<% End IF%>><span class="l_con"></span>조 생성</th>
                <td id="tdJooDivision" <% if cdbl(SelLeague) = 0 Then %>style="visibility:hidden;"<% End IF%>>
                <div class="ymd-list">
                  <input type="text" id="txtJooDivision" value="0">
                </td>
              </tr>

              <tr>
                <th scope="row"><span class="l_con"></span>경기날짜</th>
                <td>
                <div class="ymd-list">
                  <span id="sel_GameDate">
                    <input type="text" id="selGameDay" value="" class="date_ipt">
                  </span>
                </td>

                <th scope="row"><span class="l_con"></span>경기시간</th>
                <td>
                <div class="ymd-list">
                  <span id="sel_GameTime">
                    <input type="text" id="selGameTime" value="" class="time_ipt">
                  </span>
                </td>
            
                <th scope="row"><span class="l_con"></span>노출여부</th>
                <td>
                  <select id="selViewYN">
                    <option value="N">미노출</option>
                    <option value="Y">노출</option>
                  </select>
                </td>
              </tr>
              <tr>
                <th scope="row"><span class="l_con"></span>풀게임여부</th>
                <td>
                  <select id="selFullGameYN">
                    <option value="N">미선택</option>
                    <option value="Y">풀게임</option>
                  </select>
                </td>
              </tr>
              </tbody>
            </table>

            <!-- S: table_btn btn-center-list -->
            <div class="table_btn btn-center-list">
              <a href="#" id="btnsave" class="btn"  onclick='inputGameLevelDtl_frm(<%=strjson%>);' accesskey="i">등록(I)</a>
              <a href="#" id="btnupdate" class="btn btn-gray" onclick='updateGameLevelDtl_frm(<%=strjson%>);' accesskey="e">수정(E)</a>
              <a href="#" id="btndel" class="btn btn-red" onclick='delGameLevelDtl_frm(<%=strjson%>);' accesskey="r">삭제(R)</a>
            </div>
            <!-- E: table_btn btn-center-list -->
          </div>
        </div>

        <!-- S: registration_btn -->
        <div class="registration_btn">
          <a href="#" class="btn btn-add" onclick='inputGameLevelDtl_frm(<%=strjson%>);' >등록하기</a>
          <a href="javascript:href_back('<%=crypt_tIdx%>',1);"   class="btn btn-gray">목록보기</a>
          <a href="#" class="btn btn-open">펼치기 <span class="ic_deco"><i class="fas fa-caret-down"></i></span></a>
          <a href="#" class="btn btn-fold">접기<span class="ic_deco"><i class="fas fa-caret-up"></i></span></a>
        </div>
        <!-- E: registration_btn -->
      </div>
      <!-- E: tp-table-wrap -->
    
      <div class="sub_search">
      </div>
      <div class="table-list-wrap">
        <!-- S : table-list -->
        <table class="table-list level-dtl">
          <caption class="sr-only">대회정보관리 리스트</caption>
          <colgroup>
            <col width="44px">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="*">
            <col width="125px">
          </colgroup>
          <thead>
            <tr>
              <th scope="col">번호</th>
              <th scope="col">구분</th>
              <th scope="col">경기방식</th>
              <th scope="col">강수</th>
              <!--<th scope="col">최소인원</th>-->
              <th scope="col">본선진출</th>
              <th scope="col">경기장번호</th>
              <th scope="col">참가 팀 현황</th>
              <th scope="col">경기날짜/시간</th>
              <th scope="col">노출여부</th>
            </tr>
          </thead>
          <tbody id="levelDtlContest">
           <%
                If(cdbl(tGameLevelIdx) > 0) Then
                iType = 1
                LSQL = "EXEC tblGameLevelDtl_Searchd_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tGameLevelIdx & "','" & iTemp  & "','" & iLoginID & "'"
                'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
                'LSQL = LSQL & " FROM  tblGameTitle a "
                'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
                'LSQL = LSQL & " WHERE a.DELYN = 'N' "
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      LCnt = LCnt + 1
                      tGameLevelDtlidx = LRS("GameLevelDtlidx")
                      crypt_tGameLevelDtlidx =crypt.EncryptStringENC(tGameLevelDtlidx)
                      tPlayLevelType= LRS("PlayLevelType")
                      tPlayLevelTypeNm = LRS("PlayLevelTypeNm")
                      tGameTypeNm = LRS("GameTypeNm")
                      tTotRound = LRS("TotRound")
                      tEntryCnt = LRS("EntryCnt")
                      tStadiumNumber = LRS("StadiumNumber")
                      tStadiumName = LRS("StadiumName")
                      tStadiumCourt = LRS("StadiumCourt")
                      tGameDay = LRS("GameDay")
                      tLevelJooNum = LRS("LevelJooNum")
                      tGameTime = LRS("GameTime")
                      tViewYN = LRS("ViewYN")
                      tRequestCnt = LRS("RequestCnt")
                      tJooRank = LRS("JooRank")
                      tFullGameYN = LRS("FullGameYN")
                      
                      %>
                      <tr>
                        <td style="cursor:pointer" onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tGameLevelDtlidx%>
                        </td>
                        <td  style="cursor:pointer"  onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tPlayLevelTypeNm%><%if tLevelJooNum <> "" and tPlayLevelType <> "B0100002" Then%>-<%=tLevelJooNum%>조 <%End IF%>
                        </td>
                        <td  style="cursor:pointer"  onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%IF tFullGameYN = "Y" THEN%>
                          <%response.wRITE "풀 "%>
                          <%END IF%>
                          <%=tGameTypeNm%>
                        </td>
                        <td  style="cursor:pointer" onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tTotRound%>
                        </td>
                     
                        <td  style="cursor:pointer"  onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%
                            '본선 진출순위는 예선만 보이게 처리
                            If tPlayLevelType = "B0100001" Then
                                Response.Write tJooRank & "위"
                            Else
                                Response.Write "-"
                            End If
                          %>
                        </td>
                        <td  style="cursor:pointer"  onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tStadiumName%> 코트 : <%=tStadiumCourt%>
                        </td>

                        <td>
                        <% IF CDBL(tRequestCnt) > 0 Then %>
                          <a href='javascript:href_LevelDtlParticipate("<%=crypt_tPGameLevelIdx%>","<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=pType%>");'  class="btn list-btn btn-blue-empty"> 참가팀 (<%=tRequestCnt%>) <img src="../images/icon_more_right.png" alt=""></a>
                        <%Else %>
                          <a href='javascript:href_LevelDtlParticipate("<%=crypt_tPGameLevelIdx%>","<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=pType%>");'  class="btn list-btn btn-blue"> 참가팀 분류 <img src="../images/icon_more_right.png" alt=""></a>
                        <%End IF%>
                        </td>
                        <td  style="cursor:pointer" onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tGameDay%>&nbsp;(<%=tGameTime%>)
                        </td>
                        <td  style="cursor:pointer" onclick='javascript:SelGameLevelDtl(<%=strjson%>,"<%=crypt_tGameLevelIdx%>","<%=crypt_tGameLevelDtlidx%>","<%=NowPage%>")'>
                          <%=tViewYN%>
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
        <!-- E : table-list -->
        
      </div>
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
      <div>
    
    </div>
  </div>
  <!--E: content level_dtl -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>