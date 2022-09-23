

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
	' string을 입력받아 2차원 배열을 만든다. 
    ' sep1, sep2를 기준으로 배열값이 만들어진다. 
	'================================================================================= 
    Function uxGet2DimAryFromStr(strSrc, sep1, sep2)
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

        uxGet2DimAryFromStr = aryRet
    End Function
%>