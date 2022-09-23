
				<form method="post"  name="sform" action="findcontestplayer.asp">
				<input type="hidden" name="p">
					
				<ul>
					<li>
					  <select id="fnd_PType"  class="sl_search w_50">
						  <option value="1" <%If ptype= "1" then%>selected<%End if%>>전체</option>
						  <option value="2" <%If ptype= "2" then%>selected<%End if%>>입금전</option>
						  <option value="3" <%If ptype= "3" then%>selected<%End if%>>입금완료</option>
					  </select>
					</li>
					<li>
					  <select id="fnd_Type" class="sl_search w_50" onchange="mx.searchPlayer(<%=page%>);">
					  <option value="2" <%If stype= "2" then%>selected<%End if%>>선수명</option>
					  <option value="1" <%If stype= "1" then%>selected<%End if%>>입금자명</option>
					  <option value="3" <%If stype= "3" then%>selected<%End if%>>대회명</option>
					  </select>
					</li>
					<li>
						<%If CStr(stype)="3" then%>
						<select  id="tidx" onchange="mx.searchPlayer(<%=page%>);" class="sl_search">
						<option value="">==대회선택==</option>
							<%
							If IsArray(arrRT) Then
								For ar = LBound(arrRT, 2) To UBound(arrRT, 2) 
									t_tidx = arrRT(0, ar)
									t_tname = arrRT(1, ar)
									%><option value="<%=t_tidx%>"  <%If CDbl(t_tidx) = CDbl(tidx) then%>selected<%End if%>><%=t_tname%></option><%
								Next
							End if
							%>
							<option value="<%=24%>"  <%If  CDbl(tidx)= 24 then%>selected<%End if%>>예선업로드(테스트용)</option>
						</select>
						<%End if%>

						<%If CStr(stype)="3" And tidx > 0 then%>
						<select id="ridx"  class="sl_search" onchange="mx.searchPlayer(<%=page%>);">
						<option value="">==부서선택==</option>
							<%			
							If IsArray(arrRS) Then
								For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

									levelno = arrRS(0, ar) 
									PTeamGbNm = arrRS(1, ar)
									LevelNm = arrRS(2, ar)
								%>
									<option value="<%=levelno%>" <%If CDbl(ridx) = CDbl(levelno) then%>selected<%End if%>><%=PTeamGbNm &"("&LevelNm&")"%></option>
								<%
								i = i + 1
								Next
							End if					
							%>
						</select>
						<%End If%>
						
						<%If stype = "" Or stype="1" Or stype = "2" then%>
						<input type="text" id="fnd_Str" class="in_txt"  onkeyup="if(event.keyCode == 13){mx.searchPlayer(<%=page%>);}" value="<%=svalue%>">
						<a href="javascript:mx.searchPlayer(<%=page%>);" class="search_btn">검색</a>
						<%End if%>

					</li>




					<%If CStr(stype)="3" And tidx > 0 then%>
					<li>
						<%If ridx = 0 then%>
						<a href="./cacluExcel.asp?tid=<%=tidx%>" class="search_btn"><i class="far fa-file-excel"></i> 대회정산</a>
						<%End if%>
					
						<%If ridx > 0 Then
							SQLT = "select COUNT(*) from tblGameRequest as a INNER JOIN SD_RookieTennis.dbo.TB_RVAS_LIST as b ON '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) = b.CUST_CD and b.refundok ='N'  where a.GameTitleIDX = "&tidx&" and a.level = '"&ridx&"' and a.delYN = 'Y' "
							Set rst = db.ExecSQLReturnRS(SQLT , null, ConStr)
						%>
						<a href="javascript:mx.attDelList(<%=tidx%>,<%=ridx%>)" class="search_btn" style="width:180px;">취소명단 [환불요청 :<%=rst(0)%>]</a>
						<a href="./attexcel.asp?tidx=<%=tidx%>&levelno=<%=ridx%>" class="search_btn" ><i class="far fa-file-excel"></i> 참가신청</a>
						<%End if%>
					
					<li>
					<%End if%>
				


				</ul>


				</form>