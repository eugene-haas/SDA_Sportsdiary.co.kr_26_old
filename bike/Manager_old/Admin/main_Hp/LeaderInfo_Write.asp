<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<script language="javascript">
    /**
    * left-menu 체크
    */
    var locationStr = "LeaderInfo_List.asp";  // 지도자
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
    
    function onSubmit(valType){     
        if(!$('#UserName').val()){
            alert('이름을 입력해 주세요.');
            $('#UserName').focus();
            return;
        }
        
        if(!$('#UserEnName').val()){
            alert('영문이름을 입력해 주세요.');
            $('#UserEnName').focus();
            return;
        }
        
        //생년월일
        if(!$('#Birthday').val()){
            alert("생년월일을 입력해 주세요.");
            $('#Birthday').focus();
            return;
        }
        else{
            if($('#Birthday').val().length<8){
                alert("생년월일을 정확히 입력해 주세요");
                $('#Birthday').focus();
                return;
            }
            else{
                var data = $('#Birthday').val();
                
                var y = parseInt(data.substr(0, 4), 10); 
                var m = parseInt(data.substr(4, 2), 10); 
                var d = parseInt(data.substr(6, 2), 10); 
                
                var dt = new Date(y, m-1, d); 
                
                if(dt.getDate() != d) { alert("생년월일 일이 유효하지 않습니다"); $('#Birthday').focus(); return;} 
                else if(dt.getMonth()+1 != m) { alert("생년월일 월이 유효하지 않습니다."); $('#Birthday').focus(); return;} 
                else if(dt.getFullYear() != y) { alert("생년월일 년도가 유효하지 않습니다."); $('#Birthday').focus(); return;} 
                else {$('#UserPhone1').focus();}    
            }
        }
        
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
        
        if(!$('#Team').val()){
            alert('소속팀을 선택해주세요.');
            $('#TeamNm').focus();
            return;
        }

        var email = $('#UserEmail1').val().replace(/ /g, '') +'@' + $('#UserEmail2').val().replace(/ /g, '');  
        var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;   

        if(!regex.test(email)){
            alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');  
            return;
        } 

        var strAjaxUrl = '../Ajax/LeaderInfo_Write.asp';
        var formData = new FormData();

        formData.append('RegYear', $('#RegYear').val());
        formData.append('LeaderType', $('#LeaderType').val());
        formData.append('LeaderTypeSub', $('#LeaderTypeSub').val());	
        formData.append('UserName', $('#UserName').val());
        formData.append('Sex', $('#Sex').val());
        formData.append('Birthday', $('#Birthday').val());
        formData.append('UserEnName', $('#UserEnName').val());
        formData.append('UserPhone', $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, ''));
        formData.append('UserEmail', $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, ''));
        formData.append('ZipCode', $('#ZipCode').val());
        formData.append('Address', $('#Address').val());
        formData.append('AddressDtl', $('#AddressDtl').val());
        formData.append('Team', $('#Team').val());

        formData.append('BWFCode', $('#BWFCode').val());
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

        formData.append('photo', $('input[name=photo]')[0].files[0]);

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
                        alert('정보를 등록완료 하였습니다.');
                        $('form[name=s_frm]').attr('action','./LeaderInfo_List.asp');
                        $('form[name=s_frm]').submit(); 
                    }
                    else{  //FALSE|
                        var msg='';

                        switch(strcut[1]){
                        case '99'   : msg='이미 등록된 정보가 있습니다.\n확인 후 다시 이용하세요.'; break;
                        case '66'   : msg='정보를 등록하지 못하였습니다.\n시스템관리자에게 문의하십시오.'; break;
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
    
    //소속팀 조회
    function CHK_TEAMINFO(){
        var strAjaxUrl = '../Ajax/Fnd_TeamInfo.asp';
        var fnd_RegYear = $('#RegYear').val();
        var fnd_TeamNm = $('#fnd_TeamNm').val();
        
        if(!fnd_TeamNm) {
            alert('조회할 팀명을 입력해주세요.');
            $('#fnd_TeamNm').focus();
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
        
    //지도자 구분 change
    $(document).on('change', '#LeaderType', function(){
    
        //console.log($('#LeaderType').val());
    
        if($('#LeaderType').val()=="3") {
            $('#LeaderTypeSub').removeAttr('disabled');     
            make_box('sel_LeaderTypeSub', 'LeaderTypeSub', '', 'Info_Coach'); 
        }
        else {
            $('#LeaderTypeSub').attr('disabled', 'disabled');     
            $('#LeaderTypeSub').find('option:first').attr('selected', 'selected');
        }
    });
    
        
    function Input_TeamInfo(valTeam, valTeamNm){
        $('#Team').val(valTeam);
        $('#fnd_TeamNm').val(valTeamNm);  
        
        $('#fnd_team').modal('hide');
    }
    
    $(document).ready(function() {
        if($('#LeaderType').val()=='3')	{
            make_box('sel_LeaderTypeSub', 'LeaderTypeSub', '', 'Info_Coach'); //코치구분 셀렉박스 목록 생성 
        }
        else{
            $('#LeaderTypeSub').attr('disabled', 'disabled'); 	
        } 	
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
            <h2>지도자등록</h2>
            <a href="./LeaderInfo_list.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

            <!-- S: 네비게이션 -->
            <div  class="navigation_box">
                <span class="ic_deco">
                    <i class="fas fa-angle-right fa-border"></i>
                </span>
                <ul>
                    <li>회원관리</li>
                    <li>회원관리</li>
                    <li>지도자관리</li>
                    <li>지도자등록</li>
                </ul>
            </div>
            <!-- E: 네비게이션 -->
        </div>
        <!-- E: page_title -->

        <form name="s_frm" method="post">
        <input type="hidden" id="Team" name="Team">
        <table class="left-head view-table profile-table thin-border">  
            <tr>
                <th>등록년도</th>
                <td>
                    <select name="RegYear" id="RegYear" class="title_select">
                        <option value="2018" <%IF Year(Date()) = "2018" Then response.write "selected" End IF%>>2018</option>
                        <option value="2019" <%IF Year(Date()) = "2019" Then response.write "selected" End IF%>>2019</option>
                        <option value="2020" <%IF Year(Date()) = "2020" Then response.write "selected" End IF%>>2020</option>         
                    </select>
                </td>
            </tr>
            <tr>
                <th>구분</th>
                <td>
                    <select name="LeaderType" id="LeaderType">
                        <option value="2">감독</option>
                        <option value="3">코치</option>
                    </select>
                </td>
            </tr>    
            <tr id="div_LeaderTypeSub">
                <th>코치구분</th>
                <td>
                    <span id="sel_LeaderTypeSub">
                    <select name="LeaderTypeSub" id="LeaderTypeSub">
                        <option value="">코치구분</option>
                    </select>
                    </span>
                </td>
            </tr>
            <tr>
                <th>이름</th>
                <td>
                    <input type="text" name="UserName" id="UserName" class="ipt-word">
                </td>
            </tr>
            <tr>
                <th>영문이름</th>
                <td><input type="text" name="UserEnName" id="UserEnName" onKeyUp="chk_InputValue(this, 'EngSpace');" class="ipt-word"></td>
            </tr>
            <tr>
                <th>한문이름</th>
                <td><input type="text" name="UserCnName" id="UserCnName" maxlength="50" class="ipt-word"></td>
            </tr>
            <tr>
                <th>성별</th>
                <td>
                    <label>
                        <input type="radio" name="Sex" id="Sex" value="Man" checked>
                        <span class="txt">남자</span>
                    </label>
                    <label>
                        <input type="radio" name="Sex" id="Sex" value="WoMan">
                        <span class="txt">여자</span>
                    </label>
                </td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td>
                    <input type="text" name="Birthday" id="Birthday" maxlength="8" onKeyUp="chk_InputValue(this, 'Digit');" oninput="maxLengthCheck(this);" class="ipt-word">
                    <span class="txt">8자리 (예) 19830124</span>
                </td>
            </tr>        
            <tr>
                <th>소속팀</th>
                <td>
                    <input type="text" name="fnd_TeamNm" id="fnd_TeamNm" class="ipt-word">
                    <a href="javascript:CHK_TEAMINFO();" class="btn btn-confirm">소속팀 조회</a>
                </td>
            </tr>   
            <tr class="phone-line">
                <th>휴대폰</th>
                <td>
                    <select name="UserPhone1" id="UserPhone1" class="in_2">
                        <option value="010">010</option>
                        <option value="011">011</option>
                        <option value="016">016</option>
                        <option value="017">017</option>
                        <option value="018">018</option>
                        <option value="019">019</option>
                        <option value="070">070</option>
                    </select>
                    <span>-</span>
                    <input type="text" class="in_2" name="UserPhone2" id="UserPhone2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#UserPhone2').val().length==4) $('#UserPhone3').focus();">
                    <span>-</span>
                    <input type="text" class="in_2" name="UserPhone3" id="UserPhone3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#UserPhone3').val().length==4) $('#UserEmail1').focus();">
                </td>
            </tr>   
            <tr class="mail-line">
                <th>이메일</th>
                <td>
                    <input type="text" class="in_2" name="UserEmail1" id="UserEmail1" placeholder="sample123456">
                    <span>@</span>
                    <input type="text" class="in_2" name="UserEmail2" id="UserEmail2" placeholder="gmail.com">
                    <select name="EmailList" id="EmailList" class="in_2" onChange="chk_Email();">
                        <option value="">직접입력</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="hanmail.net">hanmail.net</option>
                        <option value="hotmail.com">hotmail.com</option>
                        <option value="naver.com">naver.com</option>
                        <option value="nate.com">nate.com</option>
                    </select>
                </td>
            </tr> 
            <tr>
                <th>BWF Code</th>
                <td><input type="text" name="BWFCode" id="BWFCode" class="ipt-word"></td>
            </tr> 
            <tr class="addr-line">
                <th>주소</th>
                <td class="addr-line">
                    <!-- S: stair -->
                    <div class="stair">
                        <input type="text" readonly name="ZipCode" id="ZipCode" class="in_2" >
                        <a href="javascript:execDaumPostCode();" class="btn-gray">우편번호 검색</a>
                    </div>
                    <!-- E: stair -->
                    <!-- S: stair -->
                    <div class="stair under-line">
                        <input type="text" readonly name="Address" id="Address">
                        <input type="text" name="AddressDtl" id="AddressDtl" placeholder="나머지 주소 입력" >
                    </div>
                    <!-- E: stair -->
                </td>        
            </tr>   
            <tr>
                <th>본적</th>
                <td>
                    <input type="text" name="Paddress" id="Paddress" maxlength="50">
                </td>
            </tr>
            <tr class="phone-line">
                <th>전화번호(사무실)</th>
                <td>
                    <input type="text" class="in_2" name="OfficeTel1" id="OfficeTel1" maxlength="3" onKeyUp="chk_InputValue(this, 'Digit');" />
                    <span>-</span>
                    <input type="text" class="in_2" name="OfficeTel2" id="OfficeTel2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" />
                    <span>-</span>
                    <input type="text" class="in_2" name="OfficeTel3" id="OfficeTel3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" />
                </td>
            </tr>
            <tr>
                <th>혈액형</th>
                <td>
                    <select name="BloodType" id="BloodType"  class="title_select">
                        <option value="">혈액형 선택</option>
                        <option value="A">A형</option>
                        <option value="B">B형</option>
                        <option value="O">O형</option>
                        <option value="AB">AB형</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>키</th>
                <td>
                    <input type="text" name="Mheight" id="Mheight" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" class="ipt-word">
                </td>
            </tr>
            <tr>
                <th>몸무게</th>
                <td>
                    <input type="text" name="Mweight" id="Mweight" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" class="ipt-word">
                </td>
            </tr>
            <tr class="phone-line">
                <th>시력</th>
                <td>
                    [좌] <input type="text" name="Leyesight" id="Leyesight" maxlength="3" class="in_2">&nbsp;&nbsp;
                    [우] <input type="text" name="Reyesight" id="Reyesight" maxlength="3" class="in_2">
                </td>
            </tr>
            <tr>
                <th>특기,장기</th>
                <td>
                    <input type="text" name="Specialty" id="Specialty" maxlength="50">
                </td>
            </tr>
            <tr>
                <th>특이사항</th>
                <td>
                    <input type="text" name="Mnote" id="Mnote" maxlength="50">
                </td>
            </tr>
            <tr>
                <th>프로필이미지</th>
                <td>
                    <input type="file" name="photo" id="photo" class="in_2">            
                </td>        
            </tr>
        </table>
        <div class="c_btn btn-list-center">
            <a href="javascript:history.back();" class="btn btn-cancel">취소하기</a>  
            <a href="javascript:onSubmit();" class="btn btn-confirm">등록하기</a>
        </div>
        </form>
        <!-- s: Modal 팀조회 목록 View Modal-->
        <div class="modal fade" id="fnd_team">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="btn-close" data-dismiss="modal">&times;</button>
                        <h3 class="modal-title" id="myModalLabel">팀 목록보기</h3>
                    </div>
                    <div class="modal-body">              
                        <div id="team_contents" class="table-list-wrap scroll-box">
                        </div>

                        <div class="btn_list">
                            <a href="#" class="btn-close"  data-dismiss="modal">닫기</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- e: Modal 팀조회 목록 View Modal-->
    </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->