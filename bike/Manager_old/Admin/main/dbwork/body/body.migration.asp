<!-- #include virtual="/pub/class/json2.asp" -->
<%

'############################################################
DEC_GameLevelDtlIDX = chkInt(chkReqMethod("GameLevelDtlIDX", "GET"), 1185)
DEC_TeamGameNum = chkInt(chkReqMethod("TeamGameNum", "GET"), 2)
DEC_GameNum = chkInt(chkReqMethod("GameNum", "GET"), 1)


SQL = "select name,dbid from sys.sysdatabases where dbid > 6 order by name"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrDBNM = rs.GetRows()
End if




'디비 선택
target_dbNm = DB_NAME
ConStr = makeConStr( target_dbNm )



'================================================

targetsysidx = "["&target_dbNm&"].[dbo].[sysindexes]"
targetsysobject = "["&target_dbNm&"].[dbo].[sysobjects]"

SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   "&targetsysidx&" i INNER JOIN "&targetsysobject&" o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
 
	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if
%>

<br><br>

<div>
	<!-- 복사대상테이블 (이걸선택하면 필드명을 보여주고 입력 필드를 선택할수 있도록<br>
	복사대상테이블을 그대로 복사한 테이블을 만든후 거기다가 입력시작<br> -->




<table  border="1" style="width:100%;">
<tr>
	<td>
	<textarea id="lastq" style="width:99%;height:100px;"></textarea>
	</td>
	<td style="width:100px;height:40px;"><input type="button" value="실행" style="width:99%;height:100%;"></td>
</tr>
</table>


<table border="1" style="width:100%;">

<tr>
	<td>
		<select id="dbname" onchange="bm.SetTargetDB('tablelist',this.id)">
			<option value="">:DATABASE 선택:</option>
			<%
			  if(IsArray(arrDBNM)) Then
				For ar = LBound(arrDBNM, 2) To UBound(arrDBNM, 2) 
				  dbnm = arrDBNM(0,ar)
				  tabledoc = arrDBNM(1,ar)
					  %><option value="<%=dbnm%>"><%=dbnm%></option><%
				NEXT
			  End IF
			%>
		</select>
		<br>
			

		<span id="tablelist">	
			<select id="tablelist_targetobj" style="width:auto;" onchange="bm.SetTargetTable('targetfield', this.id, '<%=target_dbNm%>' )"> 
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
			</select>
		</span>
	</td>

	<%'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%>

	<td>
		<select id="dbname2" onchange="bm.SetTargetDB('tablelist2', this.id)">
			<option value="">:DATABASE 선택:</option>
			<%
			  if(IsArray(arrDBNM)) Then
				For ar = LBound(arrDBNM, 2) To UBound(arrDBNM, 2) 
				  dbnm = arrDBNM(0,ar)
				  tabledoc = arrDBNM(1,ar)
					  %><option value="<%=dbnm%>"><%=dbnm%></option><%
				NEXT
			  End IF
			%>
		</select>
		<br>
			

		<span id="tablelist2" style="float:left;"></span>


	</td>
</tr>


<tr>
	<td style="width:500px;height:400px;">
		<span id="targetfield"></span>
	</td>

	<td>
		<span id="selectfield" style="float:left;"></span>
		<span id="selectfield2"  style="float:left;"></span>
	</td>
</tr>
</table>



</div>






<!-- <a class="btn" href="javascript:mx.copyTable('selectTabelList')">복사</a>





<a href="javascript:mx.SetKata2017Rank(0)" class="btn_a">선수 부 정리</a>


</div>

<div id="updatelog" style="width:95%;margin:auto;height:300px;overflow-x:hidden;border: 1px solid #73AD21;"></div>


<span id="sheetview"></span>
 -->

<%'<!-- #include virtual="/pub/inc/inc.scoreboard.asp" -->%>
