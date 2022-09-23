<!--#include file="../dev/dist/config.asp"-->
<%
	ifilename = date()& "_선수증재발급.xls"
	Response.Buffer = True      
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&Server.URLPathEncode(ifilename)
%>

<%
  
	Dim LCnt1
	LCnt1 = 0

  'iLoginID = decode(fInject(Request.cookies("UserID")),0)

  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
	iDivision = 1 '선수증재발급
  'Request Data
	NowPage = fInject(Request("i2"))  ' 현재페이지
	iSearchText = fInject(Request("i3"))
	iStatus = fInject(Request("i4"))
	iStartDate = fInject(Request("i5"))
	iEndDate = fInject(Request("i6"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	iType = "3"				' 1:조회, 2:총갯수, 2:전체조회(출력용)
  LSQL = "EXEC Admin_OnlineService_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iStatus & "','" & iCertificationName & "','" & iStartDate & "','" & iEndDate & "','" & iLoginID & "'"
	 Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
%>

<html>
	<head>
		<title>선수증재발급</title>
	</head>
	<body>
		<table border="1">
			<tr>
        <td style="background-color:#bdfbca;">순번</td>
        <!--<td style="color:blue">엑셀로</td>-->
        <td style="background-color:#bdfbca;">증명서 종류</td>
				<td style="background-color:#bdfbca;">상태</td>
				<td style="background-color:#bdfbca;">신청날짜</td>
				<td style="background-color:#bdfbca;">이름</td>
				<td style="background-color:#bdfbca;">아이디</td>
				<td style="background-color:#bdfbca;">핸드폰</td>
				<td style="background-color:#bdfbca;">발급용도</td>
				<td style="background-color:#bdfbca;">수령방법</td>
				<td style="background-color:#bdfbca;">수수료</td>
				<td style="background-color:#bdfbca;">우편번호</td>
				<td style="background-color:#bdfbca;">주소</td>
			</tr>
<%
		Do Until LRs.Eof
        
				LCnt1 = LCnt1 + 1
%>
			<tr>
				<td><%=LTrim(LRs("Num")) %></td>
				<td><%=LRs("CertificateName") %></td>
				<td><%=LRs("StatusName") %></td>
				<td><%=LRs("InsDateCv") %></td>
				<td><%=LRs("Name") %></td>
				<td><%=LRs("InsID") %></td>
				<td><%=LRs("Phone") %></td>
				<td><%=LRs("PublishingType") %></td>
				<td><%=LRs("ReceiveType") %></td>
				<td><%=LRs("Payment") %></td>
				<td><%=LRs("Receipt_PostCode") %></td>
				<td><%=LRs("Receipt_Address")  & " " & LRs("Receipt_AddressDetail") %> </td>
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
