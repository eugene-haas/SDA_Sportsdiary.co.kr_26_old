<!--#include file="../../dev/dist/config.asp"-->
<%

	Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iDivision = "4"                   ' 1 : 뉴스 2 : 공지 3 : 계간유도 4 : 전체 뉴스/공지
  iLoginID = decode(fInject(Request.cookies("UserID")),0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  'Request Data
	iSubType = fInject(Request("iSubType"))
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))
	iNoticeYN = fInject(Request("iNoticeYN"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSubType) = 0) Then iSubType = "" ' 구분
	if(Len(iNoticeYN) = 0) Then iNoticeYN = "" ' 구분
	if(Len(iSearchCol) = 0) Then iSearchCol = "S" ' 검색 구분자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  ' 리스트 조회
  iType = "1"

  LSQL = "EXEC News_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','','" & iLoginID & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)
										
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt = LCnt + 1
%>
<tr>
	<td><%=LRs("Num") %></td>
	<td><%=LRs("SubTypeName") %></td>
	<td class="name"><a href="javascript:;" onclick="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');"><%=LRs("Subject") %></a></td>
	<td><%=LRs("NoticeYN") %></td>
	<td><%=LRs("InsDateCv") %></td>
</tr>
<%
		LRs.MoveNext
	Loop

End If
  
LRs.close
  
'JudoKorea_DBClose()
%>