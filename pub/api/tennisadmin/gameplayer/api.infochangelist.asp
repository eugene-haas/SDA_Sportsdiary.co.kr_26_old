<%
	'request
	pageno = 1
	If hasown(oJSONoutput, "PAGENO") = "ok" then
		pageno = oJSONoutput.PAGENO
	End If

	Set db = new clsDBHelper
	
	intPageNum = pageno
	intPageSize = 10

	strTableName = " sd_TennisBoard  as a "
	strFieldName = " seq , (select top 1 gametitlename from sd_tennistitle where gametitleidx = a.gameTitleIDX) as '대회명' ,contents as '요청내용',writeday as '작성일',workok "
	'strFieldName = " seq ,gameTitleIDX,contents,writeday,workok "
	strSort = "  ORDER By seq Desc"
	strSortR = "  ORDER By  seq Asc"
	strWhere = " tid = 100 "	


	'/////////////////////////////////////////////
		Sub rsDrow_info(ByVal rs)

			For i = 0 To Rs.Fields.Count - 1
				'response.write  Rs.Fields(i).name &","
			Next
			
			response.write "<table class='table-list' border='1'>"
			Response.write "<thead id=""headtest"">"
			For i = 0 To Rs.Fields.Count - 1
				response.write "<th>"& Rs.Fields(i).name &"</th>"
			Next
			Response.write "</thead>"

			ReDim rsdata(Rs.Fields.Count) '필드값저장

			x  = 1
			Do Until rs.eof
				For i = 0 To Rs.Fields.Count - 1
					rsdata(i) = rs(i)
				Next
				
				%>
					<tr class="gametitle" id="info_<%=x%>">
						<%

							For i = 0 To Rs.Fields.Count - 1
							If Rs.Fields(i).name = "seq" Then
								seq = rsdata(i)
							End If
		
							If Rs.Fields(i).name = "요청내용" Then
								tdstyle = "style='text-align:left;padding-left:20px;line-height:20px;'"
							Else
								tdstyle = ""
							End if

							Response.write "<td "&tdstyle&">"
		If Rs.Fields(i).name = "workok" then
		%>
		<br>
		<label class="switch"  title="완료">
        <input type="checkbox"  id="w_<%=seq%>" class="checkboxFlag" onClick='mx.workok(<%=seq%>,this);' value="<%=rsdata(i)%>"  <%If CDbl(rsdata(i)) = 1 Then%> checked<%END IF%>> <!-- name="paymentCheckBox" -->
        <span class="slider round"></span>
        </label>


		<br><br><a href="javascript:mx.delOk(<%=seq%>,'info_<%=x%>')" class="btn">삭제</a>
		<%
		Else
							Response.write rsdata(i)		
		end if

								Response.write "</td>"
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
		End Sub
	'/////////////////////////////////////////////	


	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )


	%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'>정보변경요청</h3>
</div> 	
<div id="orderinfo" style="width:98%;margin:auto;height:500px;overflow:auto;border: 1px solid #73AD21;">
<%Call rsDrow_info(rs)%>
</div>

<%Call userPagingScript (intTotalPage, 10, pageno, "mx.reqInfoChange" )%>






<%
  db.Dispose
  Set db = Nothing
%>