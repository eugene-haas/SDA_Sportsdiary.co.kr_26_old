
<% 	
	'=================================================================================
	'  Purpose  : asp에서 사용하는 작은 utility function이다. 	
    '  명명법    : utx + 함수명 , utx함수라는 것을 특정하기 위해 사용한다. ex) utxGetArrayFromStr
	'  Date     : 
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 
    '=================================================================================
	'	Format String ex) strVal = strPrintf("this {0} a tes{1} string containing {2} values", Array("is","t","some"))
	'================================================================================= 
    Function sprintf(sVal, aArgs)
    Dim i
        For i=0 To UBound(aArgs)
            sVal = Replace(sVal,"{" & CStr(i) & "}",aArgs(i))
        Next
        sprintf = sVal
    End Function

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
        If (src = "") Or (Len(src) < 1) Then Exit Function
        

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
        If (src = "") Or (Len(src) < 1) Then Exit Function

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
        If (src = "") Or (Len(src) < 1) Then Exit Function

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
    
%>