<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include file="../Library/config.asp"-->
<%
	'공지사항 작성/수정페이지
	
	dim SportsGb		: SportsGb			= request.Cookies("SportsGb")
	
	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord    	= fInject(Request("fnd_KeyWord"))
	dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
	dim CIDX 			: CIDX   			= fInject(Request("CIDX"))	
	
	dim UserID			: UserID 			= Request.Cookies("UserID")  
	dim UserName		: UserName	 		= Request.Cookies("UserName")
	
	IF CIDX <> "" Then
		
		CSQL = "		SELECT NtcIDX "	
		CSQL = CSQL & "		,CASE BRPubCode "
		CSQL = CSQL & "			WHEN 'BR02' THEN '선수' "
		CSQL = CSQL & "			WHEN 'BR03' THEN '선수보호자' "
		CSQL = CSQL & "			WHEN 'BR04' THEN '팀매니저' "
		CSQL = CSQL & "		Else '전체' "
		CSQL = CSQL & "		END BRPubCodeNm "
		CSQL = CSQL & "		,Title "
		CSQL = CSQL & "		,Contents "
		CSQL = CSQL & "		,UserName "
		CSQL = CSQL & "		,WriteDate "
		CSQL = CSQL & "		,ViewCnt "
		CSQL = CSQL & "		,Notice "
		CSQL = CSQL & "	FROM [Sportsdiary].[dbo].[tblSvcNotice]" 
		CSQL = CSQL & "	WHERE NtcIDX = '"&CIDX&"' " 
		
'		response.Write CSQL
		
		SET CRs = Dbcon.Execute(CSQL)	
		IF NOT(CRs.Bof OR CRs.Eof) Then					
			
			BRPubCodeNm    	= CRs("BRPubCodeNm")
			Title    		= ReplaceTagReText(CRs("Title"))
			Contents    	= replace(ReplaceTagReText(CRs("Contents")), "<br>", chr(10))
			UserName    	= CRs("UserName")
			WriteDate    	= CRs("WriteDate")
			ViewCnt    		= CRs("ViewCnt")
			Notice    		= CRs("Notice")	
				
		ELSE					
			response.Write "<script>"
			response.Write "	alert('일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.');"
			response.Write "	history.back();"
			response.Write "</script>"
			response.End()
		End IF
			CRs.Close
		SET CRs = Nothing
		
	END IF
	
%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script>
	function chk_Submit(valType){
		var act;
		
		if(valType == "LIST"){	//공지사항 목록페이지
			$('form[name=s_frm]').attr('action',"./noticeBoard.asp");		
			$('form[name=s_frm]').submit(); 
		}
		else{	//공지사항 작성/수정
			
			var strAjaxUrl = "../Ajax/noticeBoard_ok.asp";
			var BRPubCode = $("#BRPubCode").val();
			var Title = $("#Title").val();
			var Contents = $("#Contents").val();
			var CIDX = $("#CIDX").val();
			var SportsGb = $("#SportsGb").val();
			var act = $("#act").val();
			
			var Notice;
			
			if(!($("#Notice").is(":checked"))){
				Notice = "";
			}
			else{
				Notice = "Y";
			}
			
			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",     
				data: { 
						BRPubCode   : BRPubCode        
						,Title   	: Title        
						,Contents   : Contents   
						,Notice   	: Notice
						,CIDX   	: CIDX       
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
									alert('새 글을 등록하였습니다.');
									$('form[name=s_frm]').attr('action',"./noticeBoard.asp");		
									$('form[name=s_frm]').submit(); 
									break;
								case "99": 
									alert('선택하신 정보를 수정하였습니다.');
									$('form[name=s_frm]').attr('action',"./noticeBoard.asp");		
									$('form[name=s_frm]').submit(); 
									break;
								case "100": 
									alert('선택하신 정보를 삭제하였습니다.');
									$('form[name=s_frm]').attr('action',"./noticeBoard.asp");		
									$('form[name=s_frm]').submit(); 
									break;		
								default:
							}
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
		var CIDX = $("#CIDX").val();
		
		if(CIDX != ""){
			
			$("#txt_ACT").text("수정");   	
			$("#btn_txt").text("수정");   				
			$("#act").val("MOD");   	
		}
		else{
			$("#act").val("WR");   	
			$("#txt_ACT").text("쓰기");   	
			$("#btn_txt").text("저장");   	
		}
	});
</script>
<body>
<form name="s_frm" method="post">
	<input type="hidden" name="SportsGb" id="SportsGb" value="<%=SportsGb%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />    
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_KeyWordType" id="fnd_KeyWordType" value="<%=fnd_KeyWordType%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="UserID" id="UserID" value="<%=UserID%>" />
    <input type="hidden" name="UserName" id="UserName" value="<%=UserName%>" />    
    <input type="hidden" name="act" id="act" />
  <!-- S: main container -->
  <div class="main container board boardWrite col-12">
    <!-- S: container -->
    <section class="container">
      <!-- S: row -->
      <div class="row">
        <!-- S: loaction -->
        <div class="loaction">
          <strong>게시판 관리</strong> > 게시글 <span id="txt_ACT"></span>
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
              <td>
                <select name="BRPubCode" id="BRPubCode">
                  <option value="BR01" <%IF BRPubCodeNm = "BR01" Then response.Write "selected" %>>전체</option>
                  <option value="BR02" <%IF BRPubCodeNm = "BR02" Then response.Write "selected" %>>선수</option>
                  <option value="BR03" <%IF BRPubCodeNm = "BR03" Then response.Write "selected" %>>선수보호자</option>
                  <option value="BR04" <%IF BRPubCodeNm = "BR04" Then response.Write "selected" %>>팀 매니저</option>
                </select>
              </td>
            </tr>
            <tr>
              <th>제목( <input type="checkbox" id="Notice" name="Notice" <%IF Notice = "Y" Then response.Write "checked" End IF%> > <label for="Notice">필독</label> )</th>
              <td>
                <input type="text" id="Title" name="Title" value="<%=Title%>" />
              </td>
            </tr>
            <tr>
              <th>작성자</th>
              <td><%=UserName%></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="2">
                <textarea name="Contents" id="Contents" placeholder="내용을 입력해 주세요"><%=Contents%></textarea>
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