<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim CIDX      		: CIDX      	= crypt.DecryptStringENC(fInject(request("CIDX")))
	dim currPage      	: currPage      = fInject(request("currPage"))
	dim SDate         	: SDate       	= fInject(request("SDate"))
	dim EDate         	: EDate       	= fInject(request("EDate")) 
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(request("fnd_KeyWord"))


	dim CSQL, CRs
	dim strUserPhone, UserPhone1, UserPhone2, UserPhone3
	dim strEmail, Email1, Email2

	dim UserID, UserName, UserEnName, UserBirth, UserPhone, SmsYn, SmsYnDt, Email, EmailYn, EmailYnDt
	dim PersonNum, Team, TeamNm, Role, RoleNm, AuthType, AuthTypeNm, AuthYN, WithdrawYN, WithdrawDt
   	dim MIDX
	dim RegDate, ModDate

	IF CIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>" 
		response.End()
	Else  
  
		CSQL = "    SELECT MembershipIDX "
		CSQL = CSQL & "   ,UserID " 
	    CSQL = CSQL & "   ,CASE Role "
   		CSQL = CSQL & "			WHEN 'EP' THEN PlayerIDX" 
   		CSQL = CSQL & "			WHEN 'EL' THEN LeaderIDX" 
   		CSQL = CSQL & "			ELSE '' END MIDX "
   		CSQL = CSQL & "   ,CASE WHEN LeaderIDX IS NULL OR LeaderIDX='' THEN '' END LeaderIDX" 	    
		CSQL = CSQL & "   ,UserName " 
		CSQL = CSQL & "   ,CONVERT(CHAR(10), CONVERT(DATE, UserBirth), 102) UserBirth"
		CSQL = CSQL & "   ,UserEnName "
		CSQL = CSQL & "   ,UserPhone "  
		CSQL = CSQL & "   ,SmsYn "
		CSQL = CSQL & "   ,SmsYnDt "
		CSQL = CSQL & "   ,CASE Role "
		CSQL = CSQL & "     WHEN 'EP' THEN '엘리트선수' "
		CSQL = CSQL & "     WHEN 'EL' THEN '엘리트지도자' "
		CSQL = CSQL & "     WHEN 'AP' THEN '생체선수' "
		CSQL = CSQL & "     WHEN 'AL' THEN '생체지도자' "
		CSQL = CSQL & "     WHEN 'J' THEN '심판' "
		CSQL = CSQL & "   ELSE '심판' "
		CSQL = CSQL & "   END RoleNm "             
		CSQL = CSQL & "   ,Role"             
		CSQL = CSQL & "   ,CASE AuthYN "
		CSQL = CSQL & "     WHEN 'Y' THEN "
		CSQL = CSQL & "       CASE AuthType "
		CSQL = CSQL & "         WHEN 'M' THEN '휴대폰인증' "
		CSQL = CSQL & "         WHEN 'I' THEN 'I-PIN인증' "
		CSQL = CSQL & "       END "
		CSQL = CSQL & "   ELSE 'X' "
		CSQL = CSQL & "   END AuthTypeNm"
		CSQL = CSQL & "   ,AuthType "
		CSQL = CSQL & "   ,AuthYN "
		CSQL = CSQL & "   ,Email "
		CSQL = CSQL & "   ,EmailYn "
		CSQL = CSQL & "   ,EmailYnDt "
		CSQL = CSQL & "   ,PersonNum "
		CSQL = CSQL & "   ,Team "
		CSQL = CSQL & "   ,TeamNm "
		CSQL = CSQL & "   ,RegDate "
		CSQL = CSQL & "   ,ModDate "
		CSQL = CSQL & "   ,WithdrawYN "
		CSQL = CSQL & "   ,WithdrawDt "
		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblMembershipOnline] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "   AND MembershipIDX = '"&CIDX&"'"
    
'   response.Write CSQL
    
    	SET CRs = DBCon.Execute(CSQL)
    	IF NOT(CRs.Bof OR CRs.Eof) THEN
			MIDX   = crypt.EncryptStringENC(CRs("MIDX")) 	
			UserID      = CRs("UserID")
			UserName    = CRs("UserName")
			UserEnName  = CRs("UserEnName")
			UserBirth   = CRs("UserBirth")
			SmsYn     	= CRs("SmsYn")
			SmsYnDt   	= CRs("SmsYnDt")
			UserPhone   = CRs("UserPhone")
			Role      	= CRs("Role")
			RoleNm      = CRs("RoleNm")
			AuthType    = CRs("AuthType")
			AuthTypeNm  = CRs("AuthTypeNm")
			AuthYN    	= CRs("AuthYN")
			Email     	= CRs("Email")
			EmailYn     = CRs("EmailYn")
			EmailYnDt   = CRs("EmailYnDt")      
			RegDate   	= CRs("RegDate")
			ModDate   	= CRs("ModDate")
			PersonNum   = CRs("PersonNum")
			Team      	= CRs("Team")
			TeamNm    	= CRs("TeamNm")
			WithdrawYN  = CRs("WithdrawYN")
			WithdrawDt  = CRs("WithdrawDt")

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
  /**
  * left-menu 체크
  */
  var locationStr = "Main_HP/User_List.asp";  // 대회
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
      $('form[name=s_frm]').attr('action','./User_List.asp');
      $('form[name=s_frm]').submit(); 
    }
    //회원탈퇴
    else if(valType=='DROP'){
      
      if(confirm('회원탈퇴를 진행하시겠습니까?')){
        var strAjaxUrl = '../Ajax/User_Mod_Withdraw.asp';
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
              var strcut = retDATA.split('|');
              
              if (strcut[0] == 'TRUE') {
                alert('회원탈퇴가 완료되었습니다.');
                $('form[name=s_frm]').attr('action','./User_List.asp');
                $('form[name=s_frm]').submit(); 
              }
              else{  //FALSE|
                var msg='';
                
                switch(strcut[1]){
                  case '200'  : msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; break;
                  case '99' : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
                  case '66' : msg='회원탈퇴를 완료하지 못하였습니다.\n시스템관리자에게 문의하십시오!'; break;
                  default:
                }
                alert(msg);
                return;
              }
            }
          }, 
          error: function(xhr, status, error){           
            if(error != ''){
              alert ('오류발생! - 시스템관리자에게 문의하십시오!');     
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
      
      if(confirm('회원정보를 수정하시겠습니까?')){
        
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
        
        
        var strAjaxUrl = '../Ajax/User_Mod.asp';
        var CIDX = $('#CIDX').val();  
        var UserPhone = $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, '');  
        var UserEmail = $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, '');        
        
        
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',     
          data: { 
            CIDX      : CIDX            
            ,UserPhone    : UserPhone
            ,UserEmail    : UserEmail 
          },    
          success: function(retDATA) {
            
            //console.log(retDATA);
            
            if(retDATA){
              var strcut = retDATA.split('|');
              
              if (strcut[0] == 'TRUE') {
                alert('회원정보를 수정완료 하였습니다.');
                $('form[name=s_frm]').attr('action','./User_List.asp');
                $('form[name=s_frm]').submit(); 
              }
              else{  //FALSE|
                var msg='';
                
                switch(strcut[1]){
                  case '99' : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
                  case '66' : msg='회원정보를 업데이트하지 못하였습니다.\n시스템관리자에게 문의하십시오!'; break;
                  default	: msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                }
                alert(msg);
                return;
              }
            }
          }, 
          error: function(xhr, status, error){           
            if(error != ''){
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
											   
	function INFO_MEMBER_Modal(valType, valIDX){
		var strAjaxUrl = '../ajax/User_Mod_MemberModal.asp'; 
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {     
				valType : valType 
				,valIDX : valIDX
			},
			success: function(retDATA) {

				//console.log(retDATA);
				$('.detail_player').modal('show');
				$('#player_contents').html(retDATA);
			},
			error: function(xhr, status, error){
				if(error){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		}); 										
	}											   
</script> 
<!-- S : content -->
<section>
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>회원정보 상세보기</h2>
        <a href="./User_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>회원관리</li>
            <li>온라인 회원관리</li>
            <li>회원목록</li>
            <li>회원목록 상세보기</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    
    <form name="s_frm" method="post">
      <input type="hidden" id="CIDX" name="CIDX" value="<%=fInject(request("CIDX"))%>" />
      <input type="hidden" id="SDate" name="SDate" value="<%=SDate%>" />
      <input type="hidden" id="EDate" name="EDate" value="<%=EDate%>" />
      <input type="hidden" id="fnd_KeyWord" name="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
      <table class="user_detail left-head view-table">
        <%IF WithdrawYN = "Y" Then '회원탈퇴신청%>
    <tr>
      <th>회원상태</th>
          <td colspan="2" style="color: #DD0003; font-weight: bold;">회원탈퇴 신청한 회원입니다. 탈퇴신청일 : <%=WithdrawDt%></td>
        </tr>
    <%End IF%>
    <tr>
          <th>인증</th>
          <td><%=AuthTypeNm%></td>
        </tr>
        <tr>
          <th>아이디</th>
          <td><%=UserID%></td>
        </tr>
        <tr>
          <th>이름</th>
          <td><%=UserName%></td>
        </tr>
        <tr>
          <th>영문이름</th>
          <td><%=UserEnName%></td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td><%=UserBirth%></td>
        </tr>
        <tr class="phone-line">
          <th>휴대폰</th>
          <td><select name="UserPhone1" id="UserPhone1" class="in_2">
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
            <span class="receive">
            <%IF SMSYN = "Y" Then response.Write "동의" Else response.Write "동의안함" End IF%>
            : <%=SMSYNDt%> </span></td>
        </tr>
        <tr class="mail-line">
          <th>이메일</th>
          <td><input type="text" class="in_2" name="UserEmail1" id="UserEmail1" placeholder="sample123456" value="<%=Email1%>" />
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
            <%IF EmailYN = "Y" Then response.Write "동의" Else response.Write "동의안함" End IF%>
            : <%=EmailYNDt%> </span></td>
        </tr>
        <tr>
          <th>회원구분</th>
          <td><%=RoleNm%>&nbsp;&nbsp;&nbsp;
			  <%
				 IF Role = "EP" OR Role = "EL" Then
				 	response.write "<a href=""javascript:INFO_MEMBER_Modal('"&Role&"', '"&MIDX&"');"" class=""btn btn-confirm"">상세보기</a>"
				 END IF
				 %>
			  </td>
        </tr>
        <%
       SELECT CASE Role
          CASE "EP", "EL", "AP", "AL" 
         %>
        <tr>
          <th>체육인번호</th>
          <td><%=PersonNum%></td>
        </tr>
        <%  
          CASE ELSE
       END SELECT
       %>
        
          <th>회원가입일</th>
          <td><%=RegDate%></td>
        </tr>
        <tr>
          <th>회원정보수정일</th>
          <td><%=ModDate%></td>
        </tr>
      </table>
      <div class="c_btn btn-list-center">
        <a href="javascript:chk_onSubmit('MOD');" class="btn btn-confirm">수정하기</a>
        <a href="javascript:chk_onSubmit('LIST');" class="btn btn-blue-empty">목록</a>
        <a href="javascript:chk_onSubmit('DROP');" class="btn btn-red">회원탈퇴</a>
      </div>
    </form>
  </div>
</section>

<!-- s: Modal등록동호인 목록 View Modal-->
  <div class="modal fade detail_player srch_player" id="detail_player" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
	<div class="modal-dialog modal-lg">
	  <div class="modal-content">
		<div class="modal-header">
		  <button type="button" class="btn btn-close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		  <h3 class="modal-title" id="myModalLabel">상세보기</h3>
		</div>
		<div class="modal-body">
		  <div id="player_contents" class="table-list-wrap"> 
		  </div>
		  <div class="btn_list"> <a href="#" class="btn btn-confirm" data-dismiss="modal">닫기</a> </div>
		</div>
	  </div>
	</div>
  </div>
  <!-- e: Modal등록동호인 목록 View Modal--> 
<!-- E : content --> 
<!-- E : container --> 

<!--#include file="../include/footer.asp"-->