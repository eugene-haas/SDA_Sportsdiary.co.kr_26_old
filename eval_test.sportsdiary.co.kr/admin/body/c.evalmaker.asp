<%
 'Controller ################################################################################################

	if EvalTableIDX  = "" then
		response.redirect "/admin/evalindex.asp"
		response.end
	end if
	RegYear = RegYear 'header.admin에서 받음

	if F1 <> "" then
		e_menuno = "2"
		e_EvalCateCD = F1
	end if
	if F2 <> "" then
		e_EvalSubCateCD = F2
	end if
	if F3 <> "" then
		e_EvalItemCD = F3
	end if		



	depth3cnt = " ,(select count(*) from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalCateCD = b.EvalCateCD and EvalSubCateCD = b.EvalSubCateCD and EvalItemCD > 0) as d3 "

	'2단계만 불러온다.
	fld = " b.EvalItemIDX , b.EvalTableIDX, b.EvalCateCD,b.EvalCateNm,b.EvalSubCateCD,b.EvalSubCateNm,b.EvalItemCD,b.EvalItemNm, b.RegYear,a.orderno,b.orderno " & depth3cnt
	SQL = "Select "&fld&" from tblEvalItem as a inner join tblevalitem as b "
	SQL = SQL & " ON  a.EvalCateCD = b.EvalCateCD and b.delkey = 0 and b.EvalTableIDX = "&EvalTableIDX&" and b.EvalSubCateCD > 0 and b.EvalItemCD = 0 "
	SQL = SQL & " where a.delkey = 0 and a.EvalTableIDX = "&EvalTableIDX&" and a.EvalSubCateCD = 0 order by a.orderno,b.orderno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

			gana = Array("가","나","다","라","마")
			fld = " EvalCodeIDX,EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm "
			SQL = "select "&fld&" from tblEvalCode where delkey = 0 "
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows() '평가범주 불러올때 사용
			End If			

PAGE_ENTERTYPE = "A"
pageYN = getPageState( "MN0114", "평가지표관리설정" ,Cookies_aIDX , db)
%>
<%'View ####################################################################################################%>
<style type="text/css">
input[type=checkbox]
{
  /* Double-sized Checkboxes */
  -ms-transform: scale(2); /* IE */
  -moz-transform: scale(2); /* FF */
  -webkit-transform: scale(2); /* Safari and Chrome */
  -o-transform: scale(2); /* Opera */
  margin-top:10px;
}	

.circle{
	margin-top:5px;
	width:20px;
	height:20px;
	border-radius:50%;
	background:#222D32;
	color:#ffffff;
}
</style>


	<div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
		<div class="box-header with-border">
			<h3 class="box-title"><%=menustr(1)%></h3>
			<div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0114'},'/admin/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
			</div>
		</div>

		<div class="box-body" id="gameinput_area">
				<!-- #include virtual = "/admin/inc/form.evalmaker.asp" -->
		</div>
	</div>


		<!-- 탭모양 버튼을 만들자 -->
		<div class="box-header with-border" style="text-align:right;margin-bottom:-17px;">
					<a href="javascript:mx.getGrpTotal(<%=EvalTableIDX%>)" class="btn btn-primary">구룹별 기준점수총합</a>
					<a href="/admin/evalindex.asp" class="btn btn-primary">목록보기</a>
		</div>

		<%
				order1 = 1
				order2 = 0
				If IsArray(arrR) Then 
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
							l_idx					  = arrR(0, ari)
							l_EvalTableIDX	    = arrR(1, ari)
							l_EvalCateCD	      = arrR(2, ari)
							l_EvalCateNm	      = arrR(3, ari)
							l_EvalSubCateCD	  	= arrR(4, ari)
							l_EvalSubCateNm    	= arrR(5, ari)
							l_EvalItemCD	      = arrR(6, ari)
							l_EvalItemNm	      = arrR(7, ari)
							l_RegYear	      		= arrR(8, ari)
							l_order1       			= arrR(9, ari)
							l_order2       			= arrR(10, ari)	
							l_depth3cnt 				= arrR(11,ari)						
					

							'#####################################################
							if pre_order1 = "" or pre_order1 = l_order1 then
								order1 = order1
								order2 = order2 + 1
							else
								order1 = order1 + 1
								order2 = 1
							end if
							'#####################################################
							
					%>
						<div class="box box-primary collapsed-box" style="margin-bottom:1px;">
								<div class="box-header with-border" >

										<input type="text" class="form-control" id="depthorder1_<%=l_idx%>" value="<%=order1%>" style="float:left;width:40px;font-weight:600;font-size:27px;"
											onkeyup="if(event.keyCode > 47 && event.keyCode <58){this.value=this.value.replace(/[^0-9]/g,'');mx.setOrder1(<%=l_idx%>,$(this))}" maxlength=2>
										<input type="text" class="form-control" id="depthorder2_<%=l_idx%>" value="<%=order2%>"  style="float:left;width:40px;"
											onkeyup="if(event.keyCode > 47 && event.keyCode <58){this.value=this.value.replace(/[^0-9]/g,'');mx.setOrder2(<%=l_idx%>,$(this))}" maxlength=2>

									<h3 class="box-title" style="display:block;float:left;padding-top:10px;">
										<!--<%=order1%>.<%=order2%> -->
										&nbsp;&nbsp;<%=l_EvalCateNm%> / <%=l_EvalSubCateNm%>
										<!--&nbsp;&nbsp;<span style="color:green;font-size:14px;">test</span>-->
									</h3>
									<span style="display:block;float:left;padding-top:10px;">&nbsp;&nbsp;(세부항목수 : <%=l_depth3cnt%>)</span>

									<div class="box-tools pull-right">
											<button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="mx.getGameList('game_<%=l_idx%>',<%=l_idx%>,<%=l_EvalTableIDX%>,<%=l_EvalCateCD%>,<%=l_EvalSubCateCD%>)"><i class="fa fa-plus"></i></button>
									</div>
								</div>

								<div class="box-body" id="game_<%=l_idx%>" style="tabindex:<%=CDbl(ari) + 1%>">
										<!-- 여기테이블리스트 include -->
								</div>
						</div>							
					
					<%
					pre_order1 = l_order1
					Next
				End if
		%>

