<%

	function GetBBSSelectCount(byval ConStr, byval strTableName, byval strWhere )

		Dim strSQL, objRs, intTotalCnt
	 	
	 	strSQL = " Select count(*) as cnt from  " & strTableName & " where " & strWhere

		Set objRs = db.ExecSQLReturnRS(strSQL , null, ConStr)

		if not objRs.eof then 
			intTotalCnt = cdbl( objRs("cnt") )
		end if 

		GetBBSSelectCount = intTotalCnt

	end function 



	function GetBBSSelectRS( byval ConStr, byval strTableName, byval strFieldName, byval strWhere, byval intPageSize, byref intPageNum, Byref intTotalCnt, Byref intTotalPage )

		Dim strSQL, objRs

		intTotalCnt = GetBBSSelectCount(ConStr, strTableName, strWhere )

		if strFieldName = "" then : strFieldName = " * "

	 	strSQL = ""
		strSQL = strSQL & " select top " & (intPageNum*intPageSize) & strFieldName
		strSQL = strSQL & " from " & strTableName & " where " & strWhere & strSort & vbcrlf

		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSortR & vbcrlf
		strSQL = " select top " & (intPageSize) &" * from (" & strSQL & ") s1 " & strSort & vbcrlf

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

%>	