<%
'#############################################
'넌도 종목관리 생성
'DB SD_Riding 
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblTeamGbInfo 
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End if

	Set db = new clsDBHelper 


	  strFieldName = "  setpointarr,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby "
	  SQL = "Select " &strFieldName& " from tblTeamGbInfo where DelYN = 'N' and TeamGbIDX = " & idx 
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
	  End If

	If IsArray(arrPub) Then
			setpointarr = arrPub(0, 0)
			TeamGbNm = arrPub(5, 0)
			ridingclass = arrPub(8,0)
			ptvaluearr = Split(setpointarr, "`")

				Select Case TeamGbNm
				Case "장애물"
					title = "장애물"
					pttype = "J"
				Case "마장마술"
					title = "마장마술"
					pttype = "M"
				Case "복합마술"
					If  InStr(ridingclass, "장애물") > 0  Then
						title = "복합마술 장애물"	
						pttype = "J"
					Else
						title = "복합마술 마장마술"	
						pttype = "M"
					End if
				End Select 
	
		If pttype = "J" Then
			lenpt = 9
		Else
			lenpt = 44
			Dim ptarr(45)
			getpt = ubound(ptarr)
			For a = 0 To ubound(ptarr)
				ptarr(a) = (getpt) * 10
				getpt = getpt - 1
			next
		End if
	
	End if



  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
	<!-- 콘텐츠 :: 마장마술 -->
	<div id="c_pointMajang" class="modal-content" style="width:100%;">
		<div class="modal-header">
			<button type="button" class="close" onmousedown="$('#pointInputModal').modal('hide');">x</button>
			<h4>포인트 - <%=title%></h4>
		</div>
		<div class="modal-body">

			<table class="table">
				<thead>
					<tr>
						<th>순위</th><th>포인트</th><th>순위</th><th>포인트</th><th>순위</th><th>포인트</th><th>순위</th><th>포인트</th><th>순위</th><th>포인트</th>
					</tr>
				</thead>

				<tbody>
					<%

						For i = 0 To lenpt
							p = i + 1
							Select Case p
							Case 1 '시작
								%>
								<tr>
								<td><%If pttype="J" then%><%=P%>위<%else%><%=ptarr(i)%><%End if%></td>
								<td><input type="number" id="kpoint_<%=i%>" value="<%=ptvaluearr(i)%>" placeholder="0" class="form-control" onfocus="px.chkZero(this)" onblur = "mx.setP(this, <%=idx%>,<%=i%>)"/></td><%
							Case lenpt + 1 '끝
								%>
								<td><%If pttype="J" then%><%=P%>위<%else%><%=ptarr(i)%><%End if%></td>
								<td><input type="number" id="kpoint_<%=i%>" value="<%=ptvaluearr(i)%>" placeholder="0" class="form-control" onfocus="px.chkZero(this)" onblur = "mx.setP(this, <%=idx%>,<%=i%>)"/></td></tr><%
							Case Else

								If p Mod 5 = 1 Then '줄바꿈
								%>
									</tr><tr>
									<td><%If pttype="J" then%><%=P%>위<%else%><%=ptarr(i)%><%End if%></td>
									<td><input type="number" id="kpoint_<%=i%>" value="<%=ptvaluearr(i)%>" placeholder="0" class="form-control" onfocus="px.chkZero(this)" onblur = "mx.setP(this, <%=idx%>,<%=i%>)"/></td><%	
								Else
								%>
									<td><%If pttype="J" then%><%=P%>위<%else%><%=ptarr(i)%><%End if%></td>
									<td><input type="number" id="kpoint_<%=i%>" value="<%=ptvaluearr(i)%>" placeholder="0" class="form-control" onfocus="px.chkZero(this)" onblur = "mx.setP(this, <%=idx%>,<%=i%>)"/></td><%							
								End If
								
							End Select
						Next
					%>
				</tbody>

			</table>

		</div>
	</div>
