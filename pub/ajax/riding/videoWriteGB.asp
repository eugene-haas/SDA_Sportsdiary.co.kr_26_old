<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
  Set db = new clsDBHelper
	tidx = request("tidx")
%>
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"
%>
<select  id="Search_GBIDX" name="Search_GBIDX" class="form-control form-control-half" style="width:250pt;">
	<option value="">=종목선택=</option>
	<%
			GSQL = "select gameno,TeamGbNm+' '+levelNm+' '+ridingclass+' '+ridingclasshelp as gbname "
			GSQL = GSQL & " from tblRGameLevel AA inner join tblTeamGbInfo BB on AA.GbIDX = BB.TeamGbIDX  "
			GSQL = GSQL & " where AA.DelYN = 'N' and AA.GameTitleIDX = '"& tidx &"' "
			GSQL = GSQL & " group by gameno,gbidx,TeamGbNm,levelNm,ridingclass,ridingclasshelp"

			Set GRs = db.ExecSQLReturnRS(GSQL , null, ConStr)
			If Not(GRs.Eof Or GRs.Bof) Then
				Do Until GRs.Eof
					%>
					<option value="<%=GRs("gameno")%>"><%=GRs("gbname")%></option>
					<%
					GRs.MoveNext
				Loop
			End If
	%>
</select>
