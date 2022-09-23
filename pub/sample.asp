<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
  Set db = new clsDBHelper

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "

		strwhere = " a.GameTitleIDX = 74 and  a.gamekey3 = 20101001 and a.tryoutgroupno > 0 and a.gubun = 1 and a.t_rank in (1,2)"
		strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순

		strAfield = " a. gamememberIDX, a.userName , a.tryoutgroupno, a.tryoutsortno, a.teamAna , a.teamBNa , a.tryoutstateno, a.t_rank,a.key3name "
		strBfield = " b.partnerIDX, b.userName, b.teamANa  , b.teamBNa , b.positionNo "
		strfield = strAfield &  ", " & strBfield 

		
		SQL = "select max(a.tryoutgroupno) from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		maxgno = rs(0)
		
		
		SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If Not rs.EOF Then 
		arrRS = rs.getrows()
		End If
%>

<table border="1">
		<tbody>
			<%
			For joo =1 To maxgno
				teamcnt = 0
				rtcnt = 0
				Response.write "<tr>"
				Response.write "<td>제"&joo&"조</td>"

				If IsArray(arrRS) Then
					r = 1
					For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
						aname		= arrRS(1, ar) 
						groupno	= arrRS(2, ar) 
						sortno		= arrRS(3, ar) 
						bname		= arrRS(10, ar) 
						rankno		= arrRS(7, ar) 

						If CDbl(joo) = CDbl(groupno) Then
							teamcnt = teamcnt + 1
							%>
								<%If r = 1 And CDbl(rankno) = 2 then%>
								<td><span class="player">일등자리</span></td>
								<%
								teamcnt = teamcnt + 1
								End if%>
								<td><span class="player"><%=aname%>+<%=bname%> (<%=rankno%>)</span></td>
							<%						
							End If
					r = r + 1
					Next
				End If				

				For n = 1 To 2- CDbl(teamcnt)
					%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td>
					<td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%
				Next						

				Response.write "</tr>"					
			tempjoo = groupno
			Next
			%>

		</tr>
		</tbody>
</table>