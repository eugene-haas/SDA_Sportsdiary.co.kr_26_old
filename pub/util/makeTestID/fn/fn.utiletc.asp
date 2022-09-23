<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%
    '=================================================================================
	'	Format String ex) strVal = strPrintf("this {0} a tes{1} string containing {2} values", Array("is","t","some"))
	'================================================================================= 
    Function strPrintf(sVal, aArgs)
    Dim i
        For i=0 To UBound(aArgs)
            sVal = Replace(sVal,"{" & CStr(i) & "}",aArgs(i))
        Next
        strPrintf = sVal
    End Function

'   Function StringFormat(sVal, aArgs)
'   Dim i
'       For i=0 To UBound(aArgs)
'           sVal = Replace(sVal,"{" & CStr(i) & "}",aArgs(i))
'       Next
'       StringFormat = sVal
'   End Function    

    '=================================================================================
	'	문자열을 입력받아 한글자씩 잘라서 배열을 만들어 반환한다. ex) ary = GetArrayFromStr("12345")
	'================================================================================= 
    Function getArrayFromStr(strVal)
		Dim slen, ary()
        If (strVal = "") Or (Len(strVal) < 2) Then Exit Function

		slen = Len(strVal)
		ReDim ary(slen)

		For i=1 To slen
            ary(i) = Mid(strVal, i, 1)
        Next

		GetArrayFromStr = ary
	End Function
    
    '=================================================================================
	'	DB Query용 - ,로 구분된 문자열을 입력받아 각 문자마다 ' '를 붙여서 반환한다. 
    '   1,2,3,4 => '1','2','3','4'
	'================================================================================= 
	Function addQuotationInWord(src)	
		Dim strRet, ary
		If (src = "") Or (Len(src) < 2) Then Exit Function

		ary = SPLIT (src, ",")

		strRet = strPrintf( "'{0}'", Array(ary(0)) )
		For i=1 To UBound(ary)
        	strRet = strPrintf( "{0},'{1}'", Array(strRet, ary(i)) )
    	Next

		AddQuotationInWord = strRet
	End Function

    '=================================================================================
	'	Date을 입력받아 날짜, 시, 분, 초로 잘라서 배열을 만들어 반환한다. 
    '   ex) ary = getArrayFromDate("2018-11-29 00:00:00") (0서 부터 시작) 
	'================================================================================= 
    Function getArrayFromDate(src)	
		Dim strDate, ary
		If (src = "") Or (Len(src) < 2) Then Exit Function

    	strDate = REPLACE (src, " ", ",")
		strDate = REPLACE (strDate, ":", ",")
		ary = SPLIT (strDate, ",")

		GetArrayFromDate = ary
	End Function

    '=================================================================================
	'	문자열 2개와 연결 문자열을 입력받아 문자열을 더해서 반환한다.     
    '   두 문자열이 둘다 값이 있을 경우만 strAppend를 중간에 넣고 더해서 반환. 
    '   두 문자열 (src1, src2) 중 하나가 빈값이면 값이 있는 문자열만 반환한다. 
    '   ex)  StrAddStr("1", "", " {0} + {1} ")  => 1
    '   ex)  StrAddStr("", "2", " {0} + {1} ")  => 2
    '   ex)  StrAddStr("1", "2", " {0} + {1} ")  => 1 + 2
	'================================================================================= 
    Function strAddStr(src1, src2, strAppend)	
		Dim strRet 

		If(src2 = "") Then 			
			strRet = src1
		Else
			If (src1 = "") Then 			
				strRet = src2			
			Else
                strRet = strPrintf(strAppend,  Array(src1, src2) ) 
			End If
		End If

		StrAddStr = strRet
	End Function

    '=================================================================================
	'	Sql 구문 - 변수값을 ' ' 로 둘러싼 문자열로 반환한다.
	'================================================================================= 
	Function strSqlVar(strVal)
		strSqlVar = "'" & strVal & "'"
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

	Function AppendZero(strSrc, nLimit)
		Dim str, nLen, strZero, nDiff
		nLen = Len(strSrc)

		if(nLen > nLimit) Then 
			AppendZero = strSrc
			Exit Function
		End If

		strZero = ""
		nDiff = nLimit - nLen
		For i = 1 To nDiff
			strZero = strZero & "0"
		Next

		AppendZero = strZero & strSrc
	End Function

	Function GetRandomNum(nRange)
		Randomize
		GetRandomNum = (Int(nRange * Rnd) + 1)
	End Function 

	Function GetBirthDayForTest(nAge)
		Dim nMonth, nDay, nYear, nCurYear 		
        Randomize

		nCurYear = Year(Now())

		nYear  = nCurYear - (nAge+GetRandomNum(9)) 
	'	nYear  = nCurYear - nAge
    	nMonth = GetRandomNum(12)
		nDay   = GetRandomNum(28)

		nMonth = AppendZero(nMonth, 2)
		nDay = AppendZero(nDay, 2)

        strBirthDay = strPrintf("{0}{1}{2}", Array(nYear,nMonth,nDay))
		GetBirthDayForTest = strBirthDay
	End Function

	Function GetRegDayForTest(nPos)
		Dim nMonth, nDay, nYear, strRegDay 		
        Randomize

		nYear  = 2018
    	nMonth = (nPos Mod 10) + 1		
		nDay   = GetRandomNum(28)

		nMonth 	= AppendZero(nMonth, 2)
		nDay 	= AppendZero(nDay, 2)

        strRegDay = strPrintf("{0}-{1}-{2}", Array(nYear,nMonth,nDay))
		GetRegDayForTest = strRegDay
	End Function

	Function GetAgeForTest(nPos)
		Dim nAge
		If (nPos < 10) Then 
			nAge = 10 
		ElseIf (nPos < 20) Then 
			nAge = 20 
		ElseIf (nPos < 30) Then 
			nAge = 30 
		ElseIf (nPos < 40) Then 
			nAge = 40 
		ElseIf (nPos < 50) Then 
			nAge = 50 
		Else nAge = 60 
		End If

		GetAgeForTest = nAge
	End Function

	Function HasPushFlag(nPos)
		Dim nMod, hasFlag
		nMod = nPos Mod 10

		if(nMod = 1 Or nMod = 5) Then 
			hasFlag = 1
		Else 
			hasFlag = 0
		End If

		HasPushFlag = hasFlag
	End Function 

	Function HasSmsFlag(nPos)
		Dim nMod, hasFlag
		nMod = nPos Mod 10

		if(nMod = 3 Or nMod = 5) Then 
			hasFlag = 1
		Else 
			hasFlag = 0
		End If
		
		HasSmsFlag = hasFlag
	End Function 

%>