<%
'#############################################
'수정
'#############################################
	'request
		EvalTableIDX = oJSONoutput.get("TIDX") 'EvalTableIDX 현재진행중인 평가

		reqidx = oJSONoutput.get("IDX") '수정요청시만 온다
		
		if reqidx = "" then
			e_menuno = oJSONoutput.Get("MNNO")

			if e_menuno <> "" then
				Set reqArr = oJSONoutput.get("PARR") 
				e_EvalCateCD 	= reqArr.Get(0)
				e_EvalSubCateCD = reqArr.Get(1)
				e_p_EvalItemCD = reqArr.Get(2)
			end if
		end if

	Set db = new clsDBHelper

	'공통코드
	fld = " EvalCodeIDX,EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm "
	SQL = "select "&fld&" from tblEvalCode where delkey = 0 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrP = rs.GetRows()
	End If	
	Set rs = nothing


	'수정정보 가져올때
	if reqidx <> "" then
		strTableName = " tblAssociation as a inner join  tblAssociation_sub as b on a.AssociationIDX = b.AssociationIDX  "
		strFieldName = " b.AssociationIDX as idx,b.AssociationNm,b.association_subIDX,b.evalgroupnm,b.membergroupnm,b.regyear,b.regdate "
		strFieldName = strFieldName & ", b.evalgroupcd,b.membergroupcd "
		strWhere = " a.Delkey = 0  and b.EvalTableIDX = " & EvalTableIDX & " and b.AssociationIDX = " & reqidx
		

		SQL = "SELECT top 1  " & strFieldName
		SQL = SQL &  "  FROM " & strTableName  
		SQL = SQL &  " WHERE " & strWhere
	
		' response.write SQL
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
	end if



	%><!-- #include virtual = "/admin/inc/form.evalmaker.asp" --><%

	db.Dispose
	Set db = Nothing
%>
