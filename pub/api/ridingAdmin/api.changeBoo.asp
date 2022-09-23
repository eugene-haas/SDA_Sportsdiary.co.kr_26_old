<%
'#############################################
'부변경
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "TYPENO") = "ok" Then 
		typeno = oJSONoutput.TYPENO
	End If
	
	'SQL = "select requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname from sd_TennisMember where gameMemberIDX = " & midx
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	SQL = "select pubcodeidx,pubcode,engcode,pubname from tblPubCode where PPubcode = 'RDN01_4' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	arrRs = rs.GetRows()

  db.Dispose
  Set db = Nothing


%>


			<div class="modal-dialog modal-md">
				<div class="modal-contents">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<%If typeno = "1" then %>통합<%End if%> 부서변경
					</div>
					<div class="modal-body">


						<h4 class="control-label">변경 부서 선택</h4>
						<div class="">
							<div class="form-group">
						    <select id ="newboo">
							<%
								If IsArray(arrRs)  Then
									For ar = LBound(arrRs, 2) To UBound(arrRs, 2)
										pidx = arrRs(0, ar)
										pcode = arrRs(1, ar)
										ecode = arrRs(2, ar)
										pname = arrRs(3, ar)
										%><option value="<%=pidx%>" ><%=pname%></option><%
									Next
								End if
							%>
							</select>

						  </div>
						</div>


					</div>
					<div class="modal-footer">
						<button type="button" data-dismiss="modal" aria-hidden="true" class="btn btn-default">닫기</button>
						<button type="button" class="btn btn-primary" onclick="mx.changeBooOK(<%=midx%>,<%=typeno%>,$('#newboo').val())">등록</button>
					</div>
				</div>
			</div>