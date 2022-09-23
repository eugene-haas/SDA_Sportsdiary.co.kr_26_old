<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/library/jquery.timepicker.min.js"></script>
<script type="text/javascript" src="../../js/GameTitleMenu/levelDtlParticipate.js"></script>

<%
  tIdx = fInject(crypt.DecryptStringENC(Request("tIdx")))  ' 현재페이지
  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))  ' 현재페이지
  tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelDtlIdx")))  ' 현재페이지

  crypt_tGameLevelDtlIdx =crypt.EncryptStringENC(tGameLevelDtlIdx)
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)
  crypt_tIdx =crypt.EncryptStringENC(tIdx)

  pType = Request("pType")

  IF ( pType ="plevel") Then
    tPGameLevelIdx =  fInject(crypt.DecryptStringENC(Request("tPGameLevelIdx")))
    crypt_tPGameLevelIdx= crypt.EncryptStringENC(tPGameLevelIdx)
  End IF
  
  isChkAllMember = true

  'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdx" & tIdx & "<br>"
  'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx" & tGameLevelIdx & "<br>"
  'Response.Write "tGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdx" & tGameLevelDtlIdx & "<br>"

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 50  ' 한화면에 출력할 갯수
  BlockPage = 50      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
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

  LSQL = " SELECT Top 1 a.GroupGameGb "
  LSQL = LSQL & "  FROM tblGameLevel a "
  LSQL = LSQL & " WHERE a.DelYN = 'N' and a.GameTitleIDX = " & tidx & " and a.GameLevelidx = " & tGameLevelIdx
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGroupGameGb = LRS("GroupGameGb")
      crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
      LRs.MoveNext
    Loop
  End IF

 'Response.WRite "tGroupGameGbtGroupGameGbtGroupGameGbtGroupGameGbtGroupGameGb" & crypt_tGroupGameGb & "<br>"
 
%>


<script type="text/javascript">
  /**
 * left-menu 체크
 */
  var bigCate = 2; // 대회정보
  var midCate = 0; // 대회운영
  var lowCate = 0; // 대회
  /* left-menu 체크 */
  var groupGameGb =  "<%=crypt_tGroupGameGb%>";
  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./levelDtlParticipate.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./levelDtlParticipate.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
   
    post_to_url('./levelDtlParticipate.asp', { 'i2': i2,'tGameLevelIdx' : '<%=tGameLevelIdx%>','iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./levelDtlParticipate.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  $(document).ready(function(){
    init();
  }); 

  init = function(){
    
    /* if (groupGameGb == "B4E57B7A4F9D60AE9C71424182BA33FE") { } else{ */
    
      /*개인전 영역 불러오기*/
      //왼쪽 영역 불러오기
      GameLevelEntry();
      //오른쪽 영역 불러오기
      loadLevelDtlChanged("<%=crypt_tGameLevelDtlIdx%>");
      /*개인전 영역 불러오기*/

    /*}*/
  };

  
</script>

<%
'Response.WRite "pTypepTypepTypepTypepTypepTypepTypepTypepTypepTypepTypepType:" & pType & "<br>"
'Response.WRite "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx:" & tGameLevelIdx & "<br>"
'Response.WRite "tPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdxtPGameLevelIdx:" & tPGameLevelIdx & "<br>"
'Response.WRite "tGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdx :" & tGameLevelDtlIdx & "<br>"

%>

<div id="content" class="level_dtl_participate">
    <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>참가팀 분류</h2>
    <%IF pType ="plevel" Then%>
    <a href="javascript:href_back2('<%=crypt_tIdx%>','<%=crypt_tPGameLevelIdx%>','<%=crypt_tGameLevelIdx%>',1);" class="btn btn-back">뒤로가기</a>
    <%Else%>
    <a href="javascript:href_back('<%=crypt_tIdx%>','<%=crypt_tGameLevelIdx%>',1);" class="btn btn-back">뒤로가기</a>
    <%End IF%>

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <span class="ic_deco">
        <i class="fas fa-angle-right fa-border"></i>
      </span>
      <ul>
        <li>어드민 정보</li>
        <li>대회운영</li>
        <li><a href="./index.asp">대회</a></li>
        <li><a href="./level.asp">대회종목</a></li>
        <li><a href="./levelDtl.asp">대진표</a></li>
        <li><a href="./levelDtlParticipate.asp">참가팀 분류</a></li>
      </ul>
    </div>
    <!-- E: 네비게이션 -->
  </div>
  <!-- E: page_title -->


  <!-- S : 내용 시작 -->
  <div class="contents">
    <input type="hidden" id="selGameLevelDtlIdx" value="<%=crypt_tGameLevelDtlIdx%>">
    <input type="hidden" id="selGameLevelIdx" value="<%=crypt_tGameLevelIdx%>">
    <input type="hidden" id="selGameIdx" value="<%=crypt_tIdx%>">
    <input type="hidden" id="selGroupGameGb" value="<%=crypt_tGroupGameGb%>">
    <!-- 종목 -->

    <!-- S: party_table -->
    <div class="party_table">
          <!-- S: title_scroll -->
    <div class="title_scroll">
        <!-- S: divLevelDtlMember -->
        <div id="divLevelDtlMember" name="divLevelDtlMember" >
        </div>
        <!-- E: divLevelDtlMember -->
    </div>
    <!-- E: title_scroll -->

    <!-- S: title_scroll -->
    <div class="title_scroll">
      <!-- S: divGameLevelDtlList -->
      <div id="divGameLevelDtlList" name="divGameLevelDtlList">
          
      </div>
      <!-- E: divGameLevelDtlList -->
    </div>
    <!-- E: title_scroll -->
    </div>
    <!-- E: party_table -->
    
  
    </div>
    <!-- E: content -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>