<!--#include file="../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../include/head.asp" --> 
  <!-- E: head -->
  <% 
  RoleType = "MEMALLLIST"	    '통합회원 목록   

  dim currPage   		: currPage  		= fInject(Request("currPage"))
  dim fnd_KeyWord  	: fnd_KeyWord 	    = fInject(Request("fnd_KeyWord"))
  dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	                                 
  dim fnd_SMS   		: fnd_SMS 			= fInject(Request("fnd_SMS"))	                                 
  dim fnd_Email   	: fnd_Email 		= fInject(Request("fnd_Email"))	                                                                  
  dim fnd_Push   		: fnd_Push 			= fInject(Request("fnd_Push"))	  
  dim SDate           : SDate             = replace(fInject(request("SDate")), "/", "-")
  dim EDate           : EDate             = replace(fInject(request("EDate")), "/", "-")                                 
  
%>
  <!--#include file="./CheckRole.asp"--> 
  <script language="javascript">
	
	function chk_Submit(valType, valIDX, chkPage){
		if(chkPage) $('#currPage').val(chkPage);
   
		var strAjaxUrl = '../Ajax/Member_Info_list.asp';    
		var fnd_SEX = $('#fnd_SEX').val();
        var fnd_SMS = $('#fnd_SMS').val();
        var fnd_Email = $('#fnd_Email').val();
        var fnd_Push = $('#fnd_Push').val();
		var fnd_KeyWord = $('#fnd_KeyWord').val();
		var SDate = $('#SDate').val();
		var EDate = $('#EDate').val();		
		var currPage = $('#currPage').val();
                                    
        if(valType=='VIEW'){
            $('#CIDX').val(valIDX);
            $('form[name=search_frm]').attr('action','./member_info_detail.asp');
            $('form[name=search_frm]').submit();	
        }
        else{
            $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',     
                data: { 
                    currPage    	: currPage     
                    ,fnd_SEX     	: fnd_SEX        
                    ,fnd_KeyWord  	: fnd_KeyWord  
                    ,fnd_SMS  	    : fnd_SMS  
                    ,fnd_Email  	: fnd_Email  
                    ,fnd_Push  	    : fnd_Push              
                    ,SDate			: SDate
                    ,EDate			: EDate
                },    
                success: function(retDATA) {
                    $('#board-contents').html(retDATA);       
                }, 
                error: function(xhr, status, error){           
                    if(error!=''){
                        alert ('오류발생['+error+']! - 시스템관리자에게 문의하십시오!');
                        return;
                    }
                }
            }); 
        }		    		
	}
	
    $(function() {
        $('#SDate').datepicker({
            dateFormat: 'yy-mm-dd'
        });

        $('#EDate').datepicker({
            dateFormat: 'yy-mm-dd'
        });
    });
                                  
    
    // 엔터키가 눌렸을 때 실행할 내용                                  
    function enterkey() {
		if (window.event.keyCode == 13) chk_Submit('FND', '', 1);
	}
                                  
    
	$(document).ready(function(){
		$('#SDate').val('<%=SDate%>');
		$('#EDate').val('<%=EDate%>');
		
		chk_Submit('FND', '', '<%IF currPage <> "" Then response.write currPage End IF%>');					   
	});
</script>
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
      <div class="pd-30 right-bg">
        <form method="post" name="search_frm" id="search_frm" >
					<input type="hidden" id="currPage" name="currPage" value="<%=currPage%>">
					<input type="hidden" id="CIDX" name="CIDX">
          <!-- S: sub-content -->
          <div class="sub-content">
            <div class="box-shadow">
              <div class="search-box">
								<ul>
									<li>
										<span class="l-title">가입일</span>
										<span class="r-con in-48">
											<!--<span>가입일</span>-->
											<input type="text" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" <%IF SDate=""Then%> placeholder="2018-07-01"<%End IF%>>
											<span class="center-line">-</span>
											<input type="text" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" <%IF EDate=""Then%> placeholder="2018-07-01"<%End IF%>>
										</span>
									</li>
									<li>
										<select name="fnd_SEX" id="fnd_SEX">
											<option value="" selected>성별</option>
											<option value="Man" <%IF fnd_Sex = "Man" Then response.write "selected" End IF%>>남자</option>
											<option value="WoMan" <%IF fnd_Sex = "WoMan" Then response.write "selected" End IF%>>여자</option>
										</select>
									</li>
									<li>
										<select name="fnd_SMS" id="fnd_SMS">
											<option value="" selected>SMS수신</option>
											<option value="Y" <%IF fnd_SMS = "Y" Then response.write "selected" End IF%>>Y</option>
											<option value="N" <%IF fnd_SMS = "N" Then response.write "selected" End IF%>>N</option>
										</select>
									</li>
									<li>
										<select name="fnd_Email" id="fnd_Email">
											<option value="" selected>이메일수신</option>
											<option value="Y" <%IF fnd_Email = "Y" Then response.write "selected" End IF%>>Y</option>
											<option value="N" <%IF fnd_Email = "N" Then response.write "selected" End IF%>>N</option>
										</select>
									</li>
									<li>
										<select name="fnd_Push" id="fnd_Push">
											<option value="" selected>앱알림수신</option>
											<option value="0" <%IF fnd_Push = "0" Then response.write "selected" End IF%>>미설정</option>
											<option value="Y" <%IF fnd_Push = "Y" Then response.write "selected" End IF%>>Y</option>
											<option value="N" <%IF fnd_Push = "N" Then response.write "selected" End IF%>>N</option>
										</select>
									</li>
									<li>
										<input type="text" name="fnd_KeyWord" id="fnd_KeyWord" class="in-1" placeholder="아이디, 이름, 생년월일, 전화번호, 이메일, 주소" onkeyup="enterkey();">
									</li>
									<li>
										<a href="javascript:chk_Submit('FND','', 1);" class="btn btn-primary" id="btnview" accesskey="S">검색(S)</a>
									</li>
								</ul>
							</div>
            </div>
            <div class="mem_DayRegistMember_all member_info">
              <div class="table-box basic-table-box">
                <div id="board-contents"></div>
              </div>
            </div>
          </div>
          <!-- E: sub-content -->
        </form>
      </div>
      <!-- E: pd-15 --> 
    </div>
    <!-- E: right-content --> 
  </div>
  <!-- S: footer --> 
  <!-- #include file="../include/footer.asp" -->
<!-- E: footer -->
<%
    DBClose8()
%>
