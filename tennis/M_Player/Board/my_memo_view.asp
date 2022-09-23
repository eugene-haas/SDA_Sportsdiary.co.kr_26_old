<!-- #include file="../include/config.asp" -->
<%
	Check_Login()

	dim CIDX        	: CIDX        	= fInject(request("CIDX"))
	dim currPage    	: currPage      = fInject(request("currPage"))
	dim search_date   	: search_date   = fInject(request("search_date"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(request("fnd_KeyWord"))
	dim SDate      	 	: SDate       	= fInject(request("SDate"))
	dim EDate       	: EDate       	= fInject(request("EDate"))

  	dim UserID	     	: UserID   		= request.Cookies("SD")("UserID")

  	IF CIDX = "" OR UserID = "" Then
    	response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
    	response.End()
  	ELSE

		CSQL =  "     SELECT Title  "
		CSQL = CSQL & "   ,Contents  "
		CSQL = CSQL & "   ,CONVERT(CHAR(10), WriteDate, 102) WriteDate "
		CSQL = CSQL & "   ,UserName  "
		CSQL = CSQL & "   ,MemoIDX  "
		CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcMemo] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"'"
		CSQL = CSQL & "   AND UserID = '"&UserID&"'"
		CSQL = CSQL & "   AND MemoIDX = "&CIDX

		SET CRs = DBCon3.Execute(CSQL)
		IF NOT(CRs.Eof OR CRs.Bof)  Then

			Title     = ReplaceTagReText(CRs("Title"))
			Contents  = replace(ReplaceTagReText(CRs("Contents")), chr(10),"<br>")
			WriteDate = CRs("WriteDate")
			UserName  = CRs("UserName")

		End IF
			CRs.Close
		SET CRs = Nothing

	End IF

%>
<!-- E: detail INFO -->
<script>
	//버튼액션
	function chk_URL(valType){
		if(valType!=""){

			switch(valType) {
				case "LIST" :
					$('form[name=s_frm]').attr('action',"./my_memo.asp");
					$('form[name=s_frm]').submit();
					break;

				//수정
				case "MOD" :
					$('#strType').val('MOD');
					$('form[name=s_frm]').attr('action',"./memo_write.asp");
					$('form[name=s_frm]').submit();
					break;

				//삭제
				case "DEL" :
					if(confirm("선택한 정보를 삭제하시겠습니까?")){

						var strAjaxUrl = "../Ajax/my_memo_del.asp";
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
									alert ("선택하신 메모장 정보를 삭제하였습니다.");
									$('form[name=s_frm]').attr('action',"./my_memo.asp");
									$('form[name=s_frm]').submit();

								}
								else{
									alert ("삭제를 하지 못하였습니다.\n다시 확인해 주세요.");
									return;
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
					else{
						return;
					}
					break;
				default:
					break;
			}
		}
	}
</script>
<body>

<form name="s_frm" method="post">
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="MemoIDX" id="MemoIDX" value="<%=MemoIDX%>" />
    <input type="hidden" name="strType" id="strType" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />

    <input type="hidden"  class="on_val" id="on_val" name="on_val" />
    <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />

		<!-- S: sub-header -->
	  <div class="sd-header sd-header-sub">
	    <!-- #include file="../include/sub_header_arrow.asp" -->
	    <h1>나의 메모장</h1>
	    <!-- #include file="../include/sub_header_gnb.asp" -->
	  </div>
	  <!-- #include file = "../include/gnb.asp" -->
	  <!-- E: sub-header -->

  <!-- S: top-counsel -->
 <div class="top-counsel write qa-top">
    <div class="view-title">
      <!--<h3>제목</h3>-->
      <p class="write-title clearfix">
        <span><%=Title%></span>
       </p>
       <p class="write-info clearfix">
        <span><%=replace(left(WriteDate, 10), "-", ".")%></span>
      </p>
    </div>
  </div>
  <!-- E: top-counsel -->
  <!-- S: sub sub-main -->
  <div id="board-contents" class="sub sub-main board qa-board qa-write panel-group qa-srch-board">
    <div class="view-word container">
      <!-- S: 게시판 작성 내용 -->
     <p><%=Contents%></p>
      <!-- E: 게시판 작성 내용 -->
    </div>
  </div>
  <!-- E: sub sub-main board -->


  <!-- S: btn-list -->
  <div id="board-btn" class="btn-list qa-board-cta qa-view container flex">
      <a href="javascript:chk_URL('LIST');" class="btn btn-cancel">목록</a>
      <a href="javascript:chk_URL('DEL');" class='btn delete'>삭제</a>
      <a href="javascript:chk_URL('MOD');" class='btn btn-save'>수정</a>
  </div>
  <!-- E: btn-list -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  </form>
</body>
