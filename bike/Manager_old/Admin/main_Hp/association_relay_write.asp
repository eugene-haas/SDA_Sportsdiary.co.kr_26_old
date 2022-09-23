<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/association_relay_write.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 중계일정 수정/입력
    '===================================================================================================================================
    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim iDivision, KeyField1, KeyField2, KeyField3, KeyWord, ProcType
    Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt 
    Dim MSeq, Division, SubType, SubTypeName, CodeColor, Name, Subject, Contents, N_Year, FileYN, NoticeYN, TeamGb, TeamGbNm
    Dim ReplyYN, Link, LinkExt, FileCnt, ViewCnt, InsDate, LoginIDYN, InsID
    Dim relayDate, relayTime, relayTimeHH, relayTimeMM, relayChannel, relayDateName
    Dim GameTitleIdx, GameTitleName
    Dim ListPage, ViewPage, WritePage, ProcPage
    Dim iLoginID

    ' 로그인 체크
    Check_AdminLogin()

    iDivision = "8"                             ' 현재 페이지 구분값

    ListPage    = "/Main_HP/association_relay_list.asp"
    ViewPage    = "/Main_HP/association_relay_write.asp"
    WritePage   = "/Main_HP/association_relay_write.asp"
    ProcPage    = "/Main_HP/association_relay_proc.asp"

    ' 로그인 아이디
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    If Request.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request.Form("pType")))
    If Request.Form("idx") = "" Then MSeq = 0 Else MSeq = crypt.DecryptStringENC(fInject(Trim(Request.Form("idx"))))

    'Response.Write "ProcType: "& ProcType &"<br />"
    'Response.Write "MSeq: "& MSeq &"<br />"

    gSql = "SELECT GameTitleIdx, GameTitleName from tblGameTitle WITH(NOLOCK) WHERE GameE >= CONVERT(CHAR(10), GETDATE(), 121) AND DelYN = 'N' "
    gSql = gSql &" AND ViewYN = 'Y' ORDER BY GameS ASC"

    With objCmd
        .ActiveConnection = DBCon
        .CommandType  = adCmdText

        .CommandText  = gSql

        Set gRow = .Execute

        For ry = .Parameters.Count - 1 to 0 Step -1
            .Parameters.Delete(ry)
        Next
    End With

    If gRow.eof Or gRow.bof Then
		SysBuff	= Null
		SysCnt	= 0
	Else
		SysBuff	= gRow.getrows
		SysCnt	= UBound(SysBuff,2)
	End If
    Set gRow = Nothing

    Select Case ProcType
        Case "W"
            SubType         = ""
            Subject         = ""
            Contents        = ""
            NoticeYN        = "N"

            relayTimeHH     = Right(Hour(now())+100, 2)
            relayTimeMM     = Right(Minute(now())+100, 2)
            GameTitleIdx    = ""
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
                relayDate       = Trim(gRow(22))
                relayTime       = Trim(gRow(23))
                relayChannel    = Trim(gRow(24))
                GameTitleIdx    = Cdbl(gRow(25))
                GameTitleName   = Trim(gRow(26))
				
				If InStr(relayTime, ":") > 0 Then
					relayTimeHH     = Trim(Split(relayTime)(0))
					relayTimeMM     = Trim(Split(relayTime)(1))
				Else
					relayTimeHH     = ""
					relayTimeMM     = ""
				End If 

                If LoginIDYN = "N" Then
                    Set gRow = Nothing
                    DBClose()
                    response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"
                    response.End
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
    var locationStr = "association_relay_list.asp"

    function ListLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyWord': KeyWord});
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

        if (jXrTrim(oR.relayDate.value) == "") {
            alert("중계일자를 입력해주세요.");
            oR.relayDate.focus();
            return;
        }        

        if (jXrTrim(oR.GameTitleIdx.value) == "") {
            alert("대회를 선택해주세요.");
            oR.GameTitleIdx.focus();
            return;
        }

        if (jXrTrim(oR.relayDate.value) == "") {
            alert("중계채널을 입력해주세요.");
            oR.relayDate.focus();
            return;
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
//-->
</script>
<!-- S : content association_relay_write -->
<div id="content">
    <div class="page_title clearfix">
        <h2>중계일정</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>협회소식</li>
                <li><a href="<%=ListPage%>">중계일정</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->

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
                <th>날짜</th>
                <td>
                    <input type="input" id="relayDate" name="relayDate" class="date_ipt" value="<%=relayDate%>" style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;" readonly="readonly" />
                </td>
            </tr>
            <tr class="short-line">
                <th>시간</th>
                <td>
                    <p id="sel_NoticeYN">
                        <select id="relayTimeHH" name="relayTimeHH" class="title_select" style="width:120px;">
                            <%For i=0 To 23%>
                            <option value="<%=Right(i+100, 2)%>" <%If relayTimeHH = Right(i+100, 2) Then Response.Write "selected=""selected"""%>><%=Right(i+100, 2)%></option>
                            <%Next%>
                        </select> 시 &nbsp;
                        <select id="relayTimeMM" name="relayTimeMM" class="title_select" style="width:120px;">
                            <%For i=0 To 59%>
                            <option value="<%=Right(i+100, 2)%>" <%If relayTimeMM = Right(i+100, 2) Then Response.Write "selected=""selected"""%>><%=Right(i+100, 2)%></option>
                            <%Next%>
                        </select> 분
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>대회명</th>
                <td>
                    <p id="sel_SubType" class="con">
                        <select id="GameTitleIdx" name="GameTitleIdx" class="title_select">
                            <option value="">:: 대회 선택 ::</option>
                            <%
                            If IsNull(SysBuff) = False Then 
                                For i=0 to SysCnt
                                    GameIdx        = CDbl(SysBuff(0, i))
                                    GameName       = Trim(SysBuff(1, i))
                            %>
                            <option value="<%=GameIdx%>" <%IF GameTitleIdx = GameIdx Then response.write "selected" End IF%>><%=GameName%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>채널</th>
                <td>
                    <input type="text" id="relayChannel" name="relayChannel" value="<%=relayChannel %>" maxlength="30" class="in_1" />
                </td>
            </tr>
            <tr class="short-line">
                <th>제목</th>
                <td>
                    <input type="text" id="Subject" name="Subject" value="<%=Subject %>" maxlength="100" class="in_1" />
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
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, 'W', '<%=ProcPage%>', '');" class="btn btn-confirm">등록</a> 
            <a href="javascript:;" onClick="ListLink('<%=ListPage%>');" class="btn btn-blue-empty">목록</a>
            <%Else %>
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, 'M', '<%=ProcPage%>', '');" class="btn btn-confirm">수정</a> 
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, 'D', '<%=ProcPage%>', '');" class="btn btn-red">삭제</a> 
            <a href="javascript:;" onClick="ListLink('<%=ListPage%>');" class="btn btn-blue-empty">목록</a>
            <%End If%>            
        </div>
        <!-- E: btn-list-center -->
        </form>
    </div>
</div>
<!-- E : content association_relay_write -->
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