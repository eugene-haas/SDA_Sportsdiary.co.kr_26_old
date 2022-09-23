<%
	'request
	resultidx = oJSONoutput.SCIDX 'resultIDX , courtno
	gidx = oJSONoutput.GIDX
	key3 = oJSONoutput.KEY3
	courtno = oJSONoutput.COURTNO

	Set db = new clsDBHelper
	rttable = " sd_TennisResult "
	bootable = " tblRGameLevel "



	'코트갯수
	SQL = "Select courtcnt from " & bootable & " where GameTitleIDX = " & gidx & " and Level = '"& key3 &"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	courtcnt = rs("courtcnt") '코트수



	'사용 중 (지정된 코트) 종료된경기 제외
	SQL = "Select courtno from " & rttable & " where GameTitleIDX = " & gidx & " and Level = '"& key3 &"' and preresult = 'ING' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End if



	'###########################

	%><select id="T-courtno" onchange="score.setCourtNo()"><%
	For i = 1 To courtcnt
		selectstr = ""
		usestr = ""
		usecolor = ""
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			usecourt = arrRS(0, ar) 
			If i = CDbl(usecourt) And i <> CDbl(courtno)  then
				usestr = "사용"			'사용중
				usecolor = " style='color:orange'"
			End If
			If i = CDbl(courtno) Then
				selectstr = "selected"	'선택된
				usestr = "선택"			'선택중
				usecolor = " style='color:green'"
			End if
		Next
		End If

		%><option value="<%=i%>" <%=selectstr%> <%=usecolor%>><%=i%>번 코트 <%=usestr%></option><%

	Next
    %></select>	<%

db.Dispose
Set db = Nothing
%>