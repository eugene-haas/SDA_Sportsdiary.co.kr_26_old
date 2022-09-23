<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	'공지사항 상세페이지

	dim SportsGb		: SportsGb			= "tennis"

	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord    	= fInject(Request("fnd_KeyWord"))
	dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
	dim CIDX 			: CIDX   			= fInject(Request("CIDX"))

	CSQL = "		SELECT NtcIDX "
	CSQL = CSQL & "		,CASE BRPubCode "
	CSQL = CSQL & "			WHEN 'BR02' THEN '선수' "
	CSQL = CSQL & "			WHEN 'BR03' THEN '선수보호자' "
	CSQL = CSQL & "			WHEN 'BR04' THEN '팀매니저' "
	CSQL = CSQL & "		Else '전체' "
	CSQL = CSQL & "		END BRPubCodeNm "
	CSQL = CSQL & "		,Title "
	CSQL = CSQL & "		,UserName "
	CSQL = CSQL & "		,Contents "
	CSQL = CSQL & "		,WriteDate "
	CSQL = CSQL & "		,ViewCnt "
	CSQL = CSQL & "   	,CASE ViewYN WHEN 'Y' THEN '출력' ELSE '출력안함' END ViewYN "
	CSQL = CSQL & "		,Notice "
	CSQL = CSQL & "	FROM [SD_tennis].[dbo].[tblSvcNotice]"
	CSQL = CSQL & " WHERE DelYN = 'N' "
	CSQL = CSQL & " 	AND NtcIDX = '"&CIDX&"' "

'	response.Write CSQL

	SET CRs = DBCon5.Execute(CSQL)
	IF NOT(CRs.Bof OR CRs.Eof) Then

		BRPubCodeNm = CRs("BRPubCodeNm")
		Title = ReplaceTagReText(CRs("Title"))
		Contents = replace(ReplaceTagReText(CRs("Contents")),chr(10), "<br>")
		UserName = CRs("UserName")
		WriteDate = CRs("WriteDate")
		ViewCnt = CRs("ViewCnt")
		Notice = CRs("Notice")
		ViewYN = CRs("ViewYN")

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
			$('form[name=s_frm]').attr('action',"./noticeBoard.asp");
			$('form[name=s_frm]').submit();
		}
		else if(valType == "MOD"){	//공지사항 수정
			$('form[name=s_frm]').attr('action',"./writeBoard.asp");
			$('form[name=s_frm]').submit();
		}
		else{	//공지사항 수정/삭제

			$("#act").val("DEL");

			// var strAjaxUrl = "Ajax/noticeBoard_ok.asp";
      var strAjaxUrl = "./Ajax/Board_ok_notice.asp"
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

						if (strcut[0]=="TRUE" && strcut[1] == 70) {
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
</script>
<section>
  <div id="content">
<form name="s_frm" method="post">
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_KeyWordType" id="fnd_KeyWordType" value="<%=fnd_KeyWordType%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="act" id="act" />

     <!-- S: 네비게이션 -->
      <div class="navigation_box">커뮤니티 &gt;  게시판 &gt; 공지사항</div>
      <!-- E: 네비게이션 -->
 <br />
        <!-- S: basic-view -->
        <table class="Community_wtite_box">
          <thead>
            <tr>
              <th>구분</th>
              <td><%=BRPubCodeNm%></td>
            </tr>
            <tr>
              <th>제목</th>
              <td><%IF Notice = "Y" Then response.Write "[필독]" End IF%> <%=Title%></td>
            </tr>
            <tr>
              <th>작성자</th>
              <td><%=UserName%></td>
            </tr>
			<tr>
              <th>출력구분</th>
              <td><%=ViewYN%></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="2"><%=Contents%></td>
            </tr>
          </tbody>
        </table>
        <!-- E: basic-view -->

        <div class="btn_list">

              <a href="javascript:chk_Submit('LIST');" class="btn btn-grayline">목록</a>
              <a href="javascript:chk_Submit('MOD');" class="btn btn-orangy">수정</a>
              <a href="javascript:chk_Submit('DEL');" class="btn btn-redy">삭제</a>

        </div>

  </form>
  </div>
</section>
<!--#include file="footer.asp"-->
