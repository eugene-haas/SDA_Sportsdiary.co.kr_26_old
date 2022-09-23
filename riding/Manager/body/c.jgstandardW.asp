<%
 'Controller ################################################################################################
	y = request("y")
	If y = "" or isnumeric(y) Then
	Else
		Response.write "잘못된 접근 ㅡㅡ"
		Response.end
	End if


	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and useyear = '"&year(date)&"' "
		F1_0 = 1 
		F2_3 = "1" '기본값(운동과목)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("useyear","teamgb","ridingclass","testtype")
			F1_0 = F1(0)
			F1_1 = F1(1)
			F1_2 = F1(2)
			F1_3 = F1(3)

			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)
			If ubound(F2) > 3 Then			
			F2_3 = F2(3) 'testtype
			Else
			F2_3 = "1"
			End if

			'인덱스가 있는지 확인 #################
			If ubound(F1) = 4 Then'인덱스 값을 가져왔다면 
				e_idx = F2(4)
				SQL = "Select top 1 useyear,TeamGb,TeamGbNm,ridingclass,ridingclasshelp,title,timestr,writeOK from tblTeamGbInfoDetail where idx = " & e_idx  '1개만 존재해야함
				Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
				If Not rs.EOF Then
					arr1 = rs.GetRows()
					chelp = arr1(4,0)
					testtitle = arr1(5,0)
					tmstr = arr1(6,0)
				End If	

				strwhere = " a.delYN = 'N' and ((a.testtype in (1,2) and b.delYN='N') or a.testtype = 3) and a.idx = " & e_idx & " and a.testtype = '"&F2_3&"' "
				fieldstr = " a.idxs1,a.testtype,a.orderno as ano ,a.maxval,a.gesoo,a.eidear,a.kidear      ,b.idxs2,b.orderno as bno,b.orderstr,b.ktest,b.etest "
				SQL = "Select "&fieldstr&" from tblTeamGbInfoDetail_S1 as a Left Join tblTeamGbInfoDetail_S2 as b On a.idxs1 = b.idxs1  where  " & strwhere  & " order by a.testtype, a.orderno "

				Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
				If Not rs.EOF Then
					Set fd = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
					For i = 0 To Rs.Fields.Count - 1
						fd.Add LCase(Rs.Fields(i).name), i 
					Next
					arr2 = rs.GetRows()
				End If	

				If tmstr = "" then
				Select Case F2_1 
				Case "20101", "20103","20201","20203" '마장마술 복합마술
					tmstr = getGameTime(F2_2)&":00"
				Case "20102","20202"
					tmstr = "-"
				Case Else
					tmstr = "-"
				End Select 
				End if
				
				'test#########
				'Call getrowsdrow(arr1)
				'Call getrowsdrow(arr2)
			End If




			'인덱스가 있는지 확인 #################			
			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"'  group by pteamgb, ridingclass, ridingclasshelp"
			SQL = "Select pteamgb,ridingclass,ridingclasshelp from tblTeamGbInfo where  " & strWhere & " order by ridingclass, ridingclasshelp"
			Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
			
			If Not rs.EOF Then
				arrC = rs.GetRows()
			End If	
		Else
			F2_3 = "1" '기본값(운동과목)
		End If
	End if

	'등록된 최소년도
	SQL = "Select min(useyear) from tblTeamGbInfoDetail where delYN = 'N' and writeOK = 'Y' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End If
	rs.close

	'공통코드 
	If F2_0 = "" Then	
		If y = "" Then
			ydd = year(date)
		Else
			ydd = y 
		End if
		SQL = "Select min(teamgbidx),teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' and useyear = '"&ydd&"' group by teamgb,teamgbnm"
	Else
		SQL = "Select min(teamgbidx),teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' and useyear = '"&F2_0&"' group by teamgb,teamgbnm"
	End If


	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)


	If Not rs.EOF Then
	arrPub = rs.GetRows()
	End If


'Call getrowsdrow(arrPub)
'Response.end
%>
<%'View ####################################################################################################%>
<div class="admin_content">

	<!-- s: 페이지 타이틀 -->
	<div class="page_title"><h1>심사관리 - 심사기준관리 상세</h1></div>
	<!-- e: 페이지 타이틀 -->


	<!-- s: 테이블 리스트 -->
	<div class="info_serch" id = "input_area">
		<table cellspacing="0" cellpadding="0" class="table table-hover">
			<thead>
				<tr>
					<th>사용년도</th><th>종목명</th><th>class</th><th>class안내</th><th  style="display:none;">심사지명</th><th>소정시간</th>
				</tr>
			</thead>

			<tbody id="contest">
				<tr>
					<td>
						<select id="F1_0" class="form-control">
						  <%For fny = year(date) To minyear Step - 1%>
							<option value="<%=fny%>" <%If CStr(F2_0)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
						  <%Next%>
					  </select>
					</td>
					<td>
						<select id="F1_1" class="form-control" onchange="px.goSubmit( {'F1':[0,1,2,3] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val(),<%=F2_3%>],'F3':[]} , 'jgstandardW.asp')">
							<option value="">==선택==</option>
							<%
							'단체는 릴레이만 있다  단체(개인전의 집계로만 표시된다)
							If IsArray(arrPub) Then
								For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
									mingbidx = arrPub(0,ar)
									teamgb = arrPub(1, ar)
									teamgbnm = arrPub(2, ar)
									If teamgb <> pre_teamgb  Then
									If teamgb = "20101" Or teamgb = "20103" Or teamgb = "20201" Or teamgb = "20203" Then
									If Left(teamgb,3) = "202" Then
										teamgroupstr = " 단체"
									Else
										teamgroupstr = ""									
									End if
									%><option value="<%=teamgb%>" <%If F2_1 = teamgb then%>selected<%End if%>><%=teamgbnm%><%=teamgroupstr%></option><%
									End if
									pre_teamgb= teamgb
									End if
								Next
							End if
							%>
					  </select>
					</td>
					<td>
						<select id="F1_2" class="form-control" onchange="px.goSubmit( {'F1':[0,1,2,3] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val(),<%=F2_3%>],'F3':[]} , 'jgstandardW.asp')">
							<option value="">==선택==</option>
							<%
							If IsArray(arrC) Then
								For ar = LBound(arrC, 2) To UBound(arrC, 2)
									pteamgb = arrC(0, ar)
									rclass = arrC(1, ar)
									rclasshelp = arrC(2, ar)
									
									If rclass <> pre_rclass  then
										%><option value="<%=rclass%>" <%If F2_2 = rclass then%>selected<%End if%>><%=rclass%></option><%
										pre_rclass = rclass
									End if		

								Next
							End if
							%>
					  </select>
					</td>
					<td>
					<select  id="mk_g0" class="form-control" onchange="mx.setSave('<%=F2_3%>');">
							<option value="">==선택==</option>
							<%
							If IsArray(arrC) Then
								For ar = LBound(arrC, 2) To UBound(arrC, 2)
									rclass = arrC(1, ar)
									rclasshelp = arrC(2, ar)
									If F2_2 = rclass then
									%><option value="<%=rclasshelp%>" <%If chelp = rclasshelp then%>selected<%End if%>><%=rclasshelp%></option><%
									End if
								Next
							End if
							%>
					</select>					
					</td>
					<td style="display:none;"><input type="text" id="mk_g1" value="aaa<%'=testtitle%>"  onblur="mx.setSaveTestTitle('<%=e_idx%>','<%=F2_3%>');" ></td>
					<td><input type="text" id="mk_g2" value="<%=tmstr%>" style="text-align:center;" readonly></td>
				</tr>

			</tbody>
		</table>
	</div>





<%If e_idx <> "" And testtitle <> "" And tmstr <> "" then%>

<div id="makearea" >

<div class="info_serch" >
	<a href="javascript:mx.tab('<%=e_idx%>',1);" class="btn btn-<%If F2_3 = "1" then%>gray<%else%>white<%End if%>">운동과목</a>
	<a href="javascript:mx.tab('<%=e_idx%>',2);" class="btn btn-<%If F2_3 = "2" then%>gray<%else%>white<%End if%>">종합관찰</a>	
	<a href="javascript:mx.tab('<%=e_idx%>',3);" class="btn btn-<%If F2_3 = "3" then%>gray<%else%>white<%End if%>">경로위반</a>


<hr>


<table width="100%">
<tr>
<td width="50%">
<a href="javascript:mx.addTrOrder('<%=e_idx%>','<%=F2_3%>');" class="btn btn-primary">항목추가</a>
</td>
<td style="text-align:right;">
<a href="jgstandard.asp" class="btn btn-primary">목록보기</a>
<a href="javascript:mx.save('<%=e_idx%>','<%=F2_3%>');" class="btn btn-primary">저장</a>
</tr>
</tr>
</table>


<div class="table-responsive">
	<table class="table table-bordered tbl_tspaper">
	<%If F2_3 = "3" then%>
		<colgroup>
			<col style="width:50px;"/>
			<col style="width:200px;"/>
			<col style="width:60px;"/>
			<col style="width:auto;"/>
			<col style="width:60px;"/>
			<col style="width:200px;"/>
		</colgroup>

		<thead>
			<tr>
				<th scope="col" style="border-right:0px;">순서</th>
				<th scope="col" colspan="5">감점사항 ((To be deducted/Penalty Points)</th>
			</tr>
			<tr>
				<th scope="col" style="border-right:0px;">순서</th>
				<th scope="col" colspan="2">횟수</th>
				<th scope="col" colspan="2">감점포인트</th>
				<th scope="col">삭제</th>
			</tr>
		</thead>
	<%else%>
		<colgroup>
			<col style="width:50px;"/>
			<col style="width:460px;"/>
			<col style="width:60px;"/>
			<col style="width:60px;"/>
			<col style="width:auto;"/>
			<col style="width:auto;"/>
			<col style="width:50px;"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col" style="border-right:0px;">순서</th>
				<th scope="col">순서/운동과목</th>
				<th scope="col">최고점</th>
				<th scope="col">계수</th>
				<th scope="col" colspan="2">심사착안점</th>
				<th scope="col" colspan="2">삭제</th>
			</tr>
		</thead>
	<%End if%>

		<tbody>


<%
totalm = 0
totalg = 0

	If IsArray(arr2) Then
	For ar = LBound(arr2, 2) To UBound(arr2, 2)
		'a.idxs1,a.testtype,a.orderno as ano ,a.maxval,a.gesoo,a.eidear,a.kidear      ,b.idxs2,b.orderno as bno,b.orderstr,b.ktest,b.etest
		idxs1 =  arr2(fd.Item("idxs1"), ar)
		testtype =  arr2(fd.Item("testtype"), ar)
		nos1 =   arr2(fd.Item("ano"), ar)
		nos2 =   arr2(fd.Item("bno"), ar)
		eidear =   arr2(fd.Item("eidear"), ar)
		kidear =   arr2(fd.Item("kidear"), ar)
		maxval =  isNullDefault(arr2(fd.Item("maxval"), ar),0)
		gesoo =  isNullDefault(arr2(fd.Item("gesoo"), ar),0)

If nos1 <> prenos1 Then 's1번호 와 이전번호비교
%>
			<tr name="trOrder">
			<%If F2_3 = "3" then%>
				<td scope="col"><input type="text" name = "nos1_<%=e_idx%>" value="<%=nos1%>" class="itxtbox"  onkeyup="this.value=mx.noChange(event,this.value,<%=e_idx%>,<%=idxs1%>,<%=F2_3%>)" maxlength="4"></td>
				<td scope="row"><input type="text" name="vmax" value="<%=maxval%>" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,<%=idxs1%>,5)" maxlength="4"></td>
				<td>회시</td>
				<td scope="row"><input type="text" name="vdog" value="<%=gesoo%>" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,<%=idxs1%>,6)" maxlength="4"></td>
				<td>%</td>
				<td scope="row"  >
					<a class="btn btn-primary" name="delOrder" onclick="mx.deltrOrder(this, <%=e_idx%>,<%=idxs1%>,<%=F2_3%>)">삭제</a>				
				</td>

			<%else%>
				<td scope="col"><input type="text" name = "nos1_<%=e_idx%>" value="<%=nos1%>" class="itxtbox"  onkeyup="this.value=mx.noChange(event,this.value,<%=e_idx%>,<%=idxs1%>,<%=F2_3%>)" maxlength="4"></td>
				<td style="padding:0px;">
					<table class="tbl_tspaper" cellspacing="0" cellpadding="0">
						<tr style="height:50px;" name="trStaff<%=idxs1%>">
							<td>순서</td>
							<td scope="row" colspan="3" style="text-align:left;padding-left:5px;"><a href="javascript:mx.addTr(<%=e_idx%>,<%=idxs1%>,<%=F2_3%>);" class="btn btn-primary">추가</a></td>
						</tr>
						<%
						For ar2 = LBound(arr2, 2) To UBound(arr2, 2)
							idxs1_s =  arr2(fd.Item("idxs1"), ar2)
							idxs2_s =  arr2(fd.Item("idxs2"), ar2)
							testtype_s =  arr2(fd.Item("testtype"), ar2)
							nos1_s =   arr2(fd.Item("ano"), ar2)
							nos2_s =   arr2(fd.Item("bno"), ar2)
							ktest =   arr2(fd.Item("ktest"), ar2)
							etest =   arr2(fd.Item("etest"), ar2)
							orderstr =   arr2(fd.Item("orderstr"), ar2)
							
							If CStr(idxs1) = CStr(idxs1_s) then						
						%>
						<tr style="height:50px;" name="trStaff<%=idxs1%>">
							<td scope="row" style="width:60px;"><input type="text" value="<%=orderstr%>" class="itxtbox" onblur="mx.inputData(7,this.value,<%=idxs2_s%>)" maxlength="15"><input type="hidden" name="nos2_<%=idxs1%>" value="<%=nos2%>"></td>
							<td scope="row" style="width:200px;">
								<textarea class="itxtarea" onblur="mx.inputData(1,this.value,<%=idxs2_s%>)"><%=ktest%></textarea>
							</td>
							<td scope="row" style="width:200px;">
								<textarea class="itxtarea" onblur="mx.inputData(2,this.value,<%=idxs2_s%>)"><%=etest%></textarea>
							</td>
							<td scope="row" style="width:5px;">
								<a class="btn btn-primary" name="delStaff" onclick="mx.deltr(this,<%=e_idx%>,<%=idxs1_s%>,<%=idxs2_s%>,<%=F2_3%>)">삭제</a>
							</td>
						</tr>
						<%
							End if
						Next
						%>
					</table>
				</td>
	
				<td scope="row"><input type="text" name="vmax" value="<%=maxval%>" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,<%=idxs1%>,5)" maxlength="4"></td>
				<td scope="row"><input type="text" name="vdog" value="<%=gesoo%>" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,<%=idxs1%>,6)" maxlength="4"></td>
				<td scope="row"  >
						<textarea class="itxtarea" onblur="mx.inputData(3,this.value,<%=idxs1%>)"><%=eidear%></textarea>
				</td>
				<td scope="row"  >
						<textarea class="itxtarea" onblur="mx.inputData(4,this.value,<%=idxs1%>)"><%=kidear%></textarea>
				</td>
				<td scope="row"  >
					<a class="btn btn-primary" name="delOrder" onclick="mx.deltrOrder(this, <%=e_idx%>,<%=idxs1%>,<%=F2_3%>)">삭제</a>				
				</td>
			<%End if%>
			</tr>
<%
If maxval <> "" then
totalm = totalm + (maxval*gesoo)
End If
If gesoo <> "" then
totalg = totalg + gesoo
End if
End if
	prenos1 = nos1

	Next
	End if
%>


		</tbody>
		<%If F2_3 = "3" then%>
		<%else%>
		<tfoot>
			<tr class="active">
				<td scope="row" colspan="2">계</td>
				<td scope="row" id="maxsum"><%=totalm%></td>
				<td scope="row" id="dogsum"><%=totalg%></td>
				<td scope="row"></td>
				<td scope="row"></td>
				<td scope="row"></td>
			</tr>
		</tfoot>
		<%End if%>
	</table>
</div>

<%End if%>


</div>




</div>

