<%
'#############################################
' 평가위원등록
'#############################################
	'request
	adminidx = oJSONoutput.Get("AIDX")
	itemidx = oJSONoutput.get("IIDX")

	Set db = new clsDBHelper
	fld = "EvalTableIDX,EvalItemIDX,EvalItemTypeIDX,RegYear"
	SQL = " Select "&fld&" from tblEvalMember where delkey = 0 and evalMemberidx = "	 & adminidx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	if not rs.eof then
		tableidx = rs(0) 
		itemidx = rs(1)
		itemtypeidx = rs(2)
		regyear = rs(3)
	
	
		'수정모드 확인
		Call chkEndMode(tableidx, oJSONoutput,db,ConStr)

	
	end if

	SQL = "update tblEvalMember set delkey = 1 where delkey = 0 and evalMemberidx = " & adminidx	
	Call db.execSQLRs(SQL , null, ConStr)

	fld = " adminmemberidx,userid,adminname,'평가위원' "
	SQL = " Select "&fld&" from tblAdminMember where delyn = 'N' and SiteCode = '"&SiteCode&"' and Authority = 'C' " 
	SQL = SQL & " and adminmemberidx not in (Select adminmemberidx from tblEvalMember where delkey = 0 and EvalItemIDX = " & itemidx &") "	
	'response.write SQL
	'response.end
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
												j_id = arrR(1, ari)
												j_name = arrR(2, ari)
												j_Authority = arrR(3, ari)
										%>
												<tr id="jftr_<%=j_seq%>">
													<td width="20%" style="text-align: center;"><%=j_id%></td>
													<td width="30%" style="text-align: center;"><%=j_name%></td>
													<td width="30%" style="text-align: center;"><%=j_Authority%></td>
													<td width="20%" style="text-align:right"><a href="javascript:mx.setMember(<%=j_seq%>,<%=tableidx%>,<%=itemidx%>,<%=itemtypeidx%>,<%=regyear%>);" class="btn btn-danger">등록</a></td>
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
