<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameTitleMenu/index.js"></script>

<script type="text/javascript">

  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./leader.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./leader.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./leader.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./leader.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
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

  ' 전체 가져오기
  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC Leader_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
  'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
  'response.End

  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If

  'response.Write "NowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPage="&NowPage&"<br>"
  'response.Write "iTotalCountiTotalCountiTotalCountiTotalCountiTotalCountiTotalCount="&iTotalCount&"<br>"
  'response.Write "iTotalPageiTotalPageiTotalPageiTotalPageiTotalPageiTotalPage="&iTotalPage&"<br>" 
  'response.Write "PagePerDataPagePerDataPagePerDataPagePerDataPagePerDataPagePerData="&PagePerData&"<br>"  
  'response.Write "BlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPage="&BlockPage&"<br>"  

%>

  <!-- S: content leader -->
  <div id="content" class="leader">

    <!-- S : 내용 시작 -->
    <div class="contents member">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>지도자 관리(엘리트)</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>회원관리</li>
            <li><a href="#">회원관리</a></li>
            <li><a href="./leader.asp">지도자 관리(엘리트)</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->
        </div>
        <!-- E: page_title -->

        <div class="search_top">
          <div class="search_box">
            <!-- S: upper-line -->
            <div class="upper-line">
              <span class="tit">등록날짜</span>
              <input type="date" name="SDate" id="SDate" maxlength="10" value="">
              <span class="txt">-</span>
              <input type="date" name="EDate" id="EDate" maxlength="10" value="">

              <span class="tit">구분</span>
              <select name="fnd_EnterType" id="fnd_EnterType" class="title_select">
                <option value="" selected="">===전체===</option>
                <option value="J">엘리트</option>
                <option value="A">생활체육</option>
                <option value="K">국가대표</option>
              </select>
              <span class="tit">성별</span>
              <select name="fnd_SEX" id="fnd_SEX" class="title_select">
                <option value="" selected="">===전체===</option>
                <option value="Man">남자</option>
                <option value="WoMan">여자</option>
              </select>
              <span class="tit">등록</span>
              <select name="fnd_REG" id="fnd_REG" class="title_select">
                <option value="" selected>===전체===</option>
                <option value="Y">등록</option>
                <option value="N">비등록</option>
              </select>
            </div>
            <!-- E: upper-line -->

            <!-- S: under-line -->
            <div class="under-line">
              <span class="tit">소속</span>
              <input type="text" name="fnd_Team" id="fnd_Team" class="ipt-word">
              <span class="tit">이름</span>
              <input type="text" name="fnd_User" id="fnd_User" class="ipt-word">
                    <a href="javascript:chk_Submit();" class="btn btn-search" accesskey="s">검색(S)</a> 
            </div>
            <!-- E: under-line -->
          </div>

        </div>
      </div>

      <!-- E : sch 검색조건 선택 및 입력 -->
      <!-- S : 리스트형 20개씩 노출 -->
      <div id="board-contents" class="table-list-wrap">

      <div class="total_count">
      <span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
      </div>

      <table class="table-list member-info">  
      <thead>
        <tr>
          <th width="60">번호</th>      
          <th width="80">이름</th>      
          <th width="100">생년월일</th>     
          <th width="80">성별</th>      
          <th>팀코드</th>      
          <th width="80">지도자구분</th>     
          <th width="120">연락처</th>      
          <th>체육인번호</th>      
          <th>주소</th>     
          <th>상세주소</th>     
          <th width="100">등록일</th>    
        </tr>
      </thead>  
      <tbody>

        <%
            iType = "1"                      ' 1:조회, 2:총갯수
            LSQL = "EXEC Leader_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
            'Response.Write LSQL
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                LCnt = LCnt + 1
                tLeaderIDX = LRS("LeaderIDX")
                tPersonNum = LRS("PersonNum")
                tAthleteNum = LRS("AthleteNum")
                tUserName= LRS("UserName")
                tUserEnName = LRS("UserEnName")
                tUserPhone= LRS("UserPhone")
                tUserTel = LRS("UserTel")
                tEmail = LRS("Email")
                tSEX = LRS("SEX")
                tBirthday = LRS("Birthday")
                tLeaderRegistYN = LRS("LeaderRegistYN")
                tLeaderRegistDt = LRS("LeaderRegistDt")
                tTeam = LRS("Team")
                tMngTeamGb = LRS("MngTeamGb")
                tZipCode = LRS("ZipCode")
                tAddress= LRS("Address")
                tAddressDtl= LRS("AddressDtl")
                tLeaderType= LRS("LeaderType")
                tLeaderTypeNm= LRS("LeaderTypeNm")
                tWriteDate= LRS("WriteDate")
                tRegistYear= LRS("RegistYear")
                tPKindCode= LRS("PKindCode")
                tPKIndCodeNm= LRS("PKIndCodeNm")
                tDelYN= LRS("DelYN")
                tNowRegYN= LRS("NowRegYN")

                %>
                <tr>  
                <td style="cursor:pointer"><%=tLeaderIDX%></td>
                <td style="cursor:pointer"><%=tUserName%></td>  
                <td style="cursor:pointer"><%=tBirthday%></td>  
                <td style="cursor:pointer"><%=tSEX%></td> 
                <td style="cursor:pointer"><%=tTeam%></td>  
                <td style="cursor:pointer"><%=tLeaderTypeNm%></td>  
                <td style="cursor:pointer"><%=tUserPhone%></td> 
                <td style="cursor:pointer"><%=tAthleteNum%></td>  
                <td style="cursor:pointer">(<%=tZipCode%>) <%=tAddress%> </td>  
                <td style="cursor:pointer"><%=tAddressDtl%></td>  
                <td style="cursor:pointer"><%=tWriteDate%></td> 
              </tr>
                <%
                LRs.MoveNext
              Loop
            End If
          %>
        

    
      </tbody>
    </table> 

    <div class="page_index">
      <div class="board-bullet pagination">
        <%
        if LCnt > 0 then
        %>
        <!--#include file="../../dev/dist/judoPaging_Admin.asp"-->
        <%
        End If
        %>
      </div>
    </div>
    
    </div>
  </div>
  <!-- E: content leader -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>