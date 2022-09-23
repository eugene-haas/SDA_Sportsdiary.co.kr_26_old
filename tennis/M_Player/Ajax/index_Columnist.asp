<!--#include file="../Library/ajax_config.asp"-->
<%
    '==================================================================================================
  '메인페이지 일반뉴스
  '==================================================================================================
  dim NowPage   : NowPage     = "1"
  dim PagePerData : PagePerData   = "10"
  dim BlockPage   : BlockPage   = "10"
  dim iType     : iType     = "1"
  dim iDivision   : iDivision   = "12"
  dim iSubType  : iSubType    = ""
  dim iSearchCol  : iSearchCol  = "T"
  dim iSearchText : iSearchText   = ""
  dim iYear     : iYear     = ""
  dim iNoticeYN   : iNoticeYN   = ""
  dim iSearchCol1   : iSearchCol1 = "S2Y"
  dim ieSearchCol2  : ieSearchCol2 = "" ' ColumnistIDX
  dim iSearchCol2 : iSearchCol2 = decode(ieSearchCol2,0)
  dim iLoginID  : iLoginID    = decode(fInject(Request.cookies(SportsGb)("UserID")), 0)
  dim LCnt    : LCnt      = 0
%>
<script type="text/javascript">
  function MainCMediaViewLink(i1, i2, iselSearchValue5, TSubject) {

    var selSearchValue1 = "<%=iSubType%>";
    var selSearchValue2 = "<%=iNoticeYN%>";
    var selSearchValue = "<%=iSearchCol%>";
    var txtSearchValue = "<%=iSearchText%>";

    var selSearchValue3 = "<%=iDivision%>"; // iDivision
    var selSearchValue4 = "<%=iSearchCol1%>";

    var selSearchValue5 = iselSearchValue5;

    post_to_url('../Column/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'TSubject': TSubject });

  }
</script>
<%
   '==================================================================================================
   '컬럼리스트 컨텐츠
   '==================================================================================================
  dim LRs, LSQL
  dim RE_DATA

  RE_DATA = "<li class='list_tit'>SD 칼럼</li>"

  LSQL = "    SELECT TOP 3 B.MSeq MSeq"
  LSQL = LSQL & "   ,B.ColumnistIDX ColumnistIDX"
  LSQL = LSQL & "   ,B.Subject Subject"
  LSQL = LSQL & "   ,B.Name as Name"
  LSQL = LSQL & "   ,C.Subject as GSubject"
	LSQL = LSQL & "   ,(case	when	Convert(char(10), B.InsDate + 1, 120) >= Convert(char(10), GetDate(), 120)"
	LSQL = LSQL & "   					then	'Y'"
	LSQL = LSQL & "   				else	'N'"
	LSQL = LSQL & "   	end) as NewYN"
  LSQL = LSQL & " FROM [SD_Tennis].[dbo].[Community_Board_Tbl] B"
  LSQL = LSQL & "   inner join [SD_Tennis].[dbo].[tblColumnist] C on B.ColumnistIDX = C.ColumnistIDX and C.DelYN = 'N' "
  LSQL = LSQL & "     AND C.DelYN = 'N'"
  LSQL = LSQL & "     AND C.ViewYN = 'Y'"
  LSQL = LSQL & " WHERE B.ColumnistIDX <> ''"
  LSQL = LSQL & "   AND B.DelYN = 'N'"
  LSQL = LSQL & "   AND B.OpenYN = 'Y'"
  LSQL = LSQL & "   AND B.NoticeYN = 'Y'"
	LSQL = LSQL & "   AND B.ColumnYN = 'Y'"
  LSQL = LSQL & " ORDER BY InsDate DESC"

  'response.write LSQL

  SET LRs = DBCon3.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof

        rColumnistIDX = encode(LRs("ColumnistIDX"),0)
        rMSeq = encode(LRs("MSeq"),0)

        rName = LRs("Name")

        RE_DATA = RE_DATA & "<li>"
        'RE_DATA = RE_DATA & "  <a href='../Column/view.asp?ColumnistIDX="&LRs("ColumnistIDX")&"&MSeq="&LRs("MSeq")&"'>"
        RE_DATA = RE_DATA & "  <a href=""javascript:;"" onclick=""javascript:MainCMediaViewLink('"&rMSeq&"','"&NowPage&"','"&rColumnistIDX&"','"&LRs("GSubject")&"');"" class=""youtube_link"">"

        'if Len(LRs("GSubject")) > 6 then
        'RE_DATA = RE_DATA & "    <span><b>["&left(LRs("GSubject"), 5)&"..]</b></span>"
        'else
        'RE_DATA = RE_DATA & "    <span><b>["&LRs("GSubject")&"]</b></span>"
        'end if

        if LEN(rName) < 3 then
        RE_DATA = RE_DATA & "    <span><b>["&rName&" 칼럼]</b></span>"
        else
        RE_DATA = RE_DATA & "    <span><b>["&LEFT(rName,3)&" 칼럼]</b></span>"
        end if

        RE_DATA = RE_DATA & "    <span>"&LRs("Subject")&"</span>"
				if LRs("NewYN") = "Y" then
        RE_DATA = RE_DATA & "  <span class='ic-new-bg'><span class='ic-new'>N</span>"
				end if
        RE_DATA = RE_DATA & "  </a>"
        RE_DATA = RE_DATA & "</li>"

      LRs.MoveNext
    Loop
  Else
    RE_DATA = RE_DATA & "<li>등록된 정보가 없습니다.</li>"
  End IF
    LRs.close
  SET LRs = Nothing

  DBClose3()

  response.write RE_DATA
%>
