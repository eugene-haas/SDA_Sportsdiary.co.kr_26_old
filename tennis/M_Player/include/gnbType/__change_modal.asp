<%
  
  
  '가입된 계정 목록
  FUNCTION CHG_JoinUsList(obj)
    dim str_JoinUs
  	
	      
    '테니스        
    LSQL =  "     SELECT M.MemberIDX MemberIDX"
    LSQL = LSQL & "   ,M.SD_GameIDSET"
    LSQL = LSQL & "   ,CASE M.PlayerReln "
    LSQL = LSQL & "     WHEN 'A' THEN '보호자(부-'+P.UserName+')'"
    LSQL = LSQL & "     WHEN 'B' THEN '보호자(모-'+P.UserName+')'"
    LSQL = LSQL & "     WHEN 'Z' THEN '보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
    LSQL = LSQL & "     WHEN 'T' THEN '지도자('+ISNULL(SD_Tennis.dbo.FN_PubName('sd03900'+LeaderType),'')+')-'+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')"
	LSQL = LSQL & " 	WHEN 'R' THEN "	
	LSQL = LSQL & "			CASE "
	LSQL = LSQL & "				WHEN SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2) IS NULL THEN '선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')'"
	LSQL = LSQL & "			ELSE '선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+'/'+ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2),'')+')'"
	LSQL = LSQL & "			END"	
    LSQL = LSQL & "     WHEN 'D' THEN '일반' "  
    LSQL = LSQL & "   END PlayerRelnNm "
    LSQL = LSQL & "   ,CONVERT(DATE, SrtDate, 102) SrtDate "
    LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
    LSQL = LSQL & "   left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
    LSQL = LSQL & "     AND P.SportsGb = '"&obj&"' "
    LSQL = LSQL & "     AND P.DelYN = 'N' "
    LSQL = LSQL & " WHERE M.DelYN = 'N' "
    LSQL = LSQL & "   AND M.SportsType = '"&obj&"' "
'    LSQL = LSQL & "   AND M.EnterType = '"&request.Cookies(SportsGb)("EnterType")&"' "
    LSQL = LSQL & "   AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' " 
    LSQL = LSQL & " ORDER BY M.EnterType "
    LSQL = LSQL & "   ,M.PlayerReln "   
	
'	response.Write LSQL
	
    SET LRs = DBCon3.Execute(LSQL)
    IF Not(LRs.Eof or LRs.bof) Then
      Do Until LRs.Eof
	  	
        IF cint(LRs("MemberIDX")) = cint(decode(request.Cookies(SportsGb)("MemberIDX"),0)) Then 
          str_JoinUs = str_JoinUs & "<li class='tg on'>"
        Else
          str_JoinUs = str_JoinUs & "<li class='tg'>"
        End IF
        
        str_JoinUs = str_JoinUs & " <div class='cont'>"
        str_JoinUs = str_JoinUs & "   <p>"&LRs("PlayerRelnNm")&"</p>"
        str_JoinUs = str_JoinUs & "   <span class='join_date'>가입일자 : "&LRs("SrtDate")&"</span>"
        str_JoinUs = str_JoinUs & " </div>"
        str_JoinUs = str_JoinUs & " <div class='ctr_btn'>"
        str_JoinUs = str_JoinUs & "   <label>"
        str_JoinUs = str_JoinUs & "     <input type='radio' id='ChangeUser' name='ChangeUser' value='"&LRs("MemberIDX")&"' />"
        str_JoinUs = str_JoinUs & "     <span class='sw_box'></span>"
        str_JoinUs = str_JoinUs & "   </label>"
        str_JoinUs = str_JoinUs & " </div>"
        str_JoinUs = str_JoinUs & "</li>"
        
        LRs.movenext
      Loop
    END IF
      LRs.Close
    SET LRs = Nothing
        
    CHG_JoinUsList = str_JoinUs   
    
  END FUNCTION
%>
<!-- S: change_account -->
<div class="modal fade change_account">
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <!-- S: modal-header -->
      <div class="modal-header">
        <h2>
          <span class="ic_deco">
            <i class="fa fa-refresh"></i>
          </span>
          <span class="txt">계정전환</span>
        </h2>
        <p>
          <span class="now">현재 계정</span>
          <span class="belong"><%=txt_Name%></span>
        </p>
      </div>
      <!-- E: modal-header -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <ul class="count_list">
        <%
    '테니스
'   response.Write CHG_JoinUsList("judo")
    response.Write CHG_JoinUsList(SportsGb)
    %>
        <!--
          <li class="tg on">
            <div class="cont">
              <p>테니스 생활체육(동호회) 선수 (경험없음)</p>
              <span class="join_date">가입일자:2017.11.15</span>
            </div>
            <div class="ctr_btn">
              <label>
                <input type="checkbox">
                <span class="sw_box"></span>
              </label>
            </div>
          </li>
          <li class="tg">
            <div class="cont">
              <p>테니스 생활체육(동호회) 선수 (경험없음)</p>
              <span class="join_date">가입일자:2017.11.15</span>
            </div>
            <div class="ctr_btn">
              <label>
                <input type="checkbox">
                <span class="sw_box"></span>
              </label>
            </div>
          </li>
          <li class="tg">
            <div class="cont">
              <p>테니스 생활체육(동호회) 선수 (경험없음)</p>
              <span class="join_date">가입일자:2017.11.15</span>
            </div>
            <div class="ctr_btn">
              <label>
                <input type="checkbox">
                <span class="sw_box"></span>
              </label>
            </div>
          </li>
        -->  
        </ul>

        <!-- S: make_sub -->
        <div class="make_sub">
          <a href="javascript:chk_onSubmit();">
            <span class="ic_deco">
              <i class="fa fa-plus-circle"></i>
            </span>
            <span class="txt">서브계정 생성</span>
            <span class="img_deco">
              <img src="../images/public/r_arr@3x.png" alt="">
            </span>
          </a>
        </div>
        <!-- E: make_sub -->

      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <ul class="modal-btn clearfix">
          <li>
            <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a>
          </li>
          <li>
            <a href="javascript:CHK_CHANGE_USER();" class="btn btn-ok">계정전환 적용</a>
          </li>
        </ul>
      </div>
      <!-- E: modal-footer -->
    </div>
    <!-- E: modal-content -->
  </div>
  <!-- E: modal-dialog -->
</div>
<!-- E: change_account -->
<script>
  //서브계정생성
  function chk_onSubmit(){
    alert("로그아웃 후 회원가입을 통해 서브계정을 생성합니다.");
    chk_logout(); 
  }


  //전환할 계정 선택
  function CHK_CHANGE_USER(){
    var strAjaxUrl = "../ajax/change_modal.asp";
	var ChangeUser = $('input:radio[name=ChangeUser]:checked').val(); 
	
	if(!$('input:radio[name=ChangeUser]').is(":checked")){                                
		alert('체크하세요');
		return;
	}

	
	if(confirm("계정전환을 진행하시겠습니까?")){
		$.ajax({
		  url: strAjaxUrl,
		  type: 'POST',
		  dataType: 'html',     
		  data: { ChangeUser : ChangeUser },    
		  success: function(retDATA) {
		  
			console.log(retDATA);
			
			if(retDATA){
			
			  var strcut = retDATA.split("|");
			  
			  if(strcut[0] == "TRUE") {   
				alert("계정전환이 완료되었습니다.");
	 //           $(location).attr('href', './user_account.asp');   
				$('.change_account').modal('hide');
				$('.user_type').text(strcut[1]);		//player_gnb.asp
				$('.belong').text(strcut[1]);			//change_modal.asp
				$('.player_belong').text(strcut[1]);	//mypage.asp
	
				
			  }
			  else{ //FALSE
				if(strcut[1] == 200) {
				  msg_log = "잘못된 접근입니다.\n확인 후 다시 이용하세요.";             
				}
				else{ //99
				  msg_log = "계정전환을 완료하지 못하였습니다.\n확인 후 다시 이용하세요.";
				}
				
				alert(msg_log);           
				return;
			  }
			}
		  }, 
		  error: function(xhr, status, error){           
			if(error!=""){
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
  
</script>