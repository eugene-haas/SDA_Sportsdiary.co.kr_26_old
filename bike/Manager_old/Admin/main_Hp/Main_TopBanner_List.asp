<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->

<%
    '===================================================================================================================================
    'PAGE : /Main_HP/association_Notice_list.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 공지사항 목록
    '===================================================================================================================================
    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim iDivision, iSubType, iSearchCol, iNoticeYN, iSearchText
    Dim gRow, i, ry, intNum, Buff, Cnt, SysBuff, SysCnt, LCnt0, LCnt
    Dim CSeq, Code
    Dim MSeq, Division, SubType, SubTypeName, Name, Subject, FileYN, NoticeYN, ViewCnt, InsDate
    Dim PSeq, FileName, FilePath, FileExt
    Dim ListPage, ViewPage, WritePage

    ' 로그인 체크
    Check_AdminLogin()

    PagePerData = global_PagePerData            ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage                ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

    ListPage    = "/Main_HP/Main_TopBanner_List.asp"
    ViewPage    = "/Main_HP/Main_TopBanner_Write.asp"
    WritePage   = "/Main_HP/Main_TopBanner_Write.asp"

    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

    If Request.Form("i2") = "" Or IsNumeric(Trim(Request.Form("i2"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("i2"))
    If Request.Form("iDivision") = "" Then iDivision = "42" Else iDivision = fInject(Trim(Request.Form("iDivision")))
    If Request.Form("iSubType") = "" Then iSubType = "" Else iSubType = fInject(Trim(Request.Form("iSubType")))
    If Request.Form("iSearchCol") = "" Then iSearchCol = "T" Else iSearchCol = fInject(Trim(Request.Form("iSearchCol")))
    If Request.Form("iNoticeYN") = "" Then iNoticeYN = "" Else iNoticeYN = fInject(Trim(Request.Form("iNoticeYN")))
    If Request.Form("iSearchCol1") = "" Then iSearchCol1 = "S2Y" Else iSearchCol1 = fInject(Trim(Request.Form("iSearchCol1")))      ' S2Y : 최신순, S2C : 많이본순
    If Request.Form("iSearchText") = "" Then iSearchText = "" Else iSearchText = Cstr(fInject(Replace(Trim(Request.Form("iSearchText")),"'","")))

    iType = "2"                      ' 1:조회, 2:총갯수

    ipdsgroup = ""        ' 마이페이지>게시글관리 : 게시판구분
    iColumnistIDX = ""    ' tblColumnist 컬럼리스트 그룹 IDX
    iDayGubun = ""        ' 랭킹시상식>년간,월간

  LSQL = "EXEC Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainTPTCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iColumnistIDX & "','" & iSearchCol1 & "','','','','',''"
  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If
  LRs.close
  Set LRs = Nothing
%>

<script type="text/javascript">
	var locationStr = "Main_TopBanner_List.asp"

	var selSearchValue1 = "<%=iSubType%>";
	var selSearchValue2 = "<%=iNoticeYN%>";
	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	var selSearchValue3 = "<%=iDivision%>";
	var selSearchValue4 = "<%=iSearchCol1%>";

	function WriteLink(i2) {
		post_to_url('./Main_TopBanner_Write.asp', { 'i2': i2, 'iType': '1', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function ReadLink(i1, i2) {
		post_to_url('./Main_TopBanner_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function PagingLink(i2) {
		post_to_url('./Main_TopBanner_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {
		selSearchValue4 = document.getElementById('selSearch4').value;
		selSearchValue3 = document.getElementById('selSearch3').value;

		selSearchValue2 = document.getElementById('selSearch2').value;
		selSearchValue1 = document.getElementById('selSearch1').value;
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;

		post_to_url('./Main_TopBanner_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

</script>
<!-- S: content TopBanner_list -->
<div id="content" class="TopBanner_list">
    <!-- S: page_title -->
    <div class="page_title clearfix">
        <h2>상단 배너관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
                <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>메인</li>
                <li><a href="<%=ListPage%>">상단 배너관리</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->
    </div>
    <!-- E: page_title -->

    <div class="search_top community">
        <div class="search_box">
            <!-- 메인 공지 유무 -->
            <input type="hidden" id="selSearch2" name="selSearch2" value="N" />
            <!--<select id="selSearch2" name="selSearch2" class="title_select">
            <option value="">전체-공지유무</option>
            <option value="Y">Y</option>
            <option value="N">N</option>
            </select>-->

            <!-- Division -->
            <input type="hidden" id="selSearch3" name="selSearch3" value="1" />
            <!--<select id="selSearch3" name="selSearch3" class="title_select">
            <option value="1">전체-구분</option>
            <option value="2">일반뉴스</option>
            <option value="3">영상뉴스</option>
            </select>-->

            <!-- Cnt -->
            <!--<input type="hidden" id="selSearch4" name="selSearch4" value="S2Y" />-->
            <select id="selSearch4" name="selSearch4" class="title_select">
            <option value="S2Y">최신순</option>
            <option value="S2C">많이본순</option>
            </select>

            <!-- Code 구분 -->
            <input type="hidden" id="selSearch1" name="selSearch1" value="" />

            <select id="selSearch" name="selSearch" class="title_select">
            <option value="T">전체</option>
            <option value="S">제목</option>
            <option value="C">내용</option>
            <option value="N">작성자</option>
            </select>

            <input type="text" id="txtSearch" name="txtSearch" placeholder="검색어를 입력해 주세요." class="title_input ipt-word">
            <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="btn btn-search">검색</a>
            <a href="javascript:;" onClick="javascript:WriteLink('<%=NowPage %>');" class="btn btn-add">글쓰기</a>
        </div>
        <br />
        <!-- 
        S : 내용 시작
        -->  
        <div class="total_count no-empty-top"><span>전체: <%=iTotalCount%></span>, <span><%=NowPage%> page / <%=iTotalPage%> pages</span></div>
  
        <table class="table-list">
            <caption class="sr-only">상단 배너관리 리스트</caption>
            <colgroup>
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
            </colgroup>
            <thead>
                <tr>
                    <th scope="col" width="60">순번</th>
                    <th scope="col" width="100">기본배너</th>
                    <th scope="col">링크주소</th>
                    <th scope="col" width="200">제목</th>
                    <th scope="col" width="100">개시시작일</th>
                    <th scope="col" width="100">개시종료일</th>
                    <th scope="col" width="100">작성자</th>
                    <th scope="col" width="100">작성일</th>
                </tr>
            </thead>
            <tbody id="gametitlelist">
                <%
                ' 리스트 조회
                iType = "1"
								LCnt = 0

                LSQL = "EXEC Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainNoticeCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iColumnistIDX & "','" & iSearchCol1 & "','','','','',''"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                'response.End
    
                Set LRs = DBCon.Execute(LSQL)
                        
                If Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                        LCnt = LCnt + 1
                %>
                <tr  style="cursor:pointer" onClick="javascript:ReadLink('<%=crypt.EncryptStringENC(LRs("MSeq")) %>','<%=NowPage %>');">
                    <td><%=LRs("Num") %></td>
                    <td>
                    <% if LRs("DefaultYN") = "Y" then %>
                    Y
                    <% else %>
                    <% end if %>
                    </td>
                    <td class="name"><%=LRs("LinkHref") %></td>
                    <td><%=LRs("Subject") %></td>
                    <td><%=LRs("StartDate") %></td>
                    <td><%=LRs("EndDate") %></td>
                    <td><%=LRs("Name") %></td>
                    <td><%=LRs("InsDateCv") %></td>
                </tr>
                <%
                    LRs.MoveNext
                    Loop
                Else
                %>
                <!--게시판에 데이터가 없는 경우-->
                <tr class="no-data">
                    <td colspan="8">
                        <div>등록된 게시물이 없습니다.</div>
                    </td>
                </tr>
                <%
                End If  
                LRs.close          
                Set LRs = Nothing
                DBClose()
                %>
            </tbody>
        </table>
        <%if LCnt > 0 then %>
        <div class="page_index">
        <!--#include file="../dev/dist/Paging_Admin.asp"-->
        </div>
        <%End If %>
        <!-- E : 내용 시작 -->
    </div>
    <!-- E: content TopBanner_list -->
    <script type="text/javascript">

        $("#txtSearch").val(txtSearchValue);
        $("#selSearch").val(selSearchValue);
        $("#selSearch1").val(selSearchValue1);
        $("#selSearch2").val(selSearchValue2);

        $("#selSearch3").val(selSearchValue3);
        $("#selSearch4").val(selSearchValue4);
    </script>
<!--#include file="../include/footer.asp"-->