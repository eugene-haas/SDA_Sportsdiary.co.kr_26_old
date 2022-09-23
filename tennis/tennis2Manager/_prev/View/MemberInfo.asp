<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
	
	dim SDate : SDate = replace(request("SDate"),"/","-")
	dim EDate : EDate = replace(request("EDate"),"/","-")
	
%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script language="javascript">
	//검색
	function chk_Submit(chkPage){
		
		var strAjaxUrl = "../Ajax/MemberInfo_list.asp";    
		
		var fnd_EnterType = $("#fnd_EnterType").val();
		var fnd_SEX = $("#fnd_SEX").val();
		var fnd_User = $("#fnd_User").val();
		var fnd_PlayerReln = $("#fnd_PlayerReln").val();
		var fnd_Team = $("#fnd_Team").val();
		var SDate = $("#SDate").val();
		var EDate = $("#EDate").val();
		
		if(chkPage!="") $("#currPage").val(chkPage);
		
		var currPage = $("#currPage").val();
	
		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",     
			data: { 
				currPage    	: currPage     
				,fnd_EnterType  : fnd_EnterType   
				,fnd_SEX     	: fnd_SEX        
				,fnd_User  		: fnd_User  
				,fnd_PlayerReln	: fnd_PlayerReln
				,fnd_Team		: fnd_Team
				,SDate			: SDate
				,EDate			: EDate
			},    
			success: function(retDATA) {
				$("#board-contents").html(retDATA);       
			}, 
			error: function(xhr, status, error){           
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
			}
		});     
		
	}
	
	$(document).ready(function(){
		$("#SDate").val('<%=SDate%>');
		$("#EDate").val('<%=EDate%>');
		
		chk_Submit(1);					   
	});
</script>
<body>
<form name="s_frm" method="post">
	<input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    
  <!-- S : content -->
  <section>
    <div id="content">
      <div class="loaction"> <strong>회원관리</strong> &gt; 회원명단</div>
      <!-- S : top-navi -->
      <!-- E : top-navi -->
      <!-- S : sch 검색조건 선택 및 입력 -->
      <div class="sch">
        <table class="sch-table">
          <tbody>
            <tr>
              <th scope="row">가입날짜</th>
              <td><input type="date" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" />-<input type="date" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" /></td>
                
              
              
              <th scope="row">구분</th>
              <td><select name="fnd_EnterType" id="fnd_EnterType">
                  <option value="" selected>===전체===</option>
                  <option value="E">엘리트</option>
                  <option value="A">생활체육</option>
                </select></td>
              <th scope="row">회원구분</th>
              <td><select name="fnd_PlayerReln" id="fnd_PlayerReln">
                  <option value="" selected>===전체===</option>
                  <option value="R">선수(관원)</option>
                  <option value="T">지도자(관장/사범)</option>
                  <option value="P">보호자</option>
                  <option value="D">일반</option>
                </select></td>  
              <th scope="row">성별</th>
              <td><select name="fnd_SEX" id="fnd_SEX">
                  <option value="" selected>===전체===</option><em></em>>
                  <option value="Man">남자</option>
                  <option value="WoMan">여자</option>
                </select></td>
              <th>소속</th>
              <td><input type="text" name="fnd_Team" id="fnd_Team" /></td>  
              <th>이름</th>
              <td><input type="text" name="fnd_User" id="fnd_User" /></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="btn-right-list"> <a href="javascript:chk_Submit();" class="btn" accesskey="s">검색(S)</a> </div>
      <!-- E : sch 검색조건 선택 및 입력 -->
      <!-- S : 리스트형 20개씩 노출 -->
      <div id="board-contents" class="table-list-wrap">
        <!-- S : table-list -->
        
        <!-- E : table-list -->
      </div>
      <!-- E : 리스트형 20개씩 노출 -->
    </div>
  </section>
</form>
<!-- E : content -->
</div>
<!-- E : container -->
<script src="../js/js.js"></script>
</body>
