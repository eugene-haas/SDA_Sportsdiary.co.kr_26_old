<%
'######################
'입력대상 테이블 셋팅
'######################

'function ##########
	Function fieldTypeToNo(ByVal typeno)
		Dim ftype

		Select Case  typeno
			case "34"	: ftype = "image"
			case "35"	: ftype = "text"
			case "36"	: ftype = "uniqueidentifier"
			case "48"	: ftype = "tinyint"
			case "52"	: ftype = "smallint"
			case "56"	: ftype = "int"
			case "58"	: ftype = "smalldatetime"
			case "59"	: ftype = "real"
			case "60"	: ftype = "money"
			case "61"	: ftype = "datetime"
			case "62"	: ftype = "float"
			case "98"	: ftype = "sql_variant"
			case "99"	: ftype = "ntext"
			case "104" : ftype = "bit"
			case "106"	: ftype = "decimal"
			case "108"	: ftype = "numeric"
			case "122"	: ftype = "smallmoney"
			case "127"	: ftype = "bigint"
			case "165"	: ftype = "varbinary"
			case "167"	: ftype = "varchar"
			case "173"	: ftype = "binary"
			case "175"	: ftype = "char"
			case "189"	: ftype = "timestamp"
			case "231"	: ftype = "nvarchar"
			case "231"	: ftype = "sysname"
			case "239"	: ftype = "nchar"
			case "241"	: ftype = "xml"
		End Select 

		fieldTypeToNo =  ftype
	End function


	Sub rsDrowTable(ByVal rs, ByVal fvalue)
		Dim i , n ,fname
		For i = 0 To Rs.Fields.Count - 1
			'response.write  Rs.Fields(i).name &","
		Next
		
		response.write "<table class='table-list' border='1'>"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		n = 0
		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
							fname = Rs.Fields(0).value
							Select Case  Rs.Fields(i).name 
							Case "타입"
								Response.write "<td>" & fieldTypeToNo(rsdata(i))   & "</td>"
							Case "값"
								Response.write "<td>" & fvalue(n)  & "</td>"
							Case else
								Response.write "<td>" & rsdata(i)   & "</td>"
							End select
							
						Next
					%>
				</tr>
			<%
		n = n + 1
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
	End Sub
'function ##########


	If hasown(oJSONoutput, "TARGETDBNM") = "ok" then
		targetdbnm = oJSONoutput.TARGETDBNM
		ConStr = makeConStr( targetdbnm )
	Else
		targetdbnm = DB_NAME	
	End if	

	If hasown(oJSONoutput, "TARGET") = "ok" then
		targettable = oJSONoutput.TARGET
	End if	

	targetobjid = oJSONoutput.TARGETOBJID

	Select Case targetobjid
	Case "targetfield_targetobj"
		inputid = "target"
	Case "selectfield_targetobj"
		inputid = "select"
	Case "selectfield2_targetobj"
		inputid = "select2"
	End Select 
	'@@@@@@@@@@@@@@@@@@@@@

	Set db = new clsDBHelper



	SQL  = "Select top 1 * from " & targettable 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.EOF Then 
		rsloopcnt = Rs.Fields.Count-1
		ReDim field_arr(rsloopcnt)
		ReDim value_arr(rsloopcnt)

		For i = 0 To rsloopcnt
			  field_arr(i) = Rs.Fields(i).name
			  value_arr(i) = Rs.Fields(i).value
		Next
	
		arrRS = rs.getrows()
	Else
		Response.END
	End If
'###
	'	Set target_f = JSON.Parse("{}")
	'	If IsArray(arrRS) Then
	'	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
	'			For i=0 To rsloopcnt
	'				Call target_f.Set( field_arr(i),  arrRS( i ,ar) )
	'			Next 
	'	Next
	'	End if
'###

	'Set rs = Nothing
	targetsysobject = "["&targetdbnm&"].[dbo].[sysobjects]"
	'##
	SQL = "Select   b.name as 필드, b.user_type_id as 타입, c.value as 주석  , ''  as 값 "
	SQL = SQL & " , '<input type=""button"" value=""선택"" onclick=""bm.SetTargetField('''+CAST(b.name AS varchar(30))+''',''"&inputid&"'')"" id="""&inputid&"_'+CAST(b.name AS varchar(30))+'"">' as 선택 "
	SQL = SQL & " from "&targetsysobject&" as a INNER JOIN sys.columns  as b ON a.id = b.object_id "
	SQL = SQL & " LEFT JOIN  sys.extended_properties  c  ON c.major_id = b.object_id AND c.minor_id = b.column_id   WHERE a.xtype = 'U' and a.name = '"&targettable&"' order by b.column_id asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Call rsdrowtable(rs, value_arr)
%>

<br>
<%If targetobjid  <> "selectfield2_targetobj"  then%>
<input type="text" id="<%=inputid%>_field" value="" style="width:150px;">
<%End if%>
<%
	Call rsdrowtable(rs, value_arr)


	db.Dispose
	Set db = Nothing
%>