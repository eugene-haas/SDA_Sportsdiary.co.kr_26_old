<!--#include file="../Library/ajax_config.asp"-->
<%	
   '==================================================================================================
   '메인페이지 영상뉴스
   '==================================================================================================
	dim NowPage 	: NowPage 		= "1"
	dim PagePerData : PagePerData 	= "5"
	dim BlockPage 	: BlockPage 	= "5"
	dim iType 		: iType 		= "1"
	dim iDivision 	: iDivision 	= "300"		'iDivision -  1 : 전체 - 일반뉴스+영상뉴스, 2 : 일반뉴스, 3 : 영상뉴스, 200:일반뉴스(메인), 300:영상뉴스(메인)
	dim iSubType 	: iSubType 		= ""
	dim iSearchCol 	: iSearchCol 	= "T"
	dim iSearchText	: iSearchText 	= ""
	dim iYear 		: iYear 		= ""
	dim iNoticeYN 	: iNoticeYN 	= ""
	dim iLoginID 	: iLoginID 		= decode(fInject(Request.cookies(SportsGb)("UserID")), 0)
	dim LCnt		: LCnt 			= 0									 
	dim LRs, LSQL										 
%>
<script type="text/javascript">
	function MainFreeReadLink(i1, i2) {
		var selSearchValue1 = "";
		var selSearchValue2 = "N";
		var selSearchValue = "T";
		var txtSearchValue = "";
		post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}
</script>
<%
	

	LSQL = "EXEC SD_Tennis.dbo.Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainNoticeCnt & "','','','','S2Y','','','','',''"

	'response.Write "LSQL="&LSQL&"<br>"
	'response.End

	SET LRs = DBCon3.Execute(LSQL) 										
	IF Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
			LCnt = LCnt + 1

			%>
			<li>
			  <a href="javascript:MainFreeReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage%>');" class="youtube_link"></a>
				<span class="figure">
				  <iframe src="https://www.youtube.com/embed/<%=LRs("Link")%>?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
				</span>
				<span class="figcaption">
				  <strong><%=LRs("Subject")%></strong>
				</span>
			</li>
			<%
			LRs.MoveNext
		Loop
	End If
		LRs.close
	SET LRs = Nothing
			   
	DBClose3()			   
%>
