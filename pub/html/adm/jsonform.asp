<%



'			e_a1 = arrR(0, ari) 'idx
'			e_a2 = arrR(1, ari) 'dbcode
'			e_a3 = arrR(2, ari) 'inval
'			e_a4 = arrR(3, ari) 'inquery
'			e_a5 = arrR(4, ari) 'outval
'			e_a6 = arrR(5, ari) 'outcnt
'			e_a7 = arrR(6, ari) 'title
'			e_a8 = arrR(7, ari) 'useurl

	If e_a1 <> "" Then
		Response.Cookies("DBNO") = e_a2
		Response.Cookies("DBNO").domain = "adm.sportsdiary.co.kr"	
		F1 = request.Cookies("DBNO")		

		%><input type="hidden" id="e_idx" value="<%=e_a1%>"><%
	End If
%>

		<div class="form-group">


			<label class="col-sm-1 control-label">대상DB</label>
			<div class="col-sm-2" >

				<div class="input-group" style="width:800px;">
				<select id="F1" class="form-control" style="width:200px;" onchange="px.goSearch({},1,$('#F1').val(),'')">
					<%'dbnmarr = array("공통","멤버","아이템센터","베드민턴","테니스","SD테니스","수영","승마","자전거","유도")%>
					<%For i = 0 To ubound(dbnmarr)%>
					<option value="DB<%=addZero(i)%>" <%If F1 = "DB" & addZero(i)  then%>selected<%End if%>   ><%=dbnmarr(i)%></option>
					<%next%>
				</select>

				<select id="selectTabelList" class="form-control"  style="float:left;" onchange="mx.selectTbl()">
				<%
				  if(IsArray(arr)) Then
					For ar = LBound(arr, 2) To UBound(arr, 2)
					  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
					NEXT
				  End IF
				%>
				</select>		
				</div>

			</div> 

		</div>


		<div class="form-group">
			<label class="col-sm-1 control-label">출력갯수</label>
			<div class="col-sm-2" style="width:90%;">
				<select id="mk_g0" class="form-control" style="width:200px;" >
					<option value="1" <%If e_a6 = "1" then%>selected<%End if%>>1</option>
					<option value="2" <%If e_a6 = "2" then%>selected<%End if%>>2</option>
					<option value="5" <%If e_a6 = "5" then%>selected<%End if%>>5</option>
					<option value="10" <%If e_a6 = "10" then%>selected<%End if%>>10</option>
					<option value="20" <%If e_a6 = "20" then%>selected<%End if%>>20</option>
					<option value="20" <%If e_a6 = "0" then%>selected<%End if%>>자동삽입없음</option>
				<select>
			</div> 
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">입력값</label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g1" placeholder="입력값 입력 ',' 구분 순서대로" value="<%=e_a3%>" class="form-control" style="width:80%;" onblur="mx.makeJson(this.value)">
			</div> 
		</div>

		<div class="form-group" style="padding-left:15px;padding-right:15px;">
			<label class="col-sm-1 control-label" style="padding-right:2px;">
			<a href="javascript:mx.tabInput(1)" class="btn btn-primary" id="inputtab1">입력쿼리</a>
			<a href="javascript:mx.tabInput(2)" class="btn btn-default" id="inputtab2">입력URL</a>
			</label>


			<div class="col-sm-2" style="width:90%;padding:0px;"  id="inputdiv1">
				<textarea id="mk_g2" placeholder="입력값을 ex) w = {} " class="form-control" style="height:150px;" onblur="mx.setLine(this.value)"><%=e_a4%></textarea>

				<div style="width:100%;text-align:right;margin-top:5px;">			
				<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.getJson();" >출력값가져오기</a>
				</div>
			</div> 

			<div class="col-sm-2" style="width:90%;padding:0px;display:none;"   id="inputdiv2">
				<input type="text" id="mk_g2_2" placeholder="출력값을 가져올 URL" value="<%=e_a3%>" class="form-control" style="width:100%;">
				<div style="width:100%;text-align:right;margin-top:5px;">			
				<a href="#" class="btn btn-primary" id="btnsave2" onclick="mx.getUrlJson();" >출력값가져오기</a>
				</div>
			</div> 

		</div>



		<div class="form-group">
			<label class="col-sm-1 control-label">출력값</label>
			<div class="col-sm-2" style="width:90%;">
				<textarea id="mk_g3" placeholder="JSON출력" class="form-control" style="height:150px;"><%=e_a5%></textarea>
			</div> 
		</div>



		<div class="form-group">
			<label class="col-sm-1 control-label">타이틀</label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g4" placeholder="사용 용도" value="<%=e_a7%>" class="form-control" style="width:80%;">
			</div> 
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">사용할 URL </label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g5" placeholder="사용페이지 URL" value="<%=e_a8%>" class="form-control">
			</div> 
		</div>







		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">저장<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
		</div>





