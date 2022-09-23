<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
	dim tIDX	: tIDX	= crypt.DecryptStringENC(fInject(request("tIDX")))
   	dim CIDX	: CIDX	= crypt.DecryptStringENC(fInject(request("CIDX")))
	dim i2		: i2	= fInject(request("i2"))
	
	dim CSQL, CRs
	dim UserName, UserEnName, Sex, ct_serial, RefereeGb
	

	IF tIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>" 
		response.End()
	Else  
  
		CSQL = "		SELECT A.GameRefereeIDX "
		CSQL = CSQL & "		,A.GameTitleIDX "
		CSQL = CSQL & "		,A.UserName "
		CSQL = CSQL & "		,A.UserEnName "
		CSQL = CSQL & "		,A.RefereeGb "
		CSQL = CSQL & "		,A.Sex "
		CSQL = CSQL & "		,A.ct_serial"
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitleReferee] A"
		CSQL = CSQL & "	WHERE A.DelYN = 'N'"
		CSQL = CSQL & "		AND A.GameTitleIDX = '"&tIDX&"'"
   		CSQL = CSQL & "		AND A.GameRefereeIDX = '"&CIDX&"'"
    
		SET CRs = DBCon.Execute(CSQL)
		IF NOT(CRs.Bof OR CRs.Eof) THEN
			UserName = ReHtmlSpecialChars(CRs("UserName"))
   			UserEnName = ReHtmlSpecialChars(CRs("UserEnName"))
			Sex = CRs("Sex")      
   			ct_serial = CRs("ct_serial")      
   			RefereeGb = CRs("RefereeGb")      
   
	 	End IF      
          	CRs.Close
      	SET CRs = Nothing
	End IF
%>
<script language="javascript">
	/**
	* left-menu 체크
	*/
	var locationStr = "GameTitleMenu/index"; // 대회
	/* left-menu 체크 */

	function chk_Submit(valType){
		switch(valType){
			case 'DEL'	:
				if(confirm('정보를 삭제하시겠습니까?'))	{
					on_Submit(valType);
				}
				else{return;}	
				break;

			case 'MOD': case 'SAVE'	:
				on_Submit(valType);	
				break;
			
			case 'LIST'	:
				$('form[name=s_frm]').attr('action','./GameTitle_Referee.asp');
				$('form[name=s_frm]').submit();				
				break;
			
			default		: 	window.history.back();	
		}
	}
	
    function on_Submit(valType){
      	var strAjaxUrl = '../../Ajax/GameTitleMenu/GameTitle_Referee_Mod.asp';
		
		if(valType=='MOD' || valType=='SAVE'){
				
			if(!$('#UserName').val()){
				alert('심판이름을 입력해 주세요.');
				$('#UserName').focus();
				return;
			}

			if(!$('#UserEnName').val()){
				alert('심판이름(영문)을 입력해 주세요.');
				$('#UserEnName').focus();
				return;
			}

			if(!$('#RefereeGb').val()){
				alert('심판구분을 선택해 주세요.');
				$('#RefereeGb').focus();
				return;
			}


			var UserName = $('#UserName').val();
			var UserEnName = $('#UserEnName').val();
			var RefereeGb = $('#RefereeGb').val();
			var Sex = $('#Sex').val();
			var Nationality = $('#Nationality').val();                               
		}
		
		var tIDX = $('#tIDX').val();
		var CIDX = $('#CIDX').val();
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: {
				valType			: valType
				,tIDX 			: tIDX
				,CIDX 			: CIDX
				,UserName 		: UserName
				,UserEnName 	: UserEnName
				,RefereeGb 		: RefereeGb
				,Sex 			: Sex
				,Nationality 	: Nationality
			},    
			success: function(retDATA) {

				console.log(retDATA);

				if(retDATA){
					var strcut = retDATA.split('|');
					var msg='';

					if (strcut[0] == 'TRUE') {
						switch(strcut[1]){
							case '80'   : msg='정보를 수정완료 하였습니다.'; break;
							case '70'   : msg='정보를 삭제완료 하였습니다.'; break;	
							default   	: msg='정보를 등록완료 하였습니다.'; //90
						}

						alert(msg);

						$('form[name=s_frm]').attr('action','./GameTitle_Referee.asp');
						$('form[name=s_frm]').submit(); 
					}
					else{  //FALSE|
						switch(strcut[1]){
							case '99'   : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							case '66'   : msg='정보를 업데이트하지 못하였습니다.\n시스템관리자에게 문의하십시오!'; break;
							default   	: msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
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
  
  
  	$(document).ready(function() {
    	make_box('sel_Nationality', 'Nationality', '<%=ct_serial%>', 'Info_Country'); 	//국가정보               
		make_box('sel_RefereeGb', 'RefereeGb', '<%=RefereeGb%>', 'Info_RefereeGb'); 	//심판정보               
  	}); 
</script> 
<!-- S : content -->
<section>
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>대회-심판등록</h2>
        <a href="javascript:history.back();" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i> 뒤로가기</span></a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li>대회-심판등록</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    
    <form name="s_frm" method="post">
      <input type="hidden" id="tIDX" name="tIDX" value="<%=fInject(request("tIDX"))%>" />   
	  <input type="hidden" id="CIDX" name="CIDX" value="<%=fInject(request("CIDX"))%>" />   	
      <input type="hidden" name="i2" id="i2" value="<%=i2%>">
      <table class="user_detail left-head view-table">
       
		<tr>
      <th>심판구분</th>
          <td id="sel_RefereeGb"><select name="RefereeGb" id="RefereeGb">
			  <option value="">심판구분선택</option>
			  </select></td>
        </tr> 
     <tr>
		 <tr>
        <th>국적</th>
        <td id="sel_Nationality"><select name="Nationality" id="Nationality" class="title_select">
          <option value="">국적선택</option>
          </select>
        </td>
      </tr>  
    <tr>
      <th>이름</th>
          <td><input type="text" name="UserName" id="UserName" class="in_2" value="<%=UserName%>"></td>
        </tr> 
	<tr>
      <th>영문이름</th>
          <td><input type="text" name="UserEnName" id="UserEnName" class="in_2" value="<%=UserEnName%>"></td>
        </tr> 
	
      <th>성별</th>
          <td><select name="Sex" id="Sex">
			  <option value="Man" <%IF Sex = "Man" Then response.write "selected" End IF%>>남</option>
			  <option value="WoMan" <%IF Sex = "WoMan" Then response.write "selected" End IF%>>여</option>
			  </select></td>
        </tr>  
      </table>
      <div class="c_btn btn-list-center">
		<%IF CIDX <> "" Then%> 
        <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정하기</a>
		 <a href="javascript:chk_Submit('DEL');" class="btn btn btn-red">삭제하기</a> 
		 <a href="javascript:chk_Submit('CANCEL');" class="btn btn-gray">취소</a> 
		<%Else%>
		<a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">등록</a>	
		<%End IF%>  
        <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a>        
      </div>
  
    </form>
  </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../../include/footer.asp"-->