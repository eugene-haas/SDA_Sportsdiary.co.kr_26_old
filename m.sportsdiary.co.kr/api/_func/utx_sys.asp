<% 	
	'=================================================================================
	'  Purpose  : 	utility - system funciton 
	'  Date     : 	2020.08.05
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	

'=================================================================================
'	,로 구분된 strKey, strVal를 입력 받아 배열로 만든후 Sesstion을 쓴다. 
'=================================================================================    
Function session_write(strKey, strVal)		
	Dim Idx, ub, ub2, aryKey, aryVal, err_no
	Dim key, val 

	If(strKey = "") Or (strVal = "") Then err_no = 1 End IF 

	If(err_no <> 1) Then 
		aryKey = Split(strkey, ",")
		aryVal = Split(strVal, ",")

		ub = UBound(aryKey)
		ub2 = UBound(aryVal)		

		If(ub <> ub2) Then err_no = 1 End IF 

		If(err_no <> 1) Then 
			For Idx = 0 To ub 
				key = Trim(aryKey(Idx))
				val = Trim(aryVal(Idx))

				Session(key) = val 
			Next 

			Session.TimeOut = 30
		End If 
	End If 
End Function


'=================================================================================
'	session alive check 
'=================================================================================    
Function session_check()
	If(Session.Contents.Count > 0) Then 
		Session.TimeOut = 30
		session_check = true 
	Else 
		session_check = false
	End If 
End Function 

'=================================================================================
'	get Session data -> json 
'=================================================================================    
Function session_toJson()
	Dim strData

	For Each key In Session.Contents
		If(strData = "") Then 
			strData = sprintf("[{ ""{0}"":""{1}"" ", Array(key, Session(key)))
		Else
			strData = sprintf("{0}, ""{1}"":""{2}"" ", Array(strData, key, Session(key)))
		End If 
	Next 

	strData = sprintf("{0} }] ", Array(strData))
	session_toJson = strData 
End Function 

'=================================================================================
'	get Session data -> 2Dim Array 
'=================================================================================  
Function session_toAry()
	Dim strData, ary 

	For Each key In Session.Contents
		If(strData = "") Then 
			strData = sprintf("{0},{1}", Array(key, Session(key)))
		Else
			strData = sprintf("{0}|{1},{2}", Array(strData, key, Session(key)))
		End If 
	Next 

	ary = utxGet2DimAryFromStr(strData, "|", ",")
	session_toAry = ary 
End Function 

'=================================================================================
'	세션을 삭제한다. 
'=================================================================================  
Function session_abandom()
	Session.Abandon
End Function 

'=================================================================================
'	key를 갖는 세션을 삭제한다. 
'=================================================================================  
Function session_remove(key)
	If(Session.Contents(key) <> "") Then 
		Session.Contents.Remove(key)
	End If 
End Function 
   
'=================================================================================
'	세션 데이터 RemoveAll
'=================================================================================  
Function session_removeAll()
	Session.Contents.RemoveAll()
End Function 
%>