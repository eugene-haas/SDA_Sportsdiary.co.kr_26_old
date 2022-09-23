<%
'#############################################
' 대회심판등록
'#############################################
	'request
	cda = oJSONoutput.Get("CDA")
	tidx = oJSONoutput.Get("TIDX")
	idx = oJSONoutput.Get("IDX")
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper

	SQL = "insert into sd_gameTitle_judge (tidx,cda,jSEQ,name,team,teamnm)  (select top 1 "&tidx&",cda,seq,name,team,teamnm from tblReferee where seq = "&idx&" ) "	
	Call db.execSQLRs(SQL , null, ConStr)
	  
	  fld = " seq,name,team,teamnm "
	  SQL = " Select "&fld&" from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&cda&"'  "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If
%>



			  <table  class="table table-bordered table-hover" >
						
						<tbody class="gametitle">
								<%
									If IsArray(arrR) Then 
									lastno = UBound(arrR, 2)
										For ari = LBound(arrR, 2) To UBound(arrR, 2)
												j_seq = arrR(0, ari)
												j_name = arrR(1, ari)
												j_team = arrR(2, ari)
												j_teamnm = arrR(3, ari)
								%>
												<tr id="setjftr_<%=j_seq%>">
													<td width="20%" style="text-align: center;"><%=j_seq%></td>
													<td width="30%" style="text-align: center;"><%=j_name%></td>
													<td width="30%" style="text-align: center;"><%=j_teamnm%></td>
													<td width="20%" style="text-align:right"><a href="javascript:mx.delJudge('<%=cda%>',<%=tidx%>,<%=j_seq%>)" class="btn btn-danger">삭제</a></td>

												</tr>
								<%
										next
									End if		
								%>

						</tbody>

				</table>

<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
