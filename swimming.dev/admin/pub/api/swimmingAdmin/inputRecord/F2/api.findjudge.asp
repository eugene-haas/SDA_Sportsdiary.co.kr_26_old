<%
'#############################################
' 구간기록 모달창 리스트
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	findval = oJSONoutput.Get("FINDVAL")
	cda = oJSONoutput.Get("CDA")
	CDA = "F2" '아티스틱

	If FINDVAL = "" Then
		Response.end
	End if


	Set db = new clsDBHelper

	  fld = " a.seq,a.name,a.team,a.teamnm "
	  SQL = " Select top 20 "&fld&" from tblReferee as a left join sd_gameTitle_judge as b on a.seq = b.jseq and b.tidx = "&tidx&"  where a.cda = '"&cda&"' and  a.delyn = 'N' and a.name like '"&findval&"%' and  b.jseq is null "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If
%>

	<div id="Modaltestbody" >
	<div class="box-body" style="overflow-x:hidden;" >

			  <table  class="table table-bordered table-hover" >
						
						<tbody   class="gametitle">
								<%
									If IsArray(arrR) Then 
									lastno = UBound(arrR, 2)
										For ari = LBound(arrR, 2) To UBound(arrR, 2)
												j_seq = arrR(0, ari)
												j_name = arrR(1, ari)
												j_team = arrR(2, ari)
												j_teamnm = arrR(3, ari)
								%>
												<tr id="jftr_<%=j_seq%>">
													<td width="20%" style="text-align: center;"><%=j_seq%></td>
													<td width="30%" style="text-align: center;"><%=j_name%></td>
													<td width="30%" style="text-align: center;"><%=j_teamnm%></td>
													<td width="20%" style="text-align:right"><a href="javascript:mx.setJudge('<%=cda%>',<%=tidx%>,<%=j_seq%>);" class="btn btn-danger">등록</a></td>
												</tr>
								<%
										next
									End if		
								%>

						</tbody>

				</table>

	</div>
	</div>


<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
