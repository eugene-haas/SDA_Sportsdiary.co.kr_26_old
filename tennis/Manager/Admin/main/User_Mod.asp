<!--#include file="../dev/dist/config.asp"-->
<!--#include file="./head.asp"-->
<%
	dim CIDX			: CIDX 			= fInject(request("CIDX"))
	dim currPage   		: currPage    	= fInject(request("currPage"))
	dim SDate     		: SDate     	= fInject(request("SDate"))
	dim EDate     		: EDate     	= fInject(request("EDate")) 
	dim TypeRole  		: TypeRole    	= fInject(request("TypeRole"))
	dim fnd_AuthType  	: fnd_AuthType  = fInject(request("fnd_AuthType"))	
	dim fnd_KeyWord  	: fnd_KeyWord   = fInject(request("fnd_KeyWord"))
	
	
	dim CSQL, CRs
	dim strUserPhone, UserPhone1, UserPhone2, UserPhone3
	dim strEmail, Email1, Email2
	dim txtRole
	
	dim UserName, UserPhone, Role, SmsYn, SmsYnDt, Birthday, UserID, Team, TeamNm, Email, EmailYn, EmailYnDt
	dim RegDate, WriteDate, AuthTypeNm, AuthYNNm, RoleType, PersonNum

	IF CIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>" 
		response.End()
	Else
	
	
		CSQL = "		SELECT MemberIDX "
		CSQL = CSQL & "		,UserName "
		CSQL = CSQL & "		,UserPhone "
		CSQL = CSQL & "		,Role "
		CSQL = CSQL & "		,SmsYn "
		CSQL = CSQL & "		,SmsYnDt "
		CSQL = CSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, Birthday), 102) Birthday"
		CSQL = CSQL & "		,UserID "
		CSQL = CSQL & "		,ISNULL(Team,'') Team"
		CSQL = CSQL & "		,ISNULL(TeamNm, '') TeamNm"
		CSQL = CSQL & "		,Email "
		CSQL = CSQL & "		,EmailYn "
		CSQL = CSQL & "		,EmailYnDt "
		CSQL = CSQL & "		,RegDate "
		CSQL = CSQL & "		,WriteDate "
		CSQL = CSQL & "		,CASE AuthType WHEN 'M' THEN '휴대폰 안심 본인인증' WHEN 'I' THEN '아이핀(I-PIN) 인증' ELSE '' END AuthTypeNm"
		CSQL = CSQL & "		,CASE AuthYN WHEN 'Y' THEN '인증완료' ELSE '미인증' END AuthYNNm "	
		CSQL = CSQL & "		,CASE WHEN PlayerIDX IS NOT NULL OR PlayerIDX<>'' THEN '선수' WHEN LeaderIDX IS NOT NULL OR LeaderIDX<>'' THEN '지도자' ELSE '' END RoleType"
		CSQL = CSQL & "		,ISNULL(PersonNum, '')  PersonNum "
		CSQL = CSQL & "	FROM [JudoKorea].[dbo].[Member_Tbl] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND MemberIDX = '"&CIDX&"'"
		
	'	response.Write CSQL
		
		SET CRs = DBcon4.Execute(CSQL)
		IF NOT(CRs.Bof OR CRs.Eof) THEN

			UserName    	= CRs("UserName")
			UserPhone  		= CRs("UserPhone")
			Role 			= CRs("Role")
			SmsYn  			= CRs("SmsYn")
			SmsYnDt  		= CRs("SmsYnDt")
			Birthday   		= CRs("Birthday")
			UserID    		= CRs("UserID")
			Team  			= CRs("Team")
			TeamNm  		= CRs("TeamNm")
			Email  			= CRs("Email")
			EmailYn     	= CRs("EmailYn")
			EmailYnDt     	= CRs("EmailYnDt")			
			RegDate  		= CRs("RegDate")
			WriteDate  		= CRs("WriteDate")
			AuthTypeNm 		= CRs("AuthTypeNm")
			AuthYNNm  		= CRs("AuthYNNm")
			RoleType   		= CRs("RoleType")
			PersonNum   	= CRs("PersonNum")		
			
			IF Role <> "" Then
				strRole = split(Role, "|")
				
				FOR i = 0 To Ubound(strRole)
					SELECT CASE strRole(i)
						CASE "P" : txtRole = txtRole & "· 엘리트선수 "
						CASE "L" : txtRole = txtRole & "· 지도자(감독) "
						CASE "D" : txtRole = txtRole & "· 관장 "
						CASE "J" : txtRole = txtRole & "· 심판 "
						CASE "U" : txtRole = txtRole & "· 일반 "
					END SELECT 
				NEXT
				
			End IF
			
			
			IF UserPhone <> "" Then
				strUserPhone = split(UserPhone, "-")
				UserPhone1 = strUserPhone(0)
				UserPhone2 = strUserPhone(1)
				UserPhone3 = strUserPhone(2)
			End IF
			
			IF Email <> "" Then
				strEmail = split(Email, "@")
				Email1 = strEmail(0)
				Email2 = strEmail(1)
			End IF
			
		End IF
			
			CRs.Close
		SET CRs = Nothing
		
	End IF
%>
<script language="javascript">
	//숫자입력체크
	function chk_Number(object){
		$(object).keyup(function(){
         	$(this).val($(this).val().replace(/[^0-9]/g,""));
    	}); 	
	}
	
	//이메일 도메인 선택입력
	function chk_Email(){
		if(!$('#EmailList').val()){     
			$('#UserEmail2').val("");
		}
		else{
			$('#UserEmail2').val($('#EmailList').val());
		}
	}
	
	function chk_onSubmit(valType){
		if(valType=="LIST"){
			$('form[name=s_frm]').attr('action',"./User_List.asp");
			$('form[name=s_frm]').submit(); 
		}
		//회원탈퇴
		else if(valType=="DROP"){
			
			if(confirm("회원 탈퇴를 진행하시겠습니까?")){
				var strAjaxUrl = "../Ajax/admin_Withdraw.asp";
				var CIDX = $('#CIDX').val();  
				
				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',     
					data: { 
						CIDX : CIDX 
					},    
					success: function(retDATA) {
						
						//console.log(retDATA);
						
						if(retDATA){
							var strcut = retDATA.split("|");
							
							if (strcut[0] == "TRUE") {
								alert("회원탈퇴가 완료되었습니다.");
								$('form[name=s_frm]').attr('action',"./User_List.asp");
								$('form[name=s_frm]').submit(); 
							}
							else{  //FALSE|
								if(strcut[1] == 200){
									alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');               
									return;
								}
								else if(strcut[1] == 99){	//99
									alert('일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.');               
									return;
								}
								else{}
							}
						}
					}, 
					error: function(xhr, status, error){           
						if(error != ""){
							alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
							return;
						}
					}
				});
				
			}
			else {
				return;
			}
		}
		else{
			
			if(confirm("회원정보를 수정하시겠습니까?")){
				
				if(!$('#UserPhone2').val()){
					alert("휴대폰 번호를 입력해 주세요.");
					$('#UserPhone2').focus();
					return;
				}
				
				if(!$('#UserPhone3').val()){
					alert("휴대폰 번호를 입력해 주세요.");
					$('#UserPhone3').focus();
					return;
				}
			
				//이메일체크
				if(!$('#UserEmail1').val()){
					alert("이메일을 입력해 주세요");
					$('#UserEmail1').focus();
					return;
				}
				
				if(!$('#UserEmail2').val()){
					alert("이메일을 입력해 주세요");
					$('#UserEmail2').focus();
					return;
				}
			
				var email = $('#UserEmail1').val() +"@" + $('#UserEmail2').val();  
				var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;   
				
				if(!regex.test(email)){  
					alert("잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요");  
					return;  
				} 
				
				
				var strAjaxUrl = "../Ajax/admin_User_Mod_OK.asp";
				var CIDX = $('#CIDX').val();  
				var UserPhone = $('#UserPhone1').val() + "-" + $('#UserPhone2').val() + "-" + $('#UserPhone3').val();  
				var UserEmail = $('#UserEmail1').val() + "@" + $('#UserEmail2').val();  				
				var Hidden_SmsYn = $('#Hidden_SmsYn').val();  
				var Hidden_EmailYn = $('#Hidden_EmailYn').val();  
				
				var SmsYn, EmailYn;		
				
				
				//SMS 수신동의
				if($("#AgreeSMS").is(":checked") == true){ 
					SmsYn = "Y";
				}
				else{ 
					SmsYn = "N";
				}
				//이메일 수신동의
				if($("#AgreeEmail").is(":checked") == true){ 
					EmailYn = "Y"; 
				}
				else{ 
					EmailYn = "N";
				}			
				
				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',     
					data: { 
						CIDX			: CIDX 
						,UserPhone  	: UserPhone
						,UserEmail  	: UserEmail 
						,SmsYn      	: SmsYn 
						,EmailYn    	: EmailYn 
						,Hidden_SmsYn   : Hidden_SmsYn 
						,Hidden_EmailYn : Hidden_EmailYn 	
					},    
					success: function(retDATA) {
						
						console.log(retDATA);
						
						if(retDATA){
							var strcut = retDATA.split("|");
							
							if (strcut[0] == "TRUE") {
								alert("회원정보를 수정완료 하였습니다.");
								$('form[name=s_frm]').attr('action',"./User_List.asp");
								$('form[name=s_frm]').submit(); 
							}
							else{  //FALSE|
								if(strcut[1] == 200){
									alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');               
									return;
								}
								else if(strcut[1] == 99){	//99
									alert('일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.');               
									return;
								}
								else{}
							}
						}
					}, 
					error: function(xhr, status, error){           
						if(error != ""){
							alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
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
</script>
<!-- S : content -->
<section>
  <div id="content">
    <div class="navigation_box"> 회원관리 &gt; 회원정보 상세보기</div>
    <!-- S : top-navi -->
    <!-- E : top-navi -->

    <form name="s_frm" method="post">
      <input type="hidden" id="CIDX" name="CIDX" value="<%=CIDX%>" />
      <input type="hidden" id="SDate" name="SDate" value="<%=SDate%>" />
      <input type="hidden" id="EDate" name="EDate" value="<%=EDate%>" />
      <input type="hidden" id="TypeRole" name="TypeRole" value="<%=TypeRole%>" />
      <input type="hidden" id="fnd_AuthType" name="fnd_AuthType" value="<%=fnd_AuthType%>" />
      <input type="hidden" id="fnd_KeyWord" name="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
      <input type="hidden" name="Hidden_SmsYn" id="Hidden_SmsYn" value="<%=SmsYn%>" />
      <input type="hidden" name="Hidden_EmailYn" id="Hidden_EmailYn" value="<%=EmailYn%>" />
      <table cellspacing="0" cellpadding="0" class="user_detail">
      	<tr>
          <th>회원구분</th>
          <td><%=txtRole%></td>
        </tr>
        <tr>
          <th>아이디</th>
          <td><%=UserID%></td>
        </tr>
        
        <!--
        <tr>
          <th>비밀번호</th>
          <td><input type="password" name="UserPass" id="UserPass" class="in_1" value="<%=UserID%>" /></td>
        </tr>
        -->
        <tr>
          <th>이름</th>
          <td><%=UserName%></td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td><%=Birthday%></td>
        </tr>
        <tr>
          <th>체육인번호</th>
          <td><%=PersonNum%><%IF RoleType <> "" Then response.Write "("&RoleType&")" End IF%></td>
        </tr>
        <tr>
          <th>소속팀</th>
          <td><%=TeamNm%><%IF Team <> "" Then response.Write "("&Team&")" End IF%></td>
        </tr>
        <tr>
          <th>휴대폰</th>
          <td><select name="UserPhone1" id="UserPhone1" class="in_2">
              <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
              <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
              <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
              <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
              <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
              <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
            </select>
            <span>-</span>
            <input type="text" class="in_2" name="UserPhone2" id="UserPhone2" maxlength="4" onKeyUp="chk_Number(this);" value="<%=UserPhone2%>" />
            <span>-</span>
            <input type="text" class="in_2" name="UserPhone3" id="UserPhone3" maxlength="4" onKeyUp="chk_Number(this);" value="<%=UserPhone3%>" />
            <span class="receive">
            <input type="checkbox" name="AgreeSMS" id="AgreeSMS" class="check" <%IF SmsYn = "Y" Then response.Write "checked" End IF%> />
            <label for="AgreeSMS" class="font_13">수신동의</label> : <%=SmsYNDt%>
            </span>
            </td>
        </tr>
        <tr>
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
              <span class="receive">
              <input type="checkbox" name="AgreeEmail" id="AgreeEmail" class="check"  <%IF EmailYn = "Y" Then response.Write "checked" End IF%> />
              <label for="AgreeEmail" class="font_13">수신동의</label> : <%=EmailYNDt%>
              </span>
             
            </td>
        </tr>
        <tr>
          <th>회원가입일</th>
          <td><%=RegDate%></td>
        </tr>
        <tr>
          <th>회원정보수정일</th>
          <td><%=WriteDate%></td>
        </tr>
        <tr>
          <th>인증방법</th>
          <td><%=AuthTypeNm%>(<%=AuthYNNm%>)</td>
        </tr>
        <!--
        <tr>
          <th>회원탈퇴</th>
          <td><input type="checkbox" name="MemberOut" id="MemberOut" /> ※ 회원탈퇴시 체크하세요.</td>
        </tr>
        -->
      </table>
      <div class="c_btn"> <a href="javascript:chk_onSubmit('LIST');" class="btn_list">목록</a> </div>
      <div class="c_btn"> <a href="javascript:chk_onSubmit('MOD');" class="btn_modify">수정하기</a> </div>
      <div class="c_btn"> <a href="javascript:chk_onSubmit('DROP');" class="btn_drop">회원탈퇴</a> </div>
    </form>
  </div>
</section>
<!-- E : content -->
<!-- E : container -->
<!--#include file="footer.asp"-->
