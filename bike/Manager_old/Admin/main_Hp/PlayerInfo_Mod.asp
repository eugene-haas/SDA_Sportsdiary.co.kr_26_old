<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim CIDX                : CIDX              = crypt.DecryptStringENC(fInject(request("CIDX")))
	dim currPage            : currPage          = fInject(request("currPage"))
	dim SDate               : SDate             = fInject(request("SDate"))
	dim EDate               : EDate             = fInject(request("EDate")) 
	dim fnd_Year            : fnd_Year          = fInject(request("fnd_Year"))
	dim fnd_Sex             : fnd_Sex           = fInject(request("fnd_Sex"))
	dim fnd_KeyWord         : fnd_KeyWord       = fInject(request("fnd_KeyWord"))
	dim fnd_EnterType       : fnd_EnterType     = fInject(request("fnd_EnterType"))
	dim fnd_KoreaTeamType   : fnd_KoreaTeamType = fInject(request("fnd_KoreaTeamType"))
   	dim fnd_PlayerType      : fnd_PlayerType    = fInject(request("fnd_PlayerType"))

	dim CSQL, CRs
	dim strUserPhone, UserPhone1, UserPhone2, UserPhone3
	dim strUserTel, UserTel1, UserTel2, UserTel3
	dim strEmail, Email1, Email2

	dim UserName, UserEnName, UserPhone, UserTel, Email, SEX, SexNm, Birthday, photo
	dim Nationality, ZipCode, Address, AddressDtl, MemberIDX
	dim PersonCode, AthleteCode, BWFCode, Team, TeamNm, RegYear, WriteDate, EditDate, PlayerType
	dim EnterType, EnterTypeNm, KoreaTeamNm, SubstituteYN
   
	IF CIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>" 
		response.End()
	Else
		CSQL = "    SELECT A.UserName "
		CSQL = CSQL & "   ,A.UserEnName "
        CSQL = CSQL & "   ,A.UserCnName "
		CSQL = CSQL & "   ,A.EnterType "
		CSQL = CSQL & "   ,CASE A.EnterType WHEN 'E' THEN '엘리트' ELSE '체육동호인' END EnterTypeNm"
   		CSQL = CSQL & "	  ,A.PlayerType"
		CSQL = CSQL & "   ,D.PubName KoreaTeamNm"
   		CSQL = CSQL & "	  ,F.PubName PlayerTypeNm"
		CSQL = CSQL & "   ,C.SubstituteYN"   
		CSQL = CSQL & "   ,CASE WHEN A.UserPhone <> '' THEN replace(A.UserPhone, '-', '') END UserPhone "
		CSQL = CSQL & "   ,CONVERT(CHAR(10), CONVERT(DATE, A.Birthday), 102) Birthday"
		CSQL = CSQL & "   ,A.Email "
		CSQL = CSQL & "   ,A.Sex "
		CSQL = CSQL & "   ,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
		CSQL = CSQL & "   ,A.WriteDate "
		CSQL = CSQL & "   ,A.EditDate "
		CSQL = CSQL & "   ,A.PersonCode "
		CSQL = CSQL & "   ,A.AthleteCode "
		CSQL = CSQL & "   ,A.Team"
		CSQL = CSQL & "   ,B.TeamNm"
		CSQL = CSQL & "   ,A.photo"
		CSQL = CSQL & "   ,A.RegYear" 
		CSQL = CSQL & "   ,A.MemberIDX" 
		CSQL = CSQL & "   ,A.BWFCode"  
		CSQL = CSQL & "   ,A.Nationality" 
		CSQL = CSQL & "   ,A.ZipCode" 
		CSQL = CSQL & "   ,A.Address" 
		CSQL = CSQL & "   ,A.AddressDtl"

        CSQL = CSQL & "   ,ISNULL(T.Paddress, '') AS Paddress"
        CSQL = CSQL & "   ,ISNULL(T.OfficeTel, '') AS OfficeTel"
        CSQL = CSQL & "   ,ISNULL(T.BloodType, '') AS BloodType"
        CSQL = CSQL & "   ,ISNULL(T.Mheight, '') AS Mheight"
        CSQL = CSQL & "   ,ISNULL(T.Mweight, '') AS Mweight"
        CSQL = CSQL & "   ,ISNULL(T.Leyesight, '') AS Leyesight"
        CSQL = CSQL & "   ,ISNULL(T.Reyesight, '') AS Reyesight"
        CSQL = CSQL & "   ,ISNULL(T.Specialty, '') AS Specialty"
        CSQL = CSQL & "   ,ISNULL(T.Mnote, '') AS Mnote"

		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblMemberHistory] A"
		CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] B on A.Team = B.Team AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
		CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblMemberKorea] C on A.MemberIDX = C.MemberIDX AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
		CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] D on C.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"
   		CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] F on A.PlayerType = F.PubCode AND F.DelYN = 'N' AND F.PPubCode = 'B008'"
        CSQL = CSQL & "   LEFT OUTER JOIN [KoreaBadminton].[dbo].[tblMemberDtl] T on A.MemberIDX = T.MemberIDX"
		CSQL = CSQL & " WHERE A.DelYN = 'N'"
		CSQL = CSQL & "   AND A.MemberHistoryIDX = '"&CIDX&"'"

		SET CRs = DBCon.Execute(CSQL)
		IF NOT(CRs.Bof OR CRs.Eof) THEN
			MemberIDX = CRs("MemberIDX")
   			PlayerType = CRs("PlayerType")
			KoreaTeamNm = CRs("KoreaTeamNm")
			SubstituteYN = CRs("SubstituteYN")
			PersonCode = CRs("PersonCode")  
			AthleteCode = CRs("AthleteCode")
			BWFCode = CRs("BWFCode")
			UserName = CRs("UserName")
			EnterType = CRs("EnterType")
			EnterTypeNm = CRs("EnterTypeNm")
			UserEnName = ReHtmlSpecialChars(CRs("UserEnName"))
			UserPhone = CRs("UserPhone")      
			Email = CRs("Email")
			SEX = CRs("SEX")
			SexNm = CRs("SexNm")
			Birthday = CRs("Birthday")
			Team = CRs("Team")
			TeamNm = CRs("TeamNm")
			Nationality = CRs("Nationality")
			ZipCode = CRs("ZipCode")
			Address   = ReHtmlSpecialChars(CRs("Address"))
			AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl"))
			photo = CRs("photo")
			RegYear = CRs("RegYear")
			WriteDate = CRs("WriteDate")
			EditDate = CRs("EditDate")

            UserCnName  = ReHtmlSpecialChars(CRs("UserCnName"))
            Paddress    = TRIM(CRs("Paddress"))
            OfficeTel   = TRIM(CRs("OfficeTel"))
            BloodType   = TRIM(CRs("BloodType"))
            Mheight     = TRIM(CRs("Mheight"))
            Mweight     = TRIM(CRs("Mweight"))
            Leyesight   = TRIM(CRs("Leyesight"))
            Reyesight   = TRIM(CRs("Reyesight"))
            Specialty   = TRIM(CRs("Specialty"))
            Mnote       = TRIM(CRs("Mnote"))
   
			IF UserPhone <> "" Then
				'strUserPhone = split(UserPhone, "-")
				
				SELECT CASE len(UserPhone) 
					CASE 10 : 
						UserPhone1 = left(UserPhone, 3)
						UserPhone2 = mid(UserPhone, 4, 3)
						UserPhone3 = right(UserPhone, 4)
					CASE 11 : 
						UserPhone1 = left(UserPhone, 3)
						UserPhone2 = mid(UserPhone, 4, 4)
						UserPhone3 = right(UserPhone, 4)
				END SELECT
				
				'UserPhone1 = strUserPhone(0)
				'UserPhone2 = strUserPhone(1)
				'UserPhone3 = strUserPhone(2)
			End IF

			IF Email <> "" Then
				strEmail = split(Email, "@")
				Email1 = strEmail(0)
				Email2 = strEmail(1)
			End IF

            IF OfficeTel = "" OR OfficeTel = "--" THEN
                OfficeTel1 = ""
                OfficeTel2 = ""
                OfficeTel3 = ""
            ELSE
                OfficeTel1 = split(OfficeTel, "-")(0)
                OfficeTel2 = split(OfficeTel, "-")(1)
                OfficeTel3 = split(OfficeTel, "-")(2)
            END IF 
		End IF      
		CRs.Close
		SET CRs = Nothing
	End IF
%>
<script language="javascript">
    /**
    * left-menu 체크
    */
    var locationStr = "Main_HP/PlayerInfo_List.asp";  // 선수
    /* left-menu 체크 */


    //이메일 도메인 선택입력
    function chk_Email(){
        if(!$('#EmailList').val()){     
            $('#UserEmail2').val('');
        }
        else{
            $('#UserEmail2').val($('#EmailList').val());
        }
    }
  
    function chk_onSubmit(valType){
        if(valType=='LIST'){
            $('form[name=s_frm]').attr('action','./PlayerInfo_List.asp');
            $('form[name=s_frm]').submit(); 
        }else {      
            if(confirm('정보를 수정하시겠습니까?')){
                if(!$('#UserPhone2').val()){
                    alert('휴대폰 번호를 입력해 주세요.');
                    $('#UserPhone2').focus();
                    return;
                }
                if(!$('#UserPhone3').val()){
                    alert('휴대폰 번호를 입력해 주세요.');
                    $('#UserPhone3').focus();
                    return;
                }
                //이메일체크
                if(!$('#UserEmail1').val()){
                    alert('이메일을 입력해 주세요');
                    $('#UserEmail1').focus();
                    return;
                }
                if(!$('#UserEmail2').val()){
                    alert('이메일을 입력해 주세요');
                    $('#UserEmail2').focus();
                    return;
                }

                var email = $('#UserEmail1').val().replace(/ /g, '') +'@' + $('#UserEmail2').val().replace(/ /g, '');  
                var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;   

                if(!regex.test(email)){  
                    alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');  
                    return;  
                } 
        
                var Del_PhotoYN = '';
      
                if($('#Del_Photo').is(':checked') == true) Del_PhotoYN = 'Y';   //이미지 삭제 체크박스       
                else Del_PhotoYN = 'N';

                var strAjaxUrl = '../Ajax/PlayerInfo_Mod.asp';
                var formData = new FormData();
                               
                formData.append('CIDX', $('#CIDX').val());
                formData.append('Nationality', $('#Nationality').val());    
                formData.append('PlayerType', $('#PlayerType').val());     		  
                formData.append('UserEnName', $('#UserEnName').val());
                formData.append('UserPhone', $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, ''));       
                formData.append('UserEmail', $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, ''));
                formData.append('ZipCode', $('#ZipCode').val());
                formData.append('Address', $('#Address').val());
                formData.append('AddressDtl', $('#AddressDtl').val());  
                formData.append('BWFCode', $('#BWFCode').val());  
                formData.append('EnterType', '<%=EnterType%>');

                formData.append('UserCnName', $('#UserCnName').val());
                formData.append('Paddress', $('#Paddress').val());
                formData.append('OfficeTel', $('#OfficeTel1').val() + '-' + $('#OfficeTel2').val().replace(/ /g, '') + '-' + $('#OfficeTel3').val().replace(/ /g, ''));
                formData.append('BloodType', $('#BloodType').val());
                formData.append('Mheight', $('#Mheight').val());
                formData.append('Mweight', $('#Mweight').val());
                formData.append('Leyesight', $('#Leyesight').val());
                formData.append('Reyesight', $('#Reyesight').val());
                formData.append('Specialty', $('#Specialty').val());
                formData.append('Mnote', $('#Mnote').val());
                
                formData.append('Del_PhotoYN', Del_PhotoYN);
                
                if($('#photo').val()) formData.append('photo', $('input[name=photo]')[0].files[0]);
        
                $.ajax({
                    url: strAjaxUrl,
                    type: 'POST',
                    dataType: 'html',     
                    data: formData,    
                    processData: false,
                    contentType: false,   
                    success: function(retDATA) {
                        //console.log(retDATA);
                        if(retDATA){
                            var strcut = retDATA.split('|');

                            if (strcut[0] == 'TRUE') {
                                alert('정보를 수정완료 하였습니다.');
                                $('form[name=s_frm]').attr('action','./PlayerInfo_List.asp');
                                $('form[name=s_frm]').submit(); 
                            }else {  //FALSE|
                                var msg='';

                                switch(strcut[1]){
                                case '99'   : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
                                case '66'   : msg='정보를 업데이트하지 못하였습니다.\n시스템관리자에게 문의하십시오!'; break;
                                case '33'   : msg='업로드 파일형식이 아닙니다.\n확인 후 다시 이용하세요.'; break; 
                                default   : msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                                }
                                alert(msg);
                                return;
                            }
                        }
                    }, 
                    error: function(xhr, status, error){           
                        if(error){
                        alert ('오류발생! - 시스템관리자에게 문의하십시오!');     
                        return;
                        }
                    }
                });
            }
            else{
                return;
            }
        }
    }
  
    /*
    //소속팀 조회
    function CHK_TEAMINFO(){
        var strAjaxUrl = '../Ajax/Fnd_TeamInfo.asp';
        var fnd_RegYear = $('#RegYear').val();
        var fnd_TeamNm = $('#fnd_TeamNm').val();
        
        if(!fnd_TeamNm) {
            alert('조회할 팀명을 입력해주세요.');
         return;
        }
        else{
            $('#fnd_team').modal('show');
            
            $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',     
                data: { 
                    fnd_TeamNm  : fnd_TeamNm
                    ,fnd_RegYear : fnd_RegYear
                },    
                success: function(retDATA) {
                    $('#team_contents').html(retDATA);       
                }, 
                error: function(xhr, status, error){           
                    if(error){
                        alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                        return;
                    }
                }
            }); 
        }
    }

    function Input_TeamInfo(valTeam, valTeamNm){
        $('#Team').val(valTeam);
        $('#fnd_TeamNm').val(valTeamNm);  
        
        $('#fnd_team').modal('hide');
    }
    */
  
    $(document).ready(function() {
        make_box('sel_Nationality', 'Nationality', '<%=Nationality%>', 'Info_Country'); //국가정보               
        make_box('sel_PlayerType', 'PlayerType', '<%=PlayerType%>', 'Info_PlayerNational'); //내외국인 구분정보                 
    }); 
</script> 
<!--S: 다음 주소찾기 API-->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
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

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('Address').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('AddressDtl').focus();
            },
			theme: themeObj	
        }).open({
			popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
			left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
			top: (window.screen.height / 2) - (height / 2)
		});
    }
</script>	
<!--E: 다음 주소찾기 API-->
<!-- S : content -->
<section>
    <div id="content">
        <!-- S: page_title -->
        <div class="page_title clearfix">
            <h2>선수관리</h2>
            <a href="javascript:chk_onSubmit('LIST');" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

            <!-- S: 네비게이션 -->
            <div  class="navigation_box">
                <span class="ic_deco">
                    <i class="fas fa-angle-right fa-border"></i>
                </span>
                <ul>
                    <li>회원관리</li>
                    <li>회원관리</li>
                    <li>선수관리</li>
                    <li>선수정보 상세보기</li>
                </ul>
            </div>
            <!-- E: 네비게이션 -->
        </div>
        <!-- E: page_title -->
    
        <form name="s_frm" method="post">
        <input type="hidden" id="CIDX" name="CIDX" value="<%=fInject(request("CIDX"))%>" />
        <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
        <input type="hidden" id="SDate" name="SDate" value="<%=SDate%>" />
        <input type="hidden" id="EDate" name="EDate" value="<%=EDate%>" />
        <input type="hidden" id="fnd_Year" name="fnd_Year" value="<%=fnd_Year%>" />
        <input type="hidden" id="fnd_Sex" name="fnd_Sex" value="<%=fnd_Sex%>" />
        <input type="hidden" id="fnd_KeyWord" name="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
        <input type="hidden" id="fnd_EnterType" name="fnd_EnterType" value="<%=fnd_EnterType%>" />
        <input type="hidden" id="fnd_KoreaTeamType" name="fnd_KoreaTeamType" value="<%=fnd_KoreaTeamType%>" />
        <input type="hidden" id="fnd_PlayerType" name="fnd_PlayerType" value="<%=fnd_PlayerType%>" />
        <!--
        <input type="hidden" id="UserName" name="UserName" value="<%=UserName%>" />
        <input type="hidden" id="Sex" name="Sex" value="<%=Sex%>" />
        <input type="hidden" id="Birthday" name="Birthday" value="<%=Birthday%>" />
        --> 
        <table class="user_detail left-head view-table">
            <tr>
                <th rowspan="27" valign="top">
                <%
                IF Photo <> "" Then
                    response.write "<img src='"&global_filepathUrl&"Player/"&EnterType&"/"&Photo&"' width='80' alt=''>"
                Else
                    response.write "<img src='../images/profile@3x.png' width='80' alt=''>"
                End IF
                %>
                </th>
                <th>국적</th>
                <td id="sel_Nationality">
                    <select name="Nationality" id="Nationality" class="title_select">
                        <option value="">국적선택</option>
                    </select>
                </td>
            </tr> 
	        <tr>	  
	            <th>내외국인 구분</th>
                <td id="sel_PlayerType">
                    <select name="PlayerType" id="PlayerType" class="title_select">
                        <option value="">내외국인 선택</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>등록년도</th>
                <td><%=RegYear%>
                    <!--
                    <select name="RegYear" id="RegYear">
                        <option value="2018" <%IF RegYear = "2018" Then response.write "selected" End IF%>>2018</option>
                        <option value="2019" <%IF RegYear = "2019" Then response.write "selected" End IF%>>2019</option>
                        <option value="2020" <%IF RegYear = "2020" Then response.write "selected" End IF%>>2020</option>
                    </select>
                    -->
                </td>
            </tr>
            <tr>
                <th>선수구분</th>
                <td><%=EnterTypeNm%></td>
            </tr>
            <%IF EnterType = "E" Then%>
            <tr>
                <th>대표팀구분</th>
                <td><%=KoreaTeamNm%> <%IF SubstituteYN = "Y" Then response.write "후보팀" End IF%> </td>
            </tr>
            <tr>
                <th>BWF Code</th>
                <td><input type="text" name="BWFCode" id="BWFCode" class="in_2" value="<%=BWFCode%>"></td>
            </tr> 
            <%End IF%>
            <!--
            <tr>
                <th>소속팀</th>
                <td>
                    <%=Team%>:<input type="text" name="fnd_TeamNm" id="fnd_TeamNm" value="<%=TeamNm%>" readonly />
                    <a href="javascript:CHK_TEAMINFO();">소속팀 조회</a>
                </td>
            </tr>
            --> 
            <tr>
                <th>소속팀</th>
                <td><%=TeamNm%> [ <%=Team%> ] </td>
            </tr> 
            <tr>
                <th>체육인번호</th>
                <td><%=AthleteCode%></td>
            </tr> 
            <tr>
                <th>이름</th>
                <td><%=UserName%></td>
            </tr>
            <tr>
                <th>영문이름</th>
                <td><input type="text" name="UserEnName" id="UserEnName" value="<%=UserEnName%>"></td>
            </tr>
            <tr>
                <th>한문이름</th>
                <td><input type="text" name="UserCnName" id="UserCnName" value="<%=UserCnName%>"></td>
            </tr>
            <tr>
                <th>성별</th>
                <td><%=SexNm%></td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td><%=Birthday%></td>
            </tr>        
            <tr class="phone-line">
                <th>휴대폰</th>
                <td>
                    <select name="UserPhone1" id="UserPhone1" class="in_2">
                        <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
                        <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
                        <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
                        <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
                        <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
                        <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
                        <option value="070" <%IF UserPhone1 = "070" Then response.Write "selected" End IF%>>070</option>
                    </select>
                    <span>-</span>
                    <input type="text" class="in_2" name="UserPhone2" id="UserPhone2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=UserPhone2%>" />
                    <span>-</span>
                    <input type="text" class="in_2" name="UserPhone3" id="UserPhone3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=UserPhone3%>" />
                </td>
            </tr>    
            <tr class="mail-line">
                <th>이메일</th>
                <td>
                    <input type="text" class="in_2" name="UserEmail1" id="UserEmail1" placeholder="sample123456" value="<%=Email1%>" />
                    <span>@</span>
                    <input type="text" class="in_2" name="UserEmail2" id="UserEmail2" placeholder="gmail.com" value="<%=Email2%>" />
                    <select name="EmailList" id="EmailList" class="in_2" onChange="chk_Email();">
                        <option value="">직접입력</option>
                        <option value="gmail.com" <%IF Email2 = "gmail.com" Then response.Write "selected" End IF%>>gmail.com</option>
                        <option value="hanmail.net" <%IF Email2 = "hanmail.net" Then response.Write "selected" End IF%>>hanmail.net</option>
                        <option value="hotmail.com" <%IF Email2 = "hotmail.com" Then response.Write "selected" End IF%>>hotmail.com</option>
                        <option value="naver.com" <%IF Email2 = "naver.com" Then response.Write "selected" End IF%>>naver.com</option>
                        <option value="nate.com" <%IF Email2 = "nate.com" Then response.Write "selected" End IF%>>nate.com</option>
                    </select>
                </td>
            </tr>    
            <tr class="addr-line">
                <th>주소</th>
                <td>
                    <!-- S: stair -->
                    <div class="stair">
                    <input type="text" readonly name="ZipCode" id="ZipCode" value="<%=ZipCode%>">
                        <a href="javascript:execDaumPostCode();" class="btn-gray">우편번호 검색</a>
                    </div>
                    <!-- E: stair -->
                    
                    <!-- S: stair -->
                    <div class="stair under-line">
                    <input type="text" readonly name="Address" id="Address" value="<%=Address%>">
                        <input type="text" name="AddressDtl" id="AddressDtl" value="<%=AddressDtl%>" placeholder="나머지 주소 입력">
                    </div>
                    <!-- E: stair -->
                </td>
            </tr>
            <tr>
                <th>본적</th>
                <td>
                    <input type="text" name="Paddress" id="Paddress" value="<%=Paddress%>">
                </td>
            </tr>
            <tr class="phone-line">
                <th>전화번호(사무실)</th>
                <td>
                    <input type="text" class="in_2" name="OfficeTel1" id="OfficeTel1" maxlength="3" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=OfficeTel1%>" />
                    <span>-</span>
                    <input type="text" class="in_2" name="OfficeTel2" id="OfficeTel2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=OfficeTel2%>" />
                    <span>-</span>
                    <input type="text" class="in_2" name="OfficeTel3" id="OfficeTel3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=OfficeTel3%>" />
                </td>
            </tr>
            <tr>
                <th>혈액형</th>
                <td>
                    <select name="BloodType" id="BloodType"  class="title_select">
                        <option value="" <%IF BloodType = "" Then response.Write "selected" End IF%>>혈액형 선택</option>
                        <option value="A" <%IF BloodType = "A" Then response.Write "selected" End IF%>>A형</option>
                        <option value="B" <%IF BloodType = "B" Then response.Write "selected" End IF%>>B형</option>
                        <option value="O" <%IF BloodType = "O" Then response.Write "selected" End IF%>>O형</option>
                        <option value="AB" <%IF BloodType = "AB" Then response.Write "selected" End IF%>>AB형</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>키</th>
                <td>
                    <input type="text" name="Mheight" id="Mheight" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=Mheight%>">
                </td>
            </tr>
            <tr>
                <th>몸무게</th>
                <td>
                    <input type="text" name="Mweight" id="Mweight" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=Mweight%>">
                </td>
            </tr>
            <tr class="phone-line">
                <th>시력</th>
                <td>
                    [좌] <input type="text" name="Leyesight" id="Leyesight" maxlength="3" value="<%=Leyesight%>" class="in_2">&nbsp;&nbsp;
                    [우] <input type="text" name="Reyesight" id="Reyesight" maxlength="3" value="<%=Reyesight%>" class="in_2">
                </td>
            </tr>
            <tr>
                <th>특기,장기</th>
                <td>
                    <input type="text" name="Specialty" id="Specialty" maxlength="50" value="<%=Specialty%>">
                </td>
            </tr>
            <tr>
                <th>특이사항</th>
                <td>
                    <input type="text" name="Mnote" id="Mnote" maxlength="50" value="<%=Mnote%>">
                </td>
            </tr>
            <tr>
                <th>프로필이미지</th>
                <td>
                    <input type="file" name="photo" id="photo" class="in_2">
                <%
                IF photo <> "" Then 
                    response.Write "<div class='added-list'>"
                    response.Write photo
                    response.Write "  <span><input type='checkbox' name='Del_Photo' id='Del_Photo'>삭제시 체크</span>" 
                    response.Write "</div>"
                End IF
                %>  
                </td>        
            </tr>
            <tr>
                <th>등록일</th>
                <td><%=WriteDate%></td>
            </tr>
            <tr>
                <th>최근수정일</th>
                <td><%=EditDate%></td>
            </tr>   
        </table>
        <div class="c_btn btn-list-center">
            <a href="javascript:chk_onSubmit('MOD');" class="btn btn-confirm">수정하기</a>
            <a href="javascript:chk_onSubmit('LIST');" class="btn btn-blue-empty">목록</a>        
        </div>
        <!-- s: Modal 팀조회 목록 View Modal-->
		<!--
        <div class="modal fade" id="fnd_team" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">팀 목록보기</h4>
                    </div>
                    <div class="modal-body">              
                        <div id="team_contents" class="table-list-wrap">                
                        </div>              
                    </div>
                    <div class="btn_list">
                        <a href="#" class=""  data-dismiss="modal">닫기</a>
                    </div>
                </div>
            </div>
        </div>
		-->
        <!-- e: Modal 팀조회 목록 View Modal-->
        </form>
    </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->