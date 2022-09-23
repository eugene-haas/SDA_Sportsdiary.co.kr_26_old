<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	tidx = request("tidx")
	If isnumeric(tidx) = False Then
		Response.End
	End if



	Set db = new clsDBHelper

	SQL = "select "
	SQL = SQL & " (select username from tblreader where idx = a.leaderidx ) as '지도자명' , a.teamnm as '팀명칭', a.cdbnm as '종별', a.username as '선수명' "
	SQL = SQL & " from tblGameRequest_imsi as a inner join tblGameRequest_imsi as b on a.seq = b.seq and b.delyn = 'N 'where a.tidx = "&tidx&" and a.delyn = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	if not rs.eof then
	boonm = rs(0)
	end if

	'엑셀출력################
	Response.Buffer = True
	'Response.ContentType = "application/octet-stream"
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&tidx & "_"&Replace(Date(),"-","")&"" & ".xls"
	'엑셀출력################


%>
<html lang="ko">
  <head>

    <meta charset="utf-8">
    <title>지도자 임지 작성명단</title>
  </head>
  <body>
<%
		response.write "<table class='table' border='1'>"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		x = 1
		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
							If Rs.Fields(i).name = "선수ID"  Or Rs.Fields(i).name = "기록"   Then
								%><td style="mso-number-format:'\@'"><%=rsdata(i)%></td><%
							ElseIf Rs.Fields(i).name = "순위" Then
								%><td><%=x%></td><%
							else
								Response.write "<td>" & rsdata(i)   & "</td>"
							End if
						Next
					%>
				</tr>
			<%
		x = x + 1
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
%>
  </body>
</html>



<%
	Call db.Dispose
	Set db = Nothing
%>
