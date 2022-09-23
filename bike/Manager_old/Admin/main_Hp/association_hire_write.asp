<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/association_hire_write.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 채용공고 수정/입력
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

    iDivision = "7"                             ' 현재 페이지 구분값

    ListPage    = "/Main_HP/association_hire_list.asp"
    ViewPage    = "/Main_HP/association_hire_write.asp"
    WritePage   = "/Main_HP/association_hire_write.asp"
    ProcPage    = "/Main_HP/association_hire_proc.asp"

    ' 로그인 아이디
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyField2") = "" Then KeyField2 = "" Else KeyField2 = fInject(Trim(Request.Form("KeyField2")))
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

            Buff            = Null
            Cnt             = 0
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

                If FileYN = "Y" AND FileCnt > 0 Then
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
                        Buff	= Null
                        Cnt		= 0
                    Else
                        Buff	= sRow.getrows
                        Cnt		= UBound(Buff,2)
                    End If
                    Set sRow = Nothing
                Else
                    Buff	= Null
                End If
            End If
            Set gRow = Nothing
    End Select
%>
<!--#include file="../include/head.asp"-->
<!--<script src="../dev/dist/se2_img/js/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>-->
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
<!--
	var locationStr = "association_hire_list.asp"
	
    var maxFileLength = <%=global_fileNum%>;
    var FileAddTag = "<tr class='addFile'><td><input type='file' id='xUpRObjectID' name='xUpRObject' /><input type='hidden' id='xUpCondition' name='xUpCondition' value='ETC' /><input type='hidden' id='yUpPrevPKID' name='yUpPrevPK' value='0' /><input type='hidden' id='yUpStateFlagID' name='yUpStateFlag' value='W' /><input type='hidden' id='yUpRObjectID' name='yUpRObject' value='' /><input type='hidden' id='yUpOObjectID' name='yUpOObject' value='' /></td></tr>";

    function chk_fileTag(opt) {
        nowFileLength = $("#iFileDiv").children("table").children("tbody").children("tr").length;
        if (opt == "P") {
            if (nowFileLength >= maxFileLength) {
                alert('현재 첨부 파일 추가는 ' + maxFileLength + '개 까지 만 가능 합니다.');
            }else {
                $("#iFileDiv").children("table").append(FileAddTag);
            }
        }else {
            inputFileLength = $("#iFileDiv").children("table").children("tbody").children("tr.addFile").length;
            if (inputFileLength <= 1) {
                //alert('첨부파일 개수는 최소 1개는 있어야합니다.');
            }else {
                $("#iFileDiv").children("table").children("tbody").children("tr.addFile").eq(inputFileLength-1).remove();
            }
        }
    } 

    function ListLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyWord': KeyWord});
    }

    function chk_Submit(oR, ixOpt, ixType, ixAct, ixTag) {
        var sText = (ixType == 'W' ? '등록' : (ixType == 'M' ? '수정' : '삭제'));
        $("#pType").val(ixType);
        oEditors.getById["iContents"].exec("UPDATE_CONTENTS_FIELD", []);
        var iContents = $("#iContents").val();

        // 스마트에디터 공란인데 <p><br></p> 가 들어가서 빈값을 <p><br></p> 로 잡아야 함
        // 빈값에 태그가 들어가서 값을 빈값으로 변경해줌
        if (iContents == "<p><br></p>") {
            iContents = "";
        }

        if (jXrTrim(oR.Subject.value) == "") {
            alert("제목을 입력해주세요.");
            oR.Subject.focus();
            return;
        }
        if (jXrTrim(iContents) == "") {
            alert("내용을 입력해주세요.");            
            return;
        }
        if (confirm(sText +" 하시겠습니까?")) {
            jXrSubmit(oR, ixOpt, ixAct, ixTag);
        }
    }

    function fn_fileDown(itype, idx) {
        post_to_url('/dev/dist/commonFileDown.asp', {'pType': itype, 'idx': idx}, "get");
    }

    function FileDel(obj, i4, i5, i6) {
        if (confirm("선택한 파일을 삭제 하시겠습니까?")) {
            //alert(i4 + ", " + i5 + " , " + i6);            
            
            var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
            $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',
                data: {
                    i4: i4,
                    i5: i5,
                    i6: i6,
                    i7: "5"
                },
                success: function (retDATA) {
                    //alert(retDATA);
                   
                    if (retDATA == "1") {
                        alert("해당 파일이 삭제 됐습니다.");
                        $(obj).parent().parent().remove();
                    } else {
                        alert("해당 파일이 없습니다.");
                        $(obj).parent().parent().remove();
                    }
                }, error: function (xhr, status, error) {
                    if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
                }
            });           
        }
    }
//-->
</script>
<!-- S : content association_hire_write -->
<div id="content">
    <div class="page_title clearfix">
        <h2>채용공고</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>협회소식</li>
                <li><a href="<%=ListPage%>">채용공고</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->

        <form id="form1" name="form1" action="" method="post">
        <input type="hidden" id="NowPage" name="NowPage" value="<%=NowPage%>">
        <input type="hidden" id="KeyField1" name="KeyField1" value="<%=KeyField1%>">
        <input type="hidden" id="KeyField2" name="KeyField2" value="<%=KeyField2%>">
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
            <tr class="file-line">
                <th>파일</th>
                <td>
                    <span>                        
                        <div id="iFileDiv" name="iFileDiv">
                            <table style="width:300px;">
                                <tbody>
                                    <%
                                    If IsNull(Buff) = False Then
                                        For i=0 To Cnt
                                            PSeq        = CDbl(Buff(0, i))
                                            FileName    = Trim(Buff(1, i))
                                            FilePath    = Trim(Buff(2, i))
                                            FileType    = Trim(Buff(3, i))
                                    %>
                                    <tr>
                                        <td>
                                            <input type="hidden" id="xUpCondition" name="xUpCondition" value="ETC" />
                                            <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="<%=PSeq%>" />
                                            <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                            <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="<%=FilePath%>" />
                                            <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="<%=FileName%>" />
                                            <a href="javascript:;" onClick="fn_fileDown('C', '<%=crypt.EncryptStringENC(PSeq) %>')"><%=FilePath%></a>
                                        </td>
                                        <td>
                                            <a href="javascript:;" onClick="FileDel(this, '<%=crypt.EncryptStringENC(PSeq) %>', '<%=crypt.EncryptStringENC(FileName) %>', '<%=crypt.EncryptStringENC(MSeq) %>')" class="btn btn-cancel">삭제</a>
                                        </td>
                                    </tr>
                                    <%
                                        Next
                                    End If
                                    %>
                                    <%If Cnt < 5 Then %>
                                    <tr class="addFile">
                                        <td>
                                            <input type="file" id="xUpRObjectID" name="xUpRObject" />
                                            <input type="hidden" id="xUpCondition" name="xUpCondition" value="ETC" />
                                            <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="0" />
                                            <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                            <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="" />
                                            <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="" />
                                        </td>
                                    </tr>
                                    <%End If %>
                                </tbody>
                            </table>
                        </div>

                        <span id="FN_iFile_1" class="added-list" style="padding-left:10px; padding-bottom:10px;">
                            <a href="javascript:;" onclick="chk_fileTag('P');" class="btn"><i class="fas fa-plus"></i></a>
                            <a href="javascript:;" class="btn btn_file_del" onclick="chk_fileTag('M');"><i class="fas fa-minus"></i></a>
                        </span>
                    </span>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td style="width:880px;">
                    <span class="edit_box">
                        <textarea name="iContents" id="iContents" rows="15" cols="100"><%=Contents %></textarea>
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
<!-- E : content association_hire_write -->
<script type="text/javascript">
<!--
        var oEditors = [];
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "iContents",
            //sSkinURI: "../dev/dist/se2_img/SmartEditor2Skin.html",
            sSkinURI: "../dev/dist/se2/SmartEditor2Skin.html",
            fCreator: "createSEditor2"
        });
//-->
</script>
<!--#include file="../include/footer.asp"-->
<%DBClose()%>