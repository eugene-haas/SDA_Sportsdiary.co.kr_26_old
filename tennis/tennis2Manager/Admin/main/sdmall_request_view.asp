<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%
	dim currPage      	: currPage        	= fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord     	= fInject(Request("fnd_KeyWord"))  
	dim fnd_ResultGb   	: fnd_ResultGb     	= fInject(Request("fnd_ResultGb"))  
	dim SDate			: SDate	 			= fInject(Request("SDate"))		
	dim EDate			: EDate	 			= fInject(Request("EDate"))	
	dim CIDX			: CIDX 				= decode(fInject(trim(request("CIDX"))), 0)   

   	dim LSQL, LRs
   	dim Subject, CompanyNm, ProductGbNm, ZipCode, Address, AddressDtl, CompanyURL, txtContent, InsDate, ModDate
    dim UserName, UserPhone, UserEmail, PrivacyYN
   	dim ResultGb, ResultDate, txtReContent
   
   	IF CIDX <> "" Then
		LSQL = "		SELECT * "	
		LSQL = LSQL & "	FROM [SD_Member].[dbo].[tblAllianceInfo] "	
		LSQL = LSQL & "	WHERE DelYN = 'N'"	
		LSQL = LSQL & "		AND AllianceIDX = '"&CIDX&"'"

		SET LRs =  DBCon.Execute(LSQL)  
		IF Not(LRs.Eof OR LRs.Bof) Then
			Subject = ReplaceTagReText(LRs("Subject"))	
			CompanyNm = ReplaceTagReText(LRs("CompanyNm"))	
			ProductGbNm = ReplaceTagReText(LRs("ProductGbNm"))	
			ZipCode = LRs("ZipCode")	
			Address = ReplaceTagReText(LRs("Address"))	
			AddressDtl = ReplaceTagReText(LRs("AddressDtl"))	
			CompanyURL = ReplaceTagReText(LRs("CompanyURL"))	
			txtContent = ReplaceTagReText(LRs("txtContent"))	
			InsDate = LRs("InsDate")	
			ModDate = LRs("ModDate")	
			UserName = ReplaceTagReText(LRs("UserName"))	
			UserPhone = ReplaceTagReText(LRs("UserPhone"))	
			UserEmail = ReplaceTagReText(LRs("UserEmail"))	
			PrivacyYN = LRs("PrivacyYN")	
			ResultGb = LRs("ResultGb")	
			ResultDate = LRs("ResultDate")	
			txtReContent = ReplaceTagReText(LRs("txtReContent"))		
		Else
			response.write "<script>"
			response.write "	alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"		
			response.write "	history.back();"	
			response.write "</script>"	
			response.end
		End IF
			LRs.Close
		SET LRs = Nothing
	Else
		response.write "<script>"
		response.write "	alert('잘못된 접근입니다. 확인 후 이용하세요.');"		
		response.write "	history.back();"	
		response.write "</script>"	
		response.end
	End IF

%>
<script>
	function chk_Submit(valType){	
		
		switch(valType){
			case 'MOD' 	:
				if(!$('#txtReContent').val()){
					alert('처리내용을 입력해 주세요.');
					$('#txtReContent').focus();
					return;
				} 
				on_Submit(valType);
				break;
			case 'DEL' 	: 
				if(confirm('선택하신 정보를 삭제하시겠습니까?')){
					on_Submit(valType);	
				}
				else{
					return;
				}
				break;
			default		:	
				$('form[name=s_frm]').attr('action','./sdmall_request_list.asp');
				$('form[name=s_frm]').submit();	
	  	}
	}
			
	function on_Submit(valType){
		
		var strAjaxUrl = './Ajax/sdmall_request_view.asp';															
		var txtReContent = $('#txtReContent').val();
		var ResultGb = $('#ResultGb').val();  
		var CIDX = $('#CIDX').val();  

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: { 
				valType 		: valType 
				,txtReContent 	: txtReContent
				,ResultGb 		: ResultGb 	
				,CIDX 			: CIDX 		
			},    
			success: function(retDATA) {

				console.log(retDATA);

				if(retDATA){

					var strcut = retDATA.split('|');

					if (strcut[0]=='TRUE') {
						var txtMsg = '';
						var txtUrl = '';
						
						if(strcut[1]=='MOD'){
							alert('처리내용을 업데이트하였습니다.'); 
							$('form[name=s_frm]').attr('action','./sdmall_request_view.asp');
							$('form[name=s_frm]').submit();
						}
						else{	//DEL
							alert('성공적으로 삭제처리하였습니다.'); 
							$('form[name=s_frm]').attr('action','./sdmall_request_list.asp');
							$('form[name=s_frm]').submit();
						}						
					}
					else{  //FALSE|

						var msg='';

						switch(strcut[1]){
							case '66'  	: msg='업데이트를 하지못하였습니다.\n관리자에게 문의하십시오.'; break;
							default		: msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.';  //200            
						}
						alert(msg);
						return;
					}
				}
			}, 
			error: function(xhr, status, error){           
				if(error!=''){
					alert('오류발생! - 시스템관리자에게 문의하십시오!');     
					return;
				}
			}
		}); 
	}							

</script>
<section>
  <div id="content">
    <form name="s_frm" method="post">
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
	  <input type="hidden" name="fnd_ResultGb" id="fnd_ResultGb" value="<%=fnd_ResultGb%>" />		
	  <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
	  <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />	  
      <input type="hidden" name="CIDX" id="CIDX" value="<%=request("CIDX")%>" />
      <!-- S: 네비게이션 -->
      <div class="navigation_box">광고/제휴·입점 관리 &gt; 제휴·입점 관리 &gt;  제휴·입점 관리</div>
      <!-- E: 네비게이션 --> 
      <br />
      <!-- S: basic-view -->
      <table class="Community_wtite_box" cellspacing="0" cellpadding="0">
        <thead>
          <tr>
            <th>제목</th>
            <td><%=Subject%></td>
          </tr>
          <tr>
            <th>회사명</th>
            <td><%=CompanyNm%></td>
          </tr>
          <tr>
            <th>취급상품군</th>
            <td><%=ProductGbNm%></td>
          </tr>
          <tr>
            <th>회사주소</th>
            <td>(<%=ZipCode%>)<%=Address%> <%=AddressDtl%></td>
          </tr>
          <tr>
            <th>회사 URL</th>
            <td><a href="http://<%=CompanyURL%>" target="_blank"><%=CompanyURL%></a></td>
          </tr>
          <tr>
            <th>담당자명</th>
            <td><%=UserName%></td>
          </tr>
          <tr>
            <th>연락처</th>
            <td><%=UserPhone%></td>
          </tr>
          <tr>
            <th>이메일</th>
            <td><%=UserEmail%></td>
          </tr>
          <tr>
            <th>문의 내용</th>
            <td><p><%=txtContent%></p></td>
          </tr>
          <tr>
            <th>개인정보수집 및<br>
              이용동의</th>
            <td><%=PrivacyYN%></td>
          </tr>
          <tr>
            <th>접수일</th>
            <td><p><%=InsDate%></p></td>
          </tr>
        </thead>
      </table>
			<table  class="Community_wtite_box" cellspacing="0" cellpadding="0" style="margin-top:30px;">
          <tr>
            <th>처리내용</th>
            <td><textarea id="txtReContent" name="txtReContent"><%=txtReContent%></textarea></td>
          </tr>
          <tr>
            <th>처리구분</th>
            <td><select id="ResultGb" name="ResultGb">
                <option value="stan" <%IF ResultGb = "stan" Then response.write "selected" End IF%>>대기중</option>
                <option value="take" <%IF ResultGb = "take" Then response.write "selected" End IF%>>처리중</option>
                <option value="comp" <%IF ResultGb = "comp" Then response.write "selected" End IF%>>처리완료</option>
                <option value="canc" <%IF ResultGb = "canc" Then response.write "selected" End IF%>>취소</option>
              </select></td>
          </tr>
          <tr>
            <th>처리일</th>
            <td><p><%=ResultDate%></p></td>
          </tr>
			</table>
      <!-- E: basic-view -->
      
      <div class="btn_list"> <a href="javascript:chk_Submit('LIST');" class="btn btn-grayline">목록</a>
        <%IF CIDX <> "" Then%>
        <a href="javascript:chk_Submit('MOD');" class="btn btn-orangy">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn btn-redy">삭제</a>
        <%End IF%>
      </div>
    </form>
  </div>
</section>
<!--#include file="footer.asp"-->