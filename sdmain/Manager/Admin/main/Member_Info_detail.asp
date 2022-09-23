<!--#include file="../dev/dist/config.asp"-->
<!-- S: head -->
<!--#include file="../include/head.asp" --> 
  <!-- E: head -->
  <% 
    RoleType = "MEMALLLIST"	    '통합회원 목록   
    
    dim CIDX            : CIDX              = crypt.DecryptStringENC(fInject(request("CIDX")))                                 
    dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord 	    = fInject(Request("fnd_KeyWord"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	                                 
    dim fnd_SMS   		: fnd_SMS 			= fInject(Request("fnd_SMS"))	                                 
    dim fnd_Email   	: fnd_Email 		= fInject(Request("fnd_Email"))	                                                                  
    dim fnd_Push   		: fnd_Push 			= fInject(Request("fnd_Push"))	  
	dim SDate           : SDate             = fInject(request("SDate"))
	dim EDate           : EDate             = fInject(request("EDate"))
    
    dim CSQL, CRs
      
                             
    IF CIDX = "" Then
        response.write "<script>"                             
        response.write "    alert('잘못된 접근입니다. 확인 후 이용하세요.');"                                 
        response.write "    history.back();"                                                          
        response.write "</script>"         
        response.end
                                                          
    Else
                                                          
        dim UserID, UserPhone, Birthday, SexNm, UserName, UserEnName        
        dim Email, EmailYN, EmailYnDt, SMSYN, SmsYnDt, PushStateGb, PushYNDt, RegDate, ModDate   
        dim ZipCode, Address, AddressDtl
        dim UserJudo, UserTennis, UserBike, txt_UserType       
        dim CUserPhone, UserPhone1, UserPhone2, UserPhone3
        dim CEmail, Email1, Email2                                                          

        CSQL = "	        SELECT A.UserID "
        CSQL = CSQL & "	    	,A.UserName, A.UserEnName "
        CSQL = CSQL & "	    	,A.UserPhone "
        CSQL = CSQL & "	    	,CONVERT(CHAR, CONVERT(DATE, A.Birthday), 102) Birthday "
        CSQL = CSQL & "	    	,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm "
        CSQL = CSQL & "	    	,A.Email "
        CSQL = CSQL & "	    	,A.ZipCode "    
        CSQL = CSQL & "	    	,A.Address "
        CSQL = CSQL & "	    	,A.AddressDtl "
        CSQL = CSQL & "	    	,A.EmailYN, A.EmailYnDt "
        CSQL = CSQL & "	    	,A.SMSYN, A.SmsYnDt, A.PushYNDt "
        CSQL = CSQL & "	    	,CASE WHEN A.PushYN IS NULL OR A.PushYN = '' THEN '미설정' ELSE A.PushYN END PushStateGb "    
        CSQL = CSQL & "	    	,CONVERT(CHAR, A.WriteDate, 102) RegDate, A.ModDate"	
'        CSQL = CSQL & "         ,STUFF(( "
'        CSQL = CSQL & "                SELECT ',' + "
'        CSQL = CSQL & "                        CASE "
'        CSQL = CSQL & "                        WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('R','K','S') THEN '선수'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('T') THEN '지도자'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('D') THEN '일반'"    
'        CSQL = CSQL & "                        END "
'        CSQL = CSQL & "                FROM [SD_JUDO].[Sportsdiary].[dbo].[tblMember] "
'        CSQL = CSQL & "                WHERE DelYN = 'N' AND A.UserID = SD_UserID "
'        CSQL = CSQL & "            FOR XML PATH('')),1,1,'') UserJudo "
'        CSQL = CSQL & "         ,STUFF(( "
'        CSQL = CSQL & "                 SELECT ',' + "
'        CSQL = CSQL & "                        CASE "
'        CSQL = CSQL & "                        WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('R') THEN '선수'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('T') THEN '지도자'"
'        CSQL = CSQL & "                        WHEN PlayerReln IN('D') THEN '일반'"        
'        CSQL = CSQL & "                        END "
'        CSQL = CSQL & "                FROM [SD_Tennis].[dbo].[tblMember] "
'        CSQL = CSQL & "                WHERE DelYN = 'N' AND A.UserID = SD_UserID "
'        CSQL = CSQL & "            FOR XML PATH('')),1,1,'') UserTennis "
        CSQL = CSQL & "         ,STUFF(( "
        CSQL = CSQL & "                SELECT ',' + "
        CSQL = CSQL & "                        CASE "
        CSQL = CSQL & "                        WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
        CSQL = CSQL & "                        WHEN PlayerReln IN('R') THEN '선수'"
        CSQL = CSQL & "                        WHEN PlayerReln IN('T') THEN '지도자'"
        CSQL = CSQL & "                        WHEN PlayerReln IN('D') THEN '일반'"        
        CSQL = CSQL & "                        END "
        CSQL = CSQL & "                FROM [SD_Bike].[dbo].[tblMember] "
        CSQL = CSQL & "                WHERE DelYN = 'N' AND A.UserID = SD_UserID "
        CSQL = CSQL & "            FOR XML PATH('')),1,1,'') UserBike " 
        CSQL = CSQL & "	    FROM [SD_Member].[dbo].[tblMember] A"
        CSQL = CSQL & "	    WHERE A.DelYN = 'N' AND MemberIDX = '"&CIDX&"'"      
      
        'response.Write CSQL                            
                                                                               
        SET CRs = DBCon8.Execute(CSQL)	
        If Not(CRs.Eof Or CRs.Bof) Then 
               
            UserID = CRs("UserID")
            UserPhone = CRs("UserPhone")
            Birthday = CRs("Birthday")
            SexNm = CRs("SexNm")
            Email = CRs("Email")
            ZipCode = CRs("ZipCode")            
            EmailYN = CRs("EmailYN")
            SMSYN = CRs("SMSYN")
            SmsYnDt = CRs("SmsYnDt")
            PushStateGb = CRs("PushStateGb")
            PushYNDt = CRs("PushYNDt")
            RegDate = CRs("RegDate")
'            UserBike = CRs("UserBike")
'            UserTennis = CRs("UserTennis")
'            UserJudo = CRs("UserJudo")
            EmailYnDt = CRs("EmailYnDt")
            ModDate = CRs("ModDate") 
            UserName = ReHtmlSpecialChars(CRs("UserName"))
            UserEnName = ReHtmlSpecialChars(CRs("UserEnName")) 
            Address = ReHtmlSpecialChars(CRs("Address"))
            AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl")) 

'            IF UserJudo <> "" Then txt_UserType = txt_UserType & "유도["&UserJudo&"] "
'            IF UserTennis <> "" Then txt_UserType = txt_UserType & "테니스["&UserTennis&"] "
'            IF UserBike <> "" Then txt_UserType = txt_UserType & "자전거["&UserBike&"] "

            IF UserPhone <> "" Then
                CUserPhone = split(UserPhone, "-")
                UserPhone1 = CUserPhone(0)
                UserPhone2 = CUserPhone(1)
                UserPhone3 = CUserPhone(2)
            End IF

            IF Email <>"" Then
                CEmail = split(Email, "@")
                Email1 = CEmail(0)
                Email2 = CEmail(1)
            End IF  

        ELSE
            response.write "<script>"                             
            response.write "    alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"
            response.write "    history.back();"                                                          
            response.write "</script>"         
            response.end

        End IF     
            CRs.Close
        SET CRs = Nothing

    End IF                                 
%>
  <!--#include file="./CheckRole.asp"--> 
  <script type="text/javascript">
      
    //이메일 도메인 선택입력
	function chk_Email(){
		if(!$('#EmailList').val()) $('#UserEmail2').val('');
		else $('#UserEmail2').val($('#EmailList').val());
	}
    
    function chk_Submit(valType){
      if(valType=='LIST'){
        $('form[name=s_frm]').attr('action','./member_info.asp');
        $('form[name=s_frm]').submit();
      }
    }
      
    function chk_SubmitMod(valType){
        switch(valType){
            case 'MOD'  : obj_DisplayType(valType); break;  //수정 버튼 클릭시
            case 'SAVE' : info_Member_Mod(valType); break;         //정보수정
            default     : obj_DisplayType(valType); break;  //취소시
        }        
    }
    
    //회원정보 수정
    function info_Member_Mod(valType){
        //영문이름 체크
		if($('#UserEnName').val()){
			// /[0-9]|[^\!-z]/gi 영문만 공백포함(\s)
			var regexp = /[0-9]|[^\!-z\s]/gi;

			if(regexp.test($('#UserEnName').val())){
				alert('영문만 입력 가능합니다.');
				$('#UserEnName').focus();
				$('#UserEnName').val($('#UserEnName').val().replace(/[0-9]|[^\!-z\s]/gi,''));
				return;
			} 
        }
        
        if($('#UserEmail1').val() || $('#UserEmail2').val()){
            var email = $('#UserEmail1').val().replace(/ /g, '') +'@' + $('#UserEmail2').val().replace(/ /g, '');  
            var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;   

            if(!regex.test(email)){  
                alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');  
                return;  
            } 
        }		
        
        var strAjaxUrl    = '../Ajax/member_info_mod.asp';
		
		var CIDX = $('#CIDX').val();  
		var UserEnName = $('#UserEnName').val();  
		var ZipCode = $('#ZipCode').val();  
		var Address = $('#Address').val();  
		var AddressDtl = $('#AddressDtl').val();  		
		var UserPhone = $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, '');  
		var UserEmail = $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, '');  
		
        if(confirm('회원정보를 수정하시겠습니까?')){
            $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',     
                data: { 
                    CIDX            : CIDX 
                    ,UserEnName     : UserEnName 
                    ,UserPhone      : UserPhone 
                    ,UserEmail      : UserEmail 
                    ,ZipCode        : ZipCode 
                    ,Address        : Address 
                    ,AddressDtl     : AddressDtl 
                },    
                success: function(retDATA) {

                    //console.log(retDATA);

                    if(retDATA){

                        var strcut = retDATA.split('|');

                        if (strcut[0] == 'TRUE') {
                            alert('회원정보를 수정완료 하였습니다.');
                            location.reload();
                        }
                        else{  //FALSE|
                            var msg = '';

                            switch (strcut[1]) { 
                                case '99'   : msg = '일치하는 회원정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
                                case '66'   : msg = '회원정보 수정에 실패하였습니다.\n관리자에게 문의하세요.'; break;
                                default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                            }           
                            alert(msg);
                            //obj_DisplayType('MOD');
                            return;           
                        }
                    }
                }, 
                error: function (xhr, status, error) {
                    if(error!=''){
                        alert ('오류발생['+error+']! - 시스템관리자에게 문의하십시오!');
                        return;
                    }
                }
            });  
        }
        else{
            return;
        }
    }
    
    //object 출력 또는 숨김처리
    function obj_DisplayType(valType){
        if(valType=='MOD'){            
            $('#btn_SAVE').show();
            $('#btn_CANCEL').show();
            $('#div_UserEnName').show();
            $('#div_UserPhone').show();
            $('#div_Email').show();
            $('#div_Address').show();
            $('#div_ZipCode').show(); 
            
            $('#btn_MOD').hide();
            $('#obj_UserEnName').hide();
            $('#obj_UserPhone').hide();
            $('#obj_Email').hide();
            $('#obj_Address').hide();
            $('#obj_ZipCode').hide();            
        }
        else{
            /*
            if(valType=='CANCEL') {
                history.go(0);
            }
            else{
            */
                $('#btn_MOD').show();
                $('#obj_UserEnName').show();
                $('#obj_UserPhone').show();
                $('#obj_Email').show();
                $('#obj_Address').show();
                $('#obj_ZipCode').show();   

                $('#btn_SAVE').hide();
                $('#btn_CANCEL').hide();
                $('#div_UserPhone').hide();
                $('#div_UserEnName').hide();
                $('#div_Email').hide();
                $('#div_Address').hide();
                $('#div_ZipCode').hide();    
            //}            
        }    
    }
        
    $(document).ready(function(){
        obj_DisplayType('');
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
  <div class="content"> 
    <!-- S: left-gnb --> 
    <!-- #include file="../include/left-gnb.asp" --> 
    <!-- E: left-gnb --> 
    
    <!-- S: right-content -->









		<div class="right-content">
			<!-- S: navigation -->
			<div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>회원관리</span> <i class="fas fa-chevron-right"></i> <span>통합회원</span> <i class="fas fa-chevron-right"></i> <span>통합회원</span> </div>
			<!-- E: navigation --> 
			<!-- S: pd-15 -->
			<div class="pd-30">
				<form method="post" name="s_frm" id="s_frm" >
				<input type="hidden" id="CIDX" name="CIDX" value="<%=fInject(request("CIDX"))%>">
				<input type="hidden" id="currPage" name="currPage" value="<%=currPage%>">
				<input type="hidden" id="fnd_KeyWord" name="fnd_KeyWord" value="<%=fnd_KeyWord%>">
				<input type="hidden" id="fnd_SEX" name="fnd_SEX" value="<%=fnd_SEX%>">
				<input type="hidden" id="fnd_SMS" name="fnd_SMS" value="<%=fnd_SMS%>">
				<input type="hidden" id="fnd_Email" name="fnd_Email" value="<%=fnd_Email%>">
				<input type="hidden" id="fnd_Push" name="fnd_Push" value="<%=fnd_Push%>">
				<input type="hidden" id="SDate" name="SDate" value="<%=SDate%>">
				<input type="hidden" id="EDate" name="EDate" value="<%=EDate%>">
				<!-- S: sub-content -->
				<div class="sub-content">
					
					<!-- S: player_video_view -->
					<div class="player_video_view">
						<!-- S: box-shadow -->
						<div class="box-shadow">
							<!-- S: table-box -->
							<div class="table-box basic-view">
								<table cellspacing="0" cellpadding="0">
									<tbody><tr>
										<th>아이디</th>
										<td colspan="3">
											<%=UserID%>
										</td>
									</tr>
									<tr>
										<th>이름</th>
										<td>
											<%=UserName%>
										</td>
										<th>영문이름</th>
										<td>
											 <%=UserEnName%>
										</td>
									</tr>
									<tr>
										<th>성별</th>
										<td>
											<%=SexNm%>
										</td>
										<th>생년월일</th>
										<td>
											 <%=Birthday%>
										</td>
									</tr>
									<tr>
										<th>전화번호</th>
										<td>
											<div id="obj_UserPhone"><%=UserPhone%></div>
											<div class="phone-modified" id="div_UserPhone">
												<select name="UserPhone1" id="UserPhone1" >
													<option value="010" <%IF UserPhone1 = "010" Then response.write "selected" End IF%>>010</option>
													<option value="011" <%IF UserPhone1 = "011" Then response.write "selected" End IF%>>011</option>
													<option value="016" <%IF UserPhone1 = "016" Then response.write "selected" End IF%>>016</option>
													<option value="017" <%IF UserPhone1 = "017" Then response.write "selected" End IF%>>017</option>
													<option value="018" <%IF UserPhone1 = "018" Then response.write "selected" End IF%>>018</option>
													<option value="019" <%IF UserPhone1 = "019" Then response.write "selected" End IF%>>019</option>
												</select>
												<input type="text" name="UserPhone2" id="UserPhone2" value="<%=UserPhone2%>" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />
												<input type="text" name="UserPhone3" id="UserPhone3" value="<%=UserPhone3%>" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');if($('#UserPhone3').val().length==4){$('#UserEmail1').focus();}" />
											</div>

										</td>
										<th>이메일</th>
										<td>
											<div id="obj_Email"><%=Email%></div>
											<div class="email-modified" id="div_Email"> 
												<input type="text" name="UserEmail1" id="UserEmail1" value="<%=Email1%>" placeholder="sample123456" class="email-input" />
												<span class="txt">@</span> 
												<input type="text" name="UserEmail2" id="UserEmail2" value="<%=Email2%>" placeholder="직접입력" class="email-input" />
												<select name="EmailList" id="EmailList" onChange="chk_Email();">
													<option value="userWrite">직접입력</option>
													<option value="gmail.com" <%IF Email2 = "gmail.com" Then response.Write "selected" End IF%>>gmail.com</option>
													<option value="hanmail.net" <%IF Email2 = "hanmail.net" Then response.Write "selected" End IF%>>hanmail.net</option>
													<option value="hotmail.com" <%IF Email2 = "hotmail.com" Then response.Write "selected" End IF%>>hotmail.com</option>
													<option value="naver.com" <%IF Email2 = "naver.com" Then response.Write "selected" End IF%>>naver.com</option>
													<option value="nate.com" <%IF Email2 = "nate.com" Then response.Write "selected" End IF%>>nate.com</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>주소</th>
										<td>
											<div id="obj_Address"><%=Address&" "&AddressDtl%></div>
											<div id="div_Address" class="address-modified">
												<ul>
													<li class="line-one">
														<input type="text" readonly name="Address" id="Address" value="<%=Address%>" placeholder="주소 입력" >
														<a href="javascript:execDaumPostCode();" class="btn btn-primary">주소찾기</a>
													</li>
													<li>
														<input type="text" name="AddressDtl" id="AddressDtl" value="<%=AddressDtl%>" placeholder="나머지 주소 입력">
													</li>
												</ul>
											</div>

										</td>
										<th>우편번호</th>
										<td>
											<div id="obj_ZipCode"><%=ZipCode%></div>
                    <div id="div_ZipCode">
                      <input type="text" readonly name="ZipCode" id="ZipCode" value="<%=ZipCode%>" />
                    </div>
										</td>
									</tr>
									<tr>
										<th>SMS 수신동의</th>
										<td>
											<%=SmsYN%> <span>(최근 수신동의 변경일 : <%=SmsYnDt%>)</span>
										</td>
										<th>이메일 수신동의</th>
										<td>
											<%=EmailYN%> <span>(최근 수신동의 변경일 : <%=EmailYNDt%>)</span>
										</td>
									</tr>
									<tr>
										<th>앱 알림 수신동의</th>
										<td>
											<%=PushStateGb%> <%IF PushYnDt<>"" Then%><span>(최근 수신동의 변경일 : <%=PushYnDt%>)</span><%End IF%>
										</td>
										<th>계정종목가입</th>
										<td>
											<%=txt_UserType%>
										</td>
									</tr>
									<tr>
										<th>가입일</th>
										<td colspan="3">
											<%=RegDate%><span>(최근 수정일 : <%=ModDate%>)</span>
										</td>
									</tr>

								</tbody>
								</table>
							</div>
							<!-- E: table-box -->
						</div>
						<!-- E: box-shadow -->
						<!-- S: bt-btn-box -->
						<div class="bt-btn-box txt-right">
							<a href="javascript:chk_Submit('LIST');" class="btn btn-default">목록</a>
							<a href="javascript:chk_SubmitMod('MOD');" class="btn btn-primary" id="btn_MOD">수정</a>
							<a href="javascript:chk_SubmitMod('SAVE');" class="btn btn-primary" id="btn_SAVE">수정하기</a>
							<a href="javascript:chk_SubmitMod('CANCEL');" class="btn btn-default" id="btn_CANCEL">취소</a>
						</div>
						<!-- E: bt-btn-box -->
					</div>
					<!-- E: player_video_view -->
				</div>
				<!-- E: sub-content -->
				</form>
			</div>
			<!-- E: pd-15 -->
		</div>













  </div>
  <!-- S: footer --> 
  <!-- #include file="../include/footer.asp" -->
<!-- E: footer -->
<%
    DBClose8()
%>
