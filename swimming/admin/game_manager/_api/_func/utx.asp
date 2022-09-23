

<% 	
	'=================================================================================
	'  Purpose  : 	utility algorithm funciton 
	'  Date     : 	2019.11.27
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	

   Function utx_sprintf(sVal, aArgs)      
    Dim i, arg
      If(sVal = "") Then 
         utx_sprintf = ""
         Exit Function 
      End If 

      For i=0 To UBound(aArgs)
         arg = aArgs(i)
         If(IsNull(arg)) Then arg = "" End If 
         sVal = Replace(sVal,"{" & CStr(i) & "}",arg)
      Next
      utx_sprintf = sVal
    End Function

	 Function sprintf(sVal, aArgs)      
    Dim i, arg
      If(sVal = "") Then 
         sprintf = ""
         Exit Function 
      End If 

      For i=0 To UBound(aArgs)
         arg = aArgs(i)
         If(IsNull(arg)) Then arg = "" End If 
         sVal = Replace(sVal,"{" & CStr(i) & "}",arg)
      Next
      
      sprintf = sVal
   End Function
    
'   ===============================================================================     
'      정규식 Replace()
'   =============================================================================== 
	Function utxRegExpReplace(Patt, repl, text)
		Dim ObjRegExp
		On Error Resume Next
		Set ObjRegExp   = New RegExp
		ObjRegExp.Pattern  = Patt         ' 정규 표현식 패턴
		ObjRegExp.Global  = True         ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase  = True  ' 대.소문자 구분 안함
		utxRegExpReplace  = ObjRegExp.Replace(text, repl)
		Set ObjRegExp   = Nothing
	End Function

'   ===============================================================================     
'      정규식 Exec()
'   ===============================================================================  
	Public Function utxRegExpExec(Patrn, text)
		Dim ObjRegExp  
		On Error Resume Next    
		Set ObjRegExp = New RegExp
		ObjRegExp.Pattern = Patrn               ' 정규 표현식 패턴
		ObjRegExp.Global = True                 ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

		Set utxRegExpExec = ObjRegExp.Execute(text)
		Set ObjRegExp = Nothing
	End Function

'   ===============================================================================     
'      정규식 Test()
'   ===============================================================================  
	Function utxRegExpTest(Patrn, text)
		Dim ObjRegExp  
		On Error Resume Next    
		Set ObjRegExp = New RegExp
		ObjRegExp.Pattern = Patrn               ' 정규 표현식 패턴
		ObjRegExp.Global = True                 ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

		utxRegExpTest = ObjRegExp.Test(text)
		Set ObjRegExp = Nothing
	End Function

'   ===============================================================================     
'      전화 번호 체크 
'   ===============================================================================  
	Function utxCheckPhoneNumber(strPhone)
		'핸드폰번호 체크
		patn = "^0(?:11|16|17|18|19|10)-(?:\d{3}|\d{4})-\d{4}$"
		ret = RegExpTest(patn, strPhone)

		If( ret <> True ) Then 	'일반전화 체크			
			patn = "^0(?:2|31|32|33|41|42|43|51|52|53|54|55|61|62|63|64)-(?:\d{3}|\d{4})-\d{4}$"
			ret = RegExpTest(patn, strPhone)
		End If

		utxCheckPhoneNumber = ret
	End Function 

'   ===============================================================================     
'      Space 제거 
'   ===============================================================================  
	Function utxRemoveSpace(str)
		Dim ret, patn

		patn = "\s+|\t+"
		ret = utxRegExpReplace(patn, "", str)
		utxRemoveSpace = ret
	End Function

'   ===============================================================================     
'      Load Excel File
'   =============================================================================== 
	Function utxLoadExcelFile(strPath)
		Dim aryData

		Sql = "SELECT * FROM [Sheet1$]"
		Set excelConnection = Server.createobject("ADODB.Connection")
		excelConnection.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & ";Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";"
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open Sql, excelConnection

		If Not (rs.Eof Or rs.Bof) Then
				aryData = rs.GetRows()
		End If

		utxLoadExcelFile = aryData

		rs.Close
		excelConnection.Close

		Set rs = Nothing
		Set excelConnection = Nothing
  End Function


	'=================================================================================
	'	정규식 - 문자열 Find ( ex) FindByRegEx "(of|loop)", "loop repeats a block of code loop repeats a block"
	'================================================================================= 
	Function utxFindByRegEx(ByVal strExp, ByVal strSrc)
		Dim regEx
		Set regEx = New RegExp

		regEx.Pattern = strExp
		regEx.IgnoreCase = True		' Case Insensitive ( 대소문자 구분 - 안함 )
		regEx.Global = True			' 전체 문서에서 검색 

		Set findRst = regEx.Execute(strSrc)
		For Each x In findRst
		'	response.write(findRst(x) & " = " & x )
			response.write(x & "<br>" )
		Next

		utxFindByRegEx = findRst
		Set findRst = Nothing
		Set regEx = Nothing
	End Function

	'=================================================================================
	'	정규식 - 문자열 Replace  ( ex) replaceByRegEx("[(|'|)]", "", "((2001)) 	('300')")
	'================================================================================= 
	Function utxReplaceByRegEx(ByVal strExp, ByVal strNew, ByVal strSrc)
		Dim regEx
		Set regEx = New RegExp

		regEx.Pattern = strExp
		regEx.IgnoreCase = True		' Case Insensitive ( 대소문자 구분 - 안함 )
		regEx.Global = True			' 전체 문서에서 검색 

		strSrc = regEx.Replace(strSrc, strNew)
		Set regEx = Nothing

		utxReplaceByRegEx = strSrc
	End Function    

  '===============================================================================
	' 문자열 앞에 0를 붙인다. 
	'===============================================================================
  Function utxAppendZero(strSrc, nLimit)
		Dim str, nLen, strZero, nDiff, idx
		nLen = Len(strSrc)

		if(nLen > nLimit) Then 
			AppendZero = strSrc
			Exit Function
		End If

		strZero = ""
		nDiff = nLimit - nLen
		For idx = 1 To nDiff
			strZero = strZero & "0"
		Next

		utxAppendZero = strZero & strSrc
	End Function

   Function utxAppendZero2(num, nLimit)
		Dim strNum

		strNum = utx_sprintf("{0}", Array(num))
		utxAppendZero2 = utxAppendZero(strNum, nLimit)
	End Function 

  '===============================================================================
	' 랜덤 숫자를 얻는다. 
	'===============================================================================
	Function utxGetRandomNum(nRange)
		Randomize
		utxGetRandomNum = (Int(nRange * Rnd) + 1)
	End Function 
	'=================================================================================
	' Court Number(StadiumNum)기준 DB로 부터 받아오 Data를 Sort하여 배열(AryData)에 저장한다. - 버블Sort
	' key : 기준값 Court Number(StadiumNum) 이 들어 있는 배열 위치   
	'================================================================================= 
	Function utxSort2DimAry(ByRef AryData, key, dataType, IsDesc)
			Dim nl, ul, nidx, jj, tmp
			Dim val1, val2

			nl = LBOUND(AryData, 2)
			ul = UBOUND(AryData, 2)

			For nidx=nl To ul-1            
					For jj=nl To (ul-nidx)-1    
							val1 = AryData(key, jj)
							val2 = AryData(key, jj+1)

							If( IsDesc ) Then 
								If(dataType = 1) Then      ' Text 
										If ( utxCompareStr(val1,val2) < 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2)  Then    ' 숫자 - Double
										If ( utxCompareNum(val1,val2) < 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If                 
								End If 
							Else
								If(dataType = 1) Then      ' Text 
										If ( utxCompareStr(val1,val2) > 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2)  Then    ' 숫자 - Double 
										If ( utxCompareNum(val1,val2) > 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If                 
								End If                 
							End If            
					Next
			Next
	End Function

	Function utxSortPart2DimAry(ByRef AryData, key, sIdx, eIdx, dataType, IsDesc)
			Dim nidx, jj, tmp
			Dim val1, val2
			
			For nidx=sIdx To eIdx          
					For jj=sIdx To (eIdx-1)     
							val1 = CDbl(AryData(key, jj))
							val2 = CDbl(AryData(key, jj+1))

							If( IsDesc ) Then 
								If(dataType = 1) Then      ' Text 
										If ( utxCompareStr(val1,val2) < 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2) Then      ' 숫자 - Double 
										If ( utxCompareNum(val1,val2) < 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If                 
								End If 
							Else
								If(dataType = 1) Then      ' Text  
										If ( utxCompareStr(val1,val2) > 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2) Then      ' 숫자 - Double  
										If ( utxCompareNum(val1,val2) > 0 ) Then 
											Call utxSwapRows(AryData, jj, jj+1)
										End If                 
								End If                 
							End If            
					Next
			Next
	End Function

	Function utxCompareStr(val1, val2)
		Dim str1, str2

		str1 = CStr(val1)
		str2 = CStr(val2)
		utxCompareStr = StrComp(str1, str2)
	End Function 

	Function utxCompareNum(val1, val2)
		Dim num1, num2

		num1 = CDbl(val1)
		num2 = CDbl(val2)
		utxCompareNum = (num1 - num2)
	End Function 

	'=================================================================================
' 2차원 배열에서 row를 swap하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Sub utxSwapRows(ary,row1,row2)
	'== This proc swaps two rows of an array
		Dim x,tempvar
		For x = 0 to Ubound(ary,1)
			tempvar = ary(x,row1)   
			ary(x,row1) = ary(x,row2)
			ary(x,row2) = tempvar
		Next
	End Sub  'utxSwapRows

	'=================================================================================
' 2차원 배열에서 row를 Copy하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Function utxCopyRows(aryS,aryT, rS, rT)    
		Dim Idx, ub, ub2, ret
		ub = Ubound(aryS,1)
		ub2 = Ubound(aryT,1)
		ret = 0

		If(ub <> ub2) Then 
				utxCopyRows = ret
				Exit Function 
		End If 

		For Idx = 0 to ub         
				aryT(Idx,rT) = aryS(Idx,rS)
		Next

		ret = 1
		utxCopyRows = ret
	End Function 
	
'   ===============================================================================     
'     copy partial array  - test 필요
'   =============================================================================== 
	Function utxCopyPart2DAry(rAryS, rAryT, sp_s, sp_t, cnt)
		Dim aryQTeam, aryTmp
		Dim Idx, Idx2, ub, ub2, ep_s, ep_t 
		Dim sz_s, sz_t
		
		sz_s = UBound(rAryS, 2)
		sz_t = UBound(rAryT, 2)
		
		ep_s = sp_s + cnt-1

		Idx2 = sp_t
		ep_t = sp_t + cnt-1

		' out of range
		If(ep_s > sz_s) Or (ep_t > sz_t) Then 
				Exit Function 
		End IF 
					
		For Idx = sp_s To ep_s
				Call utxCopyRows(rAryS, rAryT, Idx, Idx2)
				Idx2 = Idx2 + 1
		Next 

	End Function 

'   ===============================================================================     
'     copy partial array  - test 필요
'   =============================================================================== 
	Function utxCopyPart2DAryEx(rAryS, rAryT, sp_s, sp_t, s_col, cnt)
		Dim aryQTeam, aryTmp
		Dim Idx, Idx2, ub, ub2, ep_s, ep_t 
		Dim sz_s, sz_t
		
		sz_s = UBound(rAryS, 2)
		sz_t = UBound(rAryT, 2)
		
		ep_s = sp_s + cnt-1

		Idx2 = sp_t
		ep_t = sp_t + cnt-1

		' out of range
		If(ep_s > sz_s) Or (ep_t > sz_t) Then 
			Exit Function 
		End IF 
					
		For Idx = sp_s To ep_s
			Call utxCopyRowsPart(rAryS, rAryT, Idx, Idx2, s_col)
			Idx2 = Idx2 + 1
		Next 

	End Function 

'   ===============================================================================
'      ary를 받아서 key와 같은 데이터를 뽑아서 SubArray로 뽑아서 return 한다. 
'   ===============================================================================
	Function utxExtractAryFromAry(rAry, key, key_pos, s_col)
		Dim Idx, k, ub, ub2, cnt, s_pos, e_pos
		Dim aryInfo

		strLog = utx_sprintf("key  = {0}, key_pos  = {1}, s_col  = {2}", Array(key, key_pos, s_col))
		' Call utxLog(SPORTS_LOG1, strLog)

		If(IsArray(rAry)) Then 
				ub = UBound(rAry, 2)
				ub2 = UBound(rAry, 1)

				' Call TraceLog2Dim(SPORTS_LOG1, rAry, "rAry")

				If( key_pos < ub2 ) Then          

					' 해당 Key의 Data가 존재 하는지 , 갯수를 센다. 
					s_pos = -1
					e_pos = -1
					For Idx = 0 To ub 
						'If( CStr(rAry(key_pos, Idx)) = CStr(key)) Then    ' 데이터를 찾았으면 postion을 셋팅한다. 
						If( CDbl(rAry(key_pos, Idx)) = CDbl(key) ) Then    ' 데이터를 찾았으면 postion을 셋팅한다. 
							If(s_pos = -1) Then 
								s_pos = Idx 
								e_pos = Idx 
							Else 
								e_pos = Idx 
							End If 
						Else 
							If(e_pos <> -1) Then          ' 데이터를 찾았으면 그만 찾자 
								Exit For 
							End If 
						End If 
					Next 

					If(e_pos <> -1) Then 
						cnt = e_pos - s_pos 
						strLog = utx_sprintf("s_pos  = {0}, e_pos  = {1}, cnt  = {2}", Array(s_pos, e_pos, cnt))
						' Call utxLog(SPORTS_LOG1, strLog)

						ReDim aryInfo(ub2, cnt) 
						k = 0
						For Idx = s_pos To e_pos
							Call utxCopyRowsPart(rAry, aryInfo, Idx, k, s_col)
							k = k + 1
						Next
					End If             
				End If 
		End If 

		'Response.End 

		utxExtractAryFromAry = aryInfo 
	End Function 

	'=================================================================================
' 2차원 배열에서 row를 Copy하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Function utxCopyRowsPart(aryS,aryT, rS, rT, s_col)    
		Dim Idx, ub, ub2, ret, k
		ub = Ubound(aryS,1)
		ub2 = Ubound(aryT,1)
		ret = 0

		If(ub <> ub2) Then 
			utxCopyRowsPart = ret
			Exit Function 
		End If 

		k = 0
		For Idx = s_col to ub         
			aryT(k,rT) = aryS(Idx,rS)
			k = k + 1
		Next

		ret = 1
		utxCopyRowsPart = ret
	End Function 


'=================================================================================
' string을 입력받아 2차원 배열을 만든다. 
	' sep1, sep2를 기준으로 배열값이 만들어진다. 
'================================================================================= 
	Function utxGet2DimAryFromStr(strSrc, sep1, sep2)
		Dim aryTmp, aryRet, aryLine
		Dim ul1, ul2, ai1, ai2

		aryTmp = split(strSrc, sep1)
		aryLine = split(aryTmp(0), sep2)

		ul1 = UBound(aryTmp)
		ul2 = UBound(aryLine)

		ReDim aryRet(ul2, ul1)       

		For ai1 = 0 to ul1
			aryLine = split(aryTmp(ai1), sep2)

			For ai2 = 0 to ul2
				aryRet(ai2, ai1) = aryLine(ai2)
			Next
		Next

		utxGet2DimAryFromStr = aryRet
	End Function

	'=================================================================================
	' 2차원 배열을 입력받아 string을 만든다.  
	' sep1, sep2를 기준으로 배열값이 만들어진다. 
	'================================================================================= 
	Function utxGetStrFrom2DimAry(rAry, sep1, sep2)        
		Dim ub, ub2, Idx, k, strData, strLine
		strData = ""

		If(IsArray(rAry)) Then       
			ub = UBound(rAry, 2)
			ub2 = UBound(rAry, 1)

			For Idx = 0 to ub
				For k = 0 to ub2
					If(k = 0) Then 
						strLine = utx_sprintf("{0}", Array(rAry(k,Idx)))
					Else 
						strLine = utx_sprintf("{0}{1}{2}", Array(strLine, sep2, rAry(k,Idx)))
					End If 
				Next
				If(Idx = 0) Then 
					strData = utx_sprintf("{0}", Array(strLine))
				Else 
					strData = utx_sprintf("{0}{1}{2}", Array(strData, sep1, strLine))
				End If 
			Next
		End If 
		utxGetStrFrom2DimAry = strData
	End Function

'=================================================================================
'	string에서 l, r key 사이의 문자열을 찾아 반환한다. 
'=================================================================================
	Function utxGetBlockData(strSrc, l, r)
		Dim strRet
		Dim s_len, l_len, r_len, l_pos, r_pos, s_pos

		If Not (strSrc = "" Or (l = "" And r = "")) Then            
			s_len = Len(strSrc)

			If( l = "" ) Then 
				r_pos = INSTR(strSrc, r)
				if(r_pos > 0) Then 
					r_pos = r_pos -1 
				else 
					r_pos = Len(strSrc)
				End If                 

				strRet = Left(strSrc, r_pos)
			ElseIf( r = "" ) Then 
				l_len = Len(l)
				r_len = s_len - l_len
				strRet = Right(strSrc, r_len)
			Else        ' l and r mid 
				l_len = Len(l)
				l_pos = INSTR(strSrc, l) + l_len
				r_pos = INSTRREV(strSrc, r)

				strRet = Mid(strSrc, l_pos, r_pos-l_pos)
			End If 
		End If 

		utxGetBlockData = strRet 
	End Function
    
'   ===============================================================================     
'      Int의 음수일 때 정수변환하는 특성을 활용하여 올림함수를 구현하는 방법이다.
'						9.9 음수변환 -> -9.9
'						-9.9 를 Int함수 적용 -> -10
'						-10을 다시 -를 붙여서 10
'   ===============================================================================
	Function utxCeil(val)
		utxCeil = -(Int(-(val)))
	End Function 
	
'   ===============================================================================     
'      Swap 함수 구현 
'   ===============================================================================
	Function utxSwap(val1, val2)
		Dim tmp

		tmp = val1
		val1 = val2
		val2 = tmp 
	End Function 

'   ===============================================================================     
'      Json Object을 입력받아 그 값의 길이가 nLimit보다 작은 값만 Json Text로 변환한다.  ( 1차원 배열만 지원 )
'   ===============================================================================
	Function utxJSonStringifyByLimit(jObj, nLimit)
		dim key, n , nLen, val , strJson
		n = 0
		
		for each key in jObj.keys()
			val = jObj.get(key)
			nLen = Len(val)
			If(nLen < nLimit) Then 
				If(n = 0) Then 
					strJson = utx_sprintf(" ""{0}"":""{1}"" ", Array(key, val))
				Else 
					strJson = utx_sprintf(" {0}, ""{1}"":""{2}"" ", Array(strJson, key, val))
				End If 
				n = n + 1
			End If 
		next

		strJson = utx_sprintf(" { {0} } ", Array(strJson))
		utxJSonStringifyByLimit = strJson
	End Function 

'   ===============================================================================     
'     1차원 arrayKey,  2차원 aryData를 입력받아 Json String을 만든다. 
'   ===============================================================================
	Function utx2DAryToJsonStr(rAryKey, rAryData)
		Dim Idx, k , ub, ub2, kub2
		Dim strJson, strData 
		Dim key, val

		If(IsArray(rAryKey) ) And (IsArray(rAryData) ) Then 
			ub 		= UBound(rAryData, 2)
			ub2 	= UBound(rAryData, 1)
			kub2 	= UBound(rAryKey) 

			If(ub2 = kub2) Then 
				For Idx = 0 To ub
					For k = 0 To ub2
						key = Trim(rAryKey(k))
						val = Trim(rAryData(k,Idx))

						If(k = 0) Then 
							strData = utx_sprintf("""{0}"":""{1}""", Array(key, val))
						Else 
							strData = utx_sprintf("{0},""{1}"":""{2}""", Array(strData, key, val))
						End If 
					Next 

					If(Idx = 0) Then 
							strJson = utx_sprintf("{{0}}", Array(strData))
					Else 
						strJson = utx_sprintf("{0},{{1}}", Array(strJson, strData))
					End If 
				Next

				strJson = utx_sprintf("[{0}]", Array(strJson))
			End If 
		End If 

		utx2DAryToJsonStr = strJson 
	End Function 

'   ===============================================================================     
'      1차원 배열 arrayKey, arrayVal를 입력받아 Json String을 만든다. 
'   ===============================================================================
	Function utxAryToJsonStr(rArykey, rAryVal)
		Dim strData, ub1, ub2, Idx
		Dim key, val 

		' Array Check 
		If(IsArray(rAryKey) = False) Or (IsArray(rAryVal) = False) Then 
			AryToJsonStr = ""
			Exit Function 
		End If 

		' Array Length Check  - 두 배열의 길이가 같아야 한다. 
		ub1 = UBound(rAryKey)
		ub2 = UBound(rAryVal)
		If(ub1 <> ub2) Then 
			AryToJsonStr = ""
			Exit Function 
		End If

		' Make Json String 
		For Idx = 0 To ub1 
			key = Trim(rAryKey(Idx))
			val = Trim(rAryVal(Idx))

			If(InStr(val, "[") > 0) And (InStr(val, "]") > 0) Then 
				If(Idx = 0) Then 
					strData = utx_sprintf(" ""{0}"":{1}", Array(key, val))
				Else 
					strData = utx_sprintf("{0},""{1}"":{2}", Array(strData, key, val))
				End If
			Else 
				If(Idx = 0) Then 
					strData = utx_sprintf(" ""{0}"":""{1}"" ", Array(key, val))
				Else 
					strData = utx_sprintf("{0},""{1}"":""{2}"" ", Array(strData, key, val))
				End If
			End If
		Next 

		strData = utx_sprintf(" { {0} } ", Array(strData))
		utxAryToJsonStr = strData
	End Function 

	'=================================================================================
	'	SMS 문자열 발송시 개행 문자로 변환  
    '   Chr(10) : SMS 문자열 개행
    '   \r\n 혹은 \n으로 구분된 문자열을 받아 Chr(10)으로 구분된 문자열로 변환한다. 
	'================================================================================= 
    Function utxGetSMSStr(strContent)
        strContent   = Replace(strContent, "\r\n", Chr(10))       ' 개행 문자열 변환
        strContent   = Replace(strContent, "\n", Chr(10))         ' 개행 문자열 변환
        utxGetSMSStr = strContent
    End Function

  '=================================================================================
	'	문자열을 입력받아 한글자씩 잘라서 배열을 만들어 반환한다. ex) ary = GetArrayFromStr("12345")
	'================================================================================= 
    Function utxGetArrayFromStr(strVal)
		Dim slen, ary()
        If (src = "") Or (Len(src) < 1) Then Exit Function
        

		slen = Len(strVal)
		ReDim ary(slen)

		For i=1 To slen
            ary(i) = Mid(strVal, i, 1)
        Next

		utxGetArrayFromStr = ary
	End Function
    
  '=================================================================================
	'	DB Query용 - ,로 구분된 문자열을 입력받아 각 문자마다 ' '를 붙여서 반환한다. 
    '   1,2,3,4 => '1','2','3','4'
	'================================================================================= 
	Function utxAddQuotationInWord(src)	
		Dim strRet, ary
        If (src = "") Or (Len(src) < 1) Then Exit Function

		ary = SPLIT (src, ",")

		strRet = utx_sprintf( "'{0}'", Array(ary(0)) )
		For i=1 To UBound(ary)
        	strRet = utx_sprintf( "{0},'{1}'", Array(strRet, ary(i)) )
    	Next

		utxAddQuotationInWord = strRet
	End Function

  '=================================================================================
	'	Date을 입력받아 날짜, 시, 분, 초로 잘라서 배열을 만들어 반환한다. 
    '   ex) ary = getArrayFromDate("2018-11-29 00:00:00") (0서 부터 시작) 
	'================================================================================= 
    Function utxGetArrayFromDate(src)	
		Dim strDate, ary
        If (src = "") Or (Len(src) < 1) Then Exit Function

    	strDate = REPLACE (src, " ", ",")
		strDate = REPLACE (strDate, ":", ",")
		ary = SPLIT (strDate, ",")

		utxGetArrayFromDate = ary
	End Function

    '=================================================================================
	'	문자열 2개와 연결 문자열을 입력받아 문자열을 더해서 반환한다.     
    '   두 문자열이 둘다 값이 있을 경우만 strAppend를 중간에 넣고 더해서 반환. 
    '   두 문자열 (src1, src2) 중 하나가 빈값이면 값이 있는 문자열만 반환한다. 
    '   ex)  StrAddStr("1", "", " {0} + {1} ")  => 1
    '   ex)  StrAddStr("", "2", " {0} + {1} ")  => 2
    '   ex)  StrAddStr("1", "2", " {0} + {1} ")  => 1 + 2
	'================================================================================= 
    Function utxStrAddStr(src1, src2, strAppend)	
		Dim strRet 

		If(src2 = "") Then 			
			strRet = src1
		Else
			If (src1 = "") Then 			
				strRet = src2			
			Else
                strRet = utx_sprintf(strAppend,  Array(src1, src2) ) 
			End If
		End If

		utxStrAddStr = strRet
	End Function

	'=================================================================================
	'	Sql 구문 - 변수값을 ' ' 로 둘러싼 문자열로 반환한다.
	'================================================================================= 
	Function utxStrSqlVar(strVal)
		utxStrSqlVar = "'" & strVal & "'"
	End Function

	'=================================================================================
	'	aryKey, aryData를 입력받아 엑셀 파일을 만들어 다운로드 한다. 
	'================================================================================= 
	Function DownloadToExcel(title, fileName, aryKey, aryData)
      Dim ub_key, ub1, ub2
      Dim i, j , strFile
      Dim strBlock1, strBlock2, strHead, strContent, strData
      ub_key = UBound(aryKey)

      ' -------------------------------------------------------------------
      ' first block 
      strBlock1 = strBlock1 & "<html> "
      strBlock1 = strBlock1 & "   <head> "
      strBlock1 = strBlock1 & "      <meta charset='UTF-8'> "
      strBlock1 = strBlock1 & "      <style> "
      strBlock1 = strBlock1 & "      table{border-collapse: collapse;}"
      strBlock1 = strBlock1 & "      table td{padding:5px 10px;}"
      strBlock1 = strBlock1 & "      </style> "
      strBlock1 = strBlock1 & "   </head> "
      strBlock1 = strBlock1 & " <table border='1'>"
      strBlock1 = strBlock1 & "   <tr> "      
		strBlock1 = strBlock1 & sprintf("      <td colspan='{0}' align='center' height = '40' style='font-size:16px;' ><b>{1}</b></td> ", Array(ub_key+1, title))
      strBlock1 = strBlock1 & "   </tr>	 "

      ' -------------------------------------------------------------------
      ' table header 
      strHead = strHead & "   <tr> "
      For i = 0 To ub_key 
         strHead = strHead & sprintf("      <td align='center'><b>{0}</b></td> ", Array(aryKey(i)) )
      Next 
      strHead = strHead & "   </tr> "

      ' -------------------------------------------------------------------
      ' table content
      ub1 = UBound(aryData, 2)
      ub2 = UBound(aryData, 1)

      For i = 0 To ub1 
         strContent = strContent & "   <tr> "
         For j = 0 To ub2
            strContent = strContent & sprintf("      <td>{0}</td> ", Array(aryData(j, i)) )
         Next 
         strContent = strContent & "   </tr> "
      Next 

      ' -------------------------------------------------------------------
      ' end block 
      strBlock2 = strBlock2 & "  </table> "
      strBlock2 = strBlock2 & "</html> "

      strData = sprintf("{0}{1}{2}{3}", Array(strBlock1, strHead, strContent, strBlock2))

      response.write strData 

      Response.Buffer = True
      Response.ContentType = "application/vnd.ms-excel"
      Response.CacheControl = "public"
      Response.AddHeader "Content-disposition", "attachment;filename= " & fileName
      
   End Function 

	'=================================================================================
	'	aryKey, aryData를 입력받아 엑셀 파일을 만들어 다운로드 한다. 
	'  arySize 로 각 Cell에 대한 width를 지정할 수 있다. 
	'================================================================================= 
	Function DownloadToExcelSize(title, fileName, aryKey, arySize, aryData)
      Dim ub_key, ub1, ub2
      Dim i, j , strFile
      Dim strBlock1, strBlock2, strHead, strContent, strData
      ub_key = UBound(aryKey)

      ' -------------------------------------------------------------------
      ' first block 
      strBlock1 = strBlock1 & "<html> "
      strBlock1 = strBlock1 & "   <head> "
      strBlock1 = strBlock1 & "      <meta charset='UTF-8'> "
      strBlock1 = strBlock1 & "      <style> "
      strBlock1 = strBlock1 & "      table{border-collapse: collapse;}"
      strBlock1 = strBlock1 & "      table td{padding:5px 10px;}"
      strBlock1 = strBlock1 & "      </style> "
      strBlock1 = strBlock1 & "   </head> "
      strBlock1 = strBlock1 & " <table border='1'>"
      strBlock1 = strBlock1 & "   <tr> "
      strBlock1 = strBlock1 & sprintf("      <td colspan='{0}' align='center' height = '40' style='font-size:16px;' ><b>{1}</b></td> ", Array(ub_key+1, title))
      strBlock1 = strBlock1 & "   </tr>	 "

      ' -------------------------------------------------------------------
      ' table header 
      strHead = strHead & "   <tr> "
      For i = 0 To ub_key 
         strHead = strHead & sprintf("      <td align='center' width='{0}'><b>{1}</b></td> ", Array(arySize(i), aryKey(i)) )
      Next 
      strHead = strHead & "   </tr> "

      ' -------------------------------------------------------------------
      ' table content
      ub1 = UBound(aryData, 2)
      ub2 = UBound(aryData, 1)

      For i = 0 To ub1 
         strContent = strContent & "   <tr> "
         For j = 0 To ub2
            strContent = strContent & sprintf("      <td align='center'>{0}</td> ", Array(aryData(j, i)) )
         Next 
         strContent = strContent & "   </tr> "
      Next 

      ' -------------------------------------------------------------------
      ' end block 
      strBlock2 = strBlock2 & "  </table> "
      strBlock2 = strBlock2 & "</html> "

      strData = sprintf("{0}{1}{2}{3}", Array(strBlock1, strHead, strContent, strBlock2))

      response.write strData 

      Response.Buffer = True
      Response.ContentType = "application/vnd.ms-excel"
      Response.CacheControl = "public"
      Response.AddHeader "Content-disposition", "attachment;filename= " & fileName
      
   End Function 

	'----------------------------------------------------------------------
	' Description
	'		입력받은 데이터를 HTML Encoding 처리
	' 		asp에서는 \n을 detect하지 못해서 자바스크립트 정규식을 사용한다. 
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function htmlEncode(ByVal data)
		Dim result

		If data <> "" then
			result = Trim(data)
			result = Replace(result, ">", "&gt;")
			result = Replace(result, "<", "&lt;")
			result = Replace(result, """", "&quot;")
			result = Replace(result, "'", "&#39;")						
			result = Replace(result, "&", "&amp;")
			result = utxReplaceByRegEx("\n", "<br>", result)
			result = Replace(result, "\", "&bsol;")	
			result = Replace(result, "\t", "")		' tab 제거

			htmlEncode = result
		Else
			htmlEncode = ""
		End If

	End Function

	'----------------------------------------------------------------------
	' Description
	'		입력받은 데이터를 HTML Decoding 처리
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function htmlDecode(ByVal data)
		Dim result

		If data <> "" Then
			result = Trim(data)
			result = Replace(result, "&amp;", "&")
			result = Replace(result, "&#39;;", "'")
			result = Replace(result, "&quot;", """")
			result = Replace(result, "&lt;", "<")
			result = Replace(result, "&gt;", ">")			
			result = utxReplaceByRegEx("<br>", "\n", result)
			result = Replace(result, "&#92;", "\")	

			htmlDecode = result
		Else
			htmlDecode = ""
		End If

	End Function
   
%>