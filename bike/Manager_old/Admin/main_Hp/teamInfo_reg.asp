<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/teamInfo_reg.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 팀등록
    '===================================================================================================================================

    Dim iTotalCount, NowPage, iTotalPage, PagePerData, BlockPage
    Dim iDivision, KeyField1, KeyField2, KeyField3, KeyWord, ProcType
    Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt, SysBuff1, SysCnt1, SysBuff2, SysCnt2 
    Dim PTeamIDX, TeamGb, Team, TeamNm, TeamEnNm, Sex, sido, ZipCode, Address, AddrDtl, TeamTel, TeamFax, EnterType
    Dim TeamTel1, TeamTel2, TeamTel3, TeamFax1, TeamFax2, TeamFax3
    Dim ListPage, ViewPage, WritePage, ProcPage
    Dim iLoginID

    ' 로그인 체크
    Check_AdminLogin()

    ListPage    = "/Main_HP/teamInfo_list.asp"
    ViewPage    = "/Main_HP/teamInfo_reg.asp"
    WritePage   = "/Main_HP/teamInfo_reg.asp"
    ProcPage    = "/Main_HP/teamInfo_reg_proc.asp"

    ' 선수 구분으로 단체 구분 처리(Ajax)


    ' 로그인 아이디
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyField2") = "" Then KeyField2 = "" Else KeyField2 = fInject(Trim(Request.Form("KeyField2")))
    If Request.Form("KeyField3") = "" Then KeyField3 = "" Else KeyField3 = fInject(Trim(Request.Form("KeyField3")))
    If Request.Form("KeyField4") = "" Then KeyField4 = "" Else KeyField4 = fInject(Trim(Request.Form("KeyField4")))
    If Request.Form("KeyField5") = "" Then KeyField5 = "" Else KeyField5 = fInject(Trim(Request.Form("KeyField5")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    If Request.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request.Form("pType")))
    If Request.Form("idx") = "" Then PTeamIDX = 0 Else PTeamIDX = crypt.DecryptStringENC(fInject(Trim(Request.Form("idx"))))


    gSql = "SELECT PTeamGbCode, PTeamGbName from tblTeamGbInfo WITH(NOLOCK) WHERE DelYN = 'N' AND EnterType = 'E' ORDER BY Orderby ASC"
    gSql = gSql &" ;SELECT Sido, SidoNm from tblSidoInfo WITH(NOLOCK) WHERE DelYN = 'N' ORDER BY OrderbyNum ASC"

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
		SysBuff1	= Null
		SysCnt1	    = 0
	Else
		SysBuff1	= gRow.getrows
		SysCnt1	    = UBound(SysBuff1,2)
	End If

    Set gRow = gRow.NextRecordSet
     If gRow.eof Or gRow.bof Then
		SysBuff2	= Null
		SysCnt2	    = 0
	Else
		SysBuff2	= gRow.getrows
		SysCnt2	    = UBound(SysBuff2,2)
	End If
    Set gRow = Nothing

    Select Case ProcType
        Case "W"
            PTeamGb         = ""           ' 임의 숫자
            TeamNm          = ""
            TeamEnNm        = ""
            Sex             = ""
            sido            = ""
            ZipCode         = ""
            Address         = ""
            AddrDtl         = ""
            EnterType       = ""
            PTeamGbName     = ""
            SidoNm          = ""
            
            TeamTel1        = ""
            TeamTel2        = ""
            TeamTel3        = ""
            TeamFax1        = ""
            TeamFax2        = ""
            TeamFax3        = ""

            Buff            = Null
            Cnt             = 0
        Case "M"
            If IsNumeric(PTeamIDX) = False Then
                DBClose()
                Response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"
                Response.End
            End If
            
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "SP_ADM_TBLTEAMINFO_VIEW"

                .Parameters.Append .CreateParameter("@PTeamIDX", adBigInt, adParamInput, 20, PTeamIDX)

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
                PTeamGb         = Trim(gRow(0))
                Team            = Trim(gRow(1))
                TeamNm          = Trim(gRow(2))
                TeamEnNm        = Trim(gRow(3))
                Sex             = Trim(gRow(4))
                sido            = Trim(gRow(5))
                ZipCode         = Trim(gRow(6))
                Address         = Trim(gRow(7))
                AddrDtl         = Trim(gRow(8))
                TeamTel         = Trim(gRow(9))
                TeamFax         = Trim(gRow(10))
                EnterType       = Trim(gRow(11))
                PTeamGbName     = Trim(gRow(12))
                SidoNm          = Trim(gRow(13))

                IF INSTR(TeamTel, "-") > 0 THEN
                    TeamTel1        = SPLIT(TeamTel, "-")(0)
                    TeamTel2        = SPLIT(TeamTel, "-")(1)
                    TeamTel3        = SPLIT(TeamTel, "-")(2)
                ELSEIF TeamTel <> "" THEN
                    TeamTel1        = LEFT(TeamTel, 3)
                    IF LEN(TeamTel) = 11 THEN
                        TeamTel2        = MID(TeamTel, 3, 4)
                        TeamTel3        = RIGHT(TeamTel, 4)
                    ELSE
                        TeamTel2        = MID(TeamTel, 3, 3)
                        TeamTel3        = RIGHT(TeamTel, 4)
                    END IF 
                ELSE
                    TeamTel1        = ""
                    TeamTel2        = ""
                    TeamTel3        = ""
                END IF

                IF INSTR(TeamFax, "-") > 0 THEN
                    TeamFax1        = SPLIT(TeamFax, "-")(0)
                    TeamFax2        = SPLIT(TeamFax, "-")(1)
                    TeamFax3        = SPLIT(TeamFax, "-")(2)
                ELSEIF TeamFax <> "" THEN
                    TeamFax1        = LEFT(TeamFax, 3)
                    IF LEN(TeamFax) = 11 THEN
                        TeamFax2        = MID(TeamFax, 3, 4)
                        TeamFax3        = RIGHT(TeamFax, 4)
                    ELSE
                        TeamFax2        = MID(TeamFax, 3, 3)
                        TeamFax3        = RIGHT(TeamFax, 4)
                    END IF 
                ELSE
                    TeamFax1        = ""
                    TeamFax2        = ""
                    TeamFax3        = ""
                END IF

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
            End If
            Set gRow = Nothing
    End Select
%>
<!--#include file="../include/head.asp"-->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<script type="text/javascript">
<!--
    var locationStr = "teamInfo_list.asp"

    /**
    * 다음 우편번호 서비스
    */
    function execDaumPostCode() {
        var themeObj = {
            bgColor: "", //바탕 배경색
            searchBgColor: "#0B65C8", //검색창 배경색
            contentBgColor: "#fefefe", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
            pageBgColor: "#dedede", //페이지 배경색
            textColor: "#000", //기본 글자색
            queryTextColor: "#FFFFFF", //검색창 글자색
            //postcodeTextColor: "#000", //우편번호 글자색
            //emphTextColor: "", //강조 글자색
            //outlineColor: "" //테두리
        };

        var width = 500;
        var height = 600;

        new daum.Postcode({
            width: width,
            height: height,
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('UserAddr').value = fullRoadAddr;
                // document.getElementById('UserAddrDtl').value = data.jibunAddress;
                document.getElementById('UserAddrDtl').focus();

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            },
            theme: themeObj
        }).open({
            popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
            left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
            top: (window.screen.height / 2) - (height / 2)
        });
    }

    function ListLink(i2) {
        var KeyField1 = $("#KeyField1").val();
        var KeyField2 = $("#KeyField2").val();
        var KeyField3 = $("#KeyField3").val();
        var KeyField4 = $("#KeyField4").val();
        var KeyField5 = $("#KeyField5").val();
        var KeyWord = $("#KeyWord").val();

        post_to_url('<%=ListPage%>', {'NowPage': i2, 'KeyField1': KeyField1, 'KeyField2': KeyField2, 'KeyField3': KeyField3, 'KeyField4': KeyField4, 'KeyField5': KeyField5, 'KeyWord': KeyWord});
    }

    function chk_Submit(oR, ixOpt, ixType, ixAct, ixTag) {
        var sText = (ixType == 'W' ? '등록' : (ixType == 'M' ? '수정' : '삭제'));
        $("#pType").val(ixType);
        if (ixType == "W") {
            if (jXrTrim(oR.EnterType.value) == "E") {
                if (jXrTrim(oR.PTeamGb.value) == "") {
                    alert("단체 구분을 선택해주세요.");
                    oR.PTeamGb.focus();
                    return;
                }
            }
            if (jXrTrim(oR.Sex.value) == "") {
                alert("단체 성별을 선택해주세요.");
                oR.Sex.focus();
                return;
            }
            if (jXrTrim(oR.TeamNm.value) == "") {
                alert("단체명(국문)을 입력해주세요.");
                oR.TeamNm.focus();
                return;
            }
            if (oR.dupName.value != 'Y') {
                alert("단체명 중복체크를 해주세요.");
                return;
            }
        }
        if (jXrTrim(oR.Sido.value) == "") {
            alert("시구분을 선택해주세요.");
            oR.Sido.focus();
            return;
        }
        if (jXrTrim(oR.ZipCode.value) == "" || jXrTrim(oR.UserAddr.value) == "" || jXrTrim(oR.UserAddrDtl.value) == "") {
            alert("주소를 입력해주세요.");
            $('.srch_post_num a').click();
            return;
        }        
        if (confirm(sText+" 하시겠습니까?")) {
            jXrSubmit(oR, ixOpt, ixAct, ixTag);
        }
    }

    function teamDuplicate(oR, ixType) {
        var strAjaxUrl = '../ajax/teamInfo_reg_duplicate.asp';
		var tEnterType = $('#EnterType').val();
        var tName = $('#TeamNm').val().replace(/\s/gi, "");
        var tSex = $('#Sex').val();
		
		if (tEnterType == "") {
            alert("단체 구분을 선택해주세요.");
            oR.EnterType.focus();
            return;
        }
        if (tSex == "") {
            alert("단체 성별을 선택해주세요.");
            oR.Sex.focus();
            return;
        }
        if (tName == "") {
            alert("단체명(국문)을 입력해주세요.");
            oR.TeamNm.focus();
            return;
        }

        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {				
                pType       : ixType,
				tEType		: tEnterType,
                TeamNm      : tName,
                TeamSex     : tSex
            }, 
            success: function(retDATA) {
                oR.dupName.value = retDATA;
                if (retDATA == 'Y') {
                    $('#dupDiv').empty().html('<span style="color:blue;">등록가능한 팀입니다.</span>');
                }else {
                    $('#dupDiv').empty().html('<span style="color:red;">이미 등록된 팀입니다.</span>');
                }
            }, 
            error: function(xhr, status, error){
                if(error!=''){
                alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                return;
                }
            }
        });
    }

    function chgEnterType() {
        var obj = $("#EnterType");
        $("#PTeamGb option").each(function(index) {
            if ($(this).val() != "") {
                if ($(obj).val() == "A") {
                    $(this).hide();
                }else {
                    $(this).show();
                }
            }
        })
    }

    $(document).ready(function() {
        chgEnterType()
    });
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

        <form id="form1" name="form1" action="" method="post">
        <input type="hidden" name="dupName" />
        <input type="hidden" id="NowPage" name="NowPage" value="<%=NowPage%>">
        <input type="hidden" id="KeyField1" name="KeyField1" value="<%=KeyField1%>">
        <input type="hidden" id="KeyField2" name="KeyField2" value="<%=KeyField2%>">
        <input type="hidden" id="KeyField3" name="KeyField3" value="<%=KeyField3%>">
        <input type="hidden" id="KeyField4" name="KeyField4" value="<%=KeyField4%>">
        <input type="hidden" id="KeyField5" name="KeyField5" value="<%=KeyField5%>">
        <input type="hidden" id="KeyWord" name="KeyWord" value="<%=KeyWord%>">
        <input type="hidden" id="pType" name="pType" value="<%=ProcType%>">
        <input type="hidden" id="idx" name="idx" value="<%=crypt.EncryptStringENC(PTeamIDX) %>" />
        <table class="left-head view-table">
            <tr class="short-line">
                <th>선수 구분</th>
                <td>
                    <p id="sel_EnterType" class="con">
                        <%IF ProcType = "W" THEN %>
                        <select name="EnterType" id="EnterType" class="title_select" onChange="chgEnterType()">
                            <option value="">:: 구분 선택 ::</option>
                            <option value="A" <%IF EnterType = "A" Then response.write "selected" End IF%>>체육동호인</option>  
                            <option value="E" <%IF EnterType = "E" Then response.write "selected" End IF%>>엘리트</option>
                        </select>
                        <%ELSE %>
                        <%=EnterTypeVal%>
                        <%END IF %>
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>단체 구분</th>
                <td>
                    <p id="sel_PTeamGb" class="con">
                        <%IF ProcType = "W" THEN %>
                        <select name="PTeamGb" id="PTeamGb" class="title_select">
                            <option value="">:: 구분 선택 ::</option>
                            <%
                            If IsNull(SysBuff1) = False Then 
                                For i=0 to SysCnt1
                                    SysPTeamGbCode    = Trim(SysBuff1(0, i))
                                    SysPTeamGbName    = Trim(SysBuff1(1, i))
                            %>
                            <option value="<%=SysPTeamGbCode%>" <%IF PTeamGb = SysPTeamGbCode THEN Response.Write "selected=""selected"""%>><%=SysPTeamGbName%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
                        <%ELSE %>
                        <%=PTeamGbName%>
                        <%END IF %>
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>단체 성별</th>
                <td>
                    <p id="sel_Sex" class="con">
                        <%IF ProcType = "W" THEN %>
                        <select name="Sex" id="Sex" class="title_select">
                            <option value="">:: 구분 선택 ::</option>
                            <option value="Man" <%IF Sex = "Man" THEN Response.Write "selected=""selected"""%>>남성팀</option>
                            <option value="WoMan" <%IF Sex = "WoMan" THEN Response.Write "selected=""selected"""%>>여성팀</option>
							<option value="Mix" <%IF Sex = "Mix" THEN Response.Write "selected=""selected"""%>>혼성팀</option>
                        </select>
                        <%ELSE %>
                        <%=SexVal%>
                        <%END IF %>
                    </p>
                </td>
            </tr>
            <tr class="short-line">
                <th>단체명(국문)</th>
                <td>
                    <%IF ProcType = "W" THEN %>
                    <input type="text" id="TeamNm" name="TeamNm" maxlength="30" class="con" value="<%=TeamNm%>" /> 
                    <span class="btn btn_gray" onclick="teamDuplicate(document.form1, '<%=ProcType%>')">중복검색</span>
                    <div id="dupDiv" style="display: inline;font-family:'NanumGothicB';font-size:14px;padding-left:10px;"></div>
                    <%ELSE %>
                    <%=TeamNm%>
                    <%END IF %>
                </td>
            </tr>
            <tr class="short-line">
                <th>단체명(영문)</th>
                <td>
                    <%IF ProcType = "W" THEN %>
                    <input type="text" id="TeamEnNm" name="TeamEnNm" maxlength="50" class="con" value="<%=TeamEnNm%>" />
                    <%ELSE %>
                    <%=TeamEnNm%>
                    <%END IF %>
                </td>
            </tr>            
            <tr class="short-line">
                <th>시구분</th>
                <td>
                    <p id="sel_Sido" class="con">
                        <select name="Sido" id="Sido" class="title_select">
                            <option value="">:: 구분 선택 ::</option>
                            <%
                            If IsNull(SysBuff2) = False Then 
                                For i=0 to SysCnt2
                                    SysSido        = Trim(SysBuff2(0, i))
                                    SysSidoNm      = Trim(SysBuff2(1, i))
                            %>
                            <option value="<%=SysSido%>" <%IF SysSido = Sido THEN Response.Write "selected=""selected"""%>><%=SysSidoNm%></option>
                            <%
                                Next
                            End If
                            %>
                        </select>
                    </p>
                </td>
            </tr>
            <tr class="addr_line tr_view">
                <th>주소</th>
                <td>
                    <div class="srch_post_num">
                        <a href="javascript:;" onclick="execDaumPostCode(); return false;"><input type="text" name="ZipCode" id="ZipCode" maxlength="7" readonly="readonly" value="<%=ZipCode%>" /><span class="btn btn_gray">우편번호검색</span></a>
                    </div>
                    <div class="detail_post">
                        <input type="text" name="UserAddr" id="UserAddr" placeholder="우편번호검색을 눌러 주세요" readonly="readonly" value="<%=Address%>" />
                        <input type="text" name="UserAddrDtl" id="UserAddrDtl" placeholder="상세주소 입력" value="<%=AddrDtl%>" />
                        <span id="guide"></span>
                    </div>
                </td>
            </tr>
            <tr class="phone_line">
                <th>단체 전화번호</th>
                <td>
                    <input type="number" name="TeamTel1" id="TeamTel1" maxlength="3" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamTel1').val().length==3) $('#TeamTel2').focus(); chk_InputValue(this, 'Digit');" value="<%=TeamTel1%>" />
                    <span class="divn">-</span>
                    <input type="number" name="TeamTel2" id="TeamTel2" maxlength="4" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamTel2').val().length==4) $('#TeamTel3').focus(); chk_InputValue(this, 'Digit');" value="<%=TeamTel2%>" />
                    <span class="divn">-</span>
                    <input type="number" name="TeamTel3" id="TeamTel3" maxlength="4" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamTel3').val().length==4) chk_InputValue(this, 'Digit');" value="<%=TeamTel3%>" />
                </td>
            </tr>
            <tr class="phone_line">
                <th>단체 팩스번호</th>
                <td>
                    <input type="number" name="TeamFax1" id="TeamFax1" maxlength="3" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamFax1').val().length==3) $('#TeamFax2').focus(); chk_InputValue(this, 'Digit');" value="<%=TeamFax1%>" />
                    <span class="divn">-</span>
                    <input type="number" name="TeamFax2" id="TeamFax2" maxlength="4" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamFax2').val().length==4) $('#TeamFax3').focus(); chk_InputValue(this, 'Digit');" value="<%=TeamFax2%>" />
                    <span class="divn">-</span>
                    <input type="number" name="TeamFax3" id="TeamFax3" maxlength="4" oninput="maxLengthCheck(this);" onkeyup="if($('#TeamFax3').val().length==4) chk_InputValue(this, 'Digit');" value="<%=TeamFax3%>" />
                </td>
            </tr>
        </table>

        <!-- S: btn-list-center -->
        <div class="btn-list-center">
            <%If ProcType = "W" Then %>
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, '<%=ProcType%>', '<%=ProcPage%>', '');" class="btn btn-confirm">등록</a> 
            <%ELSE %>
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, '<%=ProcType%>', '<%=ProcPage%>', '');" class="btn btn-confirm">수정</a> 
            <a href="javascript:;" onClick="chk_Submit(document.form1, false, 'D', '<%=ProcPage%>', '');" class="btn btn-red">삭제</a> 
            <%END IF %>
            <a href="javascript:;" onClick="ListLink('<%=ListPage%>');" class="btn btn-blue-empty">목록</a>
        </div>
        <!-- E: btn-list-center -->
        </form>
    </div>
</div>
<!-- E : content teamInfo_reg -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>