<%
	If hasown(oJSONoutput, "FORMNO") = "ok" then
		fno = oJSONoutput.FORMNO
	End If

	'수정모드일때
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ
	End If

	If hasown(oJSONoutput, "F1") = "ok" then
		F1 = oJSONoutput.F1
	End If
	If hasown(oJSONoutput, "F2") = "ok" then
		F2 = oJSONoutput.F2
	End If



	Set db = new clsDBHelper

		title = "메뉴생성"
		'그룹/종목
		SQL = "Select name from sd_gamePrize where gubun = 1 and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

	db.Dispose
	Set db = Nothing
%>

<div class='modal-header game-ctr'>
	<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
	<h3 id='myModalLabel'>상품등록</h3>
</div>

<div class="modal-body" id="Modaltestbody">


					<div id="w_form" class="scroll_area">
						
						<table cellspacing="0" cellpadding="0" style="width:100%;">
							<tr>
								<td>
									<select  id="dep01"  class="sl_search" style="width:100%;" onchange="mx.SelectDEP(1,'dep01','w_form',mx.CMD_INSERTDEP1)">
									  <option value="">=상품명=</option>
										  <%
										  If IsArray(arrRS) Then
											  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
												  grp1nm = arrRS(0, ar)
												  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%></option><%
											  i = i + 1
											  Next
										  End if
										  %>
										  <option value="insert">[추가생성]</option>
									</select>						  
								</td>
							</tr>

							<tr>
								<td >
									<select  id= "dep02"  style="width:100%;" class="sl_search"  onchange="mx.SelectDEP(2,'dep02','w_form',mx.CMD_INSERTDEP1)">
									  <option value="1">남</option>
									  <option value="2">여</option>
									</select>
								</td>
							</tr>

							<tr>
								<td >
									<select  id="dep03"  class="sl_search" style="width:100%;" onchange="mx.SelectDEP(3,'dep03','w_form',mx.CMD_INSERTDEP1)">
									  <option value="">=상품옵션=</option>
										  <%
										  If IsArray(arrRS) Then
											  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
												  grp1nm = arrRS(0, ar)
												  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%></option><%
											  i = i + 1
											  Next
										  End if
										  %>
										  <option value="insert">[추가생성]</option>
									</select>	
								</td>
							</tr>
    					</table>

    				</div>

</div>
		  

	  
		  <!-- <div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true" onclick="location.reload()">닫기</button>
		    <button class="btn btn-primary" onclick="mx.writeOK(3,'dep03','w_form',mx.CMD_MAKEGOODSOK)">저장</button>
		  </div> -->


