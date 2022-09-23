<!--#include file="../dev/dist/config.asp"-->
<%
	ifilename = date()& "_계간유도신청내역.xls"
	Response.Buffer = True      
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&Server.URLPathEncode(ifilename)
%>
<%
  
	Dim LCnt1
	LCnt1 = 0

  iLoginID = decode(fInject(Request.cookies("UserID")),0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  'Request Data
	iStatus = fInject(Request("iStatus"))
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

	isyear = fInject(Request("isyear"))
	selss = fInject(Request("selss"))
	ieyear = fInject(Request("ieyear"))
	seles = fInject(Request("seles"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iStatus) = 0) Then iStatus = "" ' 구분
	if(Len(iSearchCol) = 0) Then iSearchCol = "D" ' 검색 구분자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	if(Len(isyear) = 0) Then

		iStartPosition = ""
		isyear = ""
		selss = ""

	else

		iStartPosition = isyear&"_"&selss

	end if

	if(Len(ieyear) = 0) Then

		iEndPosition = ""
		ieyear = ""
		seles = ""

	else

		iEndPosition = ieyear&"_"&seles

	end if

  iType = "3"				' 1:조회, 2:총갯수, 2:전체조회(출력용)
	iProgressYN = ""	' 현재사용안함

  LSQL = "EXEC Subscription_Board_Search_Admin_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iProgressYN & "','" & iStartPosition & "','" & iEndPosition & "','','','" & iStatus & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "'"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
%>
<html>
	<head>
		<title>계간유도 구독신청 내역</title>
	</head>
	<body>
		<table border="1">
			<tr>
        <td style="background-color:#bdfbca;">순번</td>
        <!--<td style="color:blue">엑셀로</td>-->
        <td style="background-color:#bdfbca;">구독구분</td>
				<td style="background-color:#bdfbca;">신청자</td>
				<td style="background-color:#bdfbca;">입금자</td>
				<td style="background-color:#bdfbca;">연락처</td>
				<td style="background-color:#bdfbca;">이메일</td>
				<td style="background-color:#bdfbca;">우편번호</td>
				<td style="background-color:#bdfbca;">주소</td>
				<td style="background-color:#bdfbca;">주소상세</td>
				<td style="background-color:#bdfbca;">상태</td>
				<td style="background-color:#bdfbca;">시작년도</td>
				<td style="background-color:#bdfbca;">시작호</td>
				<td style="background-color:#bdfbca;">종료년도</td>
				<td style="background-color:#bdfbca;">종료호</td>
				<td style="background-color:#bdfbca;">체크</td>
			</tr>
<%
		Do Until LRs.Eof
        
				LCnt1 = LCnt1 + 1
%>
			<tr>
				<td><%=LTrim(LRs("Num")) %></td>
				<td><%=LRs("Division") %></td>
				<td><%=LRs("Name") %></td>
				<td><%=LRs("DepositorName") %></td>
				<td><%=LRs("Phone") %></td>
				<td><%=LRs("Email") %></td>
				<td><%=LRs("PostCode") %></td>
				<td><%=LRs("Address") %></td>
				<td><%=LRs("AddressDetail") %></td>
				<td><%=LRs("StatusName") %></td>
				<td><%=LRs("StartYear") %></td>
				<td><%=LRs("StartSectionName") %></td>
				<td><%=LRs("EndYear") %></td>
				<td><%=LRs("EndSectionName") %></td>
				<td></td>
			</tr>			
<%
      LRs.MoveNext
		Loop
%>
		</table>
	</body>
</html>
<%
	End If
  LRs.close
%>
