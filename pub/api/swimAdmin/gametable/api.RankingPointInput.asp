
<% 
	idx = oJSONoutput.IDX
	TeamGb = oJSONoutput.TEAMGB
	RankingPoint = oJSONoutput.RANKINGPOINT
	cmdType = oJSONoutput.TYPE
	
	Set db = new clsDBHelper
	strTableName = " sd_TennisRPoint "
	SQL = "Select Top 1 Rankpoint from " & strTableName & " where  teamGB = " & TeamGb & " and PlayerIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write(SQL) 

	If Not rs.EOF And Not rs.BOF Then
    If IsNULL(rs(0)) Then
      number = 0
    else 
      number = 1
      oldPoint = rs(0)
    End If
  else
    number = 0
  End If

	set rs = nothing
	
	if  number = 1 and cmdType = "update"then 
			'LOG
			log_tableName = "sd_TennisRPoint"
			log_fieldName = "rankpoint"
			idxFieldName = "idx"
			WhereQuery = " Where teamGB = " & TeamGb & " and PlayerIDX = " & idx
			newValue = RankingPoint
			operation = "update"	
			adminName ="song"
			Call writeDBLog(log_tableName,log_fieldName,idxFieldName,WhereQuery,newValue,operation,adminName)

			'Update
			SQL = "update " & strTableName & " set rankpoint = " & RankingPoint & " , writeday = getdate() where PlayerIDX = " & idx & " and teamGb = " & TeamGb 
			'response.write(SQL) 
			Call db.execSQLRs(SQL , null, ConStr)

	elseif number = 0 and cmdType ="insert" then
		
			'insert 
			field = " PlayerIDX, rankpoint, teamGb "
		 	SQL = " SET NOCOUNT ON Insert INTO "& strTableName &"  ("& field &") VALUES "
			SQL = SQL & "('" & idx & "'"
			SQL = SQL & ",'" & RankingPoint & "'"
			SQL = SQL & ",'" & TeamGb & "') SELECT @@IDENTITY" 
			'Response.write(SQL)
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			newRPointkey = rs(0)
			'LOG
			log_tableName = "sd_TennisRPoint"
			log_fieldName = "rankpoint"
			log_tableIdx = newRPointkey
			oldValue = oldPoint
			newValue = RankingPoint
			operation = "insert"	
			adminName ="song"
			Call writeDBLogNonQuery(log_tableName, log_fieldName, log_tableIdx, oldValue,  newValue, operation, adminName)

	end if
%>

<% 

	SQL = "select TeamGb, TeamGbNm from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('200', '201', '202') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

	SQL = " Select  idx, PlayerIDX, rankpoint, b.TeamGb, b.TeamGbNm, writeday "
	SQL = SQL & " FROM [SD_Tennis].[dbo].[sd_TennisRPoint] a  "
	SQL = SQL & " Inner Join [SD_Tennis].[dbo].[tblTeamGbInfo] b On a.teamGb = b.TeamGb  WHERE a.PlayerIDX = '"&idx&"' order by a.writeday desc"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS2 = rs.GetRows()
	End if

	rs.Close
	set rs = nothing

	db.Dispose
	Set db = Nothing

	Cnt = 0
	'	strFieldName = " PlayerIDX, UserName, UserPhone,Birthday, Sex,PersonCode,team,teamNm,team2,team2Nm,RankingPoint,userLevel,WriteDate "
	If IsArray(arrRS) Then
			IF IsArray(arrRS2) tHEN
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					TeamGb = arrRS(0, ar)
					TeamGbNm = arrRS(1, ar)
					IsMatCh = 0
						For ar2 = LBound(arrRS2, 2) To UBound(arrRS2, 2) 
							rteamGb = arrRS2(3, ar2) 
							IF TeamGb = rteamGb Then
							ridx =  arrRS2(0, ar2) 
							rrankpoint = arrRS2(2, ar2) 
							rteamGbName =	 arrRS2(4, ar2) 
							rwriteday =	 arrRS2(5, ar2) 
							Cnt = Cnt + 1		
							%>
								<!-- #include virtual = "/pub/html/swimAdmin/RankingPointList.asp" -->
							<%
								IsMatCh = 1
							End IF
						Next

					IF IsMatCh = 0  Then
					Cnt = Cnt + 1
					%>
					<tr class="gametitle<%=Cnt%>">
						<td><%=TeamGbNm%></td> 
						<td><input type="text" id="txtRankingPoint<%=Cnt%>" value="0"></input></td>
						<td>-</td>
						<td> <a class="btn_a" class="btn" href="javascript:mx.input_Ranking(<%=IDX%>,<%=TeamGb%>,<%=Cnt%>);" >입력</a></td>
					</tr>
					<%
					End If
				Next
			else
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					Cnt = Cnt + 1
					TeamGb = arrRS(0, ar)
					TeamGbNm = arrRS(1, ar)
					%>
					<tr class="gametitle<%=Cnt%>">
						<td><%=TeamGbNm%></td> 
						<td><input type="text" id="txtRankingPoint<%=Cnt%>" value="0"></input></td>
						<td>-</td>
						<td> <a class="btn_a" class="btn" href="javascript:mx.input_Ranking(<%=IDX%>,<%=TeamGb%>,<%=Cnt%>);" >입력</a></td>
					</tr>
					<%
				Next
			End if
	End if

%>
