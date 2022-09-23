<%
	If hasown(oJSONoutput, "RIDX") = "ok" Then  
		ridx = chkStrRpl(oJSONoutput.RIDX,"")
	End If


	Set db = new clsDBHelper

	'팀정보 
	SQL = "select p1_team,p1_teamnm,cda from tblGameRequest where delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	teamcode = rs(0)
	teamnm = rs(1)
	cda = rs(2)
	If cda = "D2" Then
		chkmember = 4
	Else
		chkmember = 20
	End if


	'출전선수 정보
	fld = " partnerIDX,gameMemberIDX,requestIDX,playeridx,username,odrno,team,teamnm,userClass,				sido,sex ,capno"
	If cda = "D2" Then	
	SQL = "SELECT top 4 " & fld & "  FROM sd_gameMember_partner   WHERE delyn = 'N' and  requestIDX = " & ridx & " order by odrno asc"
	Else
	SQL = "SELECT " & fld & "  FROM sd_gameMember_partner   WHERE delyn = 'N' and  requestIDX = " & ridx & " order by odrno asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
	If Not rs.EOF Then
		arM = rs.GetRows()
	End If

'Response.write sql
'Response.end


	'신청선수 정보
	fld = " seq,requestIDX,playeridx,username,payOK,paynum,team,teamnm,userClass, capno "
	strSql = "SELECT " & fld & "   FROM tblGameRequest_r  WHERE delyn = 'N' and startMember = 'N' and requestIDX = " & ridx
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
	

%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel"><%=cda%>단체전 출전 선수 지정</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">



            <div class="box-body">

              <table id="settable" class="table table-bordered" style="width:50%;float:left;">
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th colspan="3">단체전 출전선수</th>
						</tr>
						<tr>
								<th>출선순서</th>
								<th>선수명</th>
<%If ADGRADE > 500 then%>
								<th>취소</th>
<%End if%>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					memberCnt = 0
					If IsArray(arM) Then 
					   memberCnt = UBound(arM, 2)

						For a = LBound(arM, 2) To UBound(arM, 2)
						pIDX = arM(0, a) 
						mIDX = arM(1, a)
						l_requestIDX = arM(2, a) 
						l_playeridx = arM(3, a) 
						l_username = arM(4, a) 
						l_odrno = arM(5, a) 
						l_team = arM(6, a) 
						l_teamnm = arM(7, a) 
						l_userClass = arM(8, a) 

						l_cap = isnulldefault(arM(11,a),"")
					 %>
					 
					  <tr id="pidx_<%=l_seq%>"  style="text-align:center;">
						<td><%=l_odrno%></td>
						<td><%=l_username%> <%If l_cap <> "" then%>[ 수모 <%=l_cap%>]<%End if%></td>
<%If ADGRADE > 500 then%>
						<td><a href="javascript:mx.outMember(<%=pIDX%>,<%=l_requestIDX%>,<%=l_playeridx%>)" class="btn btn-danger" >취소</a></td>
<%End if%>
					  </tr>
					 

					 <%
						  Next
					 End if
					%>
					</tbody>
			</table>


              <table id="odrtable" class="table table-bordered table-hover" style="width:50%;float:left;">
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th colspan="3"><%=teamnm%></th>
						</tr>
						<tr>
								<th>번호</th>
								<th>선수명</th>
<%If ADGRADE > 500 then%>
								<th>등록</th>
<%End if%>
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
						l_capno = isnulldefault(ar(9,a),"")

					 %>
					 
					  <tr id="titlelist_<%=l_seq%>"  style="text-align:center;">
						<td><%=a+1%></td>
						<td><%=l_username%><%If l_capno <> "" then%>[ 수모 <%=l_capno%>]<%End if%></td>
<%If ADGRADE > 500 then%>
						<td>
						<%If CDbl(memberCnt) < CDbl(chkmember) then%>
						<a href="javascript:mx.inputMember(<%=l_seq%>,<%=l_requestIDX%>)" class="btn btn-primary" >출전<%%></a>
						<%else%>
						<a href="#" class="btn btn-primary" disabled>출전</a>
						<%End if%>
						</td>
<%End if%>
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
