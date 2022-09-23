<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
  <%
	dim CIDX          	: CIDX          	= crypt.DecryptStringENC(fInject(request("CIDX")))
	dim currPage        : currPage        	= fInject(request("currPage"))
	dim SDate           : SDate           	= fInject(request("SDate"))
	dim EDate           : EDate           	= fInject(request("EDate")) 
	dim fnd_KeyWord     : fnd_KeyWord     	= fInject(request("fnd_KeyWord"))
	dim fnd_MemberType  : fnd_MemberType    = fInject(request("fnd_MemberType"))


	dim CSQL, CRs
	dim MemberIDX, MemberType, MemberTypeNm, UserName
	dim TeamBefore, TeamBeforeNm, TeamAfter, TeamAfterNm, TransDate
	dim ApprovalGb, ApprovalGbNm, ApprDate, txtMemo

	IF CIDX <> "" Then 
  
		CSQL = "    	SELECT A.TeamTransferIDX"
		CSQL = CSQL & "		,A.MemberIDX"
		CSQL = CSQL & "		,A.MemberHisIDX"
   		CSQL = CSQL & "		,A.MemberType"
		CSQL = CSQL & "		,A.UserName"		
		CSQL = CSQL & "		,CASE A.MemberType WHEN 'L' THEN '지도자' ELSE '선수' END MemberTypeNm"
		CSQL = CSQL & "		,A.TeamBefore"
		CSQL = CSQL & "		,A.TeamAfter"
		CSQL = CSQL & "		,A.TransDate"
		CSQL = CSQL & "		,A.ApprovalGb"
		CSQL = CSQL & "		,B.PubName ApprovalGbNm"
		CSQL = CSQL & "		,CONVERT(CHAR(10), A.ApprDate, 102) ApprDate"
		CSQL = CSQL & "		,A.txtMemo"
		CSQL = CSQL & "		,[KoreaBadminton].[dbo].[FN_TeamName] (A.TeamBefore, left(A.TransDate, 4)) TeamBeforeNm "
		CSQL = CSQL & "		,[KoreaBadminton].[dbo].[FN_TeamName] (A.TeamAfter, left(A.TransDate, 4)) TeamAfterNm "
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamTransfer] A"
		CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] B on A.ApprovalGb = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'APPROVAL' "
		CSQL = CSQL & " WHERE A.DelYN = 'N'"
   		CSQL = CSQL & "   AND A.TeamTransferIDX = '"&CIDX&"'"
		
		SET CRs = DBCon.Execute(CSQL)
		IF NOT(CRs.Bof OR CRs.Eof) THEN
			MemberIDX = CRs("MemberIDX")
			MemberHisIDX = CRs("MemberHisIDX")
			MemberType = CRs("MemberType")
   			MemberTypeNm = CRs("MemberTypeNm")
			UserName = CRs("UserName")			
			TeamBefore = CRs("TeamBefore")
   			TeamBeforeNm = CRs("TeamBeforeNm")
			TeamAfter = CRs("TeamAfter")
   			TeamAfterNm = CRs("TeamAfterNm")		
			TransDate = CRs("TransDate")
			ApprovalGb = CRs("ApprovalGb")
			ApprovalGbNm = CRs("ApprovalGbNm")
			ApprDate = CRs("ApprDate")
			txtMemo = ReHtmlSpecialChars(CRs("txtMemo"))				
      	End IF      
          	CRs.Close
      	SET CRs = Nothing    
	End IF
%>
  <script language="javascript">
	/**
	* left-menu 체크
	*/
	var locationStr = "TeamTransfer_list";
	/* left-menu 체크 */

	function chk_Submit(valType){

		if(valType=='MOD' || valType=='SAVE'){
			on_Submit(valType); 
		}
		else if(valType=='LIST'){
			$(location).attr('href', './TeamTransfer_list.asp');
		}
		else{
			window.history.back();    
		}
	} 
	  
	function on_Submit(valType){     
		var strAjaxUrl = '../Ajax/TeamTransfer_Write.asp';

		if(!$('#UserName').val() || !$('#MemberIDX').val()){
			alert('이름을 입력해 주세요.');
			$('#UserName').focus();
			return;
		}

		if(!$('#TeamAfterNm').val() || !$('#TeamAfter').val()){
			alert('이적할 소속팀을 조회해 주세요.');
			$('#TeamAfterNm').focus();
			return;
		}
		
		/*
		if(!$('#TeamBeforeNm').val() || !$('#TeamBefore').val()){
			alert('현소속팀을 입력해 주세요.');
			$('#TeamBeforeNm').focus();
			return;
		}
		*/
		
		if(!$('#TransDate').val()){
			alert("이적일을 입력해 주세요.");
			$('#TransDate').focus();
			return;
		}
		
		if(!$('#ApprovalGb').val()){
			alert("동의서 여부를 선택해 주세요.");
			$('#ApprovalGb').focus();
			return;
		}
		
		var CIDX = $('#CIDX').val();	
		var MemberIDX = $('#MemberIDX').val();
		var MemberHisIDX = $('#MemberHisIDX').val();	
		var MemberType = $('input:radio[name=MemberType]:checked').val();
		var UserName = $('#UserName').val();
		var TeamBefore = $('#TeamBefore').val();
		var TeamBefore_Old = $('#TeamBefore_Old').val();
		var TeamAfter = $('#TeamAfter').val();
		var TeamAfter_Old = $('#TeamAfter_Old').val();
		var TransDate = $('#TransDate').val();
		var txtMemo = $('#txtMemo').val();
		var ApprovalGb = $('#ApprovalGb').val();
		

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: {
				CIDX 			: CIDX
				,MemberIDX 		: MemberIDX
				,MemberHisIDX 	: MemberHisIDX
				,UserName 		: UserName
				,MemberType 	: MemberType
				,TeamBefore 	: TeamBefore
				,TeamBefore_Old : TeamBefore_Old
				,TeamAfter 		: TeamAfter
				,TeamAfter_Old 	: TeamAfter_Old
				,TransDate 		: TransDate
				,txtMemo 		: txtMemo
				,ApprovalGb		: ApprovalGb
				,valType		: valType
			},    
			success: function(retDATA) {

				console.log(retDATA);

				if(retDATA){
					var strcut = retDATA.split('|');

					if (strcut[0] == 'TRUE') {
						alert('정보를 등록완료 하였습니다.');
						$('form[name=s_frm]').attr('action','./TeamTransfer_list.asp');
						$('form[name=s_frm]').submit(); 
					}
					else{  //FALSE|
						var msg='';

						switch(strcut[1]){
							case '99'   : msg='일치하는 정보가 없습니다.\n확인 후 이용하세요.'; break;
							case '66'   : msg='정보를 등록하지 못하였습니다.\n시스템관리자에게 문의하십시오.'; break;
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
	
	//선수/지도자 조회
	function CHK_MEMBER(){
		
		if(!$('input:radio[name=MemberType]').is(':checked')){
			alert('선수/지도자 구분을 선택해 주세요.');
			$('MemberType').focus();
			return;
		}
		
		if(!$('#UserName').val()){
			alert('조회할 선수이름을 입력해 주세요.');
			$('#UserName').focus();
			return;
		}   
		
		$('.detail_player').modal('show');

		var strAjaxUrl = '../ajax/TeamTransfer_Write_Member.asp'; 
		var fnd_UserName = $('#UserName').val();
		var fnd_MemberType = $('input:radio[name=MemberType]:checked').val();

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false, 
			data: {     
				fnd_UserName   	: fnd_UserName 
				,fnd_MemberType : fnd_MemberType
			},
			success: function(retDATA) {

				//console.log(retDATA);

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
	
	//선수/지도자 조회  Input field 정보 넣기
	function INPUT_MEMBERINFO(valMemberHisIDX, valMemberIDX, valUserName, valTeam, valTeamNm){
		$('#MemberHisIDX').val(valMemberHisIDX);
		$('#MemberIDX').val(valMemberIDX);
		$('#UserName').val(valUserName);		
		$('#TeamBefore').val(valTeam);		
		$('#TeamBeforeNm').val(valTeamNm);		
		$('.detail_player').modal('hide');
		$('#TeamAfterNm').focus();		
	}  	  
	  
	//선수/지도자 radio btn 변경시 초기화  
	$(document).on('change','input:radio[name=MemberType]', function(){
		$('#UserName').val('');
		$('#MemberIDX').val('');
		$('#MemberHisIDX').val('');
		$('#TeamBefore').val('');
		$('#TeamBeforeNm').val('');
	});

	  
	//이적 소속팀 조회
	function CHK_TEAMINFO(){
		var strAjaxUrl = '../Ajax/Fnd_TeamInfo.asp';
		var fnd_TeamNm = $('#TeamAfterNm').val();

		if(!fnd_TeamNm) {
			alert('이적할 팀명을 입력해주세요.');
			$('#TeamAfterNm').focus();
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

	//이적 소속팀 Input field 정보 넣기
	function Input_TeamInfo(valTeam, valTeamNm){
		$('#TeamAfter').val(valTeam);
		$('#TeamAfterNm').val(valTeamNm);  
		$('#fnd_team').modal('hide');
	}
  
  	$(document).ready(function() {
    	make_box('sel_ApprovalGb', 'ApprovalGb', '<%IF ApprovalGb <> "" Then response.write ApprovalGb End IF%>', 'ApprovalGb'); //코치구분 셀렉박스 목록 생성 	
  	}); 
</script> 
  <!-- S : content -->
  <section>
    <div id="content"> 
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>소속팀 이적</h2>
        <a href="./LeaderInfo_list.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a> 
        
        <!-- S: 네비게이션 -->
        <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li>소속팀 이적관리</li>
          </ul>
        </div>
        <!-- E: 네비게이션 --> 
        
      </div>
      <!-- E: page_title -->
     
      <form name="s_frm" method="post">
		  
		  <input type="hidden" name="CIDX" id="CIDX" value="<%=request("CIDX")%>">
		  <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>">
		  <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>">
		  <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>">
		  <input type="hidden" name="fnd_MemberType" id="fnd_MemberType" value="<%=fnd_MemberType%>">
		  <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>">
		  
		  
        <table class="left-head view-table profile-table thin-border">
          <tr>
            <th>구분</th>
            <td colspan="3"><label>
                <input type="radio" name="MemberType" id="MemberType" value="L" <%IF MemberType = "L" Then response.write "checked" End IF%>>
                <span class="txt">지도자</span> </label>
              <label>
                <input type="radio" name="MemberType" id="MemberType" value="P" <%IF MemberType = "P" Then response.write "checked" End IF%>>
                선수 </label></td>
          </tr>
          <tr>
            <th>이름</th>
            <td colspan="3"><input type="text" name="UserName" id="UserName" class="ipt-word" value="<%=UserName%>">
              <input type="hidden" name="MemberIDX" id="MemberIDX" value="<%=MemberIDX%>">
			  <input type="hidden" name="MemberHisIDX" id="MemberHisIDX" value="<%=MemberHisIDX%>">	
              <a href="javascript:CHK_MEMBER();" class="btn btn-confirm"> 조회</a></td>
          </tr>
          <tr>
            <th>현소속팀</th>
            <td><input type="text" name="TeamBeforeNm" id="TeamBeforeNm" class="ipt-word" readonly value="<%=TeamBeforeNm%>">
              <input type="hidden" name="TeamBefore" id="TeamBefore" value="<%=TeamBefore%>">
			  <input type="hidden" name="TeamBefore_Old" id="TeamBefore_Old" value="<%=TeamBefore%>">
			  </td>
            <th>이적팀</th>
            <td><input type="text" name="TeamAfterNm" id="TeamAfterNm" class="ipt-word" value="<%=TeamAfterNm%>">
              <input type="hidden" name="TeamAfter" id="TeamAfter" value="<%=TeamAfter%>">
			  <input type="hidden" name="TeamAfterOld" id="TeamAfterOld" value="<%=TeamAfter%>">	
              <a href="javascript:CHK_TEAMINFO();" class="btn btn-confirm">이적팀 조회</a></td>
          </tr>
		  <tr>
            <th>동의서여부</th>
            <td id="sel_ApprovalGb"><select name="ApprovalGb" id="ApprovalGb">
							<option value=''>동의서여부</option>
						</select></td>
						<th>이적일</th>
            <td><input type="date" name="TransDate" id="TransDate" maxlength="10" class="date_ipt" value="<%=TransDate%>" <%IF TransDate="" Then%> placeholder="2017-07-01"<%End IF%>></td>

          </tr>	
					
		  <tr>
            <th>메모</th>
            <td colspan="3"><textarea type="text" name="txtMemo" id="txtMemo" value="" placeholder="메모할 내용을 입력해 주세요."><%=txtMemo%></textarea></td>
          </tr>	
        </table>
		<%IF CIDX<>"" Then%>
      <div class="c_btn btn-list-center"> <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
      <%Else%>
      <div class="c_btn btn-list-center"> <a href="javascript:chk_Submit('SAVE');" class="btn btn-add">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
      <%End IF%>		
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
              <div id="team_contents" class="table-list-wrap scroll-box"> </div>
              <div class="btn_list"> <a href="#" class="btn-close"  data-dismiss="modal">닫기</a> </div>
            </div>
          </div>
        </div>
      </div>
      <!-- e: Modal 팀조회 목록 View Modal--> 
      
      <!-- s: Modal등록동호인 목록 View Modal-->
      <div class="modal fade detail_player srch_player" id="detail_player" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="btn btn-close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h3 class="modal-title" id="myModalLabel">목록 보기</h3>
            </div>
            <div class="modal-body">
              <div id="player_contents" class="table-list-wrap"> </div>
              <div class="btn_list"> <a href="#" class="btn btn-confirm" data-dismiss="modal">닫기</a> </div>
            </div>
          </div>
        </div>
      </div>
      <!-- e: Modal등록동호인 목록 View Modal--> 
    </div>
  </section>
  <!-- E : content --> 
  <!-- E : container --> 
  <!--#include file="../include/footer.asp"-->