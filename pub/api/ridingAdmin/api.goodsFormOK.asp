<%
	If hasown(oJSONoutput, "DEPNO") = "ok" then
		depno = oJSONoutput.DEPNO
	End If

	'@@@@@@@@@@@@@@@@@@@@@@@@

	If hasown(oJSONoutput, "DEP1") = "ok" then
		dep1 = oJSONoutput.DEP1
	End If
	If hasown(oJSONoutput, "DEP2") = "ok" then
		dep2 = oJSONoutput.DEP2
	End If
	If hasown(oJSONoutput, "DEP3") = "ok" then
		dep3 = oJSONoutput.DEP3
	End If
	

	Set db = new clsDBHelper

	'#################################

		If CDbl(depno) > 0 then
		'중복값확인
		Select Case DEPNO
		Case "1" :	SQL = "Select name from sd_gamePrize where gubun = 1 and name = '"&dep1&"' "
		Case "3" :	SQL = "Select name from sd_gamePrize where gubun = 1 and name = '"&dep1&"' and size = '"&dep3&"' "
		End Select 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.End
		End if

		Select Case DEPNO
		Case "1" :	SQL = " insert into sd_gamePrize (gubun, name) values (1, '"&dep1&"')"
		Case "3" :	SQL = " insert into sd_gamePrize (gubun, name,sex,size) values (3, '"&dep1&"' ,'"&dep2&"','"&dep3&"' )"
		End Select 
		Call db.execSQLRs(SQL , null, ConStr)
		End if
	'#################################

		SQL = "Select name from sd_gamePrize where gubun = 1  and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If



		SQL = "Select size from sd_gamePrize where gubun = 3 and  name = '"&dep1&"' and  sex = "&dep2&"  and delYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrRSM = rs.GetRows()
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
												  %><option value="<%=grp1nm%>" <%If grp1nm = dep1 then%>selected<%End if%>><%=grp1nm%></option><%
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
									  <option value="1" <%If dep2 = "1" then%>selected<%End if%>>남</option>
									  <option value="2" <%If dep2 = "2" then%>selected<%End if%>>여</option>
									</select>
								</td>
							</tr>

							<tr>
								<td >
									<select  id="dep03"  class="sl_search" style="width:100%;" onchange="mx.SelectDEP(3,'dep03','w_form',mx.CMD_INSERTDEP1)">
									  <option value="">=상품옵션=</option>
										  <%
										  If IsArray(arrRSM) Then
											  For ar = LBound(arrRSM, 2) To UBound(arrRSM, 2)
												  size = arrRSM(0, ar)
												  %><option value="<%=grp1nm%>" <%If size = dep3 then%>selected<%End if%>><%=size%></option><%
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
		  

