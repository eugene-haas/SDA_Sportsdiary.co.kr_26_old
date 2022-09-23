<%
'#############################################
'수정
'#############################################
	'request
		reqidx = oJSONoutput.get("IDX")
		EvalTableIDX = oJSONoutput.get("ETBLIDX") 'EvalTableIDX 현재진행중인 평가


	Set db = new clsDBHelper

	'공통코드
	SQL = "select pubcodeidx,kindcd,kindnm,codecd,codenm from tblPubCode where delkey = 0"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrRSP = rs.GetRows()
	End If
	Set rs = nothing


	strTableName = " tblAssociation as a inner join  tblAssociation_sub as b on a.AssociationIDX = b.AssociationIDX and b.delkey = 0 "
	strFieldName = " b.AssociationIDX as idx,b.AssociationNm,b.association_subIDX,b.evalgroupnm,b.membergroupnm,b.regyear,b.regdate "
	strFieldName = strFieldName & ", b.evalgroupcd,b.membergroupcd "
	strWhere = " a.Delkey = 0  and b.EvalTableIDX = " & EvalTableIDX & " and b.AssociationIDX = " & reqidx
	

	SQL = "SELECT top 1  " & strFieldName
	SQL = SQL &  "  FROM " & strTableName  
	SQL = SQL &  " WHERE " & strWhere
	
	 response.write SQL
	' response.end

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If


	If IsArray(arrR) Then
	
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			e_idx						 			= arrR(0, ari)
			e_AssociationNm 			= arrR(1, ari)
			e_association_subIDX 	= arrR(2, ari)
			e_evalgroupnm 				= arrR(3, ari)
			e_membergroupnm 			= arrR(4, ari)
			e_regyear 						= arrR(5, ari)
			e_regdate 						= arrR(6, ari)

			e_evalgroupcd 				= arrR(7, ari)
			e_membergroupcd 			= arrR(8, ari)
		Next
	End if



	%><!-- #include virtual = "/admin/inc/form.sportslog.asp" --><%

	db.Dispose
	Set db = Nothing
%>
