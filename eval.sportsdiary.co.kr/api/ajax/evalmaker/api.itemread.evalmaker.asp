<%
'#############################################
'상세 불러오기
'#############################################
	'request
	reqidx = oJSONoutput.Get("IDX") 'itemidx (2댑스) 위항목호출용
	tidx = oJSONoutput.Get("TIDX")
	CDA = oJSONoutput.Get("CDA")
	CDB = oJSONoutput.Get("CDB")			


	Set db = new clsDBHelper

	'3단계
	evalmembercnt = ", (select count(*) from tblEvalMember where delkey = 0 and  EvalItemIDX = a.EvalItemIDX) as cnt "

	fld = " EvalItemIDX , EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,  RegYear " & evalmembercnt
	SQL = "Select "&fld&" from tblEvalItem as a where delkey = 0 and EvalTableIDX = " &tidx
	SQL = SQL & " and EvalCateCD = "&CDA&" and EvalSubCateCD = "&CDB&" and EvalItemCD > 0 order by orderno"    'EvalCateCD, EvalSubCateCD, EvalItemCD
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	'설정값 가져오기
	'itemtype    (tblEvalItemType)
	'item group  (tblEvalItemTypeGroup)	
	
	SQL = " select "
	SQL = SQL & " a.EvalItemIDX,a.EvalItemTypeIDX,b.EvalItemTypeGroupIDX  ,a.EvalItemCD,a.EvalTypeCD,b.EvalGroupCD, b.StandardPoint " 
	
	SQL = SQL & " from tblEvalItemType as a inner join 	tblEvalItemTypeGroup as b "
	SQL = SQL & " on a.EvalItemTypeIDX = b.EvalItemTypeIDX and b.Delkey = 0 "
	SQL = SQL & " where a.Delkey = 0 and a.EvalTableIDX = "&tidx&"	and EvalCateCD ="&CDA&"  and EvalSubCateCD = "&CDB&" "
	SQL = SQL & " order by evaltypecd , evalgroupcd "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrTG = rs.GetRows()
	End If


	function getTypePoint(arrTG, EvalItemCD, EvalTypeCD, EvalGroupCD)
		dim l_EvalItemCD,l_EvalTypeCD,l_EvalGroupCD,l_StandardPoint, ari
		Dim checkstate
		checkstate = 0

		If IsArray(arrTG) Then
			For ari = LBound(arrTG, 2) To UBound(arrTG, 2)
				l_EvalItemCD = arrTG(3, ari)
				l_EvalTypeCD = arrTG(4, ari)
				l_EvalGroupCD = arrTG(5, ari)
				l_StandardPoint = arrTG(6, ari)
				if l_EvalItemCD = EvalItemCD and l_EvalTypeCD = EvalTypeCD and l_EvalGroupCD = EvalGroupCD then
					checkstate = 1
					exit for
				end if
			Next
		end if

		getTypePoint = array(checkstate ,l_StandardPoint )		
	end function
	'aaa = getTypePoint(arrTG, 1, 1, 1)
	
	gana = Array("가","나","다","라","마")
%>

            <div class="box-body" style="padding:2px;">

<%If IsArray(arrR) = false Then%>
<%'=SQLPrint%>
<!-- 생성시 무조건 생성되므로 올일은 없어야함 -->
<%else%>
			<%
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_idx					  = arrR(0, ari) 'itemidx
					l_EvalTableIDX	    = arrR(1, ari)
					l_EvalCateCD	      = arrR(2, ari)
					' l_EvalCateNm	      = arrR(3, ari)
					 l_EvalSubCateCD	  = arrR(4, ari)
					' l_EvalSubCateNm    	= arrR(5, ari)
					l_EvalItemCD	      = arrR(6, ari)
					l_EvalItemNm	      = arrR(7, ari)
					l_RegYear	      		= arrR(8, ari)
					l_membercnt 				= arrR(9,ari)
			%>

				<table id="swtable_<%=reqidx%>" class="table table-bordered table-hover">
          <thead class="bg-light-blue-active color-palette">
						<tr>
								<th style="width:50px;text-align:center;vertical-align:top;"><input type="text" class="form-control" value="<%=ari+1%>"  style="border-radius:4px;"
								onkeyup="if(event.keyCode > 47 && event.keyCode <58){this.value=this.value.replace(/[^0-9]/g,'');mx.setOrder(<%=reqidx%>,<%=l_idx%>,$(this))}" maxlength=2
								></th>								
								
								<th colspan="11">
									<span>
									<!--<input type="text" class="form-control" style="width:60%;" value="<%=l_EvalItemNm%>" required><a href="#" class="btn btn-default">수정</a>-->
										<div class="form-group" style="width:50%;float:left;">
											<div class="input-group date">
													<input type="text" class="form-control" id="itemnm_<%=l_idx%>" value="<%=l_EvalItemNm%>" required>
												<div class="input-group-addon" style="cursor:pointer;" onclick="mx.setItemNm(<%=l_idx%>,$('#itemnm_<%=l_idx%>').val())">
													수정
												</div>
											</div>
										</div>									
									</span>
								
									<!-- 2, 3 단계 itemidx -->
									<span><a href="javascript:mx.delItem(<%=reqidx%>,<%=l_idx%>)" class="btn btn-danger" style="margin-left:2px;float:right;">삭제</a></span>

									<a href="javascript:mx.getWindow(<%=tidx%>,<%=l_idx%>,<%=l_RegYear%>)" class = "btn btn-default" id ="btn4_<%=l_idx%>" style="float:right;">정성 평가자등록 
									(<span id="mcnt_<%=l_idx%>"><%=l_membercnt%></span>)</a>
								</th>
						</tr>
					</thead>




					<tbody id="contest" class="gametitle">
							<tr class="gametitle" id="titlelist_<%=l_idx%>" style="text-align:center;">
							<%for i = 0 to 4%>
									<%if i = 0 then%>
									<td>
										<div style="height:35px;">정성</div>
										<div style="height:35px;">정량</div>
										<div style="height:35px;">감점</div>
									</td>
									<%end if%>

									<td>
										<div class="circle"><%=gana(i)%></div>
									</td>
									
									<td>
										<div class="row">
											<div class="col-lg-11">
												
												<%
												valarr = getTypePoint(arrTG, l_EvalItemCD, 1, Cdbl(i+1))
												%>
												
												<div class="input-group">
															<span class="input-group-addon">
																<input type="checkbox" id="ckA_<%=l_idx%>_<%=i%>" value="정성" 
																<%if valarr(0) = 1 then%>
																	checked
																<%end if%>
																onclick="mx.setType( 'A_<%=l_idx%>_<%=i%>' , $(this) ,1,<%=Cdbl(i+1)%>,<%=l_idx%>)">
															</span>
													<input type="text" class="form-control" placeholder="정성기준점수" id="bpA_<%=l_idx%>_<%=i%>" value="<%if valarr(0) = 1 then%><%=valarr(1)%><%end if%>" 
													onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.setPoint('A_<%=l_idx%>_<%=i%>' ,$(this) ,1,<%=i+1%>,<%=l_idx%>)" maxlength=2>
												</div>
												
												<%
												valarr = getTypePoint(arrTG, l_EvalItemCD, 2, Cdbl(i+1))
												%>
												<div class="input-group">
															<span class="input-group-addon">
																<input type="checkbox" id="ckB_<%=l_idx%>_<%=i%>" value="정량"
																<%if valarr(0) = 1 then%>
																	checked
																<%end if%>																
																onclick="mx.setType( 'B_<%=l_idx%>_<%=i%>',  $(this) ,2,<%=Cdbl(i+1)%>,<%=l_idx%>)">
															</span>
													<input type="text" class="form-control" placeholder="정량기준점수"  id="bpB_<%=l_idx%>_<%=i%>" value="<%if valarr(0) = 1 then%><%=valarr(1)%><%end if%>"
													onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.setPoint('B_<%=l_idx%>_<%=i%>' ,$(this) ,2,<%=i+1%>,<%=l_idx%>)"  maxlength=2>
												</div>

												<%
												valarr = getTypePoint(arrTG, l_EvalItemCD, 100, Cdbl(i+1))
												%>
												<div class="input-group">
															<span class="input-group-addon">
																<input type="checkbox" id="ckC_<%=l_idx%>_<%=i%>" value="감점"
																<%if valarr(0) = 1 then%>
																	checked
																<%end if%>																
																onclick="mx.setType( 'C_<%=l_idx%>_<%=i%>',  $(this) ,100,<%=Cdbl(i+1)%>,<%=l_idx%>)">
															</span>
													<input type="text" class="form-control" placeholder="감점기준점수"  id="bpC_<%=l_idx%>_<%=i%>" value="<%if valarr(0) = 1 then%><%=valarr(1)%><%end if%>"
													onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.setPoint('C_<%=l_idx%>_<%=i%>' ,$(this) ,100,<%=i+1%>,<%=l_idx%>)"  maxlength=2>
												</div>												


											</div>
										</div>
									</td>
							<%next%>
							</tr>							
						

						

					</tbody>
				</table>
			<%next%>
				

<%End if%>

            </div>
<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>