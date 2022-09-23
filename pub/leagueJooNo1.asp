<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
'Set db = new clsDBHelper

'4개로 나눔  ,   3 대 1
'배열을 4개 만들어서
groupcnt = 32
jooDivision = 4
jooArea = 3

Isfulljoarr = true	
joarrcnt = Fix(groupcnt/jooDivision)
joarrcntMod = (groupcnt Mod jooDivision)

if joarrcntMod > 0 Then
	joarrcnt = joarrcnt + 1
	Isfulljoarr = false
End IF

maxgroupCnt = jooDivision * joarrcnt

Function fc_tryoutGroupSplit(groupcnt, jooDivision)
  Dim no,jono,totalarr,cntno,reversetoggle,startno
	'Response.write "최대 행 : "  & jooDivision & "<br>"
	'Response.write "최대 열 : "  & joarrcnt & "<br>"
  ReDim totalarr(jooDivision, joarrcnt)
  ReDim cntno(jooDivision)

	Response.write "(행, 열) : " & "(" & jooDivision & "," & joarrcnt  & ")"  & "<br>"
  For i = 1 To ubound(cntno)
		cntno(i) = 1
  Next

  reversetoggle = 0
	j = 1

  For i = 1 To groupcnt
		If i > 1 And (i Mod jooDivision) = 1  Then
			j = j + 1
			If reversetoggle  = 0 then
				reversetoggle  = 1
				startno = CDbl( i + jooDivision -1)
			Else
				reversetoggle  = 0
			End if
		End If

		If reversetoggle  = 0 Then
			jono = i 
		Else
			'Response.write "j : " & j <> jooDivision  & "<br>"
			jono = startno 
			'jono = startno 
			startno = startno - 1
		End if

		If (i mod jooDivision) = 0 Then
			no = jooDivision
			'Response.write "no" & no & "<br>" 
		Else
			no = i mod jooDivision
			'Response.write "no :" & no & "<br>"
		End if
		
		'Response.write "no" & no & "<br>" 
		'Response.write "no" & i mod jooDivision & "<br>" 

		ckarr = cntno(no)
		totalarr(no , ckarr) = jono
		'Response.write "(no,charr): " & "(" & no & "," & ckarr & ")"  & "<br>"
		cntno(no) = CDbl(cntno(no)) + 1
  Next

	fc_tryoutGroupSplit = totalarr
End Function

Response.Write "조 : " & groupcnt & "<br>"
Response.Write "나눈 조 : " & jooDivision & "<br>"
Response.Write "영역  : " & jooArea & "<br>" & "<br>"

joarr = fc_tryoutGroupSplit(maxgroupCnt,jooDivision)

For i = 1 To ubound(joarr)
	For  n = 1 To joarrcnt
		Response.write joarr(i, n) & ","
	Next
	Response.write "<br>"
next

'시작 위치
StartPosition = 1
RowIndex = ubound(joarr,1)
ColumnIndex = ubound(joarr,2)
TotalData =  RowIndex * ColumnIndex

Response.Write "<br>"
Response.Write "배열 행  : " &  RowIndex & "<br>"
Response.Write "배열 열  : " &  ColumnIndex & "<br>" & "<br>"

Redim ResultList(TotalData)

For i = 1 To jooDivision
	if(i mod jooArea) = 0 then
		Response.write "jooArea : " & i  & "<br>"
		EndPosition = i
		reversetoggle = 0
		Response.write "StartPosition : " & StartPosition  & "<br>"
		Response.write "EndPosition : " & EndPosition & "<br>"

		For columnI = 1 To ColumnIndex
					If Cdbl(columnI) > 1 Then
					IF(reversetoggle = 0) Then
						reversetoggle = 1
						startNo = EndPosition
					ElseIF(reversetoggle = 1) Then
						reversetoggle = 0
					End IF
				End If

			For j = StartPosition To EndPosition

				'Response.write "j : " &  j & "<br>"
				'Response.write "j의 EndPosition 나머지 구하기 : " & (j Mod EndPosition) & "<br>"

	

				if(reversetoggle = 1) Then
					'Response.write "startNo : " & startNo & "<br>"
					'Response.write "(j, columnI) : " & "(" & startNo & "," & columnI  & ")"  & "<br>"
					Data = joarr(startno,columnI)
					if( Data <> "" and Data <= groupcnt) Then
						Response.write Data & "<bR>"
					ENd IF
					startNo	 = startNo - 1
				Else
					'Response.write "(j, columnI) : " & "(" & j & "," & columnI  & ")"  & "<br>"
					'Response.write joarr(j,columnI) & "<bR>"
					Data = joarr(j,columnI)
					if( Data <> "" and Data <= groupcnt) Then
						Response.write Data & "<bR>"
					ENd IF
				End IF
				'Response.write "reversetoggle : " & reversetoggle & "<br>"
			Next
		Next

		StartPosition = EndPosition + 1
	End If
Next

'Response.Write "여기?"
' 나뉘어 떨어지지 않은 나머지 
If (jooDivision mod jooArea) <> 0 Then

		StartPosition = EndPosition + 1  
		EndPosition = jooDivision

		reversetoggle = 0
		For columnI = 1 To ColumnIndex

		
					If Cdbl(columnI) > 1 Then
					IF(reversetoggle = 0) Then
						reversetoggle = 1
						startNo = EndPosition
					ElseIF(reversetoggle = 1) Then
						reversetoggle = 0
					End IF
				End If

			For j = StartPosition To EndPosition
			
	

				if(reversetoggle = 1) Then
					Response.write joarr(startno,columnI) & "<bR>"
					startNo	 = startNo - 1
				Else
					Response.write joarr(j,columnI) & "<bR>"
				End IF

			Next
		Next

End if


%>