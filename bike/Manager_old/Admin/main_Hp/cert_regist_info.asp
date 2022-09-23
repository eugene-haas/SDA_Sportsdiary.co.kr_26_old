<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/cert_regist_info.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서발급 정보관리
    '===================================================================================================================================
	Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt 
    Dim CertInfoIDX, CertWitness, CertDirector, CertPrice, CertFile, CertWFile, CertDFile
    Dim ListPage, ViewPage, WritePage, ProcPage
    Dim iLoginID

	' 로그인 체크
    Check_AdminLogin()

	ListPage    = "/Main_HP/cert_regist_info.asp"
    ViewPage    = "/Main_HP/cert_regist_info.asp"
    WritePage   = "/Main_HP/cert_regist_info.asp"
    ProcPage    = "/Main_HP/cert_regist_info_proc.asp"

	ProcType	= "M"

	' 로그인 아이디
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

	gSql = "SELECT TOP 1 CertInfoIDX, CertWitness, CertDirector, CertPrice, CertFile, CertWFile, CertDFile "
	gSql = gSql &"from [KoreaBadminton].[dbo].[tblOnlineCertificateInfo] WITH(NOLOCK) ORDER BY CertInfoIDX DESC"    

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
		CertInfoIDX			= 0
		CertWitness			= ""
		CertDirector		= ""
		CertPrice			= 0
		CertFile			= ""
        CertWFile           = ""
        CertDFile           = ""
	Else
		CertInfoIDX			= CDbl(gRow(0))
		CertWitness			= Trim(gRow(1))
		CertDirector		= Trim(gRow(2))
		CertPrice			= CDbl(gRow(3))
		CertFile			= Trim(gRow(4))
        CertWFile           = Trim(gRow(5))
        CertDFile           = Trim(gRow(6))
	End If
    Set gRow = Nothing
%>
<!--#include file="../include/head.asp"-->
<script type="text/javascript">
<!--
	var locationStr = "cert_regist_info.asp"

    function ListLink(i2) {
        post_to_url('<%=ListPage%>', {'NowPage': i2});
    }

    function chk_Submit(oR, ixOpt, ixType, ixAct, ixTag) {
        var sText = (ixType == 'W' ? '등록' : (ixType == 'M' ? '수정' : '삭제'));
        $("#pType").val(ixType);

        if (jXrTrim(oR.CertWitness.value) == "") {
            alert("기록 대조·확인자를 입력해주세요.");
            oR.CertWitness.focus();
            return;
        }
        if (jXrTrim(oR.CertDirector.value) == "") {
            alert("사무국장을 입력해주세요.");
            oR.CertDirector.focus();
            return;
        }
		if (jXrTrim(oR.CertPrice.value) == "") {
            alert("발급료를 입력해주세요.");
            oR.CertPrice.focus();
            return;
        }else {
			if (isNaN(oR.CertPrice.value)) {
				alert("발급료는 숫자만 입력해주세요.");
				oR.CertPrice.focus();
				return;
			}
		}
        if (confirm(sText +" 하시겠습니까?")) {
            jXrSubmit(oR, ixOpt, ixAct, ixTag);
        }
    }

    function fn_fileDown(itype, idx, iNum) {
        post_to_url('/dev/dist/commonFileDown.asp', {'pType': itype, 'idx': idx,  'fType': iNum}, "get");
    }
//-->
</script>
<!-- S : content cert_regist_info -->
<div id="content">
    <div class="page_title clearfix">
        <h2>증명서발급 정보관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>온라인서비스</li>
                <li><a href="<%=ListPage%>">증명서발급 정보관리</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->

        <form id="form1" name="form1" action="" method="post">
        <input type="hidden" id="pType" name="pType" value="<%=ProcType%>">
        <input type="hidden" id="idx" name="idx" value="<%=crypt.EncryptStringENC(CertInfoIDX) %>" />
        <table class="left-head view-table">          
			<tr class="short-line">
                <th>기록 대조·확인자</th>
                <td>
                    <input type="text" id="CertWitness" name="CertWitness" value="<%=CertWitness %>" maxlength="10" class="in_2 inputfield" />
                </td>
            </tr>
            <tr class="short-line">
                <th>사무국장</th>
                <td>
                    <input type="text" id="CertDirector" name="CertDirector" value="<%=CertDirector %>" maxlength="10" class="in_2 inputfield" />
                </td>
            </tr>
            <tr class="short-line">
                <th>발급료</th>
                <td>
                    <input type="text" id="CertPrice" name="CertPrice" value="<%=CertPrice %>" maxlength="5" class="in_2 inputfield" />
                </td>
            </tr>
            <tr class="file-line">
                <th>기록 대조·확인자 직인</th>
                <td>
                    <span class="con">
                        <div id="iFileDiv" name="iFileDiv">
                            <table style="width:300px;">
                                <span id="sFile_1">
                                    <input type="file" id="xUpRObjectID1" name="xUpRObject" />
                                    <input type="hidden" id="xUpCondition" name="xUpCondition" value="IMG" />
                                    <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="0" />
                                    <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                    <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="<%=CertWFile%>" />
                                    <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="<%=CertWFile%>" />
                                    <%IF CertWFile <> "" Then%>
                                        <div style="width:400px;">
                                            <a href="javascript:;" onClick="fn_fileDown('E', '<%=crypt.EncryptStringENC(CertInfoIDX)%>', 'W');"><%=CertWFile%></a>
                                        </div>
                                    <%End IF%>
                                </span>
                            </table>
                        </div>
                    </span>
                </td>
            </tr>
            <tr class="file-line">
                <th>사무국장 직인</th>
                <td>
                    <span class="con">
                        <div id="iFileDiv" name="iFileDiv">
                            <table style="width:300px;">
                                <span id="sFile_1">
                                    <input type="file" id="xUpRObjectID1" name="xUpRObject" />
                                    <input type="hidden" id="xUpCondition" name="xUpCondition" value="IMG" />
                                    <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="0" />
                                    <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                    <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="<%=CertDFile%>" />
                                    <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="<%=CertDFile%>" />
                                    <%IF CertDFile <> "" Then%>
                                        <div style="width:400px;">
                                            <a href="javascript:;" onClick="fn_fileDown('E', '<%=crypt.EncryptStringENC(CertInfoIDX)%>', 'D');"><%=CertDFile%></a>
                                        </div>
                                    <%End IF%>
                                </span>
                            </table>
                        </div>
                    </span>
                </td>
            </tr>
            <tr class="file-line">
                <th>협회 직인</th>
                <td>
                    <span class="con">
                        <div id="iFileDiv" name="iFileDiv">
                            <table style="width:300px;">
                                <span id="sFile_1">
                                    <input type="file" id="xUpRObjectID1" name="xUpRObject" />
                                    <input type="hidden" id="xUpCondition" name="xUpCondition" value="IMG" />
                                    <input type="hidden" id="yUpPrevPKID" name="yUpPrevPK" value="0" />
                                    <input type="hidden" id="yUpStateFlagID" name="yUpStateFlag" value="W" />
                                    <input type="hidden" id="yUpRObjectID" name="yUpRObject" value="<%=CertFile%>" />
                                    <input type="hidden" id="yUpOObjectID" name="yUpOObject" value="<%=CertFile%>" />
                                    <%IF CertFile <> "" Then%>
                                        <div style="width:400px;">
                                            <a href="javascript:;" onClick="fn_fileDown('E', '<%=crypt.EncryptStringENC(CertInfoIDX)%>', 'F');"><%=CertFile%></a>
                                        </div>
                                    <%End IF%>
                                </span>
                            </table>
                        </div>
                    </span>
                </td>
            </tr>
		</table>

        <!-- S: btn-list-center -->
        <div class="btn-list-center">
            <a href="javascript:;" onClick="chk_Submit(document.form1, true, 'M', '<%=ProcPage%>', '');" class="btn btn-confirm">수정</a> 
            <a href="javascript:;" onClick="ListLink('1');" class="btn btn-blue-empty">취소</a>
        </div>
        <!-- E: btn-list-center -->
        </form>
    </div>
</div>
<!-- E : content cert_regist_info -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>