<%
'#############################################
'검색이름의 참가팀 대진표 목록
'#############################################
	Set db = new clsDBHelper

	tidx = oJSONoutput.get("TIDX")
	cda = oJSONoutput.get("CDA")
	pidx = oJSONoutput.get("PIDX")

	'참가종목을 구한다. 클릭하면 표시해 준다?
	amo = "  (select top 1 resultopenAMYN from tblRgamelevel where delyn='N' and gametitleidx = a.gametitleidx and gbidx = a.gbidx ) as  amopen "
	pmo = "  (select top 1 resultopenPMYN from tblRgamelevel where delyn='N' and gametitleidx = a.gametitleidx and gbidx = a.gbidx ) as  pmopen "
	
	fld = " a.CDA,a.CDC, a.CDCNM,a.CDB,a.CDBNM, (case when itgubun = 'I' then a.UserName else b.username  end) as unm   ,a.TEAMNM,levelno , "&amo&" ,tryoutgroupno as joono,a.sidonm, (case when itgubun = 'I' then a.userclass else b.userclass  end) as uclass, a.startType,   " 
	fld = fld & " a.tryoutgroupno,a.tryoutsortno, a.tryouttotalorder, a.tryoutresult, a.roundno, a.sortno, a.gameresult,a.gameorder, a.tryoutOrder, "& pmo & ",a.gameMemberIDX"

	SQL = "select "&fld&" from sd_gameMember as a left join sd_gameMember_partner as b on a.gamememberIDX = b.gamememberIDX and a.DelYN = 'N' and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.CDA = '"&cda&"' and (a.playeridx = '"&pidx&"' or b.playeridx = '"&pidx&"')  order by a.CDB"

	'Response.write sql
	'Response.end

	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arr = rs.GetRows()
		unm = arr(5,0)
		joono = arr(9,0) '첫번재 조번호 일뿐
	End if	


	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
'################################################


%>

<div class="match-result-con__tab-box">
  <h3 class="hide">경기순서 표</h3>
  <table class="match-result-con__tab-box__con">
	<thead class="match-result-con__tab-box__con__thead">
	  <tr>
		<th>종별.</th>
		<th>순위</th>
		<th>선수명</th>
		<th>시도</th>
		<th>소속</th>
		<th>학년</th>
		<th>기록</th>
		<th>상세</th>		
	  </tr>
	</thead>
	<tbody class="match-result-con__tab-box__con__tbody">
	  <!-- s_highlight = 1,2,3 위 꾸며줌 -->

		<%
			If IsArray(arr) Then
				For ari = LBound(arr, 2) To UBound(arr, 2)
					a_CDA = arr(0, ari)
					a_CDC = arr(1, ari)
					a_CDCNM = arr(2, ari)
					a_CDB = arr(3,ari)
					a_CDBNM = arr(4,ari)
					a_UNM1 = arr(5, ari)
					a_TEAMNM = arr(6, ari)
					a_amopen  = arr(8, ari)
					a_sidonm = arr(10,ari)
					a_class = arr(11,ari)
					a_starttype = arr(12,ari)


					a_tryoutgroupno = arr(13,ari)
					a_tryoutsortno = arr(14,ari)
					a_tryouttotlorder = arr(15,ari)
					a_tryoutresult = arr(16,ari)
					a_roundno = arr(17,ari)
					a_sortno = arr(18,ari)
					a_gameresult = arr(19,ari)
					a_gameOrder = arr(20,ari)
					a_tryoutOrder = arr(21,ari)
					a_pmopen  = arr(22, ari)
					a_midx = arr(23,ari)

					If CDbl(a_tryoutsortno) > 0 Then
						If a_starttype = "1" Then
							rndstr = "예선"
						Else
							rndstr = "결승"
						End if
						%>
						  <tr>
							<td><%=a_CDCNM%></td>
							<td><span>
							<%
								Select Case a_CDA
								Case "D2" '경영
									If a_tryoutOrder <> "" Then
										Response.write rndstr & ":"&a_tryoutOrder&"위"
									End if
								Case "E2","F2" '다이빙/수구 '아티스틱
									If a_tryouttotlorder <> "" then
										Response.write a_tryouttotlorder&"위"
									End if
								End Select 									
							%>
							
							</span></td>
							<td><%=unm%></td>
							<td><%=a_sidonm%></td>
							<td><%=shortNm(a_TEAMNM)%></td>
							<td><%=a_class%></td>
							<td>
							<%'If a_amopen = "Y" And a_pmopen = "Y" then%>
									<%
										Select Case a_CDA
										Case "D2" '경영
											Call SetRC(a_tryoutresult)
										Case "E2" '다이빙/수구
											If  a_CDC = "31" Then
												
											Else
												If a_tryoutresult = "0" Then
												else
												Response.write FormatNumber(a_tryoutresult / 100 ,2)'Left(a_tryoutresult,3)& "." & Right(a_tryoutresult,2)
												End if
											End if
										Case "F2" '아티스틱
												If a_tryoutresult = "0" Then
												else
												Response.write FormatNumber(a_tryoutresult / 10000 ,4)'Left(a_tryoutresult,2)& "." & Right(a_tryoutresult,4)
												End if
										End Select 									
									%>								


							<%'End if%>
							</td>
							<td><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=a_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button></td>
						  </tr>
						<%						
					End if

					If CDbl(a_sortno) > 0 Then
						%>
						  <tr>
							<td><%=a_CDCNM%></td>
							<td><span><%If a_gameOrder <> "" then%>결승:<%=a_gameOrder%>위<%End if%></span></td>
							<td><%=unm%></td>
							<td><%=a_sidonm%></td>
							<td><%=shortNm(a_TEAMNM)%></td>
							<td><%=a_class%></td>
							<td><%'If a_amopen = "Y" And a_pmopen = "Y" then%><%Call SetRC(a_gameresult)%><%'End if%></td>
							</tr>
						<%
					End if
					
					
					

				Next 
			End if
		%>

	  


	</tbody>
  </table>
</div>



