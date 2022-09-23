

<% 	
	'=================================================================================
	'  Purpose  : 	
	'  Date     : 
	'  Author   : 															By Aramdry
	'================================================================================= 
%>
<script language="Javascript" runat="server">
	/* =================================================================================
			테스트용 - 숫자를 입력받아 2로 나눈 나머지가 1이면 'Y' 0 이면 'N'반환
	   ================================================================================= */
	function GetYesNoChar(num) {
		return (num % 2) ? "'Y'" : "'N'";
	}    

</script>

<% 	

   Function sprintf(sVal, aArgs)      
    Dim i, arg
      If(sVal = "") Then 
         sprintf = ""
         Exit Function 
      End If 

      For i=0 To UBound(aArgs)
         arg = aArgs(i)
         If(arg = "" Or IsNull(arg)) Then arg = " " End If 
         sVal = Replace(sVal,"{" & CStr(i) & "}",arg)
      Next
      sprintf = sVal
    End Function
    
'   ===============================================================================     
'      정규식 Replace()
'   =============================================================================== 
	Function RegExpReplace(Patt, repl, text)
		Dim ObjRegExp
		On Error Resume Next
		Set ObjRegExp   = New RegExp
		ObjRegExp.Pattern  = Patt         ' 정규 표현식 패턴
		ObjRegExp.Global  = True         ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase  = True  ' 대.소문자 구분 안함
		RegExpReplace  = ObjRegExp.Replace(text, repl)
		Set ObjRegExp   = Nothing
	End Function

'   ===============================================================================     
'      정규식 Exec()
'   ===============================================================================  
	Public Function RegExpExec(Patrn, text)
		Dim ObjRegExp  
		On Error Resume Next    
		Set ObjRegExp = New RegExp
		ObjRegExp.Pattern = Patrn               ' 정규 표현식 패턴
		ObjRegExp.Global = True                 ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

		Set RegExpExec = ObjRegExp.Execute(text)
		Set ObjRegExp = Nothing
	End Function

'   ===============================================================================     
'      정규식 Test()
'   ===============================================================================  
	Function RegExpTest(Patrn, text)
		Dim ObjRegExp  
		On Error Resume Next    
		Set ObjRegExp = New RegExp
		ObjRegExp.Pattern = Patrn               ' 정규 표현식 패턴
		ObjRegExp.Global = True                 ' 문자열 전체를 검색함
		ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

		RegExpTest = ObjRegExp.Test(text)
		Set ObjRegExp = Nothing
	End Function

'   ===============================================================================     
'      전화 번호 체크 
'   ===============================================================================  
	Function CheckPhoneNumber(strPhone)
		'핸드폰번호 체크
		patn = "^0(?:11|16|17|18|19|10)-(?:\d{3}|\d{4})-\d{4}$"
		ret = RegExpTest(patn, strPhone)

		If( ret <> True ) Then 	'일반전화 체크			
			patn = "^0(?:2|31|32|33|41|42|43|51|52|53|54|55|61|62|63|64)-(?:\d{3}|\d{4})-\d{4}$"
			ret = RegExpTest(patn, strPhone)
		End If

		CheckPhoneNumber = ret
	End Function 

'   ===============================================================================     
'      Space 제거 
'   ===============================================================================  
	Function RemoveSpace(str)
		Dim ret, patn

		patn = "\s+|\t+"
		ret = RegExpReplace(patn, "", str)
		RemoveSpace = ret
	End Function

'   ===============================================================================     
'      Load Excel File
'   =============================================================================== 
	Function LoadExcelFile(strPath)
        Dim aryData

        Sql = "SELECT * FROM [Sheet1$]"
        Set excelConnection = Server.createobject("ADODB.Connection")
        excelConnection.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & ";Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";"
        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open Sql, excelConnection

        If Not (rs.Eof Or rs.Bof) Then
            aryData = rs.GetRows()
        End If
	
		LoadExcelFile = aryData

        rs.Close
        excelConnection.Close

        Set rs = Nothing
        Set excelConnection = Nothing
    End Function


	'=================================================================================
	'	정규식 - 문자열 Find ( ex) FindByRegEx "(of|loop)", "loop repeats a block of code loop repeats a block"
	'================================================================================= 
	Function FindByRegEx(ByVal strExp, ByVal strSrc)
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

		Set findRst = Nothing
		Set regEx = Nothing
	End Function

	'=================================================================================
	'	정규식 - 문자열 Replace  ( ex) replaceByRegEx("[(|'|)]", "", "((2001)) 	('300')")
	'================================================================================= 
	Function replaceByRegEx(ByVal strExp, ByVal strNew, ByVal strSrc)
		Dim regEx
		Set regEx = New RegExp

		regEx.Pattern = strExp
		regEx.IgnoreCase = True		' Case Insensitive ( 대소문자 구분 - 안함 )
		regEx.Global = True			' 전체 문서에서 검색 

		strSrc = regEx.Replace(strSrc, strNew)
		Set regEx = Nothing

		replaceByRegEx = strSrc
	End Function    

    '===============================================================================
	' 배열을 받아 그 값을 출력한다. 
	'===============================================================================
	Function printAry(ary)
		Dim strRet 
		strRet = "=========================== print array"& vbCrLf
		If( IsArray(ary) ) Then 			
			nl = LBound(ary) 
			ul = UBound(ary) 

			For i = nl to ul 				
				strRet = strRet & "ary (" & i & ") = " & ary(i) & vbCrLf
			Next 		
		End If
		strRet = strRet & "=========================== print array"& vbCrLf

		printAry = strRet
	End Function

   '===============================================================================
	' 문자열 앞에 0를 붙인다. 
	'===============================================================================
    Function AppendZero(strSrc, nLimit)
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

		AppendZero = strZero & strSrc
	End Function

   Function AppendZero2(num, nLimit)
		Dim strNum

		strNum = sprintf("{0}", Array(num))
		AppendZero2 = AppendZero(strNum, nLimit)
	End Function 

    Function GetRandomKey(keyLen)
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		serialCode = ""
		Randomize
		For j = 1 To keyLen
			r = Int((Len(str) - 1 + 1) * Rnd + 1)
			serialCode = serialCode + Mid(str,r,1)
		Next
		
		GetRandomKey = serialCode
	End Function

    '===============================================================================
	' 랜덤 PW를 얻는다. 
	'===============================================================================
	Function GetRandomPasswd(keyLen)
		Dim arySrc(6), aryLen(6), max, r1, r2, i, j, ul, len1
		arySrc(0) = "abcdefghijklmnopqrstuvwxyz"
		arySrc(1) = "0123456789"
		arySrc(2) = "~!@#$%^&*()_+"
		arySrc(3) = "0123456789~!@#$%^&*()_+"
		arySrc(4) = "0123456789~!@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"
		arySrc(5) = "@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"

		ul = UBound(arySrc)
		serialCode = ""
		For i = 0 To ul
			len1 = Len(arySrc(i))
			aryLen(i) = len1
		Next
		
		For j = 0 To keyLen
			r1 = GetRandomNum(ul) -1
			r2 = GetRandomNum(aryLen(r1))
			serialCode = serialCode + Mid(arySrc(r1),r2,1)
		Next
		
		GetRandomPasswd = serialCode
	End Function

    '===============================================================================
	' 랜덤 Id를 얻는다.  strBase + random string
	'===============================================================================
	Function GetRandomID(strBase, keyLen)
		Dim arySrc(3), aryLen(3), max, r1, r2, i, j, ul, len1
		arySrc(0) = "abcdefghijklmnopqrstuvwxyz"
		arySrc(1) = "0123456789"
		arySrc(2) = "abcdefghijklmnopqrstuvwxyz0123456789"

		ul = UBound(arySrc)
		serialCode = ""
		For i = 0 To ul
			len1 = Len(arySrc(i))
			aryLen(i) = len1
		Next
		
		For j = 0 To keyLen
			r1 = GetRandomNum(ul) -1
			r2 = GetRandomNum(aryLen(r1))
			serialCode = serialCode + Mid(arySrc(r1),r2,1)
		Next
		
		GetRandomID = strBase & serialCode
	End Function 

  '===============================================================================
	' 랜덤 숫자를 얻는다. 
	'===============================================================================
	Function GetRandomNum(nRange)
		Randomize
		GetRandomNum = (Int(nRange * Rnd) + 1)
	End Function 

	'=================================================================================
	' Court Number(StadiumNum)기준 DB로 부터 받아오 Data를 Sort하여 배열(AryData)에 저장한다. - 버블Sort
	' key : 기준값 Court Number(StadiumNum) 이 들어 있는 배열 위치   
	'================================================================================= 
	Function Sort2DimAryByKey(ByRef AryData, key, IsDesc)
			Dim nl, ul, nidx, jj, tmp
			Dim val1, val2

			nl = LBOUND(AryData, 2)
			ul = UBOUND(AryData, 2)

			For nidx=nl To ul-1            
					For jj=nl To (ul-nidx)-1    
							val1 = CDbl(AryData(key, jj))
							val2 = CDbl(AryData(key, jj+1))

							If( IsDesc ) Then 
									If ( val1 < val2 ) Then 
											Call SwapRows(AryData, jj, jj+1)
									End If                 
							Else
									If ( val1 > val2 ) Then 
											Call SwapRows(AryData, jj, jj+1)
									End If                 
							End If            
					Next
			Next
	End Function

	Function SortPart2DimAryByKey(ByRef AryData, key, sIdx, eIdx, IsDesc)
			Dim nidx, jj, tmp
			Dim val1, val2
			
			For nidx=sIdx To eIdx          
					For jj=sIdx To (eIdx-1)     
							val1 = CDbl(AryData(key, jj))
							val2 = CDbl(AryData(key, jj+1))

							If( IsDesc ) Then 
									If ( val1 < val2 ) Then 
											Call SwapRows(AryData, jj, jj+1)
									End If                 
							Else
									If ( val1 > val2 ) Then 
											Call SwapRows(AryData, jj, jj+1)
									End If                 
							End If            
					Next
			Next
	End Function

	'=================================================================================
	' Court Number(StadiumNum)기준 DB로 부터 받아오 Data를 Sort하여 배열(AryData)에 저장한다. - 버블Sort
	' key : 기준값 Court Number(StadiumNum) 이 들어 있는 배열 위치   
	'================================================================================= 
	Function Sort2DimAryEx(ByRef AryData, key, dataType, IsDesc)
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
										If ( CompareStr(val1,val2) < 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2)  Then    ' 숫자 - Double
										If ( CompareNum(val1,val2) < 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If                 
								End If 
							Else
								If(dataType = 1) Then      ' Text 
										If ( CompareStr(val1,val2) > 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2)  Then    ' 숫자 - Double 
										If ( CompareNum(val1,val2) > 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If                 
								End If                 
							End If            
					Next
			Next
	End Function

	Function SortPart2DimAryEx(ByRef AryData, key, sIdx, eIdx, dataType, IsDesc)
			Dim nidx, jj, tmp
			Dim val1, val2
			
			For nidx=sIdx To eIdx          
					For jj=sIdx To (eIdx-1)     
							val1 = CDbl(AryData(key, jj))
							val2 = CDbl(AryData(key, jj+1))

							If( IsDesc ) Then 
								If(dataType = 1) Then      ' Text 
										If ( CompareStr(val1,val2) < 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2) Then      ' 숫자 - Double 
										If ( CompareNum(val1,val2) < 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If                 
								End If 
							Else
								If(dataType = 1) Then      ' Text  
										If ( CompareStr(val1,val2) > 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If
								ElseIf(dataType = 2) Then      ' 숫자 - Double  
										If ( CompareNum(val1,val2) > 0 ) Then 
											Call SwapRows(AryData, jj, jj+1)
										End If                 
								End If                 
							End If            
					Next
			Next
	End Function

	Function CompareStr(val1, val2)
		Dim str1, str2

		str1 = CStr(val1)
		str2 = CStr(val2)
		CompareStr = StrComp(str1, str2)
	End Function 

	Function CompareNum(val1, val2)
		Dim num1, num2

		num1 = CDbl(val1)
		num2 = CDbl(val2)
		CompareNum = (num1 - num2)
	End Function 

	'=================================================================================
' 2차원 배열에서 row를 swap하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Sub SwapRows(ary,row1,row2)
	'== This proc swaps two rows of an array
		Dim x,tempvar
		For x = 0 to Ubound(ary,1)
			tempvar = ary(x,row1)   
			ary(x,row1) = ary(x,row2)
			ary(x,row2) = tempvar
		Next
	End Sub  'SwapRows

	'=================================================================================
' 2차원 배열에서 row를 Copy하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Function CopyRows(aryS,aryT, rS, rT)    
		Dim Idx, ub, ub2, ret
		ub = Ubound(aryS,1)
		ub2 = Ubound(aryT,1)
		ret = 0

		If(ub <> ub2) Then 
				CopyRows = ret
				Exit Function 
		End If 

		For Idx = 0 to ub         
				aryT(Idx,rT) = aryS(Idx,rS)
		Next

		ret = 1
		CopyRows = ret
	End Function 
	
'   ===============================================================================     
'     copy partial array  - test 필요
'   =============================================================================== 
	Function CopyPart2DAry(rAryS, rAryT, sp_s, sp_t, cnt)
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
				Call CopyRows(rAryS, rAryT, Idx, Idx2)
				Idx2 = Idx2 + 1
		Next 

	End Function 

'   ===============================================================================     
'     copy partial array  - test 필요
'   =============================================================================== 
	Function CopyPart2DAryEx(rAryS, rAryT, sp_s, sp_t, s_col, cnt)
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
			Call CopyRowsPart(rAryS, rAryT, Idx, Idx2, s_col)
			Idx2 = Idx2 + 1
		Next 

	End Function 

'   ===============================================================================
'      ary를 받아서 key와 같은 데이터를 뽑아서 SubArray로 뽑아서 return 한다. 
'   ===============================================================================
	Function extractAryFromAry(rAry, key, key_pos, s_col)
		Dim Idx, k, ub, ub2, cnt, s_pos, e_pos
		Dim aryInfo

		strLog = sPrintf("key  = {0}, key_pos  = {1}, s_col  = {2}", Array(key, key_pos, s_col))
		' Call TraceLog(SPORTS_LOG1, strLog)

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
						strLog = sPrintf("s_pos  = {0}, e_pos  = {1}, cnt  = {2}", Array(s_pos, e_pos, cnt))
						' Call TraceLog(SPORTS_LOG1, strLog)

						ReDim aryInfo(ub2, cnt) 
						k = 0
						For Idx = s_pos To e_pos
							Call CopyRowsPart(rAry, aryInfo, Idx, k, s_col)
							k = k + 1
						Next
					End If             
				End If 
		End If 

		'Response.End 

		extractAryFromAry = aryInfo 
	End Function 

'   ===============================================================================
'      ary를 받아서 ary로 나눈다. 
'   ===============================================================================
	Function extractAryFromAryEx(rAry, s_col)
		Dim Idx, ub, ub2, cntAry, cntSubAry, s_pos
		Dim aryTmp, aryInfo, aryData

		If(IsArray(rAry)) Then 
			ub = UBound(rAry, 2)
			ub2 = UBound(rAry, 1)
			cntAry = 0

			ReDim aryTmp(2, ub)

			For Idx = 0 To ub 
				If(Idx <> 0) And (rAry(0, Idx) = "1") Then             
					aryTmp(0, cntAry) = rAry(1, Idx)
					aryTmp(1, cntAry) = cntSubAry
					cntAry = cntAry + 1
				End If 
				cntSubAry = rAry(0, Idx)
			Next 

			aryTmp(0, cntAry) = rAry(1, Idx-1)
			aryTmp(1, cntAry) = cntSubAry

			strLog = sprintf("cntAry  = {0}", Array(cntAry))
			' Call TraceLog(SPORTS_LOG1, strLog)

			If(cntAry = 0) Then 
				aryInfo = rAry
			Else          
				ReDim aryInfo(cntAry) 

				s_pos = 0
				For Idx = 0 To cntAry
					If(aryTmp(0, Idx) = "") Then 
						Exit For 
					End If 
					cntSubAry = CDbl(aryTmp(1, Idx))
					ReDim aryData(ub2, cntSubAry-1)   

					Call CopyPart2DAryEx(rAry, aryData, s_pos, 0, s_col, cntSubAry)
					s_pos = s_pos + cntSubAry
					aryInfo(Idx) = aryData
				Next 
			End If 
		End If 

		extractAryFromAryEx = aryInfo 
	End Function 

	'=================================================================================
' 2차원 배열에서 row를 Copy하는 함수 
	' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
'================================================================================= 
	Function CopyRowsPart(aryS,aryT, rS, rT, s_col)    
		Dim Idx, ub, ub2, ret, k
		ub = Ubound(aryS,1)
		ub2 = Ubound(aryT,1)
		ret = 0

		If(ub <> ub2) Then 
			CopyRowsPart = ret
			Exit Function 
		End If 

		k = 0
		For Idx = s_col to ub         
			aryT(k,rT) = aryS(Idx,rS)
			k = k + 1
		Next

		ret = 1
		CopyRowsPart = ret
	End Function 


'=================================================================================
' string을 입력받아 2차원 배열을 만든다. 
	' sep1, sep2를 기준으로 배열값이 만들어진다. 
'================================================================================= 
	Function uxGet2DimAryFromStr(strSrc, sep1, sep2)
		Dim aryTmp, aryRet, aryLine
		Dim ul1, ul2, ai1, ai2

		If(strSrc = "") Then 
			Exit Function 
		End If 

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

		uxGet2DimAryFromStr = aryRet
	End Function

	'=================================================================================
	' 2차원 배열을 입력받아 string을 만든다.  
	' sep1, sep2를 기준으로 배열값이 만들어진다. 
	'================================================================================= 
	Function uxGetStrFrom2DimAry(rAry, sep1, sep2)        
		Dim ub, ub2, Idx, k, strData, strLine
		strData = ""

		If(IsArray(rAry)) Then       
			ub = UBound(rAry, 2)
			ub2 = UBound(rAry, 1)

			For Idx = 0 to ub
				For k = 0 to ub2
					If(k = 0) Then 
						strLine = sprintf("{0}", Array(rAry(k,Idx)))
					Else 
						strLine = sprintf("{0}{1}{2}", Array(strLine, sep2, rAry(k,Idx)))
					End If 
				Next
				If(Idx = 0) Then 
					strData = sprintf("{0}", Array(strLine))
				Else 
					strData = sprintf("{0}{1}{2}", Array(strData, sep1, strLine))
				End If 
			Next
		End If 
		uxGetStrFrom2DimAry = strData
	End Function

	'=================================================================================
'	현재 날짜를 기반으로 File 명 생성 
'=================================================================================    
Function etcGetFileNameWithDate(strName, nType)		
	Dim strPath, curDate, cYear, cMonth, cDay
	If(strName = "") Then strName = "Log" End If 
	If(nType = "") Then nType = "1" End If

	If(nType = "1") Then 
		curDate 	= Date()
		curDate 	= Replace(curDate, "-", "")
		strPath = sprintf("{0}_{1}.txt", Array(curDate, strName))
	End If 
		
	etcGetFileNameWithDate = strPath
End Function

'=================================================================================
'	Directory Path, fileName를 받아서  filePath를 반환한다. 
'=================================================================================    
Function etcMergeFilePath(strDir, strFile)		
	Dim strPath, strTmp, nLen, nPos
	
	strTmp = strDir
	strTmp = Replace(strTmp, "\", "/")
	nLen = Len(strTmp)		
	nPos = InStrRev(strTmp, "/")

	strLog = sprintf("etcMergeFilePath Len = {0}, pos = {1}<br>", Array(nLen, nPos))
	response.write(strLog)

	If(nLen <> nPos) Then 
		strTmp = strTmp & "/"
	End If 

	strPath = sprintf("{0}{1}", Array(strTmp, strFile))	    
	etcMergeFilePath = strPath
End Function

'=================================================================================
'	File Path에서 Directory Path 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => D:\wroot\my1\Node_JS_Test\
'================================================================================= 
Function etcGetDirPath(strPath)		
	Dim strDir, strTmp, nPos
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,"/")
	strDir = Left(strTmp, nPos)

	etcGetDirPath = strDir
End Function

'=================================================================================
'	File Path에서 File Name 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => test.txt
'================================================================================= 
Function etcGetFileName(strPath)		
	Dim strName, nPos, nLen, strTmp
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,"/")
	nLen = Len(strTmp)
	strName = Right(strTmp, nLen-nPos)

	strLog = sprintf("nPos = {0}, nLen = {1}<br>", Array(nPos, nLen))
	response.write(strLog)

	etcGetFileName = strName
End Function

'=================================================================================
'	File Path에서 File 확장자 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => txt
'================================================================================= 
Function etcGetFileExt(strPath)		
	Dim strExt, nPos, nLen, strTmp
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,".")
	nLen = Len(strTmp)
	strExt = Right(strTmp, nLen-nPos)

	strLog = sprintf("nPos = {0}, nLen = {1}<br>", Array(nPos, nLen))
	response.write(strLog)

	etcGetFileExt = strExt
End Function

'=================================================================================
'	Directory 존재 유무 확인 
'=================================================================================
Function etcIsExistDir(strPath)
	Dim objFSO, retVal
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	retVal = objFSO.FolderExists(strPath)

	Set objFSO = Nothing 

	etcIsExistDir = retVal
End Function 

'=================================================================================
'	Directory 생성
'=================================================================================  
Function etcCreateDir(strPath)
	Dim objFSO, dirExist, nPos, strDir
	dirExist = True
	nPos = InStrRev(strPath, ".")

	strDir = strPath 
	' file path면 dir 경로를 구해서 Directory를 만든다. 
	If( nPos <> 0 ) Then 
		strDir = etcGetDirPath(strDir)	
	End If

	Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	dirExist = objFSO.FolderExists(strDir)

	If(dirExist = False) Then 
		objFSO.CreateFolder(strDir)
	End If 
	Set objFSO = Nothing 
End Function 

'=================================================================================
'	File 존재 유무 확인
'=================================================================================  
Function etcIsExistFile(strPath)
	Dim objFSO, retVal
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	retVal = objFSO.FileExists(strPath)

	Set objFSO = Nothing 

	etcIsExistFile = retVal
End Function 

'=================================================================================
'	File 생성
'=================================================================================
Function etcCreateFile(strPath)

End Function 

	'=================================================================================
'	string에서 l, r key 사이의 문자열을 찾아 반환한다. 
'=================================================================================
	'=================================================================================
'	string에서 l, r key 사이의 문자열을 찾아 반환한다. 
'=================================================================================
	Function etcGetBlockData(strSrc, l, r)
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

		etcGetBlockData = strRet 
	End Function

	'=================================================================================
'	reverse 0 to 1 or 1 to 0
'=================================================================================
	Function Reverse0And1(val)
		Dim ret 
		if(val = 0) Then 
			ret = 1
		ElseIf(val = 1) Then 
			ret = 0
		Else 
			ret = val
		End If 
		Reverse0And1 = ret
	End Function 

	'   ===============================================================================     
	'     print - 2차원 배열을 print하는 범용 함수 
	'   ===============================================================================
	Function printInfo(rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo

		If(IsArray(rAryInfo)) Then    
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)
			
			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} -------------------------  <br>", Array(strTitle))
			response.write strLog

			strInfo = ""

			For Idx = 0 To ul 
				strInfo = sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2 
					strInfo = sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
				Next 
				response.write strInfo & "<br>"
			Next

			strLog = sprintf(" ------------------------- {0} -------------------------   <br>", Array(strTitle))
			response.write strLog
		End If 
	End Function 

	'   ===============================================================================     
	'    사용하지 말것  print - 2차원 배열을 print하는 범용 함수 
	'   ===============================================================================
	Function TraceLogInfo(rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo      

		If(IsArray(rAryInfo)) Then    
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)

			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))      
			Call TraceLog(SAMALL_LOG1, strLog)

			strInfo = ""

			For Idx = 0 To ul 
				strInfo = sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2 
					strInfo = sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
				Next 
				Call TraceLog(SAMALL_LOG1, strInfo)
			Next

			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call TraceLog(SAMALL_LOG1, strLog)
		End If 
	End Function 

'   ===============================================================================     
'     print - 2차원 배열을 print하는 범용 함수 
'   ===============================================================================
	Function TraceLog2Dim(logType, rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo      

		If(IsArray(rAryInfo)) Then    
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)

			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))      
			Call TraceLog(logType, strLog)

			strInfo = ""

			For Idx = 0 To ul 
				strInfo = sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2 
					strInfo = sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
				Next 
				Call TraceLog(logType, strInfo)
			Next

			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call TraceLog(logType, strLog)
		End If 
	End Function 

'   ===============================================================================     
'     print - 1차원 배열을 print하는 범용 함수 
'   ===============================================================================
	Function TraceLog1Dim(logType, rAryInfo, sBlock, strTitle)
		Dim Idx, aj , ul, ul2, strInfo      

		If(IsArray(rAryInfo)) Then   
			sBlock = CDbl(sBlock) 
			if(sBlock = "" Or sBlock = "0" Or sBlock = 0) Then sBlock = 5 End If 

			ul = UBound(rAryInfo)

			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))      
			Call TraceLog(logType, strLog)

			strInfo = ""

			For Idx = 0 To ul             
				If(Idx Mod sBlock = 0) Then 
					If(Idx = 0) Then 
						strInfo = sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					Else 
						Call TraceLog(logType, strInfo)
						strInfo = sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))                  
					End If 
				Else 
					strInfo = sprintf("{0}({1} - {2}), ", Array(strInfo, Idx, rAryInfo(Idx)))
				End If 
			Next
			Call TraceLog(logType, strInfo)

			strLog = sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call TraceLog(logType, strLog)
		End If 
	End Function 

	'   ===============================================================================     
'     print - 2차원 배열을 print하는 범용 함수  - Web Display
'   ===============================================================================
	Function webLog2Dim(rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo      

		If(IsArray(rAryInfo)) Then    
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)

			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))      
			Call webLog(strLog)

			strInfo = ""

			For Idx = 0 To ul 
				strInfo = sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2 
					strInfo = sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
				Next 
				strInfo = sprintf("{0}<br>", Array(strInfo))
				Call webLog(strInfo)
			Next

			strLog = sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call webLog(strLog)
		End If 
	End Function 

'   ===============================================================================     
'     print - 1차원 배열을 print하는 범용 함수 - Web Display
'   ===============================================================================
	Function webLog1Dim(rAryInfo, sBlock, strTitle)
		Dim Idx, aj , ul, ul2, strInfo      

		If(IsArray(rAryInfo)) Then   
			sBlock = CDbl(sBlock) 
			if(sBlock = "" Or sBlock = "0" Or sBlock = 0) Then sBlock = 5 End If 

			ul = UBound(rAryInfo)

			If(strTitle = "") Then strTitle = "printInfo" End If 
			strLog = sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))      
			Call webLog(strLog)

			strInfo = ""

			For Idx = 0 To ul             
				If(Idx Mod sBlock = 0) Then 
					If(Idx = 0) Then 
						strInfo = sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					Else 
						strInfo = sprintf("{0}<br>", Array(strInfo))
						Call webLog(strInfo)
						strInfo = sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))                  
					End If 
				Else 
					strInfo = sprintf("{0}({1} - {2}), ", Array(strInfo, Idx, rAryInfo(Idx)))
				End If 
			Next
			strInfo = sprintf("{0}<br>", Array(strInfo))
			Call webLog(strInfo)

			strLog = sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call webLog(strLog)
		End If 
	End Function 

	'   ===============================================================================     
	'     시간 문자열 hh:mm 에 숫자를 더하여 시간 문자열을 반환한다. 
	'   ===============================================================================
	Function etcTimeAdd(strTime, nGap)
		Dim nHour, nMin, aryTime, strTimeSum, nMod, nAddHour
		Dim strHour, strMin 
		nHour = 0
		nMin  = 0
		strTimeSum = " "
		
		if(InStr(strTime, ":") <> 0) Then 
			aryTime = split(strTime, ":")
			nHour = CDbl(aryTime(0))
			nMin = CDbl(aryTime(1))
			nMin = nMin + nGap 

			If(nMin >= 0) Then 
				nMod = nMin Mod 60
				nAddHour = Fix(nMin / 60)
				nHour = nHour + nAddHour
				nMin  = nMod 
			Else 
				nMin = -nMin
				nMod = nMin Mod 60
				nAddHour = Fix(nMin / 60)
				nHour = nHour - (nAddHour + 1)
				nMin = 60 - nMod 
			End If 

			If(nHour > 24) Then nHour = nHour Mod 24 End If 
			If(nHour < 0) Then nHour = nHour + 24 End If 
		End If 

		strTimeSum = sprintf("{0}:{1}", Array(AppendZero2(nHour, 2), AppendZero2(nMin, 2)))
		etcTimeAdd = strTimeSum
	End Function 

	'   ===============================================================================     
	'     http agent info를 가지고 browser info를 얻는다. 
	'   ===============================================================================
	Function etcGetAgentBrowser(strUserAgent)
		Dim strAgentBrowser
		If InStr(strUserAgent,"Edge") > 0 then
		strAgentBrowser = "Edge"
		elseIf InStr(strUserAgent,"rv:11.0") > 0 then
		strAgentBrowser = "IE11"
		elseIf InStr(strUserAgent,"MSIE 10") > 0 then
		strAgentBrowser = "IE10"
		elseIf InStr(strUserAgent,"MSIE 9") > 0 then
		strAgentBrowser = "IE9"
		elseIf InStr(strUserAgent,"MSIE 8") > 0 then
		strAgentBrowser = "IE8"
		elseIf InStr(strUserAgent,"MSIE 7") > 0 then
		strAgentBrowser = "IE7"
		elseIf InStr(strUserAgent,"MSIE 6") > 0 then
		strAgentBrowser = "IE6"
		elseIf InStr(strUserAgent,"Opera") > 0 or InStr(strUserAgent,"OPERA") > 0 or InStr(strUserAgent,"OPR") > 0 then
		strAgentBrowser = "Opera"
		elseIf InStr(strUserAgent,"Firefox") > 0 or InStr(strUserAgent,"FIREFOX") > 0 then
		strAgentBrowser = "Firefox"
		elseIf InStr(strUserAgent,"KAKAOTALK") > 0 then
		strAgentBrowser = "KakaoTalk"
		elseIf InStr(strUserAgent,"NAVER") > 0 then
		strAgentBrowser = "Naver"
		elseIf InStr(strUserAgent,"FBAN") > 0 or InStr(strUserAgent,"FBAV") > 0 or InStr(strUserAgent,"FBBV") > 0 or InStr(strUserAgent,"FBRV") > 0 or InStr(strUserAgent,"FBDV") > 0 or InStr(strUserAgent,"FBMD") > 0 or InStr(strUserAgent,"FBSN") > 0 or InStr(strUserAgent,"FBSV") > 0 or InStr(strUserAgent,"FBSS") > 0 or InStr(strUserAgent,"FBCR") > 0 or InStr(strUserAgent,"FBID") > 0 or InStr(strUserAgent,"FBLC") > 0 or InStr(strUserAgent,"FBOP") > 0 then
		strAgentBrowser = "Facebook"
		elseIf InStr(strUserAgent,"Chrome") > 0 or InStr(strUserAgent,"CriOS") > 0 then
		strAgentBrowser = "Chrome"
		elseIf InStr(strUserAgent,"Android") > 0 or InStr(strUserAgent,"ANDROID") > 0 then
		strAgentBrowser = "Android"
		elseIf InStr(strUserAgent,"Safari") > 0 or InStr(strUserAgent,"SAFARI") > 0 then
		strAgentBrowser = "Safari"
		else
		strAgentBrowser = "Browser ETC"
		end if

		etcGetAgentBrowser = strAgentBrowser
	End Function 

	'   ===============================================================================     
	'     http agent info를 가지고 OS info를 얻는다. 
	'   ===============================================================================
	Function etcGetAgentDevice(strUserAgent)
		Dim strAgentDevice

		If InStr(strUserAgent,"Android") > 0 then
		strAgentDevice = "Android"
		elseIf InStr(strUserAgent,"iPhone") > 0 then
		strAgentDevice = "iPhone"
		elseIf InStr(strUserAgent,"iPad") > 0 then
		strAgentDevice = "iPad"
		elseIf InStr(strUserAgent,"iPod") > 0 then
		strAgentDevice = "iPod"
		elseIf InStr(strUserAgent,"Macintosh") > 0 then
		strAgentDevice = "Macintosh"
		elseIf InStr(strUserAgent,"SymbianOS") > 0 then
		strAgentDevice = "SymbianOS"
		elseIf InStr(strUserAgent,"BlackBerry") > 0 then
		strAgentDevice = "BlackBerry"
		elseIf InStr(strUserAgent,"BB10") > 0 then
		strAgentDevice = "BB10"
		elseIf InStr(strUserAgent,"Nokia") > 0 then
		strAgentDevice = "Nokia"
		elseIf InStr(strUserAgent,"SonyEricsson") > 0 then
		strAgentDevice = "SonyEricsson"
		elseIf InStr(strUserAgent,"webOS") > 0 then
		strAgentDevice = "webOS"
		elseIf InStr(strUserAgent,"PalmOS") > 0 then
		strAgentDevice = "PalmOS"
		elseIf InStr(strUserAgent,"LINUX") > 0 or InStr(strUserAgent,"Linux") > 0 then
		strAgentDevice = "Linux"
		elseIf InStr(strUserAgent,"Windows") > 0 then
		strAgentDevice = "Windows"
		else
		strAgentDevice = "Device ETC"
		end if

		etcGetAgentDevice = strAgentDevice
	End Function 

    
'   ===============================================================================     
'      Int의 음수일 때 정수변환하는 특성을 활용하여 올림함수를 구현하는 방법이다.
'						9.9 음수변환 -> -9.9
'						-9.9 를 Int함수 적용 -> -10
'						-10을 다시 -를 붙여서 10
'   ===============================================================================
	Function Ceil(val)
		Ceil = -(Int(-(val)))
	End Function 
	
'   ===============================================================================     
'      Swap 함수 구현 
'   ===============================================================================
	Function Swap(val1, val2)
		Dim tmp

		tmp = val1
		val1 = val2
		val2 = tmp 
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
							strData = sprintf("""{0}"":""{1}""", Array(key, val))
						Else 
							strData = sprintf("{0},""{1}"":""{2}""", Array(strData, key, val))
						End If 
					Next 

					If(Idx = 0) Then 
							strJson = sprintf("{{0}}", Array(strData))
					Else 
						strJson = sprintf("{0},{{1}}", Array(strJson, strData))
					End If 
				Next

				strJson = sprintf("[{0}]", Array(strJson))
			End If 
		End If 

		utx2DAryToJsonStr = strJson 
	End Function 

'   ===============================================================================     
'      1차원 배열 arrayKey, arrayVal를 입력받아 Json String을 만든다. 
' 		rAryErase[Idx] = 1일 경우 { Or [에 " 를 붙이지 않는다. 
'   ===============================================================================
	Function utxAryToJsonStrEx(rAryErase, rArykey, rAryVal)
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

			If(rAryErase(Idx) = 1) Or ((InStr(val, "[") > 0) And (InStr(val, "]") > 0)) Then 
				If(Idx = 0) Then 
					strData = sprintf(" ""{0}"":{1}", Array(key, val))
				Else 
					strData = sprintf("{0},""{1}"":{2}", Array(strData, key, val))
				End If
			Else 
				If(Idx = 0) Then 
					strData = sprintf(" ""{0}"":""{1}"" ", Array(key, val))
				Else 
					strData = sprintf("{0},""{1}"":""{2}"" ", Array(strData, key, val))
				End If
			End If
		Next 

		strData = sprintf(" { {0} } ", Array(strData))
		utxAryToJsonStrEx = strData
	End Function 


'   ===============================================================================     
'     1차원 arrayKey,  2차원 aryData를 입력받아 Json String을 만든다. 
'     pos_ary 에 있는 Key를 배열명으로 그 이후에 나오는 데이터는 해당 배열의 데이터 들이다. 
'   ===============================================================================
	Function utx2DAryToJsonStrForVList(rAryKey, rAryData, pos_ary)
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

						If(k = pos_ary) Then 
							If(k = 0) Then 
								strData = sprintf(" ""{0}"": [", Array(key))
							Else 
								strData = sprintf("{0},""{1}"": [", Array(strData, key))
							End If 
						ElseIf(k = ub2) Then 
							strData = sprintf("{0} {1}", Array(strData, val))
						ElseIf(k > pos_ary) Then 
							strData = sprintf("{0} {1}, ", Array(strData, val))
						Else  
							If(k = 0) Then 
								strData = sprintf("""{0}"":""{1}""", Array(key, val))
							Else 
								strData = sprintf("{0},""{1}"":""{2}""", Array(strData, key, val))
							End If 
						End If 
					Next 

					If(Idx = 0) Then 
							strJson = sprintf("{{0}]}", Array(strData))
					Else 
						strJson = sprintf("{0},{{1}]}", Array(strJson, strData))
					End If 
				Next

				strJson = sprintf("[{0}]", Array(strJson))
			End If 
		End If 

		utx2DAryToJsonStrForVList = strJson 
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
					strData = sprintf(" ""{0}"":{1}", Array(key, val))
				Else 
					strData = sprintf("{0},""{1}"":{2}", Array(strData, key, val))
				End If
			Else 
				If(Idx = 0) Then 
					strData = sprintf(" ""{0}"":""{1}"" ", Array(key, val))
				Else 
					strData = sprintf("{0},""{1}"":""{2}"" ", Array(strData, key, val))
				End If
			End If
		Next 

		strData = sprintf(" { {0} } ", Array(strData))
		utxAryToJsonStr = strData
	End Function 
   
%>