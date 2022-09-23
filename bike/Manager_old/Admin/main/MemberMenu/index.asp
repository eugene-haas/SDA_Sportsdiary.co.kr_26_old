<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/MemberMenu/index.js"></script>


<script type="text/javascript">

  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./index.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./index.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
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

  LSQL = "EXEC Member_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
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

  <div id="content" class="member">
    <!-- S : 내용 시작 -->
    <div class="contents">

      <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>선수 관리(엘리트)</h2>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>회원관리</li>
          <li><a href="#">회원관리</a></li>
          <li><a href="./index.asp">선수 관리(엘리트)</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->

      <!-- S : sch 검색조건 선택 및 입력 -->
      <div class="search_top">
        <div class="search_box">
          <span class="tit">가입날짜</span>
          <input type="date" name="SDate" id="SDate" maxlength="10" value="">-<input type="date" name="EDate" id="EDate" maxlength="10" value="">
              <span class="tit">구분</span>
              <select name="fnd_EnterType" id="fnd_EnterType" class="title_select">
                <option value="" selected="">===전체===</option>
                <option value="E">엘리트</option>
                <option value="A">생활체육</option>
              </select>
           
              <span class="tit">성별</span>
              <select name="fnd_SEX" id="fnd_SEX" class="title_select">
                  <option value="" selected="">===전체===</option>&gt;
                  <option value="Man">남자</option>
                  <option value="WoMan">여자</option>
                </select>
             
              <span class="tit">이름</span>
              <input type="text" name="fnd_User" id="fnd_User" class="ipt-word">
              <a href="javascript:chk_Submit();" class="btn btn-search" accesskey="s">검색(S)</a>
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
            <th>번호</th>     
            <th>구분</th>     
            <th>이름</th>     
            <th>생년월일</th>     
            <th>성별</th>     
            <th>회원구분</th>     
            <th>지역</th>     
            <th>소속</th>     
            <th>팀코드</th>      
            <th>Phone</th>      
            <th>SMS수신</th>      
            <th>이메일</th>      
            <th>이메일수신</th>      
            <th>주소</th>     
            <th>가입일</th>    
          </tr> 
        </thead>  
        <tbody>
          
          <%
            'LSQL = " SELECT MemberIDX,b.PubName as PlayerGb,UserName,UserPhone,Birthday,Sex,Level,PlayerCode,AthleteCode,PlayerType,PlayerGrade,a.EnterType,Team,RegTp,NowRegYN, Convert(char(10), a.WriteDate, 120) as WriteDate"
            'LSQL = LSQL & " FROM  tblMember a "
            'LSQL = LSQL & " Left join tblPubcode b on a.PlayerGb = b.PubCode  and b.DelYN = 'N'"
            iType = 1
            LSQL = "EXEC Member_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
            'response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL="&LSQL&"<br>" 
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                LCnt= LCnt + 1
                rMemberIDX = LRS("MemberIDX")
                rPlayerGb = LRS("PlayerGb")
                rUserName = LRS("UserName")
                rUserPhone = LRS("UserPhone")
                rBirthday = LRS("Birthday")
                rSex = LRS("Sex")
                rLevel = LRS("Level")
                rPlayerCode = LRS("PlayerCode")
                rAthleteCode = LRS("AthleteCode")
                rPlayerType = LRS("PlayerType")
                rPlayerGrade = LRS("PlayerGrade")
                rEnterType = LRS("EnterType")
                rTeam = LRS("Team")
                rRegTp = LRS("RegTp")
                rNowRegYN = LRS("NowRegYN")
                rWriteDate= LRS("WriteDate")
                %>
                  <!--#include file="../../html/MemberMenu/MemberList.asp"-->
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
    
      <!-- E : 리스트형 20개씩 노출 -->
    </div>
    </div>
  </div>

<!--#include file="../../include/footer.asp"-->
<%
  DBClose()
%>