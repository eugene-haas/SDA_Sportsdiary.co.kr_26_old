<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->

	<%
		'=======================================================================================
		'질문과 답변 상세페이지
		'=======================================================================================
		Check_Login()

		dim CIDX        	: CIDX        	= fInject(request("CIDX"))
		dim currPage    	: currPage      = fInject(request("currPage"))
		dim fnd_user    	: fnd_user      = fInject(request("fnd_user"))
		dim search_date   	: search_date   = fInject(request("search_date"))
		dim SDate       	: SDate       	= fInject(request("SDate"))
		dim EDate       	: EDate       	= fInject(request("EDate"))
		dim MemberIDX       : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)


		IF CIDX = "" OR MemberIDX = "" Then
			response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
			response.End()
		End IF

		CSQL =  "       SELECT Q.Title Title "
		CSQL = CSQL & "   ,Q.Contents Contents "
		CSQL = CSQL & "   ,CONVERT(CHAR(10), Q.WriteDate, 102) WriteDate "
		CSQL = CSQL & "   ,Q.UserName UserName "
		CSQL = CSQL & "   ,Q.ViewCnt ViewCnt "
		CSQL = CSQL & "   ,Q.MemberIDX MemberIDX "
		CSQL = CSQL & "   ,Q.QnAIDX QnAIDX "
		CSQL = CSQL & "   ,Q.ReQnAIDX ReQnAIDX "
		CSQL = CSQL & "   ,A.Title ReTitle "
		CSQL = CSQL & "   ,A.Contents ReContents "
		CSQL = CSQL & "   ,ISNULL(CONVERT(CHAR(10), A.WriteDate, 102), '') ReWriteDate "
		CSQL = CSQL & "   ,A.UserName ReUserName "
		CSQL = CSQL & "   ,A.QnAIDX ReIDX "
		CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] Q "
		CSQL = CSQL & "   left join [SD_tennis].[dbo].[tblSvcQnA] A on Q.QnAIDX = A.ReQnAIDX AND A.DelYN = 'N' AND A.SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & " WHERE Q.DelYN = 'N' "
		CSQL = CSQL & "   AND Q.SportsGb = '"&SportsGb&"'"
		CSQL = CSQL & "   AND Q.QnAIDX = "&CIDX

		'	response.Write CSQL

		SET CRs = server.CreateObject ("ADODB.Recordset")
			CRs.Open CSQL, DBCon3, 1 ,3
		IF NOT(CRs.Bof OR CRs.Eof) THEN
			CRs("ViewCnt") = cint(CRs("ViewCnt")) + 1
			CRs.Update

		'질문
		WriterID  = CRs("MemberIDX")
		Title     = ReplaceTagReText(CRs("Title"))
		Contents  = replace(ReplaceTagReText(CRs("Contents")), chr(10),"<br>")
		WriteDate = CRs("WriteDate")
		UserName  = CRs("UserName")
		ViewCnt   = CRs("ViewCnt")
		QnAIDX    = CRs("QnAIDX")
		ReQnAIDX  = CRs("ReQnAIDX")

		'답변
		ReTitle     = ReplaceTagReText(CRs("ReTitle"))
		ReContents  = replace(ReplaceTagReText(CRs("ReContents")), chr(10),"<br>")
		ReWriteDate = CRs("ReWriteDate")
		ReUserName  = CRs("ReUserName")
		ReIDX   = CRs("ReIDX")
		End IF

			CRs.Close
		SET CRs = Nothing


	%>
	<!-- E: detail INFO -->
	<script>
	  //버튼액션
	  function chk_URL(type){
	    if(type!=""){

	      switch(type) {
	         case "LIST" :
	            $('form[name=s_frm]').attr('action',"./qa_board.asp");
	          $('form[name=s_frm]').submit();
	          break;
	         //수정
	         case "MOD" :
	            $('#strType').val('MOD');
	            $('form[name=s_frm]').attr('action',"./qa_board_write.asp");
	          $('form[name=s_frm]').submit();
	          break;
	        /*
	        //답변
	         case "REPLY" :
	            var strType = $("#strType").val(type);

	            $('form[name=s_frm]').attr('action',"./qa_board_write.asp");
	          $('form[name=s_frm]').submit();
	          break;
	      */
	         //삭제
	         case "DEL" :
	            if(confirm("선택한 정보를 삭제하시겠습니까?")){

	            var strAjaxUrl = "../Ajax/qa_board_del.asp";
	            var CIDX = $("#CIDX").val();

	            $.ajax({
	              url: strAjaxUrl,
	              type: "POST",
	              dataType: "html",
	              data: {
	                 CIDX       : CIDX
	              },
	              success: function(retDATA) {
	                if(retDATA=="TRUE"){
	                  $('form[name=s_frm]').attr('action',"./qa_board.asp");
	                  $('form[name=s_frm]').submit();

	                }else{
	                  alert ("삭제를 하지 못하였습니다.\n다시 확인해 주세요.");
					  return;
	                }
	              }, error: function(xhr, status, error){
	                if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");
						return;
					}
	              }
	            });
	            break;
	          }
	          else{
	            return;
	          }
	         default:
	            break;
	      }
	    }
	  }

	  function info_Button(){
	    var strAjaxUrl = "../Ajax/qa_board_view_btn.asp";
	    var QnAIDX = $("#QnAIDX").val();
	    var ReQnAIDX = $("#ReQnAIDX").val();
	    var WriterID = $("#WriterID").val();

	    $.ajax({
	      url: strAjaxUrl,
	      type: "POST",
	      dataType: "html",
	      data: {
	        QnAIDX    : QnAIDX
	        ,ReQnAIDX   : ReQnAIDX
	        ,WriterID : WriterID
	      },
	      success: function(retDATA) {

	        $("#board-btn").html(retDATA);

	      }, error: function(xhr, status, error){
	        if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
	      }
	    });
	  }


	  $(document).ready(function(){
	    info_Button();
	  });
	</script>
</head>
<body>

	<form name="s_frm" method="post">
	  <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
	    <input type="hidden" name="QnAIDX" id="QnAIDX" value="<%=QnAIDX%>" />
	    <input type="hidden" name="ReQnAIDX" id="ReQnAIDX" value="<%=ReQnAIDX%>" />
	    <input type="hidden" name="WriterID" id="WriterID" value="<%=WriterID%>" />
	    <input type="hidden" name="strType" id="strType" />
	    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
	    <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
	    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
	    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
	    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
	    <input type="hidden"  class="on_val" id="on_val" name="on_val" />
	  <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />

	<div class="l m_bg_f2f2f2">

		<!-- #include file = "../include/gnb.asp" -->

	  <div class="l_header">
			<div class="m_header s_sub">
		    <!-- #include file="../include/header_back.asp" -->
		    <h1 class="m_header__tit">Q&amp;A 게시판</h1>
		    <!-- #include file="../include/header_gnb.asp" -->
			</div>
	  </div>
		<div class="m_horizon"></div>

		<div class="l_content m_scroll [ _content _scroll ]">

			<!-- S: top-counsel -->
		  <div class="m_forumView">
		  	<div class="m_forumView__header">
		    	<h3 class="m_forumView__tit">
		      	<span><%=Title%></span>
		      </h3>
		      <p class="m_forumView__additionalTxt">
		        <span><%=UserName%></span>
		        <span><%=replace(left(WriteDate, 10), "-", ".")%></span>
		        <span class="m_forumView__txt s_seen">조회수</span>
		        <span><%IF ViewCnt<>"" Then response.Write formatnumber(ViewCnt, 0) Else response.Write "0" End IF%></span>
		      </p>
		    </div>

			  <div id="board-contents" class="m_forumView__contentWrap">
			  	<p class="m_forumView__content"><%=Contents%></p>
			  </div>

				<!-- S: retop-counsel -->
		    <%IF ReIDX <> "" and cint(WriterID) = cint(MemberIDX) Then%>
			  <div class="m_forumView__header">
					<h3 class="m_forumView__tit">
						<span class="m_forumView__txt s_reply">답변: </span>&nbsp;&nbsp;<span><%=ReTitle%></span></p>
					</h3>
					<p class="m_forumView__additionalTxt">
						<span><%=ReUserName%></span>
						<span><%=replace(left(ReWriteDate, 10), "-", ".")%></span>
					</p>
			    <!-- <div class="re-info">
			      <p><span class="ic-deco"><img src="../images/board/ic_reply@3x.png" alt></span><span class='ic-reply'>답변</span><span><%=ReTitle%></span></p>
			      <p>
			        <span><%=ReUserName%></span>
			        <span><%=replace(left(ReWriteDate, 10), "-", ".")%></span>
			      </p>
			    </div> -->
			  </div>

				<div class="m_forumView__replyContentWrap">
					<p class="m_forumView__replyContent"><%=ReContents%></p>
				</div>
			  <%End IF%>
			  <!-- E: retop-counsel -->
			</div>

		  <!-- S: btn-list -->
		  <div id="board-btn" class="m_forum__btnBar">
		  <!--
		    <a href="./qa_board.asp" class="btn btn-cancel">목록</a>
		    <a href="./qa_board_write.asp" class="btn btn-save">답변</a>
		    -->
		  </div>
		  <!-- E: btn-list -->

		</div>


	</div>

	</form>

	<!-- #include file="../include/bottom_menu.asp" -->
	<!-- #include file= "../include/bot_config.asp" -->


</body>
</html>
