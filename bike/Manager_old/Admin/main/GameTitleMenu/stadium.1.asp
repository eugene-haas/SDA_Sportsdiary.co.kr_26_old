<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<%
  tIdx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tidx =crypt.EncryptStringENC(tidx)

%>
<script type="text/javascript" src="../../js/GameTitleMenu/stadium.js"></script>


<script type="text/javascript">
  /**
 * left-menu 체크
 */
  var locationStr = "GameTitleMenu/index"; // 대회
  /* left-menu 체크 */


  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./stadium.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./stadium.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./stadium.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./stadium.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>
<%

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

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

%>

  <input type="hidden" id="selGameTitleIdx" value="<%=crypt_tidx%>">
  <!-- S: content stadium -->
  <div id="content" class="stadium">
    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>장소 등록/관리</h2>
        <a href="./index.asp" class="btn btn-back">뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li><a href="./index.asp">대회</a></li>
            <li><a href="./stadium.asp">장소 등록/관리</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
      <strong id="Depth_GameTitle"><%=tGameTitleName%></strong>
          <!-- S: fromGameTitle -->
            <div id ="formGameTitle">   
              <!-- S: stdatiuminput_area -->
              <div id="stdatiuminput_area">
                <!-- left-head view-table -->
                <table class="left-head view-table">
                  <!-- <caption class="sr-only">대회정보 기본정보</caption> -->
                  <colgroup>
                    <col width="110px">
                    <col width="*">
                    <col width="110px">
                    <col width="*">
                    <col width="110px">
                    <col width="*">
                  </colgroup>
                  <tbody>
                    <tr>
                      <th scope="row">경기 장소</th>
                      <td>
                        <div>
                          <span class="con"><input type="text" id="txtStadiumName" value=""></span>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">코트수</th>
                      <td>
                        <div>
                          <span class="con"><input type="text" id="txtCourtCnt" value=""></span>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
            
            <!-- S: btn-list-left -->
            <div class="btn-list-left">
                <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputStadium_frm();" accesskey="i">등록(I)</a>
                <a href="#" id="btnupdate" class="btn btn-add" onclick="updateStadium_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
                <a href="#" id="btndel" class="btn btn-red" onclick="delStadium_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
              </div>
              <!-- E: btn-list-left -->
            </div>

          <table class="table-list push-top">
          <thead>
            <tr>
              <th>번호</th>
              <th>경기 장소</th>
              <th>코트 수 </th>
              <th>등록 날짜</th>
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
            <col width="100px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
          </colgroup>
          <tbody id="levelContest">
            <%
                If(cdbl(tIdx) > 0) Then
                LSQL = "SELECT StadiumIDX, GameTitleIDX, StadiumName, StadiumCourt, WriteDate"
                LSQL = LSQL & " FROM  tblStadium"
                LSQL = LSQL & " WHERE DelYN ='N' and GameTitleIDX = '" & tidx & "'"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
              Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    tStadiumIDX = LRs("StadiumIDX")
                    crypt_tStadiumIDX =crypt.EncryptStringENC(tStadiumIDX)
                    tGameTitleIDX = LRs("GameTitleIDX")
                    tStadiumName = LRs("StadiumName")
                    tStadiumCourt = LRs("StadiumCourt")
                    tWriteDate = LRs("WriteDate")
                    
                    %>
                     <tr>
                        <td style="cursor:pointer" onclick="javascript:SelStadium('<%=crypt_tStadiumIDX%>')">
                            <%=tStadiumIDX%>
                        </td>
                        <td style="cursor:pointer" onclick="javascript:SelStadium('<%=crypt_tStadiumIDX%>')">
                            <%=tStadiumName%>
                        </td>
                       <td style="cursor:pointer" onclick="javascript:SelStadium('<%=crypt_tStadiumIDX%>')">
                            <%=tStadiumCourt%>
                        </td>
                        <td style="cursor:pointer" onclick="javascript:SelStadium('<%=crypt_tStadiumIDX%>')">
                            <%=tWriteDate%>
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
          </div>
        </div>
    <!-- E: contents -->
  <div>
  <!-- E: content stadium -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>