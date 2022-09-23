<%
'#############################################
' 평가위원등록
'#############################################
	'request
	adminidx = oJSONoutput.Get("AIDX")
	tableidx = oJSONoutput.Get("TIDX")
	itemidx = oJSONoutput.Get("IIDX")
	itemtypeidx = oJSONoutput.Get("ITIDX")	
	regyear = oJSONoutput.Get("RY")

	Set db = new clsDBHelper

	'수정모드 확인
	Call chkEndMode(tableidx, oJSONoutput,db,ConStr)


	infld = "AdminMemberIDX,UserID,AdminName,EvalTableIDX,EvalItemIDX,EvalItemTypeIDX,RegYear"
	invalue = "select adminmemberidx,userid,adminname,"&tableidx&","&itemidx&","&itemtypeidx&","&regyear&" from tblAdminMember where delYN= 'N' and adminmemberidx = " & adminidx
	SQL = "insert into tblEvalMember ("&infld&")  ("&invalue&") "	
	Call db.execSQLRs(SQL , null, ConStr)


		fld = "EvalMemberIDX,EvalTableIDX,AdminMemberIDX,userid,adminname,evalitemidx,evalitemtypeidx"
		SQL = " Select "&fld&" from tblEvalMember  where delkey = 0 and evalitemtypeidx = " & itemtypeidx
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
												j_id = arrR(3, ari)
												j_name = arrR(4, ari)
												j_Authority = "평가위원"
												j_itemidx = arrR(5,ari)
										%>
												<tr id="setjftr_<%=j_seq%>">
													<td width="20%" style="text-align: center;"><%=j_id%></td>
													<td width="30%" style="text-align: center;"><%=j_name%></td>
													<td width="30%" style="text-align: center;"><%=j_Authority%></td>
													<td width="20%" style="text-align:right"><a href="javascript:mx.delMember(<%=j_seq%>,<%=j_itemidx%>);" class="btn btn-danger">삭제</a></td>
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
