<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "SEXNO") = "ok" Then
		sexno = oJSONoutput.SEXNO
	End if


	Set db = new clsDBHelper

	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '"&sexno&"'"
	Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)


	'Call rsdrow(rss)
	If Not rsb.EOF Then
	arrRSB = rsb.GetRows()
	End If


	db.Dispose
	Set db = Nothing

%>
<select id="mk_g3" class="form-control">
<%
	If IsArray(arrRSB) Then 
		For ari = LBound(arrRSB, 2) To UBound(arrRSB, 2)
			l_CDB = arrRSB(0, ari)
			l_CDBNM = arrRSB(1,ari)
			%><option value="<%=l_CDB%>" ><%=l_CDBNM%></option><%
		Next
	End if
%>
</select>