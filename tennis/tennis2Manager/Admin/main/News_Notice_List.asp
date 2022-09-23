<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  
  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iDivision = "4"                   ' 1 : 뉴스 2 : 공지 3 : 계간유도 4 : 전체 뉴스/공지
  iLoginID = decode(fInject(Request.cookies("UserID")),0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  'Request Data
	iSubType = fInject(Request("iSubType"))
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))
	iNoticeYN = fInject(Request("iNoticeYN"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSubType) = 0) Then iSubType = "" ' 구분
	if(Len(iNoticeYN) = 0) Then iNoticeYN = "" ' 구분
	if(Len(iSearchCol) = 0) Then iSearchCol = "S" ' 검색 구분자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC News_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','','" & iLoginID & "'"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
		Loop
	End If
  LRs.close
%>

  <script type="text/javascript">

  	var selSearchValue1 = "<%=iSubType%>";
  	var selSearchValue2 = "<%=iNoticeYN%>";
    var selSearchValue = "<%=iSearchCol%>";
    var txtSearchValue = "<%=iSearchText%>";

    function WriteLink(i2) {

    	post_to_url('./News_Notice_Write.asp', { 'i2': i2, 'iType': '1' });

    }

    function ReadLink(i1, i2) {
      //location.href = 'cmRead.asp?i1=' + i1 + '&i2=' + i2; 
      //post_to_url('./cmRead.asp', { 'i1': i1, 'i2': i2 });

      //./Community_Motion_Read.asp

      //alert(i1 + " , " + i2);
    	post_to_url('./News_Notice_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function PagingLink(i2) {

      //location.href = 'cmList.asp?i2=' + i2;
    	post_to_url('./News_Notice_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function fn_selSearch() {

    	selSearchValue2 = document.getElementById('selSearch2').value;
    	selSearchValue1 = document.getElementById('selSearch1').value;
      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./News_Notice_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

  </script>


   <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			유도소식 > 뉴스/공지 > 뉴스공지
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
			<div class="search_box">
				<select id="selSearch2" name="selSearch2" class="title_select">
					<option value="">전체 공지</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				<select id="selSearch1" name="selSearch1" class="title_select">
					<option value="">전체</option>
					<%
							' 리스트 조회
							iType = "1"
							CType = "JudoNews"
							CSubType = ""

							LCnt1 = 0

							LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iType & "','" & CType & "','" & CSubType & "'"
							'response.Write "LSQL="&LSQL&"<br>"
							'response.End
  
							Set LRs = DBCon4.Execute(LSQL)
										
							If Not (LRs.Eof Or LRs.Bof) Then
								Do Until LRs.Eof
										LCnt1 = LCnt1 + 1
					%>
					<option value="<%=LRs("Code") %>"><%=LRs("Name") %></option>
					<%
								LRs.MoveNext
							Loop
							End If

							LRs.close
					%>
				</select>
				<select id="selSearch" name="selSearch" class="title_select">
					<option value="S">제목</option>
					<option value="C">내용</option>
				</select>
				<input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
			 <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
			</div>
      <div class="btn_list right">
        <!--<input type="button" id="btnselSearch" name="btnselSearch" value="검색" onclick="javascript:fn_selSearch();" />-->
		  </div>
      <br />
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list news_notice_list">
      <caption>대회 리스트</caption>
      <colgroup>
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">순번</th>
					<th scope="col">구분</th>
          <th scope="col">제목</th>
					<th scope="col">공지 유/무</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

					

          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC News_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','','" & iLoginID & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onclick="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td><%=LRs("SubTypeName") %></td>
          <td class="name"><%=LRs("Subject") %></td>
					<td><%=LRs("NoticeYN") %></td>
          <td><%=LRs("InsDateCv") %></td>
        </tr>
        <%
			        LRs.MoveNext
		        Loop
        %>

        <%
						Else
				%>
					<!--게시판에 데이터가 없는 경우-->
				<tr>
					<td colspan="4">
							<div>등록된 게시물이 없습니다.</div>
						</td>
				</tr>
        <%
          End If
  
          LRs.close
  
          JudoKorea_DBClose()
        %>

      </tbody>
    </table>

    <%
			if LCnt > 0 then
		%>
      <!--#include file="../dev/dist/judoPaging_Admin.asp"-->
		<%
			End If
		%>

    <!-- E : 내용 시작 -->
    <div class="btn_list right">
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">글쓰기</span></a>
		</div>


    </div>
  <section>

    <script type="text/javascript">

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);
      $("#selSearch1").val(selSearchValue1);
      $("#selSearch2").val(selSearchValue2);

    </script>
<!--#include file="footer.asp"-->
