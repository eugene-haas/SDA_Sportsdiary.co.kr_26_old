
	<tr class="gametitle" id="titlelist_<%=l_midx%>"  style="text-align:center;<%If l_sortno > 0 And gameTypestr = "예선" then%>background:#CED7DD;<%End if%>">

		<%If chkrowno > 0 then%>
		<%If ari =  0 or prejoo <> chkrowno Then%>
			<td  rowspan="<%=raneCnt%>" style="vertical-align:middle;background:#ffffff;"><span><%=chkrowno%>조</span></td>
		<%End if%>
		<%else%>
		<td>&nbsp;</td>
		<%End if%>

		<td>
		<%If chkrowno > 0 then%>
			<%If ADGRADE > 500 then%>
				<span><input  id="player_<%=l_midx%>" value = "<%=l_raneno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeRane(<%=l_midx%>,this.value,3,'<%=l_gno%>','<%=ampm%>')" ></span>
			<%else%>
				<span><%=l_raneno%></span>
			<%End if%>
		<%End if%>
		</td>


			<td><%=l_ksportsno%></td>

			<%If ADGRADE > 500 then%>
			<td><%=kno%></td>
			<%End if%>

			<td><a href="javascript:mx.changeBoo(<%=tidx%>,<%=lidx%>,<%=l_midx%>,'<%=l_gamedate%>','<%=ampm%>')" class="btn btn-default"><%=l_userName%></a></td>
			<td><%=l_TeamNm%></td>
			<td><%=l_sidonm%></td>
			<td><%=l_orderno%></td>
			<td><%=l_totalorderno%></td>

<%If ADGRADE > 500 then%>
	<%
	'계영 400m, 800m와 혼계영 400m
	If InStr(l_CDCNM,"계영") then
	%>
			<td><input  class="form-control" type="text" id= "r1_<%=l_midx%>" style="width:90px;" value="<%Call SetRC(firstRC)%>" maxlength="6" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')"     tabindex="<%=CDbl(firsttab) + CDbl(ari)+1%>"></td>
			<td><input  class="form-control" type="text" id= "r2_<%=l_midx%>" style="width:90px;" value = "<%Call SetRC(firstSin)%>" readonly></td>
	<%else%>
			<td><input  class="form-control" type="text" id= "r1_<%=l_midx%>" style="width:90px;" disabled></td>
			<td><input  class="form-control" type="text" id= "r2_<%=l_midx%>" style="width:90px;" disabled></td>
	<%end if%>

		<%
		If korSin <> "" Then

		End if
		If gameSin <> "" Then

		End If
		%>
			<td><input  class="form-control" type="text" id= "r3_<%=l_midx%>" value="<%Call SetRC(SinRC)%>" style="width:90px;" readonly></td>

			<td><input  class="form-control" type="text" id= "r4_<%=l_midx%>" style="width:90px;" tabindex="<%=CDbl(ari)+1%>"
			onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" onblur="mx.setP(this, <%=l_midx%>, <%=l_lidx%>, <%=l_gno%>,'r1_<%=l_midx%>')"
			value="<%=l_result%>" maxlength="6" <%If l_result = "" then%>disabled<%End if%>  onfocus="px.chkZeroSm(this)"></td><!-- onfocus="px.chkZeroSm(this)"  -->



<%else%>
	<%
	'계영 400m, 800m와 혼계영 400m
	If InStr(l_CDCNM,"계영") then
	%>
			<td><%Call SetRC(firstRC)%></td>
			<td><%Call SetRC(firstSin)%></td>
	<%else%>
			<td></td>
			<td></td>
	<%end if%>

			<td><%Call SetRC(SinRC)%></td>
			<td><%=l_result%></td>


<%End if%>



			<%If ADGRADE > 500 then%>
			<td><input type="checkbox" type="text" style="width:20px;" id= "r5_<%=l_midx%>" name="chk_<%=l_gno%>" value="<%=l_midx%>" <%If l_result = "" then%>disabled<%End if%>></td>
			<%End if%>

			<td>
<%If ADGRADE > 500 then%>
			<select class="form-control" style="width:80px;"  id= "r6_<%=l_midx%>"  onchange= "mx.setOut(this, <%=l_midx%>, <%=l_lidx%>, <%=l_gno%>)">
			<option value="">--</option>
<%
	If IsArray(arrC) Then
		For arc = LBound(arrC, 2) To UBound(arrC, 2)
			l_outCD = arrC(0, arc)
			l_outCDNM= arrC(1, arc)
			%><option value="<%=l_outCD%>" <%If l_err = l_outCD then%>selected<%End if%>><%=l_outCDNM%></option><%
		Next
	End if
%>
<%else%>
<%
	If IsArray(arrC) Then
		For arc = LBound(arrC, 2) To UBound(arrC, 2)
			l_outCD = arrC(0, arc)
			l_outCDNM= arrC(1, arc)
			%><%If l_err = l_outCD then%><%=l_outCDNM%><%End if%><%
		Next
	End if
%>
<%End if%>
			</select>
			</td>

			<!-- <option value="a" <%If l_err = "a" then%>selected<%End if%>>실격</option>
			<option value="b" <%If l_err = "b" then%>selected<%End if%>>불참</option>
			<option value="c" <%If l_err = "c" then%>selected<%End if%>>박탈</option> -->
<%
'계영 400m, 800m와 혼계영 400m
'If l_CDC = "16" Or l_CDC = "17" Or l_CDC="15" then
If InStr(l_CDCNM,"계영") Then
%>

			<td><a href="javascript:mx.orderList(<%=l_requestIDX%>)" class="btn btn-default"><%If ADGRADE > 500 then%>오더등록(<%=l_ptncnt%>)<%else%>출전선수<%End if%></a></td>
<%else%>
			<td><a  class="btn btn-default" disabled><%If ADGRADE > 500 then%>오더등록<%else%>출전선수<%End if%></a></td>
<%end if%>

	</tr>
<%
prejoo = chkrowno
%>
