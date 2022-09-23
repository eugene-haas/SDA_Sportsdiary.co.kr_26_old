<%
	If hasown(oJSONoutput, "RIDX") = "ok" Then  
		ridx = chkStrRpl(oJSONoutput.RIDX,"")
	End If


	Set db = new clsDBHelper

	SQL = "select p1_team,p1_teamnm,cdbnm,cdcnm from tblGameRequest where delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	teamcode = rs(0)
	teamname = rs(1)
	cdbnm = rs(2)
	cdcnm = rs(3)



	fld = " seq,requestIDX,playeridx,username,payOK,paynum,team,teamnm,userClass,capno "
	strSql = "SELECT " & fld & "   FROM tblGameRequest_r  WHERE delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	If Not rs.EOF Then
		ar = rs.GetRows()
	End If


	If IsArray(ar) Then 

			
		For a = LBound(ar, 2) To UBound(ar, 2)
			If a = 0 then
				attpidxStr = ar(2, a)
			Else
				attpidxStr = attpidxStr &","& ar(2, a)
			End if
		Next

	End if
		
		
		
		If attpidxStr = "" then
		
		SQL = "select playeridx , username, userClass,sex from tblPlayer where delyn = 'N' and team = '"&teamcode &"' "
		Else
		
		SQL = "select playeridx , username, userClass,sex from tblPlayer where delyn = 'N' and team = '"& teamcode &"'  and playeridx not in ("&attpidxSTR&") "

		End if
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rss.EOF Then
			arrR = rss.GetRows()
		End If




%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">신청명단 [<%=teamname%>] <%=cdbnm%> <%=cdcnm%></button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

<%If user_ip = "112.187.195.132" then%>
							<div class="col-md-6" style="width:25%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<input type="hidden" id = "newrequestidx" value="<%=ridx%>">
										<select id="newpidx" class="form-control">
										<%
										If IsArray(arrR) Then 
											For ari = LBound(arrR, 2) To UBound(arrR, 2)
												l_pidx= arrR(0, ari) 
												l_pname = arrR(1,ari)
												l_uc = arrR(2,ari)

												%><option value="<%=l_pidx%>" ><%=l_pname%> / <%=l_uc%>학년</option><%

											Next
										End if
										%>
										</select>
								  </div>
							</div>


						<div class="row" >
							<div class="col-md-6" style="width:15%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<input type="button" class="btn btn-primary" value="선수추가" onclick="mx.newMemberIn()"><%'=ridx%>
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">

								  </div>
							</div>

						</div>			  
<%End if%>
			</div>


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>선수명</th>
								<th>수모</th>
								<th>팀코드</th>
								<th>팀명칭</th>
								<th>학년</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					If IsArray(ar) Then 
						For a = LBound(ar, 2) To UBound(ar, 2)



						l_seq = ar(0, a) 
						l_requestIDX = ar(1, a) 
						l_playeridx = ar(2, a) 
						l_username = ar(3, a) 
						l_payOK = ar(4, a) 
						l_paynum = ar(5, a) 
						l_team = ar(6, a) 
						l_teamnm = ar(7, a) 
						l_userClass = ar(8, a) 
						l_capno = ar(9,a)

					 %>
					 
					  <tr id="titlelist_<%=l_seq%>"  style="text-align:center;">
						<td><%=l_username%></td>
						<td><%=l_capno%></td>
						<td><%=l_team%></td>
						<td><%=l_teamnm%></td>
						<td><%=l_userclass%></td>
					  </tr>
					 

					 <%
						  Next
					 End if
					%>

					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>





      </div>





    </div>


  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
