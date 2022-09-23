<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'Q&A 상세페이지
	
	dim SportsGb		: SportsGb			= request.Cookies("SportsGb")
	dim RUserID			: RUserID 			= Request.Cookies("UserID")  	'답변자 ID
	dim RUserName		: RUserName	 		= Request.Cookies("UserName")	'답변자 이름
	
	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord    	= fInject(Request("fnd_KeyWord"))
	dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
	dim CIDX 			: CIDX   			= fInject(Request("CIDX"))		'질문IDX
	
	CSQL =  "       SELECT Q.QnAIDX  "
	CSQL = CSQL & "     ,Q.QnAType  "
	CSQL = CSQL & "   	,CASE Q.QnAType WHEN 'P' THEN '선수APP' WHEN 'C' THEN '팀매니저APP' END QnATypeNm"	
	CSQL = CSQL & "     ,Q.MemberIDX  "
	CSQL = CSQL & "     ,Q.ReQnAIDX  "
	CSQL = CSQL & "     ,Q.UserName  "
	CSQL = CSQL & "     ,Q.Title  "
	CSQL = CSQL & "     ,Q.Contents  "
	CSQL = CSQL & "     ,Q.WriteDate  " 
	CSQL = CSQL & "     ,Q.ViewCnt  "
	CSQL = CSQL & "     ,A.QnAIDX RQnAIDX "
	CSQL = CSQL & "     ,A.ReQnAIDX RReQnAIDX "
	CSQL = CSQL & "     ,A.Title RTitle "
	CSQL = CSQL & "     ,A.Contents RContents "
	CSQL = CSQL & "     ,A.UserName RUserName "	
	CSQL = CSQL & "     ,A.MemberIDX RMemberIDX "
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcQnA] Q "
	CSQL = CSQL & " 	left join [Sportsdiary].[dbo].[tblSvcQnA] A on Q.QnAIDX = A.ReQnAIDX"
	CSQL = CSQL & " 		AND A.DelYN = 'N' "
	CSQL = CSQL & " 		AND A.SportsGb = '"&SportsGb&"' "	
	CSQL = CSQL & " WHERE Q.DelYN = 'N' "
	CSQL = CSQL & " 	AND Q.SportsGb = '"&SportsGb&"' "	
	CSQL = CSQL & "     AND Q.QnAIDX = '"&CIDX&"' " 
	
'	response.Write CSQL
'	response.End()
	
	SET CRs = Dbcon.Execute(CSQL)	
	IF NOT(CRs.Bof OR CRs.Eof) Then					
		
		QnAIDX = CRs("QnAIDX")
		QnAType = CRs("QnAType")
		QnATypeNm = CRs("QnATypeNm")
		MemberIDX = CRs("MemberIDX")
		ReQnAIDX = CRs("ReQnAIDX")
		Title = ReplaceTagReText(CRs("Title"))
		Contents = replace(ReplaceTagReText(CRs("Contents")),chr(10), "<br>")		
		UserName = CRs("UserName")
		WriteDate = CRs("WriteDate")
		ViewCnt = CRs("ViewCnt")
		
		RMemberIDX = CRs("RMemberIDX")
		RQnAIDX = CRs("RQnAIDX")
		RReQnAIDX = CRs("RReQnAIDX")
		RTitle = ReplaceTagReText(CRs("RTitle"))
		RContents = replace(ReplaceTagReText(CRs("RContents")), "<br>", chr(10))		
		RUserName = CRs("RUserName")
		
		
		'신규답변글의 경우 질문제목을 넣어준다
		IF RQnAIDX = "" Then RTitle = "RE_"&Title

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
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script>
	function chk_Submit(valType){
		
		if(valType == "LIST"){	// 목록페이지
			$('form[name=s_frm]').attr('action',"./qnaBoard.asp");		
			$('form[name=s_frm]').submit(); 
		}
		else if(valType == "RESET"){
			$('form[name=s_frm]')[0].reset();
		}
		else{	//답변 내용 작성/수정
			if(valType == "DEL"){
				if(confirm("답변글을 삭제하시겠습니까?")){
					$("#act").val("DEL");   
				}
				else{
					return;	
				}
			}
			
			if(!$('#RTitle').val()){
				alert("제목을 입력해 주세요.");
				$('#RTitle').focus();
				return;
			}
			
			if(!$('#RContents').val()){
				alert("내용을 입력해 주세요.");
				$('#RContents').focus();
				return;
			}

	
			var strAjaxUrl = "../Ajax/qnaBoard_ok.asp";
			var QnAType = $("#QnAType").val();
			var CIDX = $("#CIDX").val();
			var RQnAIDX = $("#RQnAIDX").val();
			var RTitle = $("#RTitle").val();
			var RContents = $("#RContents").val();
			var RUserID = $("#RUserID").val();
			var RUserName = $("#RUserName").val();
			var SportsGb = $("#SportsGb").val();
			var act = $("#act").val();
			
			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",     
				data: { 
						QnAType   	: QnAType        
						,CIDX   	: CIDX       
						,RQnAIDX   	: RQnAIDX       
						,RTitle   	: RTitle        
						,RContents  : RContents 	
						,RUserID	: RUserID  
						,RUserName	: RUserName  
						,act   		: act       
						,SportsGb	: SportsGb  
					},    
				success: function(retDATA) {
					
					//console.log(retDATA);
					
					if(retDATA){
						var strcut = retDATA.split("|");
						
						if (strcut[0]=="TRUE") {      
							switch (strcut[1]) { 
								case "66": 
									alert('답변 글을 등록하였습니다.');
									break;
								case "99": 
									alert('답변 글을 수정하였습니다.');
									break;
								case "100": 
									alert('답변 글을 삭제하였습니다.');
									break;		
								default:
							}
							
							$('form[name=s_frm]').attr('action',"./qnaViewBoard.asp");		
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
	
	$(document).ready(function(){
		var RQnAIDX = $("#RQnAIDX").val();
		
		if(RQnAIDX != ""){
			
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
    <input type="hidden" name="QnAType" id="QnAType" value="<%=QnAType%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="RQnAIDX" id="RQnAIDX" value="<%=RQnAIDX%>" />
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
          <strong>게시판 관리</strong> > Q&amp;A 게시글 보기 및 답변 달기
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
        <table class="table-list basic-table">
          <thead>
            <tr>
              <th>구분</th>
              <td><%=QnATypeNm%></td>
            </tr>
            <tr>
              <th>제목</th>
              <td><%=Title%></td>
            </tr>
            <tr>
              <th>작성자</th>
              <td><%=UserName%></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="2"><%=Contents%></td>
            </tr>
          </tbody>
        </table>
        <!-- E: basic-view -->
        <!-- S: board-btm-view -->
        <div class="board-btm-view">
          <p>답변하기</p>
          <!-- <ul class="clearfix">
            <li>
              <a href="#" class="btn btn-grayline">목록</a>
            </li>
            <li>
              <a href="#" class="btn btn-blue">저장</a>
            </li>
            <li>
              <a href="#" class="btn btn-gray">취소</a>
            </li>
          </ul> -->
        </div>
        <!-- E: board-btm-view -->

        <!-- S: reply-view -->
        <div class="reply-view">
          <ul class="reply-tit clearfix">
            <li>제목</li>
            <li><textarea type="text" id="RTitle" name="RTitle" ><%=RTitle%></textarea></li>
          </ul>
          <div class="txt-box">
            <textarea name="RContents" id="RContents"><%=RContents%></textarea>
          </div>
          <ul class="clearfix">
            <li>
              <a href="javascript:chk_Submit('LIST');" class="btn btn-grayline">목록</a>
            </li>
            <li>
              <a href="javascript:chk_Submit('REREG');" id="btn_txt" class="btn btn-blue">등록</a>
            </li>
            <li>
            	<a href="javascript:chk_Submit('DEL');" class="btn btn-redy">삭제</a>
            </li>
            <li>
              <a href="javascript:chk_Submit('RESET');" class="btn btn-gray">취소</a>
            </li>
          </ul>
        </div>
        <!-- E: reply-view -->
      </div>
      <!-- E: article-frame -->
    </div>
    <!-- E: article-bg -->
  </div>
  <!-- E: main container -->
  </form>
</body>