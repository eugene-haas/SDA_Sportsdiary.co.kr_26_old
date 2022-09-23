<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%

'request 처리##############
REQ = chkReqMethod("p", "POST")
	If REQ <> "" Then
		Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)
	Else
		 page = chkInt(chkReqMethod("page", "GET"), 1)
	End If

If totalCount = "" Then
totalCount = -1
End If


'db 호출
  Set db = new clsDBHelper


'종목선택 불러오기

strField = " a.classIDX, a.classCode, a.className, b.videoCount "
strTable = " tblClassList a "
strTableSub = " INNER JOIN ( SELECT COUNT(*) videoCount, classCode FROM k_gameVideoInfo WHERE DelYN = 'N' GROUP BY classCode ) b ON a.classCode = b.classCode "
srtOrder = " className ASC "
SQL = " SELECT "&strField&" FROM "&strTable&strTableSub&" ORDER BY "& srtOrder &""

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrClass = rs.GetRows()
End If

db.dispose()

%>

		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회실적검색</h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				  <!-- #include virtual = "/pub/html/ksports/gameSearchform.asp" -->
				</div>
			<!-- e: 정보 검색 -->

			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tbody id="gamelist">

							<!-- #include virtual = "/pub/html/ksports/gameSearchList.asp" -->
						 </tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->

		</div>
		<!-- s: 콘텐츠 끝 -->
