<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->


<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util2.asp" -->
<!-- #include virtual = "/pub/fn/fn_bike.asp" -->
<!-- #include virtual = "/pub/class/aes.asp" -->
<!-- #include virtual = "/pub/class/sha256.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->
<!-- #include virtual = "/pub/fn/fn.dminclude.asp" -->
<!-- #include virtual = "/pub/cookies/bike.cookies.asp" -->

<!-- #include virtual="/pub/class/json2.asp" -->
	<%
		Set mallobj =  JSON.Parse("{}")
		Call mallobj.Set("M_MIDX", 6806 )
		Call mallobj.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
		Call mallobj.Set("M_SGB", "judo" )
		Call mallobj.Set("M_GIDX", "0") '상품인덱스 0: 없음
		strjson = JSON.stringify(mallobj)
		malljsondata = encode(strjson)
	%>


<%









<%

Set tpoint1 = JSON.Parse("{}")
'객체로 담기 샘플

	If Not rs.EOF Then 
		rsloopcnt = Rs.Fields.Count-1
		ReDim fieldarr(rsloopcnt)
		For i = 0 To rsloopcnt
			  fieldarr(i) = Rs.Fields(i).name
		Next
		arrRS = rs.getrows()
	End If
	Set rs = Nothing

	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			For i=0 To rsloopcnt
				Call tpoint1.Set( fieldarr(i),  arrRS( i ,ar) )
			Next 
	Next
	End if
%>