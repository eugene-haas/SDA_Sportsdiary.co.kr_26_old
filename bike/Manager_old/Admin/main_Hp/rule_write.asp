<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/rule_write.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 관련 규정 수정/입력
    '===================================================================================================================================
    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim iDivision, KeyField1, KeyField2, KeyField3, KeyWord, ProcType
    Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt 
    Dim MSeq, Division, SubType, SubTypeName, CodeColor, Name, Subject, Contents, N_Year, FileYN, NoticeYN, TeamGb, TeamGbNm
    Dim ReplyYN, Link, LinkExt, FileCnt, ViewCnt, InsDate, LoginIDYN, InsID
    Dim PSeq, FileName, FilePath, FileExt
    Dim ListPage, ViewPage, WritePage, ProcPage
    Dim iLoginID

    ' 로그인 체크
    Check_AdminLogin()

    iDivision = "9"                             ' 현재 페이지 구분값

    ListPage    = "/Main_HP/rule_list.asp"
    ViewPage    = "/Main_HP/rule_write.asp"
    WritePage   = "/Main_HP/rule_write.asp"
    ProcPage    = "/Main_HP/rule_proc.asp"

    ' 로그인 아이디
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    If Request.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request.Form("pType")))
    If Request.Form("idx") = "" Then MSeq = 0 Else MSeq = crypt.DecryptStringENC(fInject(Trim(Request.Form("idx"))))

    'Response.Write "ProcType: "& ProcType &"<br />"
    'Response.Write "MSeq: "& MSeq &"<br />"

    Select Case ProcType
        Case "W"
            SubType         = ""
            Subject         = ""
            Contents        = ""
            NoticeYN        = "N"

            PSeq            = 0
            FileName        = ""
            FilePath        = ""                ' 원본 파일명으로 사용
            FileExt         = ""
        Case "M"
            If IsNumeric(MSeq) = False Then
                DBClose()
                Response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"
                Response.End
            End If
            
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "Community_Board_R"

                .Parameters.Append .CreateParameter("@NowPage", adInteger, adParamInput, 4, NowPage)
                .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)                
                .Parameters.Append .CreateParameter("@iLoginID",adVarChar, adParamInput, 30, iLoginID)

                Set gRow = .Execute

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With

            If gRow.eof Or gRow.bof Then
                Set gRow = Nothing
                DBClose()
                Response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"                
                Response.End
            Else
                Division        = Trim(gRow(1))
                Name            = Trim(gRow(2))
                SubTypeName     = Trim(gRow(3))
                SubType         = Trim(gRow(4))
                CodeColor       = Trim(gRow(5))
                Subject         = Trim(gRow(6))
                ViewCnt         = Cdbl(gRow(7))
                Contents        = Trim(gRow(8))
                N_Year          = Trim(gRow(9))
                NoticeYN        = Trim(gRow(10))
                TeamGb          = Trim(gRow(11))
                TeamGbNm        = Trim(gRow(12))
                ReplyYN         = Trim(gRow(13))
                Link            = Trim(gRow(14))
                LinkExt         = Trim(gRow(15))
                FileYN          = Trim(gRow(16))
                FileCnt         = Trim(gRow(17))
                InsDate         = Trim(gRow(18))
                NowPage         = Trim(gRow(19))
                LoginIDYN       = Trim(gRow(20))
                InsID           = Trim(gRow(21))

                If LoginIDYN = "N" Then
                    Set gRow = Nothing
                    DBClose()
                    response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"
                    response.End
                End If

                If FileCnt <> "0" Then
                    With objCmd
                        .ActiveConnection = DBCon
                        .CommandType  = adCmdStoredProc

                        .CommandText  = "Community_Board_Pds_R"

                        .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)

                        Set sRow = .Execute

                        For ry = .Parameters.Count - 1 to 0 Step -1
                            .Parameters.Delete(ry)
                        Next
                    End With

                    If sRow.eof Or sRow.bof Then
                        PSeq            = 0
                        FileName        = ""
                        FilePath        = ""
                        FileExt         = ""
                    Else
                        PSeq            = Cdbl(sRow(0))
                        FileName        = Trim(sRow(1))
                        FilePath        = Trim(sRow(2))
                        FileExt         = Trim(sRow(3))
                    End If
                    Set sRow = Nothing
                End If
            End If
            Set gRow = Nothing
    End Select
%>
<!--#include file="../include/head.asp"-->
<script type="text/javascript">
<!--
	var locationStr = "rule_list.asp"

    function ListLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyWord': KeyWord});
    }

    function chk_Submit(oR, ixOpt, ixType, ixAct, ixTag) {
        var sText = (ixType == 'W' ? '등록' : (ixType == 'M' ? '수정' : '삭제'));
        $("#pType").val(ixType);


        if (jXrTrim(oR.Subject.value) == "") {
            alert("제목을 입력해주세요.");
            oR.Subject.focus();
            return;
        }
        if (confirm(sText +" 하시겠습니까?")) {
            jXrSubmit(oR, ixOpt, ixAct, ixTag);
        }
    }
//-->
</script>
<!-- S : content rule_write -->
<div id="content">
    <div class="page_title clearfix">
        <h2>관련 규정</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>협회정보</li>
                <li><a href="<%=ListPage%>">관련 규정</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->
    </div>

        <form id="form1" name="form1" action="" method="post">
        <input type="hidden" id="NowPage" name="NowPage" value="<%=NowPage%>">
        <input type="hidden" id="KeyField1" name="KeyField1" value="<%=KeyField1%>">
        <input type="hidden" id="KeyWord" name="KeyWord" value="<%=KeyWord%>">
        <input type="hidden" id="pType" name="pType" value="<%=ProcType%>">
        <input type="hidden" id="idx" name="idx" value="<%=crypt.EncryptStringENC(MSeq) %>" />
        <table class="left-head view-table">
            <%If ProcType ="M" Then %>
            <tr>
                <th>등록일</th>
                <td><span class="regist_date"><%=InsDate %></span></td>
            </tr>
            <%End If %>
            <tr class="short-line">
                <th>공지 유/무</th>
                <td>
                    <p id="sel_NoticeYN" class="con">
                        <select name="NoticeYN" id="NoticeYN" class="title_select">
                            <option value="">:: 공지구분 선택 ::</option>
                            <option value="Y" <%If NoticeYN = "Y" Then Response.Write "selected=""selected"""%>>Y</option>
                            <option value="N" <%If NoticeYN = "N" Then Response.Write "selected=""selected"""%>>N</option>
                        </select>
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>제목</th>
                <td>
                    <input type="text" id="Subject" name="Subject" value="<%=Subject %>" maxlength="100" class="in_1" />
                </td>
            </tr>
            <tr class="added-list">
                <th>파일</th>
                <td>
                    <span class="con">
                        <div id="iFileDiv" name="iFileDiv">
                            <span id="sFile_1">
                                <input type="file" id="xUpRObjectID1" name="xUpRObject" />
                                <input type="hidden" id="xUpCondition" name="xUpCondition" value="ETC" />
                                <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="<%=PSeq%>" />
                                <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="<%=FilePath%>" />
                                <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="<%=FileName%>" />
                                <%IF FileName <> "" Then%>
                                    <div style="width:400px;">
                                        <%=FilePath%>
                                        <input type="checkbox" name="Del_ImgProfile" id="Del_ImgProfile" value="Y" style="position: relative; height:20px; top: 5px;"><label for="Del_ImgProfile" style="cursor:pointer;">삭제시 체크</label>
                                    </div>
                                <%End IF%>
                            </span>
                        </div>
                    </span>
                </td>
            </tr>            
        </table>

        <!-- S: btn-list-center -->
        <div class="btn-list-center">
            <%If ProcType = "W" Then %>
            <a href="javascript:;" onClick="chk_Submit(document.form1, true, 'W', '<%=ProcPage%>', '');" class="btn btn-confirm">등록</a> 
            <a href="javascript:;" onClick="ListLink('<%=ListPage%>');" class="btn btn-blue-empty">목록</a>
            <%Else %>
            <a href="javascript:;" onClick="chk_Submit(document.form1, true, 'M', '<%=ProcPage%>', '');" class="btn btn-confirm">수정</a> 
            <a href="javascript:;" onClick="chk_Submit(document.form1, true, 'D', '<%=ProcPage%>', '');" class="btn btn-red">삭제</a> 
            <a href="javascript:;" onClick="ListLink('<%=ListPage%>');" class="btn btn-blue-empty">목록</a>
            <%End If%>            
        </div>
        <!-- E: btn-list-center -->
        </form>
    </div>
</div>
<!-- E : content rule_write -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>