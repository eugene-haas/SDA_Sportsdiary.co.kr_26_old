<%
	If hasown(oJSONoutput, "IDX") = "ok" Then  '테이블 명
		idx = chkStrRpl(oJSONoutput.IDX,"")
	End If


	If hasown(oJSONoutput, "TIDX") = "ok" Then  '테이블 명
		tidx = chkStrRpl(oJSONoutput.TIDX,"")
	End If

	If hasown(oJSONoutput, "GBIDX") = "ok" Then  '테이블 명
		gbidx = chkStrRpl(oJSONoutput.GBIDX,"")
	End If

	If hasown(oJSONoutput, "CDC") = "ok" Then  '자유형 100 .. 의 코드
		cdc = chkStrRpl(oJSONoutput.CDC,"")
		If Len(cdc) = 1 Then
			cdc = "0"& cdc
		End if
	End If

	If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
		F1 = chkStrRpl(oJSONoutput.F1,"")
	End If
	If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
		F2 = chkStrRpl(oJSONoutput.F2,"")
	End If








	Set db = new clsDBHelper


	fld = " idx,tidx,gbidx,levelno,midxL,midxR,teamL,teamR,teamnmL,teamnmR,scoreL,scoreR,winmidx,result,gangno,roundno,orderno,LPL1,LPL2,LPL3,LPL4,LPL5 ,RPL1,RPL2,RPL3,RPL4,RPL5    "
	fld = fld &  " ,(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL     ,sidonmL, sidonmR , sayoocode, vstype "
	SQL = "Select " & fld & " from sd_gameMember_vs where idx = " & idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Response.write sql
'Call rsdrow(rs)

	arrUp = rs.GetRows()

	If IsArray(arrUp) Then  '부전이니까 업데이트 할대상을 찾자.
		For x = LBound(arrUp, 2) To UBound(arrUp, 2)
			l_idx  = arrUP(0,x)
			l_tidx  = arrUP(1,x)
			l_gbidx  = arrUP(2,x)
			l_levelno  = arrUP(3,x)
			l_midxL  = arrUP(4,x)
			l_midxR  = arrUP(5,x)
			l_teamL  = arrUP(6,x)
			l_teamR  = arrUP(7,x)
			l_teamnmL  = arrUP(8,x)
			l_teamnmR  = arrUP(9,x)
			l_scoreL  = arrUP(10,x)
			l_scoreR  = arrUP(11,x)
			l_winmidx  = arrUP(12,x)
			l_result  = arrUP(13,x)
			l_gangno  = arrUP(14,x)
			l_roundno  = arrUP(15,x)
			l_orderno  = arrUP(16,x)

			l_LPL1  = arrUP(17,x)
			l_LPL2  = arrUP(18,x)
			l_LPL3  = arrUP(19,x)
			l_LPL4  = arrUP(20,x)
			l_LPL5   = arrUP(21,x)
			ltotal = CDbl(l_LPL1) + CDbl(l_LPL2) + CDbl(l_LPL3) + CDbl(l_LPL4) + CDbl(l_LPL5) 
			
			lplarr = array(l_LPL1,l_LPL2,l_LPL3,l_LPL4,l_LPL5)
			l_RPL1  = arrUP(22,x)
			l_RPL2  = arrUP(23,x)
			l_RPL3  = arrUP(24,x)
			l_RPL4  = arrUP(25,x)
			l_RPL5  = arrUP(26,x)
			rplarr = array(l_RPL1,l_RPL2,l_rPL3,l_RPL4,l_RPL5)


			rtotal = CDbl(l_RPL1) + CDbl(l_RPL2) + CDbl(l_RPL3) + CDbl(l_RPL4) + CDbl(l_RPL5) 
			
			l_LWL  = arrUP(27,x)
			l_RWL  = arrUP(28,x)

			l_sidoL  = arrUP(29,x)
			l_sidoR  = arrUP(30,x)
			l_sayoocode = arrUP(31,x)
			l_vstype = arrUP(32,x)
		Next

	
		SQL = "select cdbnm from sd_gameMember where gamememberidx = " & l_midxL
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		cdbnm = rs(0)
	End if


  '사유코드 가져오기#####################
  SQL = "select code,codeNm from tblCode  where gubun = 2 and CDA = 'E2' and delyn = 'N'  order by sortno asc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		arrC = rs.GetRows()
  End if
  '사유코드 가져오기#####################

%>
		<div class="m_searchPopup__control" >
			<span style="font-color:#000;font-size:12px;"><br><%=cdbnm%> <%If l_vstype = "T" then%><%=l_gangno%>강 <%End if%> / 수구</span>
        </div>

        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">

	<%'#######################################################%>
          <div class="box" style="width:100%;">
            <div class="box-header">
            
						<div class="row" >
							<div class="col-md-6">
								  <div class="form-group">
										<%=l_teamnmL%> (<%=l_sidoL%>) VS <%=l_teamnmR%> (<%=l_sidoR%>)
								  </div>
							</div>

							<!-- <div class="col-md-6" >
								  <div class="form-group" >
									<%
										If IsArray(arrC) Then  '부전이니까 업데이트 할대상을 찾자.
											For x = LBound(arrC, 2) To UBound(arrC, 2)
												l_code  = arrC(0,x)
												l_codenm  = arrC(1,x)
												%><%If l_sayoocode = l_code then%><%=l_codenm%><%End if%><%
											Next
										End if
									%>
								  </div>
							</div> -->

						</div>			  
            </div>


            <div class="box-body">
              <table id="swtable" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th id="lresult"><%If l_LWL = "W" then%>승<%else%>패<%End if%></th>
								<th>승패</th>
								<th id="rresult"><%If l_RWL = "W" then%>승<%else%>패<%End if%></th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
						<tr>


								<th><%=ltotal%></th>
								<th>Score</th>
								<th><%=rtotal%></th>
						</tr>

						<%For i = 1 To 5%>
						<tr>
								<td><%=lplarr(i-1)%></td>
								<td><%If i = 5 then%>연장<%else%><%=i%>P<%End if%></td>
								<td><%=rplarr(i-1)%></td>
						</tr>
						<%next%>


					</tbody>
				</table>


            </div>
          </div>
	<%'#######################################################%>


        </div>









<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
