<!-- #include virtual = "/pub/header.swimAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<head>
<title>excel</title>
</head>
<body >

<%
'request
levelno = chkInt(chkReqMethod("lno", "GET"), 1)
tidx = chkInt(chkReqMethod("tidx", "GET"), 1)

'기본정보#####################################

SQL = " Select EntryCnt,attmembercnt,courtcnt,level,bigo,JooArea,JooDivision,joocnt from   tblRGameLevel  where    DelYN = 'N' and  gametitleidx = "&tidx&"  and level = '"&levelno&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
JooDivision = rs("JooDivision")
JooArea = rs("JooArea")
endgroup = rs("joocnt")

'If request("test") <> "" then
if(Cdbl(JooDivision) <> 1) Then
jorder = fc_tryoutGroupMerge(endgroup,JooDivision, JooArea)
IsChangeJoo =True
End If
'End if
	
		
	
	
	
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "


	strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0  and a.gubun in ( 0, 1) and a.DelYN = 'N' "
	strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별
	strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint, a.rankpoint + b.rankpoint as totalPointWithPartner, a.AttFlag,  a.GiftFlag, a.gameMemberIDX, a.PlayerIDX as PlayerIDX, b.PlayerIDX as PatnerPlayerIDX, a.gubun,t_rank, a.areaChanging, A.SeedFlag, A.rndno1, A.rndno2, A.place"
	strfield = strAfield &  ", " & strBfield 
	SQL = "select " & strfield & " from  " & strtable & " as a " 
	SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
	SQL = SQL & "where " & strwhere & strsort



	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
	arrRS = rs.getrows()
	End If
	Set rs = Nothing




If request("test") = "" then
Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=예선_" & date() &  ".xls"
End if


%>

<%If IsChangeJoo = true then%>
<%

sub drowjooline(ByVal jno)
    If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		  g_no = arrRS(0,ar)
		  s_no = arrRS(1,ar)
		  m_idx = arrRS(2,ar)

		  p1name = arrRS(3,ar)
		  p2name = arrRS(8,ar)

		  tnm1 = arrRS(4,ar)
		  tnm2 = arrRS(5,ar)
		  tnm3 = arrRS(9,ar)
		  tnm4 = arrRS(10,ar)
			
			If  CDbl(jno) = CDbl(g_no) Then
				If s_no = 1 then
				  Response.write "<td>"&g_no &"</td>"
				  If tnm2 = "" Then
					  Response.write "<td>"& p1name &"</td><td>"&tnm1&"</td>"
				  Else
					  Response.write "<td>"& p1name &"</td><td>"&tnm1 &","& tnm2&"</td>"
				  End if

				  If tnm4 = "" Then
					  Response.write "<td>"& p2name &"</td><td>"&tnm3 &"</td>"
				  Else
					  Response.write "<td>"& p2name &"</td><td>"&tnm3 &","& tnm4&"</td>"
				  End if
				Else
				  If tnm2 = "" Then
					  Response.write "<td>"& p1name &"</td><td>"&tnm1&"</td>"
				  Else
					  Response.write "<td>"& p1name &"</td><td>"&tnm1 &","& tnm2&"</td>"
				  End if

				  If tnm4 = "" Then
					  Response.write "<td>"& p2name &"</td><td>"&tnm3 &"</td>"
				  Else
					  Response.write "<td>"& p2name &"</td><td>"&tnm3 &","& tnm4&"</td>"
				  End if
				End If
			End If

			If CDbl(jno) > Cdbl(g_no) Then
				'Response.write "<br>"
				'Exit sub
			End if
		next
	End if
End sub


%>

<table border="1">
		<tr><td>조</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td></tr>
<%
For i = 1 To ubound(jorder)
	Response.write "<tr>	"
	Call drowjooline(jorder(i))
	Response.write "</tr>"
next
%>
</table>

<%else%>
	<table border="1">
		<tr><td>조</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td><td>이름</td><td>클럽</td></tr>
		<tr><td>1</td>
	<%
	Nextgno = 1
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

		  g_no = arrRS(0,ar)
		  s_no = arrRS(1,ar)
		  m_idx = arrRS(2,ar)

		  p1name = arrRS(3,ar)
		  p2name = arrRS(8,ar)

		  tnm1 = arrRS(4,ar)
		  tnm2 = arrRS(5,ar)
		  tnm3 = arrRS(9,ar)
		  tnm4 = arrRS(10,ar)

		  If CDbl(Nextgno) <> CDbl(g_no) Then
			  Response.write "</tr>"
			  Response.write "<tr><td>"&g_no &"</td>"
		  End If
		  
			  If tnm2 = "" Then
				  Response.write "<td>"& p1name &"</td><td>"&tnm1&"</td>"
			  Else
				  Response.write "<td>"& p1name &"</td><td>"&tnm1 &","& tnm2&"</td>"
			  End if

			  If tnm4 = "" Then
				  Response.write "<td>"& p2name &"</td><td>"&tnm3 &"</td>"
			  Else
				  Response.write "<td>"& p2name &"</td><td>"&tnm3 &","& tnm4&"</td>"
			  End if
			nextgno = g_no 
		Next  
		END If
	%>
	</tr>
	<table>
<%End if%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
