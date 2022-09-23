<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/teamInfo_list.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 팀관리 목록
    '===================================================================================================================================
    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim KeyField1, KeyField2, KeyField3, KeyField4, KeyWord
    Dim gRow, i, ry, intNum, Buff, Cnt, SysBuff1, SysCnt1, SysBuff2, SysCnt2
    Dim PTeamIDX, PTeamGb, Team, TeamNm, TeamEnNm, Sex, sido, TeamTel, EnterType, WriteDate, PTeamGbName, SidoNm
    Dim SexVal, EnterTypeVal
    Dim ListPage, ViewPage, WritePage

    ' 로그인 체크
    Check_AdminLogin()

    PagePerData = global_PagePerData            ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage                ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

    ListPage    = "/Main_HP/teamInfo_list.asp"
    ViewPage    = "/Main_HP/teamInfo_reg.asp"
    WritePage   = "/Main_HP/teamInfo_reg.asp"

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyField2") = "" Then KeyField2 = "" Else KeyField2 = fInject(Trim(Request.Form("KeyField2")))
    If Request.Form("KeyField3") = "" Then KeyField3 = "" Else KeyField3 = fInject(Trim(Request.Form("KeyField3")))
    If Request.Form("KeyField4") = "" Then KeyField4 = "" Else KeyField4 = fInject(Trim(Request.Form("KeyField4")))
    If Request.Form("KeyField5") = "" Then KeyField5 = "" Else KeyField5 = fInject(Trim(Request.Form("KeyField5")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    With objCmd
		.ActiveConnection = DBCon
		.CommandType  = adCmdStoredProc

		.CommandText  = "SP_ADM_TBLTEAMINFO_LIST"

        .Parameters.Append .CreateParameter("@NowPage", adInteger, adParamInput, 4, NowPage)
		.Parameters.Append .CreateParameter("@PagePerData", adInteger, adParamInput, 4, PagePerData)
		.Parameters.Append .CreateParameter("@BlockPage",adInteger, adParamInput, 4, BlockPage)
        .Parameters.Append .CreateParameter("@KEYFIELD1",adVarWChar, adParamInput, 50, KeyField1)
        .Parameters.Append .CreateParameter("@KEYFIELD2",adVarWChar, adParamInput, 20, KeyField2)
        .Parameters.Append .CreateParameter("@KEYFIELD3",adVarChar, adParamInput, 10, KeyField3)
        .Parameters.Append .CreateParameter("@KEYFIELD4", adVarChar, adParamInput, 1, KeyField4)
        .Parameters.Append .CreateParameter("@KEYFIELD5", adVarChar, adParamInput, 100, KeyField5)
        .Parameters.Append .CreateParameter("@KEYWORD", adVarWChar, adParamInput, 50, KeyWord)        

		Set gRow = .Execute

		For ry = .Parameters.Count - 1 to 0 Step -1
            .Parameters.Delete(ry)
        Next
	End With

    ' 단체 구분
    If gRow.eof Or gRow.bof Then
		SysBuff1	= Null
		SysCnt1	    = 0
	Else
		SysBuff1	= gRow.getrows
		SysCnt1	    = UBound(SysBuff1,2)
	End If

    ' 시구분
    Set gRow = gRow.NextRecordSet
    If gRow.eof Or gRow.bof Then
		SysBuff2	= Null
		SysCnt2	    = 0
	Else
		SysBuff2	= gRow.getrows
		SysCnt2	    = UBound(SysBuff2,2)
	End If

    Set gRow = gRow.NextRecordSet
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
    var locationStr = "teamInfo_list.asp"
    
    function PagingLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyField4 = $("#KeyField4").val();
        var KeyField5 = $("#KeyField5").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyField4': KeyField4, 'KeyField5': KeyField5, 'KeyWord': KeyWord});
    }

    function fn_selSearch() {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyField4 = $("#KeyField4").val();
        var KeyField5 = $("#KeyField5").val();
        var KeyWord = $("#KeyWord").val();    

        post_to_url('<%=ListPage%>', {'NowPage': 1, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyField4': KeyField4, 'KeyField5': KeyField5, 'KeyWord': KeyWord});
    }

    function ReadLink(i1, i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyField4 = $("#KeyField4").val();
        var KeyField5 = $("#KeyField5").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ViewPage%>', {idx: i1, 'pType': 'M', 'NowPage': i2, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyField4': KeyField4, 'KeyField5': KeyField5, 'KeyWord': KeyWord});
    }
	function chgEnterType() {
		var obj = $("#KeyField4");
        $("#KeyField1 option").each(function(index) {
            if ($(this).val() != "") {
                if ($(obj).val() == "E") {
                    $(this).show();
                }else {
                    $(this).hide();
                }
            }
        })
	}
    $(document).ready(function() {
        chgEnterType()
    })
//-->
</script>
<!-- S : content teamInfo_reg -->
<div id="content">
    <div class="page_title clearfix">
        <h2>팀 관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>대회정보</li>
                <li>대회운영</li>
                <li><a href="<%=ListPage%>">팀 관리</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->

        <!-- S : sch 검색조건 선택 및 입력 -->
        <form name="s_frm" method="post">
        <div class="search_top community">
            <!-- S: search_box -->
            <div class="search_box" >
                <select name="KeyField4" id="KeyField4" class="title_select" onChange="chgEnterType()">
                    <option value="">:: 선수구분 선택 ::</option>
                    <option value="A" <%IF KeyField4 = "A" Then response.write "selected" End IF%>>체육동호인</option>  
                    <option value="E" <%IF KeyField4 = "E" Then response.write "selected" End IF%>>엘리트</option>
                </select>
                <select name="KeyField1" id="KeyField1" class="title_select">
                    <option value="">:: 단체구분 선택 ::</option>
                    <%
                    If IsNull(SysBuff1) = False Then 
                        For i=0 to SysCnt1
                            PTeamGbCode    = Trim(SysBuff1(0, i))
                            PTeamGbName    = Trim(SysBuff1(1, i))
                    %>
                    <option value="<%=PTeamGbCode%>" <%IF KeyField1 = PTeamGbCode Then response.write "selected" End IF%>><%=PTeamGbName%></option>
                    <%
                        Next
                    End If
                    %>
                </select>
                <select name="KeyField2" id="KeyField2" class="title_select">
                    <option value="">:: 단체성별구분 선택 ::</option>
                    <option value="Man" <%IF KeyField2 = "Man" Then response.write "selected" End IF%>>남성팀</option>
                    <option value="WoMan" <%IF KeyField2 = "WoMan" Then response.write "selected" End IF%>>여성팀</option>  
                </select>
                <select name="KeyField3" id="KeyField3" class="title_select">
                    <option value="">:: 시구분 선택 ::</option>
                    <%
                    If IsNull(SysBuff2) = False Then 
                        For i=0 to SysCnt2
                            Sido    = Trim(SysBuff2(0, i))
                            SidoNm  = Trim(SysBuff2(1, i))
                    %>
                    <option value="<%=Sido%>" <%IF KeyField3 = Sido Then response.write "selected" End IF%>><%=SidoNm%></option>
                    <%
                        Next
                    End If
                    %>
                </select>                
                <select name="KeyField5" id="KeyField5" class="title_select">
                    <option value="">:: 선택 ::</option>
                    <option value="NAME" <%IF KeyField5 = "NAME" Then response.write "selected" End IF%>>제목</option>
                </select>

                <input type="text" id="KeyWord" name="KeyWord" placeholder="검색어를 입력해주세요" value="<%=KeyWord%>" class="title_input ipt-word">
                <a href="javascript:;" onClick="fn_selSearch();" class="btn btn-search">검색</a>
                <a href="<%=ListPage%>" class="btn btn-blue-empty">전체목록</a>
                <a href="<%=WritePage%>" class="btn btn-add" >팀 등록</a>
            </div>
            <!-- E: search-box -->
            <div class="total_count"><span>전체: <%=iTotalCount%></span>, <span><%=NowPage%> page / <%=iTotalPage%> pages</span></div>
        </div>

        <div class="community">
            <!-- S : 리스트형 20개씩 노출 -->   
            <div id="board-contents" class="table-list-wrap">
                <!-- S : table-list -->
                <table class="table-list">
                    <caption class="sr-only">팀 리스트</caption>
                    <thead>
                        <tr>
                            <th scope="col" width="60">순번</th>
                            <th scope="col" width="100">선수구분</th>
                            <th scope="col" width="100">단체구분</th>                            
                            <th scope="col">단체명</th>
                            <th scope="col" width="100">단체성별</th>
                            <th scope="col" width="100">시구분</th>
                            <th scope="col" width="100">단체 전화번호</th>                            
                            <th scope="col" width="100">등록일</th>                            
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        If IsNull(Buff) = True Then 
                            Response.Write "<tr><td colspan=""8"">등록된 게시물이 없습니다.</td></tr>"
                        Else
                            For i=0 To Cnt
                                intNum			= iTotalCount - ((NowPage-1) * PagePerData) - i
                                PTeamIDX        = CDbl(Buff(0, i))
                                PTeamGb         = Trim(Buff(1, i))
                                Team            = Trim(Buff(2, i))
                                TeamNm          = Trim(Buff(3, i))
                                TeamEnNm        = Trim(Buff(4, i))
                                Sex             = Trim(Buff(5, i))
                                sido            = Trim(Buff(6, i))
                                TeamTel         = Trim(Buff(7, i))
                                EnterType       = Trim(Buff(8, i))
                                WriteDate       = Trim(Buff(9, i))
                                PTeamGbName     = Trim(Buff(10, i))
                                SidoNm          = Trim(Buff(11, i))

                                IF Sex = "Man" THEN 
                                    SexVal = "남성팀"
                                ELSE
                                    SexVal = "여성팀"
                                END IF 

                                IF EnterType = "E" THEN
                                    EnterTypeVal = "엘리트"
                                ELSE
                                    EnterTypeVal = "아마추어"
                                END IF 
                        %>
                        <tr style="cursor:pointer" onClick="javascript:ReadLink('<%=crypt.EncryptStringENC(PTeamIDX) %>','<%=NowPage %>');">
                            <td><%=intNum %></td>
                            <td><%=EnterTypeVal%></td>
                            <td><%=PTeamGbName %></td>
                            <td class="name"><%=TeamNm %></td>
                            <td><%=SexVal %></td>
                            <td><%=SidoNm %></td>
                            <td><%=TeamTel %></td>
                            <td><%=WriteDate %></td>
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
		</form>				
    </div>
</div>
<!-- E : content teamInfo_reg -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>