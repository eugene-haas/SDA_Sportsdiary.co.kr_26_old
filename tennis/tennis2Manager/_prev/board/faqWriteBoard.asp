<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'FAQ 등록/수정페이지
	
	dim SportsGb		: SportsGb			= request.Cookies("SportsGb")
	dim UserID			: UserID 			= Request.Cookies("UserID")  			'작성자 ID
	dim UserName		: UserName	 		= Request.Cookies("UserName")			'작성자 이름
	
	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord    	= fInject(Request("fnd_KeyWord"))
	dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
	dim CIDX 			: CIDX   			= fInject(Request("CIDX"))				'FaqIDX
	
'	response.Write "CIDX="&CIDX&"<br>"
	
	IF CIDX <> "" Then
		CSQL =  "       SELECT Q.FaqIDX  "
		CSQL = CSQL & "     ,Q.FAPubCode  "
		CSQL = CSQL & "   	,CASE Q.FAPubCode WHEN 'FA01' THEN '전체' WHEN 'FA02' THEN '선수' WHEN 'FA03' THEN '선수보호자' WHEN 'FA04' THEN '팀매니저' END FAPubCodeNm"	
		CSQL = CSQL & "     ,Q.ReFaqIDX  "
		CSQL = CSQL & "     ,Q.Title  "
		CSQL = CSQL & "     ,Q.Contents  "
		CSQL = CSQL & "     ,Q.WriteDate  " 
		CSQL = CSQL & "     ,Q.WriteName   " 
		CSQL = CSQL & "     ,CASE WHEN A.FaqIDX IS NULL OR A.FaqIDX ='' THEN '' END RFaqIDX "
		CSQL = CSQL & "     ,A.ReFaqIDX RReFaqIDX "
		CSQL = CSQL & "     ,A.Title RTitle "
		CSQL = CSQL & "     ,A.Contents RContents "
		CSQL = CSQL & "     ,A.WriteName RWriteName " 
		CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcFaq] Q "
		CSQL = CSQL & " 	left join [Sportsdiary].[dbo].[tblSvcFaq] A on Q.FaqIDX = A.ReFaqIDX"
		CSQL = CSQL & " 		AND A.DelYN = 'N' "
		CSQL = CSQL & " 		AND A.SportsGb = '"&SportsGb&"' "	
		CSQL = CSQL & " WHERE Q.DelYN = 'N' "
		CSQL = CSQL & " 	AND Q.SportsGb = '"&SportsGb&"' "	
		CSQL = CSQL & "     AND (Q.FaqIDX = '"&CIDX&"' OR A.ReFaqIDX = '"&CIDX&"') " 
		
'		response.Write CSQL
	'	response.End()
		
		SET CRs = Dbcon.Execute(CSQL)	
		IF NOT(CRs.Bof OR CRs.Eof) Then					
			
			FaqIDX = CRs("FaqIDX")
			FAPubCode = CRs("FAPubCode")
			FAPubCodeNm = CRs("FAPubCodeNm")
			ReFaqIDX = CRs("ReFaqIDX")
			WriteName = CRs("WriteName")
			Title = ReplaceTagReText(CRs("Title"))
			Contents = replace(ReplaceTagReText(CRs("Contents")), "<br>", chr(10))		
			WriteDate = CRs("WriteDate")
			
			RFaqIDX = CRs("RFaqIDX")
			RReFaqIDX = CRs("RReFaqIDX")
			RWriteName = CRs("RWriteName")
			RTitle = ReplaceTagReText(CRs("RTitle"))
			RContents = replace(ReplaceTagReText(CRs("RContents")), "<br>", chr(10))		
			RWriteName = CRs("RWriteName")
			
		ELSE					
			response.Write "<script>"	
			response.Write "	alert('일치하는 정보가 없습니다.');"
			response.Write "	history.back();"
			response.Write "</script>"	
			response.End()
			
		End IF
			CRs.Close
		SET CRs = Nothing
	End IF	
%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script>
	function chk_Submit(valType){
		
		if(valType == "LIST"){	// 목록페이지
			$('form[name=s_frm]').attr('action',"./faqBoard.asp");		
			$('form[name=s_frm]').submit(); 
		}
		else if(valType == "RESET"){
			$('form[name=s_frm]')[0].reset();
		}
		else{	//답변 내용 작성/수정
			if(valType == "DEL"){
				if(confirm("선택하신 정보를 삭제하시겠습니까?\n질문과 답변정보 모두 삭제됩니다.")){
					$("#act").val("DEL");   
				}
				else{
					return;	
				}
			}
			
			if(!$('#Contents').val()){
				alert("질문내용을 입력해 주세요.");
				$('#Contents').focus();
				return;
			}
			
			if(!$('#RContents').val()){
				alert("답변 내용을 입력해 주세요.");
				$('#RContents').focus();
				return;
			}

			var strAjaxUrl = "../Ajax/faqBoard_ok.asp";
			var FAPubCode = $("#FAPubCode").val();
			var CIDX = $("#CIDX").val();
			var Contents = $("#Contents").val();			
			var RContents = $("#RContents").val();
			var RUserName = $("#RUserName").val();
			var SportsGb = $("#SportsGb").val();
			var act = $("#act").val();
			
			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",     
				data: { 
						FAPubCode   	: FAPubCode        
						,CIDX   		: CIDX       
						,Contents   	: Contents        
						,RContents  	: RContents 	
						,RUserName		: RUserName  
						,act   			: act       
						,SportsGb		: SportsGb  
					},    
				success: function(retDATA) {
					
					//console.log(retDATA);
					//$("#txt").html(retDATA);
					
					if(retDATA){
						var strcut = retDATA.split("|");
						
						if (strcut[0]=="TRUE") {      
							switch (strcut[1]) { 
								case "66": 
									alert('새 글을 등록하였습니다.');									
									break;
								case "99": 
									alert('글을 수정하였습니다.');
									break;
								case "100": 
									alert('글을 삭제하였습니다.');
									break;		
								default:
							}
							
							$('form[name=s_frm]').attr('action',"./faqBoard.asp");		
							$('form[name=s_frm]').submit(); 
						}
						else{
							switch (strcut[1]) { 
								case "66": 
									alert('새 글을 등록하지 못하였습니다.');
									break;
								case "99": 
									alert('글을 수정하지 못하였습니다.');
									break;
								case "100": 
									alert('글을 삭제하지 못하였습니다.');
									break;		
								default:
									alert("잘못된 접근입니다.\n확인 후 다시 이용하세요.1");               
							}
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
	
	$(document).ready(function(){
		var CIDX = $("#CIDX").val();
		
		if(CIDX != ""){
			
			$("#btn_txt").text("수정");   				
			$("#act").val("MOD");   	
		}
		else{
			$("#btn_txt").text("등록");   	
			$("#act").val("WR");   				
		}
	});
</script>
<body>
<form name="s_frm" method="post">
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />    
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_KeyWordType" id="fnd_KeyWordType" value="<%=fnd_KeyWordType%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="RUserID" id="RUserID" value="<%=RUserID%>" />
    <input type="hidden" name="RUserName" id="RUserName" value="<%=RUserName%>" />    
    <input type="hidden" name="act" id="act" />
  <!-- S: main container -->
  <div class="main container board boardWrite boardView col-12">
    <!-- S: container -->
    <section class="container">
      <!-- S: row -->
      <div class="row">
        <!-- S: loaction -->
        <div class="loaction">
          <strong>게시판 관리</strong> > FAQ 게시글 보기 및 답변 달기
        </div>
        <!-- E: loaction -->
      </div>
      <!-- E: row -->
    </section>
    <!-- E: container -->

    <!-- S: article-bg -->
    <div class="article-bg">
      <!-- S: article-frame -->
      <div class="article-frame community">
        <!-- S: basic-view -->
        <table class="table-list basic-table faq-table">
          <thead>
            <tr>
              <th>구분</th>
              <td>
                <select name="FAPubCode" id="FAPubCode">
                  <option value="FA01" <%IF FAPubCode = "FA01" Then response.Write "selected" End IF%> >전체</option>
                  <option value="FA02" <%IF FAPubCode = "FA02" Then response.Write "selected" End IF%> >선수</option>
                  <option value="FA03" <%IF FAPubCode = "FA03" Then response.Write "selected" End IF%> >선수보호자</option>
                  <option value="FA04" <%IF FAPubCode = "FA04" Then response.Write "selected" End IF%> >팀매니저</option>
                </select>
              </td>
            </tr>
            <tr>
              <th>질문</th>
              <td>
                <textarea id="Contents" name="Contents"><%=Contents%></textarea>
              </td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>답변</th>
              <td>
                <textarea name="RContents" id="RContents"><%=RContents%></textarea>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- E: basic-view -->

        <!-- S: board-btm-view -->
        <div class="board-btm-view">
          <ul class="clearfix">
            <li>
              <a href="javascript:chk_Submit('LIST');" class="btn btn-grayline">목록</a>
            </li>
            <li>
              <a href="javascript:chk_Submit('SAVE');" id="btn_txt" class="btn btn-blue">저장</a>
            </li>
            <li>
              <a href="javascript:chk_Submit('DEL');" class="btn btn-redy">삭제</a>
            </li>
            <li>
              <a href="javascript:chk_Submit('RESET');" class="btn btn-gray">취소</a>
            </li>
          </ul>
        </div>
        <!-- E: board-btm-view -->
      </div>
      <!-- E: article-frame -->
    </div>
    <!-- E: article-bg -->
  </div>
  <!-- E: main container -->
  </form>
</body>