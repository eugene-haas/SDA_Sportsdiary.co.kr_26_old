<%If prereq = l_reqid then
	scolor = scolor
else

	If ari = 0 Or scolor = "style=""color:red""" Then
	scolor = "style=""color:green"""
	else
	scolor = "style=""color:red"""
	End if
	prereq = l_reqid
End If

styletd = "style=""padding:0px;"""
%>

	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
			
			<td <%=scolor%>><%=l_reqID%></td>
			<td <%=styletd%>><input  style="width:100%;"  type="text" id="reqid2_<%=l_idx%>" value="<%=l_reqID2%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_reqID2%></span></td>
			<td <%=styletd%>><input  style="width:100%;"  type="text" id="reqnm_<%=l_idx%>" value="<%=l_reqNm%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_reqNm%></span></td>

			<td <%=styletd%>><textarea   style="width:100%;"  id="reqcon_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_reqcon%></textarea><span style="display:none"><%=Replace(l_reqcon,vbLf,"<br>")%></span></td>
			<td <%=styletd%>><textarea   style="width:100%;" id="reqA_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_reqA%></textarea><span style="display:none"><%=Replace(l_reqA,vbLf,"<br>")%></span></td>




			<td <%=styletd%>><input  style="width:100%;"  type="text" id="reqgubun_<%=l_idx%>" value="<%=l_reqgubun%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_reqgubun%></span></td>
			<td <%=styletd%>><input  style="width:100%;"  type="text" id="reqing_<%=l_idx%>" value="<%=l_reqing%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_reqing%></span></td>

			<td <%=styletd%>><%=l_UIID%><input type="button" onclick="mx.input_ui(<%=l_idx%>)" value="생성"> </td>
			<td <%=styletd%>><input  style="width:100%;" type="text" id="uinm_<%=l_idx%>" value="<%=l_UINm%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_UINm%></span></td>
			<td <%=styletd%>><input  style="width:100%;"  type="text" id="uiurl_<%=l_idx%>" value="<%=l_UIURL%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_UIURL%></span></td>

			<td <%=styletd%>><%=l_pgID%></td>
			<td <%=styletd%>><textarea  style="width:100%;"  id="pgnm_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_pgNm%></textarea><span style="display:none"><%=Replace(l_pgNm,vbLf,"<br>")%></span></td>
			<td <%=styletd%>>
			<textarea   style="width:100%;" id="jsonurl_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_JsonURL%></textarea><span style="display:none"><%=Replace(l_JsonURL,vbLf,"<br>")%></span>
			</td>

			<td <%=styletd%>>
			<textarea   style="width:100%;" id="jsonres_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_Jsonres%></textarea><span style="display:none"><%=Replace(l_Jsonres,vbLf,"<br>")%></span>
			</td>


			<td <%=styletd%>><%=l_TotalTestID%></td>
			<td <%=styletd%>><input style="width:100%;" type="text" id="bigo_<%=l_idx%>" value="<%=l_bigo%>" onblur="mx.setVal(this.id, this.value)"><span style="display:none"><%=l_bigo%></span></td>
			<td <%=styletd%>><textarea  style="width:100%;" id="test_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_test%></textarea><span style="display:none"><%=Replace(l_test,vbLf,"<br>")%></span></td>
			<td <%=styletd%>><textarea style="width:100%;"  id="rtok_<%=l_idx%>" onblur="mx.setVal(this.id, this.value)"><%=l_rtOK%></textarea><span style="display:none"><%=Replace(l_rtOK,vbLf,"<br>")%></span></td>

			<td><a href="javascript:mx.delLine(<%=l_idx%>)" class="btn btn-danger">삭제</a></td>
	</tr>


