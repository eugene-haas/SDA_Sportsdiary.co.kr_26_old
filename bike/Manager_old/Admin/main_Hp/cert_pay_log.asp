<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/cert_pay_log.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서발급 결제내역 목록
    '===================================================================================================================================
    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim KeyField1, KeyField2, KeyField3, KeyWord
    Dim gRow, i, ry, intNum, Buff, Cnt, SysBuff, SysCnt
    Dim CertPayIDX, CertificateIDX, CerPayNum, CertPayRespCode, CertPayRespCodeNm, CertPayRespMsg, CertPayAmout
    Dim CertPayTid, CertPayPayType, CertPayPayTypeNm, CertPayPayDate
    Dim CertPayBuyer
    Dim ListPage

    ' 로그인 체크
    Check_AdminLogin()

    PagePerData = global_PagePerData            ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage                ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

    ListPage    = "/Main_HP/cert_pay_log.asp"

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyField2") = "" Then KeyField2 = "" Else KeyField2 = fInject(Trim(Request.Form("KeyField2")))
    If Request.Form("KeyField3") = "" Then KeyField3 = "" Else KeyField3 = fInject(Trim(Request.Form("KeyField3")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    With objCmd
		.ActiveConnection = DBCon
		.CommandType  = adCmdStoredProc

		.CommandText  = "SP_ADM_TBLONLINECERTIFICATEPAYLOG_LIST"

        .Parameters.Append .CreateParameter("@NowPage", adInteger, adParamInput, 4, NowPage)
		.Parameters.Append .CreateParameter("@PagePerData", adInteger, adParamInput, 4, PagePerData)
		.Parameters.Append .CreateParameter("@BlockPage",adInteger, adParamInput, 4, BlockPage)
        .Parameters.Append .CreateParameter("@KEYFIELD1", adVarChar, adParamInput, 6, KeyField1)
        .Parameters.Append .CreateParameter("@KEYFIELD2",adVarChar, adParamInput, 4, KeyField2)
        .Parameters.Append .CreateParameter("@KEYFIELD3",adVarChar, adParamInput, 64, KeyField3)
        .Parameters.Append .CreateParameter("@KEYWORD",adVarWChar, adParamInput, 50, KeyWord)

		Set gRow = .Execute

		For ry = .Parameters.Count - 1 to 0 Step -1
            .Parameters.Delete(ry)
        Next
	End With

	iTotalCount     = CDbl(gRow(0))
	iTotalPage      = CDbl(gRow(1))

    Set gRow = gRow.NextRecordSet
    If gRow.eof Or gRow.bof Then
		Buff	= Null
		Cnt		= 0
	Else
		Buff	= gRow.getrows
		Cnt		= UBound(Buff,2)
	End If
    Set gRow = Nothing
%>
<!--#include file="../include/head.asp"-->
<script type="text/javascript">
<!--
    var locationStr = "cert_pay_log.asp"

    function PagingLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyWord': KeyWord});
    }

    function fn_selSearch() {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyWord = $("#KeyWord").val();    

        post_to_url('<%=ListPage%>', {'NowPage': 1, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyWord': KeyWord});
    }
//-->
</script>
<!-- S : content cert_pay_log -->
<div id="content">
    <div class="page_title clearfix">
        <h2>증명서발급 결제내역</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>온라인서비스</li>
                <li><a href="<%=ListPage%>">증명서발급 결제내역</a></li>                    
            </ul>
        </div>
        <!-- E: 네비게이션 -->

        <!-- S : sch 검색조건 선택 및 입력 -->
        <form name="s_frm" method="post">
        <div class="search_top community">
            <!-- S: search_box -->
            <div class="search_box" >
                <select name="KeyField1" id="KeyField1" class="title_select">
                    <option value="">:: 결제구분 선택 ::</option>
                    <option value="SC0010" <%IF KeyField1 = "SC0010" Then response.write "selected" End IF%>>신용카드</option>
                    <option value="SC0030" <%IF KeyField1 = "SC0030" Then response.write "selected" End IF%>>계좌이체</option>
                    <option value="SC0040" <%IF KeyField1 = "SC0040" Then response.write "selected" End IF%>>무통장입금</option>
                    <option value="SC0060" <%IF KeyField1 = "SC0060" Then response.write "selected" End IF%>>휴대폰</option>
                </select>
                <select name="KeyField2" id="KeyField2" class="title_select">
                    <option value="">:: 결제성공 선택 ::</option>
                    <option value="0000" <%IF KeyField2 = "0000" Then response.write "selected" End IF%>>성공</option>
                    <option value="9999" <%IF KeyField2 = "9999" Then response.write "selected" End IF%>>실패</option>
                </select>
                <select name="KeyField3" id="KeyField3" class="title_select">
                    <option value="">:: 선택 ::</option>
                    <option value="NAME" <%IF KeyField3 = "NAME" Then response.write "selected" End IF%>>신청자명</option>
                    <option value="PNUM" <%IF KeyField3 = "PNUM" Then response.write "selected" End IF%>>주문번호</option>
                </select>

                <input type="text" id="KeyWord" name="KeyWord" placeholder="검색어를 입력해주세요" value="<%=KeyWord%>" class="title_input ipt-word">
                <a href="javascript:;" onClick="fn_selSearch();" class="btn btn-search">검색</a>
                <a href="<%=ListPage%>" class="btn btn-blue-empty">전체목록</a>
            </div>
            <!-- E: search-box -->
            <div class="total_count"><span>전체: <%=iTotalCount%></span>, <span><%=NowPage%> page / <%=iTotalPage%> pages</span></div>
        </div>

        <div class="community">
            <!-- S : 리스트형 20개씩 노출 -->   
            <div id="board-contents" class="table-list-wrap">
                <!-- S : table-list -->
                <table class="table-list">
                    <caption class="sr-only">증명서발급 결제내역 리스트</caption>
                    <thead>
                        <tr>
                            <th scope="col" width="60">순번</th>
                            <th scope="col" width="100">결제성공여부</th>
                            <th scope="col" width="100">결제구분</th>
                            <th scope="col" width="100">신청자명</th>
                            <th scope="col" width="180">주문번호</th>
                            <th scope="col" width="100">주문금액</th>
                            <th scope="col" width="200">LG 거래번호</th>
                            <th scope="col" width="120">결제일</th>
                            <th scope="col">결제메시지</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        If IsNull(Buff) = True Then 
                            Response.Write "<tr><td colspan=""9"">등록된 게시물이 없습니다.</td></tr>"
                        Else
                            For i=0 To Cnt
                                intNum			    = iTotalCount - ((NowPage-1) * PagePerData) - i
                                CertPayIDX          = CDbl(Buff(0, i))
                                CertificateIDX      = CDbl(Buff(1, i))
                                CerPayNum           = Trim(Buff(2, i))                               
                                CertPayRespCode     = Trim(Buff(3, i))
                                CertPayRespCodeNm   = Trim(Buff(4, i))
                                CertPayRespMsg      = Trim(Buff(5, i))
                                CertPayAmout        = Trim(Buff(6, i))
                                CertPayTid          = Trim(Buff(7, i))
                                CertPayPayType      = Trim(Buff(8, i))
                                CertPayPayTypeNm    = Trim(Buff(9, i))
                                CertPayPayDate      = Trim(Buff(10, i))
                                CertPayBuyer        = Trim(Buff(11, i))
                        %>
                        <tr>
                            <td><%=intNum %></td>
                            <td><%=CertPayRespCodeNm %></td>
                            <td><%=CertPayPayTypeNm%></td>
                            <td><%=CertPayBuyer %></td>
                            <td><%=CerPayNum %></td>
                            <td><%=FORMATNUMBER(CertPayAmout, 0)%></td>
                            <td><%=CertPayTid %></td>
                            <td><%=CertPayPayDate %></td>
                            <td><%=CertPayRespMsg %></td>
                        </tr>
                        <%
                            Next
                        End If
                        %>
                    </tbody>
                </table>
                <!-- E : table-list -->

                <%If IsNull(Buff) = False Then%>
                <!-- S: page_index -->
                <div class="page_index">
                <!--#include file="../dev/dist/Paging_Admin.asp"-->
                </div>
                <!-- E: page_index -->
                <%End If%>
            </div>
            <!-- E : 리스트형 20개씩 노출 -->    
        </div>
    </div>
</div>
<!-- E : content cert_pay_log -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>