<%
	'최대값제거 최소값 제거 하기..#############
	Function arrayMax(ByRef p_arr, ByVal p_def, ByVal returntype, ByVal chkYNarr)
		Dim result : result = p_def
		Dim i
		Dim ivalue

		If isarray(p_arr) Then
		For i = 0 To ubound(p_arr)
			If chkYNarr(i) = "Y" then
				If result = p_def Then
					 result = p_arr(i)
					 ivalue = i
				End If

				If result < p_arr(i) Then
					 result = p_arr(i)
					 ivalue = i
				End If
			End if
		Next
		End If

		If returntype = "k" then
			arrayMax = ivalue + 1
		Else
			arrayMax = result
		End if
	End Function
 
	Function arrayMin(ByRef p_arr, ByVal p_def, ByVal returntype, ByVal chkYNarr)
		Dim result : result = p_def
		Dim i
		Dim ivalue

		If isarray(p_arr) Then
		For i = 0 To ubound(p_arr)
			If chkYNarr(i) = "Y" then
				If result = p_def Then
					 result = p_arr(i)
					 ivalue = i
				End If

				If result > p_arr(i) Then
					 result =  p_arr(i)
					 ivalue = i
				End If
			End if
		Next
		End If

		If returntype = "k" then
			arrayMin = ivalue + 1
		Else
			arrayMin = result
		End if
	End Function

	'3수중 중간값 찾기
	function median(a, b, c)
		If (a > b) Then
			If (b > c)       then 
			median =  b
			elseif (a > c)  then 
			median = c
			else               
			median =  a
			End if
		Else
			if (a > c)   then   
			median =  a
			elseif (b > c)  then 
			median =  c
			else            
			median =  b
			End if
		End if
	End Function
%>