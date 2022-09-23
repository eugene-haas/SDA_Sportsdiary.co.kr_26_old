<!--#include file="../Library/ajax_config.asp"-->
<%
  '==================================================================================================
	'메인페이지 일반뉴스
	'==================================================================================================
	dim NowPage 	: NowPage 		= "1"
	dim PagePerData : PagePerData 	= "10"
	dim BlockPage 	: BlockPage 	= "10"
	dim iType 		: iType 		= "1"
	dim iDivision 	: iDivision 	= "300"		'iDivision -  1 : 전체 - 일반뉴스+영상뉴스, 2 : 일반뉴스, 3 : 영상뉴스, 200:일반뉴스(메인), 300:영상뉴스(메인)
	dim iSubType 	: iSubType 		= ""
	dim iSearchCol 	: iSearchCol 	= "T"
	dim iSearchText	: iSearchText 	= ""
	dim iYear 		: iYear 		= ""
	dim iNoticeYN 	: iNoticeYN 	= ""
	dim iSearchCol1 	: iSearchCol1 = "S2Y"
	dim ieSearchCol2 	: ieSearchCol2 = "" ' ColumnistIDX
	dim iSearchCol2 : iSearchCol2 = decode(ieSearchCol2,0)
	dim iLoginID 	: iLoginID 		= decode(fInject(Request.cookies(SportsGb)("UserID")), 0)
	dim LCnt		: LCnt 			= 0
	dim LRs, LSQL
%>
<script type="text/javascript">
	// function MainMMediaViewLink(i1, i2) {
	//
	// 	var selSearchValue1 = "<%=iSubType%>";
	// 	var selSearchValue2 = "<%=iNoticeYN%>";
	// 	var selSearchValue = "<%=iSearchCol%>";
	// 	var txtSearchValue = "<%=iSearchText%>";
	//
	// 	var selSearchValue3 = "1"; // iDivision -  1 : 전체 - 일반뉴스+영상뉴스
	// 	var selSearchValue4 = "<%=iSearchCol1%>";
	//
	// 	var selSearchValue5 = "<%=ieSearchCol2%>";
	//
	// 	post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	// 	//post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	// }
</script>
<%


  LSQL = "EXEC SD_Tennis.dbo.Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainCLCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  SET LRs = DBCon3.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LCnt = LCnt + 1

      ImgSum1 = golbal_youtubeImg&LRs("Link")&"/hqdefault.jpg"
      %>
      <li class="m_movieList__item">
        <a href="javascript:;" onclick="javascript:MainMediaViewLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage%>');" class="m_movieList__link">
          <div class="m_movieList__photoWrap">
            <img src="<%=ImgSum1 %>" alt="" class="m_movieList__photo" />
          </div>
        </a>
        <span class="m_movieList__cap">
          <strong class="m_movieList__capTxt"><%=LRs("Subject")%></strong>
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
