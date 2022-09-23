<%
	If hasown(oJSONoutput, "NM") = "ok" Then  '테이블 명
		NM = chkStrRpl(oJSONoutput.NM,"")
	End If	

	If hasown(oJSONoutput, "ST") = "ok" Then  '이전다음  : 0 첫장 :  1 이전 : 2 다음
		ST = chkInt(oJSONoutput.ST,0)
	Else
		ST = 0
	End If	


	Set db = new clsDBHelper

	'해당 테이블 별 컬럼 추출
		'34 image
		'35 text
		'36 uniqueidentifier
		'48 tinyint
		'52 smallint
		'56 int
		'58 smalldatetime
		'59 real
		'60 money
		'61 datetime
		'62 float
		'98 sql_variant
		'99 ntext
		'104 bit
		'106 decimal
		'108 numeric
		'122 smallmoney
		'127 bigint
		'165 varbinary
		'167 varchar
		'173 binary
		'175 char
		'189 timestamp
		'231 nvarchar
		'231 sysname
		'239 nchar
		'241 xml
	'해당 테이블 별 컬럼 추출
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

	SQL = "Select   b.name, b.user_type_id, c.value  "
	SQL = SQL & " from sysobjects as a INNER JOIN sys.columns  as b ON a.id = b.object_id "
	SQL = SQL & " LEFT JOIN  sys.extended_properties  c  ON c.major_id = b.object_id AND c.minor_id = b.column_id   WHERE a.xtype = 'U' and a.name = '"&NM&"' order by b.column_id asc"
	
	'SQL = "Select   c.name, c.xusertype, o.xtype  from sysobjects as o INNER JOIN syscolumns as c ON o.id = c.id Where o.xtype = 'u' and o.name = '"&NM&"' " 
	'order by syscolumns.name"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	selecttableinfo = Session("TINFO")
	If selecttableinfo <> "" Then
		sinfo = Split(selecttableinfo, "^")
		FN = sinfo(0) '필드명
		PN = sinfo(1) '보여지는 인덱스번호
	End if

	Select Case ST
	Case "0" : dataWhere = " "
	Case "1" : dataWhere = " where " & FN & " < " & PN & "  order by 1 desc"
	Case "2" : dataWhere =  " where " & FN & " > " & PN & "  order by 1 asc"
	End Select



	'ROW_NUMBER()over(order by seq) as rown 로 Null일 경우 처리?
	SQL = "select top 1 * from " & NM & dataWhere
	Set rsData = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rsData.eof then

		i = 0
		For each field in rsData.Fields
			If i = 0 Then
				 FN = field.Name
				 Exit For
			 End if
		next

		'이전다음페이지용 session 생성
		Session("TINFO") = FN & "^" & rsData(0)
	End if


	If rs.eof Then
		jstr = "{""result"":""1""}"
		Response.write jstr
		Set rs = Nothing
		Set db = Nothing
		Response.end
	Else
%>
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<h4 class="modal-title" id="myModalLabel">(<%=NM%>)테이블 컬럼</h4>
		  </div>
		  <div class="modal-body">


    				<div class="table-box basic-table-box">
    					<table cellspacing="0" cellpadding="0">
    						<tr>
    							<th style="width:20%;">column</th><th style="width:10%;">type</th><th>comment</th><th style="width:20%;">data</th>
    						</tr>
    						<tr id="contest">
								<%
								i = 0
								Do Until rs.eof 
									If i = 0 Then
										idxfieldNm = rs(0)
									End if
									fieldtype = fieldTypeToNo(rs(1))

									Response.write "<tr>" 
									Response.write "<td>"& rs(0) &"</td>"
									Response.write "<td>"& fieldtype &"</td>"

									If rs(2) = "" Or Len(rs(2)) >= 1 Then
										MD = 2 'update
									Else 
										MD = 1 'insert
									End if

									Response.write "<td><input type='text' value='" &  rs(2) & "'  onblur=""if(this.value !=''){mx.SendPacket(this,{'CMD':mx.CMD_COLUMNCMT,'NM':'"&NM&"','DN':'"&DN&"','CN':'"&rs(0)&"','CMT':this.value, 'MD':"&MD&"})}"" style=""width:100%;""></td>"

									If Not rsData.EOF Then
									%><td><%=rsData(i)%></td><% 
									End if
									Response.write "</tr>"
								i = i + 1
								rs.movenext
								loop  
								%>
							</tr>
    					</table>
    				</div>

			<!-- E: list-tale -->
		  </div>
		  <div class="modal-footer">
			<a href="#" class="white-btn" data-dismiss="modal">닫기</a>
			<a href='javascript:mx.SendPacket(this,{"CMD":mx.CMD_TABLELIST,"TN":"<%=NM%>","IDXFIELDNM":"<%=idxfieldNm%>"})' class="navy-btn">목록보기</a> 
		  </div>
		</div>
	  </div>

<%
	End If
	
	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>