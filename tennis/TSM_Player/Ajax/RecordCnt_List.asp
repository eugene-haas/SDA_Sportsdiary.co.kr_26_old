<!--#include file="../Library/ajax_config.asp"-->
<%
	Dim iTotalCount, iTotalPage, LCnt0 '페이징
	LCnt0 = 0

	Dim LCnt, NowPage, PagePerData '리스트
	LCnt = 0

	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)

	NowPage = fInject(Request("i2"))  ' 현재페이지
	PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
	BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	  iType = "1"        ' 1:총갯수, 2:조회
	   LSQL = " EXEC Search_TennisRPing_log_RankingList_01 '"&iType&"','"&NowPage&"', 10, 10, '20102', ''"
	  Set LRs = DBCon4.Execute(LSQL)
										
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt = LCnt + 1
				iTotalPage = LRs("TOTALPAGE")
		LRs.MoveNext
	Loop
End If
LRs.close

DBClose4()
response.Write iTotalPage
%>