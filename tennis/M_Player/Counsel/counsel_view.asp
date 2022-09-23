<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  dim CIDX    : CIDX      = fInject(request("CIDX"))
  dim currPage  : currPage    = fInject(request("currPage"))
  dim fnd_user  : fnd_user    = fInject(request("fnd_user"))
  dim search_date : search_date   = fInject(request("search_date"))
  dim SDate     : SDate     = fInject(request("SDate"))
  dim EDate     : EDate     = fInject(request("EDate"))
  dim typeMenu  : typeMenu    = fInject(Request("typeMenu"))

  IF CIDX = "" Then
    response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
    response.End()
  End IF

  '지도자 상담내역 조회
  	CSQL =  " 		SELECT L.* "
	CSQL = CSQL & "		,CASE M.PlayerReln "
	CSQL = CSQL & "			WHEN 'T' THEN SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType)"
	CSQL = CSQL & "			WHEN 'A' THEN '부' "
	CSQL = CSQL & "			WHEN 'B' THEN '모' "
	CSQL = CSQL & "			WHEN 'Z' THEN PlayerRelnMemo "
	CSQL = CSQL & "		END	LeaderType "
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "		inner join [Sportsdiary].[dbo].[tblMember] M on M.UserID = L.UserID "
	CSQL = CSQL & "			AND M.DelYN = 'N'"
	CSQL = CSQL & "			AND M.SportsType = '"&SportsGb&"'"
	CSQL = CSQL & " WHERE L.DelYN = 'N' "
	CSQL = CSQL & "	  AND L.SportsGb = '"&SportsGb&"'"
	CSQL = CSQL & "   AND L.LedrAdvIDX = "&CIDX

'	response.Write CSQL

  SET CRs = server.CreateObject ("ADODB.Recordset")
    CRs.Open CSQL, Dbcon, 1 ,3

  IF Not(CRs.eof or CRs.bof)  Then
    LedrAdvIDX    = CRs("LedrAdvIDX")
    ReLedrAdvIDX  = CRs("ReLedrAdvIDX")
    ReplyType   = CRs("ReplyType")
    Title       = ReplaceTagReText(CRs("Title"))
    Contents    = replace(ReplaceTagReText(CRs("Contents")),chr(10), "<br>")
    WriterID    = CRs("UserID")
    UserName    = CRs("UserName")
    MarkYn      = CRs("MarkYn")
    WriteDate     = CRs("WriteDate")
    WorkDt      = CRs("WorkDt")
    LeaderType    = CRs("LeaderType")
  End IF
    CRs.Close
  SET CRs = Nothing

' dim returnURL : returnURL = Request("HTTP_REFERER")
' dim chkURL, strURL

' IF returnURL <> "" Then
'   chkURL = split(returnURL, "/")
'   strURL = chkURL(ubound(chkURL))
' End IF

' response.Write strURL
%>
<!-- E: detail INFO -->
<script type="text/javascript">

  //버튼액션
  function chk_URL(type){
    if(type!=""){

      switch(type) {
         case "LIST" :
            $('form[name=frm]').attr('action',"./<%=typeMenu%>.asp");
          $('form[name=frm]').submit();
          break;
         //수정
         case "MOD" :
            $('form[name=frm]').attr('action',"./counsel_mod.asp");
          $('form[name=frm]').submit();
          break;
         //답변
         case "REPLY" :
            var strType = $("#strType").val(type);

            $('form[name=frm]').attr('action',"./counsel_write.asp");
          $('form[name=frm]').submit();
          break;
         //삭제
         case "DEL" :
            if(confirm("선택한 정보를 삭제하시겠습니까?")){

            var strAjaxUrl = "../Ajax/counsel_del.asp";
            var CIDX = $("#CIDX").val();
            var SDate = $("#SDate").val();
            var EDate = $("#EDate").val();
            var fnd_user = $("#fnd_user").val();
            var search_date = $("#search_date").val();

            $.ajax({
              url: strAjaxUrl,
              type: "POST",
              dataType: "html",
              data: {
                 CIDX       : CIDX
                ,SDate      : SDate
                ,EDate      : EDate
                ,fnd_user     : fnd_user
                ,search_date    : search_date
              },
              success: function(retDATA) {
                if(retDATA=="TRUE"){
                  $('form[name=frm]').attr('action',"./<%=typeMenu%>.asp");
                  $('form[name=frm]').submit();
                  //$(location).attr("href", "./<%=typeMenu%>.asp");
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

  $(document).ready(function(){

    var strAjaxUrl = "../Ajax/counsel_view_btn.asp";
    var LedrAdvIDX = $("#LedrAdvIDX").val();
    var ReLedrAdvIDX = $("#ReLedrAdvIDX").val();
    var typeMenu = $("#typeMenu").val();
    var WriterID = $("#WriterID").val();

    $.ajax({
      url: strAjaxUrl,
      type: "POST",
      dataType: "html",
      data: {
         typeMenu   : typeMenu
        ,LedrAdvIDX   : LedrAdvIDX
        ,ReLedrAdvIDX   : ReLedrAdvIDX
        ,WriterID     : WriterID
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
  });
</script>
<body class="board-bg">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>지도자상담</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->
  
  <!-- S: sub sub-main -->
  <form name="frm" method="post">
    <input type="hidden" name="typeMenu" id="typeMenu" value="<%=typeMenu%>" />
  <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="LedrAdvIDX" id="LedrAdvIDX" value="<%=LedrAdvIDX%>" />
    <input type="hidden" name="ReLedrAdvIDX" id="ReLedrAdvIDX" value="<%=ReLedrAdvIDX%>" />
    <input type="hidden" name="WriterID" id="WriterID" value="<%=WriterID%>" />
    <input type="hidden" name="strType" id="strType" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
  <div class="sub sub-main board">
    <div class="view-title">
      <h4><%=Title%></h4>
      <p class="write-info clearfix">
        <!-- 팀매니저일경우엔 하늘색 -->
        <span class="skyblue"><%=UserName%><%="("&LeaderType&")"%></span>
        <!-- 학부모일경우
        <span>학부모</span> -->
        <span><%=replace(left(WriteDate, 10), "-", ".")%></span>
        <!--
        <span class="seen">조회수</span>
        <span>4,221</span>
        -->
      </p>
    </div>
    <!-- S: view-cont -->
    <div class="view-cont">
      <!-- S: 게시판 작성 내용 -->
      <p><%=Contents%></p>
      <!-- E: 게시판 작성 내용 -->
    </div>
    <!-- E: view-cont -->
    <!-- S: btn-list 팀매니저가 작성한 글인경우-->
    <div id="board-btn" class="btn-list">
    <!--
      <ul>
        <li><a href="#" class="btn show-list">목록</a></li>
        <li><a href="#" class="btn reply">답변</a></li>
      </ul>
      -->
    </div>
    <!-- E: btn-list btn-list 팀매니저가 작성한 글인경우 -->
    <!-- S: btn-list 학부모가 작성한 글인경우
    <div  class="btn-list">
      <ul>
        <li><a href="#" class="btn show-list">목록</a></li>
        <li><a href="#" class="btn delete">삭제</a></li>
        <li><a href="#" class="btn modify">수정</a></li>
      </ul>
    </div>
    <!-- E: btn-list btn-list 학부모가 작성한 글인경우 -->
  </div>
  </form>
  <!-- E: sub sub-main board -->
    <!-- S: bottom-menu -->
      <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: record-bg -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
