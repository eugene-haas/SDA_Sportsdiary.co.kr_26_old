	<tr class="gametitle"   id="titlelist_<%=pidx%>">
		<%
			
			For i = 0 To Rs.Fields.Count - 1
					If Rs.Fields(i).name = "court1playerIDX" Then
						orangeidx = rsdata(1)
						greenidx = rsdata(2)

						sv1 =  rsdata(i - 2)
						sv2 =  rsdata(i - 1)
						
						courtpidx(0) = rsdata(i)
						courtpidx(1) = rsdata(i+1)
						courtpidx(2) = rsdata(i+2)
						courtpidx(3) = rsdata(i+3)

						i = i + 3
						Response.write "<td>"

						If courtpidx(0) <> "" then
						%>

						<table border="1" style="padding:0;margin:0;">
						<tr>
							<td style="border-left: thick double <%If sv1 = courtpidx(0) then%>#ff0000<%End if%><%If sv2 = courtpidx(0) then%>blue<%End if%>;background:
								<%If orangeidx = courtpidx(0) Or orangeidx = courtpidx(2)  then%>orange
								<%else%>green
								<%End if%>;"><%=courtpidx(0) %><%=arrDup%></td>
							
							<td style="border-right: thick double <%If sv1 = courtpidx(1) then%>#ff0000<%End if%><%If sv2 = courtpidx(1) then%>blue<%End if%>;background:
								<%If orangeidx = courtpidx(1) Or orangeidx = courtpidx(3)  then%>orange
								<%else%>green
								<%End if%>;"><%=courtpidx(1) %></td>
							</tr>
							
							<tr>
							<td style="border-left: thick double <%If sv1 = courtpidx(2) then%>#ff0000<%End if%><%If sv2 = courtpidx(2) then%>blue<%End if%>;background:
								<%If orangeidx = courtpidx(0) Or orangeidx = courtpidx(2)  then%>orange
								<%else%>green
								<%End if%>;"><%=courtpidx(2) %></td>
							<td style="border-right: thick double <%If sv1 = courtpidx(3) then%>#ff0000<%End if%><%If sv2 = courtpidx(3) then%>blue<%End if%>;background:
								<%If orangeidx = courtpidx(1) Or orangeidx = courtpidx(3)  then%>orange
								<%else%>green
								<%End if%>;"><%=courtpidx(3) %></td>
						</tr>
						</table>
						<%
						End if
						Response.write "</td>"					
						%>
						<td>
						<%If courtpidx(0) <> "" then%>
							<a href="gameDebug2.asp?req=<%=rsdata(0)%>"  class="btn_a" target="_blank">상세</a>
						<%End if%></td><%
					Else

						if(Cdbl(i) = 10 ) Then 
						%>
						<td><input type="text" value="<%=rsdata(i)%>" onblur='mx.updateMSet("1","<%=rsdata(0)%>",this);' style="width:50px">  </input>   </td>
						<%
						ELSEIF (Cdbl(i) = 11) tHEN
						%>
						<td><input type="text" value="<%=rsdata(i)%>"  onblur='mx.updateMSet("2","<%=rsdata(0)%>",this);' style="width:50px">  </input>   </td>
						<%	
						ELSE
								if(Cdbl(i) = 3) Then
									if ISNULL(rsdata(3)) = false tHEN
										if(Cdbl(IsRound) <> Cdbl(rsdata(3))) Then
											IsRound = rsdata(i)
											j = 1
										End if
									ELSE 
										j = 1
									END IF
									
							
									Response.write "<td>" & rsdata(i)   & "</td>"

									if ISNULL(rsdata(i)) = false tHEN
										Response.write "<td>" & j &"</td>"
									else
									Response.write "<td></td>"
									END IF
							'ELSEif (Cdbl(i) = 5) Then
							'	if(Cdbl(titleName) <> Cdbl(rsdata(5))) Then
							'		titleName = rsdata(i)
							'	END IF
							ELSE
									Response.write "<td>" & rsdata(i)   & "</td>"
							END IF
						End IF
					End if
			Next
		%>
	</tr>