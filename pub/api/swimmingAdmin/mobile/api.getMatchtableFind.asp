<%
'#############################################
'검색이름의 참가팀 대진표 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if
'	If hasown(oJSONoutput, "LNO") = "ok" then
'		levelno = fInject(oJSONoutput.LNO)
'	End If
'	If hasown(oJSONoutput, "LIDX") = "ok" then
'		lidx = fInject(oJSONoutput.LIDX)
'	End if	
	If hasown(oJSONoutput, "CDA") = "ok" Then 
		cda = oJSONoutput.CDA
	End if	
	If hasown(oJSONoutput, "PIDX") = "ok" Then 
		pidx = oJSONoutput.PIDX
	End if	



	'참가종목을 구한다. 클릭하면 표시해 준다?
	lidxq = "  (select top 1 RGameLevelidx from tblRgamelevel where delyn='N' and gametitleidx = a.gametitleidx and gbidx = a.gbidx ) as  lidx "
	fld = " a.CDA,a.CDC, a.CDCNM,a.CDB,a.CDBNM, (case when itgubun = 'I' then a.UserName else b.username  end) as unm   ,a.TEAMNM,a.levelno , "&lidxq&" ,tryoutgroupno as joono "
	'SQL = "select "&fld&" from sd_gameMember as a left join sd_gameMember_partner as b on a.gamememberIDX = b.gamememberIDX and a.DelYN = 'N' and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.CDA = '"&cda&"' and (a.playeridx = '"&pidx&"' or b.playeridx = '"&pidx&"')  order by a.CDB"

	SQL = "select "&fld&" from sd_gameMember as a left join sd_gameMember_partner as b on a.gamememberIDX = b.gamememberIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and  (a.playeridx = '"&pidx&"' or b.playeridx = '"&pidx&"') and a.DelYN = 'N'   order by a.CDB"


	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arr = rs.GetRows()
		unm = arr(5,0)
		joono = arr(9,0) '첫번재 조번호 일뿐
	End if	


	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
'################################################


%>
<%
	If IsArray(arr) Then
		For ari = LBound(arr, 2) To UBound(arr, 2)
			a_CDA = arr(0, ari)
			a_CDC = arr(1, ari)
			a_CDB = arr(3,ari)
			a_lidx  = arr(8, ari)
			a_levelno = arr(7, ari)
			a_joono  = arr(9, ari)
			%><%'=SQL%><input type="hidden" id="<%=a_lidx%>_<%=a_levelno%>" value="<%=a_joono%>"><%
		Next 
	End if
%>
<select id="usercdbc"  onchange="mx.getMachTable('<%=tidx%>',$(this).val(),'<%=joono%>','<%=unm%>')">
			<%
				If IsArray(arr) Then
					For ari = LBound(arr, 2) To UBound(arr, 2)
						a_CDA = arr(0, ari)
						a_CDC = arr(1, ari)
						a_CDCNM = arr(2, ari)
						a_CDB = arr(3,ari)
						a_CDBNM = arr(4,ari)
						a_UNM1 = arr(5, ari)
						a_TEAMNM = arr(6, ari)
						a_levelno = arr(7, ari)
						a_lidx  = arr(8, ari)
						%><option value="<%=a_lidx%>_<%=a_levelno%>"  <%If ari = 0 then%>selected<%End if%>><%=a_UNM1%> | <%=a_TEAMNM%>&nbsp;[<%=a_CDBNM%> <%=a_CDCNM%>의 대진표.</option><%
					Next 
				End if
			%>
</select>	

