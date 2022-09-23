<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
'Set db = new clsDBHelper

'4개로 나눔  ,   3 대 1
'배열을 4개 만들어서
groupcnt = 32
splitcnt = 4

Function fc_tryoutGroupSplit(groupcnt, splitcnt)
  Dim joarrcnt,no,jono,totalarr,cntno,reversetoggle,startno

  joarrcnt = Fix(groupcnt/splitcnt)
  ReDim totalarr(splitcnt, joarrcnt)

  ReDim cntno(splitcnt)
  For i = 1 To ubound(cntno)
	cntno(i) = 1
  Next

  reversetoggle = 0
  For i = 1 To groupcnt

	If i > 1 And i Mod splitcnt = 1  Then
		If reversetoggle  = 0 then
			reversetoggle  = 1
			startno = CDbl( i + splitcnt -1)
		Else
			reversetoggle  = 0
		End if
	End If

	If reversetoggle  = 0 Then
		jono = i 
	Else
		jono = startno 
		startno = startno - 1
	End if

	If i mod splitcnt = 0 Then
		no =splitcnt
	Else
		no = i mod splitcnt
	End if

	ckarr = cntno(no)
	totalarr(no , ckarr) = jono
	cntno(no) = CDbl(cntno(no)) + 1
  Next

	fc_tryoutGroupSplit = totalarr
End Function
  


joarr = fc_tryoutGroupSplit(32,4)

For i = 1 To ubound(joarr)
	For  n = 1 To Fix(32/4)
	Response.write joarr(i, n) & ","
	Next
	Response.write "<br>"
next




Function fn_tryoutGroupJooNo(ByVal joarrcnt,ByVal splitcnt, ByVal joarr, istart)
  Dim reversetoggle, arrno,i , startno

  ReDim returnarr(joarrcnt * splitcnt)
  reversetoggle = 0
  arrno = 1  
  For i = 1 To joarrcnt * splitcnt
	If i > 1 And i Mod splitcnt = 1  Then
		arrno = arrno + 1
		If reversetoggle  = 0 then
			reversetoggle  = 1
			startno = splitcnt 
		Else
			reversetoggle  = 0
		End if
	End If

	If reversetoggle  = 0 Then
		If i Mod splitcnt = 0 Then
			no = splitcnt
		Else
			no = i Mod splitcnt
		End if
		returnarr(i) = joarr(no , arrno)
	Else
		returnarr(i) = joarr(startno, arrno)
		startno = startno - 1
	End if
  Next
  
  fn_tryoutGroupJooNo = returnarr
End Function


joarrcnt = fix(groupcnt/splitcnt)
farr = fn_tryoutGroupJooNo(joarrcnt, 2, joarr, 2)
  For i = 1 To ubound(farr)
	Response.write farr(i) & ","	
  next



%>