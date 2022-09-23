<%
'######################
'입력대상 테이블 셋팅
'######################

	If hasown(oJSONoutput, "TARGET") = "ok" then
		targetdb = oJSONoutput.TARGET
		ConStr = makeConStr( targetdb )
	Else
		targetdb = DB_NAME
	End if	

	targetobjid = oJSONoutput.TARGETOBJID

	Select Case targetobjid
	Case "tablelist_targetobj"
		targetid = "targetfield"
	Case "tablelist2_targetobj"
		targetobjid2 = "tablelist3_targetobj"
		targetid = "selectfield"
		targetid2 = "selectfield2"
	End Select 

	Set db = new clsDBHelper


	targetsysidx = "["&targetdb&"].[dbo].[sysindexes]"
	targetsysobject = "["&targetdb&"].[dbo].[sysobjects]"

	SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   "&targetsysidx&" i INNER JOIN "&targetsysobject&" o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	 
	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if

	db.Dispose
	Set db = Nothing
	%>


	<select id="<%=targetobjid%>" style="width:auto;" onchange="bm.SetTargetTable('<%=targetid%>', this.id , '<%=targetdb%>')"> 
	<option value="">:입력테이블선택:</option>
	<%
	  if(IsArray(arr)) Then
		For ar = LBound(arr, 2) To UBound(arr, 2) 
		  tablenm = arr(0,ar)
		  tabledoc = arr(1,ar)
			  %><option value="<%=tablenm%>"><%=tablenm%><%If tabledoc <> "" Then%> ( <%=tabledoc%> )<%End if%></option><%
		NEXT
	  End IF
	%>
	</select> as a INNER JOIN 


<%If targetobjid2 <> "" then%>
	<select id="<%=targetobjid2%>" style="width:auto;" onchange="bm.SetTargetTable('<%=targetid2%>', this.id , '<%=targetdb%>')"> 
	<option value="">:조인테이블선택:</option>
	<%
	  if(IsArray(arr)) Then
		For ar = LBound(arr, 2) To UBound(arr, 2) 
		  tablenm = arr(0,ar)
		  tabledoc = arr(1,ar)
			  %><option value="<%=tablenm%>"><%=tablenm%><%If tabledoc <> "" Then%> ( <%=tabledoc%> )<%End if%></option><%
		NEXT
	  End IF
	%>
	</select> as b 
	<br>
	ON <input type="text" id="onquery"  style="width:200px;">  Where <input type="text" id="wherequery"  style="width:200px;">  <input type="button" value="쿼리생성" onclick="bm.makeQuery()">
<%End if%>