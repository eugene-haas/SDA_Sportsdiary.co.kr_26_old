<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	'공지사항 상세페이지
	
	dim SportsGb				: SportsGb				= "tennis"
	dim currPage   				: currPage    			= fInject(Request("currPage"))
	dim IDX 					: IDX   				= fInject(Request("IDX"))	
	dim Search_GameTitleIDX 	: Search_GameTitleIDX   = fInject(Request("Search_GameTitleIDX"))
    dim Search_TeamGbIDX 		: Search_TeamGbIDX		= fInject(Request("Search_TeamGbIDX"))

	ControlSql ="  exec Stadium_Sketch_view @idx ='"&idx&"' "

	Response.write ControlSql
	SET CRs = DBCon7.Execute(ControlSql)	
	IF NOT(CRs.Bof OR CRs.Eof) Then		
		GameYear	  = CRs("GameYear")
		Idx			  = CRs("Idx")
		GAMETITLENAME = CRs("GAMETITLENAME")
		TeamGbNm	  = CRs("TeamGbNm")
		Delyn		  = CRs("Delyn")
		userid		  = CRs("userid")
		username	  = CRs("username")
		Writeday	  = CRs("Writeday")		
		viewcnt		  = CRs("viewcnt")		
	ELSE					
		response.Write "<script>"	
		response.Write "	alert('일치하는 정보가 없습니다.');"
		response.Write "	history.back();"
		response.Write "</script>"	
		response.End()
		
	End IF
		CRs.Close
	SET CRs = Nothing
%>
<script>
	function chk_Submit(valType){
		//alert(valType);
		
		if(valType == "LIST"){	//공지사항 목록페이지
			$('form[name=s_frm]').attr('action',"./GMS_Stadium_Sketch_Sd.asp");		
			$('form[name=s_frm]').submit(); 
		}
		else if(valType == "MOD"){	//공지사항 수정
			$('form[name=s_frm]').attr('action',"./GMS_Stadium_Sketch_Write_Sd.asp");		
			$('form[name=s_frm]').submit(); 
		}
		else{	//공지사항 수정/삭제		

			$("#act").val("DEL");
			
			var strAjaxUrl = "../Ajax/noticeBoard_ok.asp";
			var CIDX = $("#CIDX").val();
			var act = $("#act").val();
			var SportsGb = $("#SportsGb").val();
			
			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",     
				data: { 
						CIDX   	: CIDX       
						,act   		: act       
						,SportsGb	: SportsGb       
					},    
				success: function(retDATA) {
					if(retDATA){
						var strcut = retDATA.split("|");
						
						if (strcut[0]=="TRUE" && strcut[1] == 100) { 
							alert('선택하신 정보를 삭제하였습니다.');
							$('form[name=s_frm]').attr('action',"./noticeBoard.asp");		
							$('form[name=s_frm]').submit(); 
						}
						else{
							alert("잘못된 접근입니다.\n확인 후 다시 이용하세요.");               
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
	}	

  function Sketch_Result(sk_gubun, idx)
  {
		if (confirm("정말 삭제하시겠습니까??") == true){    //확인
			var strAjaxUrl="GMS_Stadium_Sketch_Result_Sd.asp?sk_gubun="+sk_gubun+"&idx="+idx;
			//location.href = strAjaxUrl
			//alert(strAjaxUrl);
				var retDATA="";
				//alert(strAjaxUrl);
				 $.ajax({
					 type: 'GET',
					 url: strAjaxUrl,
					 dataType: 'html',
					 success: function(retDATA) {
						if(retDATA)
							{
								if(retDATA=='TRUE')
								{	
									alert('삭제완료');
									document.s_frm.action="GMS_Stadium_Sketch_Sd.asp"
									document.s_frm.submit();
								}
								else
								{
									alert('error')
									return;
								}
							}
					 }
				 }); //close $.ajax(
		}
  }
</script>	
<section>
  <div id="content">
<form name="s_frm" method="post">
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />    
    <input type="hidden" name="Search_GameTitleIDX" id="Search_GameTitleIDX" value="<%=Search_GameTitleIDX%>" />
    <input type="hidden" name="Search_TeamGbIDX" id="Search_TeamGbIDX" value="<%=Search_TeamGbIDX%>" />
    <input type="hidden" name="IDX" id="IDX" value="<%=IDX%>" />	
    <input type="hidden" name="act" id="act" />
     <!-- S: 네비게이션 -->
      <div class="navigation_box">
	 <strong>경기관리</strong> &gt; 현장스케치 - SD
	  </div>
      <!-- E: 네비게이션 -->
 <br />
        <!-- S: basic-view -->
        <table class="Community_wtite_box">
          <thead>
            <tr>
              <th>대회</th>
              <td colspan="3" style="width:80%;">[<%=GameYear%>]<%=GAMETITLENAME%></td>
            </tr>
            <tr>
              <th>종별</th>
              <td style="width:40%;"><%=TeamGbNm%></td>
 
              <th>작성자</th>
              <td style="width:40%;"><%=UserName%></td>
            </tr>
			<tr>
              <th>작성일</th>
              <td><%=Replace(Writeday,"-",".")%></td>
 
              <th>조회수</th>
              <td><%=viewcnt%></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="4">
				  <%
					ControlSql =" exec Stadium_Sketch_admin_ajax @sketch_idx= '"&idx&"' "	

					SET CRs = DBCon7.Execute(ControlSql)	

				  %>
					
				 <%
					If Not(CRs.Eof Or CRs.Bof) Then 
						Do Until CRs.Eof 
				 %>
						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/<%=CRs("Photo")%>"><br>
				 <%
							CRs.MoveNext
						Loop 
					End If 
				 %>
			  </td>
            </tr>
          </tbody>
        </table>
        <!-- E: basic-view -->

        <div class="btn_list">
          
              <a href="javascript:chk_Submit('LIST');" class="btn btn-grayline">목록</a>
              <a href="javascript:chk_Submit('MOD');" class="btn btn-orangy">수정</a>
              <a href="javascript:Sketch_Result('content_delete','<%=IDX%>');" class="btn btn-redy">삭제</a>
          
        </div>

  </form>
  </div>
</section>
<!--#include file="footer.asp"-->