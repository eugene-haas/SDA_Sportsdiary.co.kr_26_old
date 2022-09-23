<%

	function GetBBSSelectCount(byval ConStr, byval strTableName, byval strWhere ,ByVal strFieldName)

		Dim strSQL, objRs, intTotalCnt

	 	If InStr(LCase(strWhere), "group by")  > 0 then
			strSQL = " select count(*) as cnt  from  ( Select count(*) as cnt from  " & strTableName & " where " & strWhere & " ) as tblcnt"
		Else
			strSQL = " Select count(*) as cnt from  " & strTableName & " where " & strWhere
		End if

		'If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
		'Response.write strSQL
		'Response.end
		'End if

		Set objRs = db.ExecSQLReturnRS(strSQL , null, ConStr)

		if not objRs.eof then
			intTotalCnt = cdbl( objRs("cnt") )
		end if

		GetBBSSelectCount = intTotalCnt
	end function


function GetBBSSelectDecRS( byval ConStr, byval strTableName, byval strFieldName, byval strWhere, byval intPageSize, byref intPageNum, Byref intTotalCnt, Byref intTotalPage )

  Dim C_OPENKEY,C_CLOSEKEY
		C_OPENKEY = " Open Symmetric Key eval_ability_key " 					'대칭키
		C_OPENKEY = C_OPENKEY & " Decryption By Certificate Cert_eval " '인증서
		C_OPENKEY = C_OPENKEY & " With Password = 'pwdcerteval' "	 			'인증서패스워드
		C_CLOSEKEY = " Close Symmetric Key eval_ability_key "

		Dim strSQL, objRs

		intTotalCnt = GetBBSSelectCount(ConStr, strTableName, strWhere , strFieldName)

		if strFieldName = "" then : strFieldName = " * "

	 	strSQL = ""
		strSQL = strSQL & " select top " & (intPageNum * intPageSize) & strFieldName
		strSQL = strSQL & " from " & strTableName & "  where " & strWhere & strSort & vbcrlf

		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSortR & vbcrlf
		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSort & vbcrlf

		Set objRs = db.ExecSQLReturnRS(C_OPENKEY & strSQL & C_CLOSEKEY , null, ConStr)

		intTotalPage = int( intTotalCnt / intPageSize )
		if ( intTotalCnt mod intPageSize ) > 0 then intTotalPage = intTotalPage + 1

		if intTotalPage <= 0 then : intTotalPage = 1
		if cdbl(intPageNum) > cdbl(intTotalPage) then : intPageNum = intTotalPage

		iF cdbl(intTotalPage) <= cdbl(intPageNum) And cdbl(intPageNum) > 1 Then
			if ( intTotalCnt mod intPageSize ) > 0 then
				for i = intPageSize to ( intTotalCnt mod intPageSize ) + 1 step - 1
					if not objRs.eof then
						objRs.movenext
					end if
				next
			end if
		End if

		SET GetBBSSelectDecRS = objRs

end function





	function GetBBSSelectRS( byval ConStr, byval strTableName, byval strFieldName, byval strWhere, byval intPageSize, byref intPageNum, Byref intTotalCnt, Byref intTotalPage )

		Dim strSQL, objRs

		intTotalCnt = GetBBSSelectCount(ConStr, strTableName, strWhere , strFieldName)

		if strFieldName = "" then : strFieldName = " * "

	 	strSQL = ""
		strSQL = strSQL & " select top " & (intPageNum * intPageSize) & strFieldName
		strSQL = strSQL & " from " & strTableName & "  where " & strWhere & strSort & vbcrlf

		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSortR & vbcrlf
		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSort & vbcrlf

'If Request.ServerVariables("REMOTE_ADDR") = "218.152.205.127" Then
'Response.write strSQL
'Response.end
'End if

		Set objRs = db.ExecSQLReturnRS(strSQL , null, ConStr)

		intTotalPage = int( intTotalCnt / intPageSize )
		if ( intTotalCnt mod intPageSize ) > 0 then intTotalPage = intTotalPage + 1

		if intTotalPage <= 0 then : intTotalPage = 1
		if cdbl(intPageNum) > cdbl(intTotalPage) then : intPageNum = intTotalPage

		iF cdbl(intTotalPage) <= cdbl(intPageNum) And cdbl(intPageNum) > 1 Then
			if ( intTotalCnt mod intPageSize ) > 0 then
				for i = intPageSize to ( intTotalCnt mod intPageSize ) + 1 step - 1
					if not objRs.eof then
						objRs.movenext
					end if
				next
			end if
		End if

		SET GetBBSSelectRS = objRs

	end function




'/////////////////////
'테니스 참가신청 목록
	function GetBBSSelectCount2(byval ConStr, byval strTableName, byval strWhere ,ByVal strFieldName)
		Dim strSQL, objRs, intTotalCnt
		strSQL = " Select count(*) as cnt from  tblGameRequest as a where a.DelYN = 'N' " & strWhere
		Set objRs = db.ExecSQLReturnRS(strSQL , null, ConStr)

		if not objRs.eof then
			intTotalCnt = cdbl( objRs("cnt") )
		end if
		GetBBSSelectCount2 = intTotalCnt
	end function

	function GetBBSSelectRS2( byval ConStr, byval strTableName, byval strFieldName, byval strWhere, byval intPageSize, byref intPageNum, Byref intTotalCnt, Byref intTotalPage , ByVal query)

		Dim strSQL, objRs
		intTotalCnt = GetBBSSelectCount2(ConStr, strTableName, strWhere , strFieldName)

		if strFieldName = "" then : strFieldName = " * "

	 	strSQL = ""
'		strSQL = strSQL & " select top " & (intPageNum * intPageSize) & strFieldName
'		strSQL = strSQL & " from " & strTableName & "  where " & strWhere & strSort & vbcrlf
		strSQL = strSQL & " select top " & (intPageNum * intPageSize) & query & strWhere
		strSQL = strSQL & strSort & vbcrlf


		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSortR & vbcrlf
		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSort & vbcrlf

If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'Response.write strSQL
'Response.end
End if

		Set objRs = db.ExecSQLReturnRS(strSQL , null, ConStr)

		intTotalPage = int( intTotalCnt / intPageSize )
		if ( intTotalCnt mod intPageSize ) > 0 then intTotalPage = intTotalPage + 1

		if intTotalPage <= 0 then : intTotalPage = 1
		if cdbl(intPageNum) > cdbl(intTotalPage) then : intPageNum = intTotalPage

		iF cdbl(intTotalPage) <= cdbl(intPageNum) And cdbl(intPageNum) > 1 Then
			if ( intTotalCnt mod intPageSize ) > 0 then
				for i = intPageSize to ( intTotalCnt mod intPageSize ) + 1 step - 1
					if not objRs.eof then
						objRs.movenext
					end if
				next
			end if
		End if

		SET GetBBSSelectRS2 = objRs

	end function



%>
