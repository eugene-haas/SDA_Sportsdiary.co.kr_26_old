<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		'종목상세  + 개인 / 단체  e_ITgubun
		If e_CDA = "D2" then
			SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and  pteamgb = 'D2'  and  teamgb not in ('31','32','33','34','35','41','42')   and cd_mcnt = '"&e_ITgubun&"'  order by orderby asc"
		Else
			SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&e_CDA&"'  and cd_mcnt = '"&e_ITgubun&"'  order by orderby asc"
		End if
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rss.EOF Then
			fcd = rss.GetRows()
		End If
	Else
		
		'개인단체로 넘어오는것에 따라서
		SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and  pteamgb = 'D2'  and  teamgb not in ('31','32','33','34','35','41','42')    and cd_mcnt = 'I'  order by orderby asc"
		Set rsa = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rsa.EOF Then
			fcd = rsa.GetRows()
		End If


	End If
	


	If e_Sexno	= "" Then
		e_Sexno = "1"
	End if

	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '"&e_Sexno&"'"
	Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsdrow(rss)
	If Not rsb.EOF Then
	arrRSB = rsb.GetRows()
	End If



	strWhere = " a.GameTitleIDX = "&reqtidx&" and a.DelYN = 'N' and CDA = '"&F1&"' "

  if F1 = "" then
    F1 = "D2"
  end if
	
  SQL = "Select max(CDA) as cda ,CDB,CDBNM,max(b.orderby) as orderby  from tblRGameLevel as a inner join tblteamgbinfo as b on a.cdb = b.cd_boo and b.delyn='N' "
  SQL = SQL & " where CDA = '"&F1&"' and  gametitleidx = "&reqtidx&" and a.delyn = 'N' group by cdb,cdbnm order by orderby"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
	arrR = rs.GetRows()
	End If
%>

<div class="row">
          <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>종목</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="F1" class="form-control" onchange='px.goSubmit({"F1":$("#F1").val(),"F2":"","TIDX":<%=reqtidx%>}, "<%=pagename%>")' >
										<option value="D2" <%If F1 = "" Or F1 = "D2" then%>selected<%End if%>>경영</option>
										<option value="E2" <%If F1 = "E2" then%>selected<%End if%>>다이빙/수구</option>
										<option value="F2" <%If F1 = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

          </div><%'#####################################################################################가로 한줄%>

          <div class="col-md-6">
				  <div class="form-group">
						<label>부</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="F2" class="form-control">
                  	<option value="">==출력부서선택==</option>
                    <%
                      If IsArray(arrR) Then 
                        For ari = LBound(arrR, 2) To UBound(arrR, 2)
                          l_CDA= arrR(0, ari)
                          l_CDB= arrR(1, ari)
                          l_CDBNM= arrR(2, ari)
                            %><option value="<%=l_CDB%>" <%If F2 = l_CDB then%>selected<%End if%>><%=l_cdbnm%></option><%
                          Next
                        end if
                    %>
									</select>
								  </div>
							</div>
						</div>
				  </div>
    			</div>


          <div class="col-md-6">
				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
										<a href="#" class="btn btn-primary" id="btnsave" onclick='px.goSubmit({"F1":$("#F1").val(),"F2":$("#F2").val(),"TIDX":<%=reqtidx%>}, "<%=pagename%>")' >검색</a>
								  </div>
							</div>
						</div>
				  </div>
				  </div>








</div>