
<!-- #include virtual = "/pub/api/sms/reqAjaxSms.asp" -->
<%
'#############################################
' 랭크 포인트 조회
'#############################################
	'request
GameYears=""
gametitle=""
teamGb=""
Level=""
userName=""
PaymentType=""

If hasown(oJSONoutput, "GameYears") = "ok" then	
	GameYears = oJSONoutput.GameYears
end if 
if GameYears ="" then 
    GameYears=year(date())
end if  
    
If hasown(oJSONoutput, "gametitle") = "ok" then	
	gametitle = oJSONoutput.gametitle
	If isnull(gametitle) = True Then
	gametitle = ""
	End if
end if 
If hasown(oJSONoutput, "teamGb") = "ok" then	
	teamGb = oJSONoutput.teamGb
end if 
If hasown(oJSONoutput, "Level") = "ok" then	
	Level = oJSONoutput.Level
end if 
If hasown(oJSONoutput, "userName") = "ok" then	
	userName = oJSONoutput.userName
end if  
If hasown(oJSONoutput, "PaymentType") = "ok" then	
	PaymentType = oJSONoutput.PaymentType
end if  
 
Set db = new clsDBHelper
 
  
SQL ="selecT GameYear,GameYear+'년' GameYearNm from sd_TennisTitle where DelYN='N' and ISNULL(GameYear,'')<>'' group by  GameYear  order by GameYear desc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
    YearArr = rs.GetRows()
End if

SQL ="selecT GameTitleIDX,GameTitleName  from sd_TennisTitle  where DelYN='N'  and SportsGb ='tennis' and ViewYN='Y' and ISNULL(GameYear,'')='"&GameYears&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

If Not rs.EOF Then 
    GameArr = rs.GetRows()
End if
    
SQL ="select TeamGb,TeamGbNm from dbo.tblRGameLevel where delyn='N' and SportsGb ='tennis' and GameTitleIDX='"&gametitle&"' group by TeamGb,TeamGbNm order by TeamGb"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
    TeamgbArr = rs.GetRows()
End if
    
SQL ="  select b.Level,b.LevelNm " & _ 
    "   from tblRGameLevel a  " & _ 
    "     inner join tblLevelInfo b on a.SportsGb= b.SportsGb  and a.TeamGb = b.TeamGb and a.Level=b.Level and a.SportsGb='tennis' and a.DelYN='N' and b.DelYN='N'  " & _ 
    "     and a.GameTitleIDX='"&gametitle&"'  " & _ 
    "     and a.TeamGb='"&teamgb&"' " & _ 
    "      order by b.Orderby"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
    levelgbArr = rs.GetRows()
End if

'생성 여부 확인하고 찍어준다.
Call oJSONoutput.Set("result", "0" ) 
     
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
    %>

<table class="navi-tp-table">
	<colgroup>
		<col width="110px">
		<col width="*">
		<col width="110px">
		<col width="*">
		<col width="110px">
		<col width="*">
		<col width="110px">
		<col width="*">
	</colgroup>
	<tbody>  
        <tr>
            <th scope="row"><label for="competition-name">대회년도</label></th>
			<td> 
				<select id="GameYears" onchange="mx_Sms.ControlSearch();">
                    <% 
                        If IsArray(YearArr) Then
		                For ar = LBound(YearArr, 2) To UBound(YearArr, 2) 
                            %> <option value="<%=YearArr(0, ar) %>"<%if GameYears=YearArr(0, ar) then  %> selected<%end if  %>><%=YearArr(1, ar) %></option><%
                        next
                    end if 
                    %>
				</select>
            </td>
			<th scope="row"><label for="competition-name" >대회명</label></th>
			<td> 
				<select id="gametitle"  onchange="mx_Sms.ControlSearch();">
                    <% 
                        If IsArray(GameArr) Then
		                For ar = LBound(GameArr, 2) To UBound(GameArr, 2) 

								
                            %> <option value="<%=GameArr(0, ar) %>" <%if Cstr(gametitle)=Cstr(GameArr(0, ar)) then  %> selected<%end if  %> ><%=GameArr(1, ar) %></option><%
                        next
                    end if 
                    %>
				</select>
            </td>

			<td> 
				<select id="teamgb"   onchange="mx_Sms.ControlSearch();">
					<option value="">== 부 전체 ==</option>
                    <% 
                        If IsArray(TeamgbArr) Then
		                For ar = LBound(TeamgbArr, 2) To UBound(TeamgbArr, 2) 
                            %> <option value="<%=TeamgbArr(0, ar) %>"<%if teamgb=TeamgbArr(0, ar) then  %> selected<%end if  %> ><%=TeamgbArr(1, ar) %></option><%
                        next
                    end if 
                    %>
				</select>
            </td>

			<td> 
				<select id="Level"  onchange="mx_Sms.TableSearch(1);">
					<option value="">== 구분 전체 ==</option>
                    <% 
                        If IsArray(levelgbArr) Then
		                For ar = LBound(levelgbArr, 2) To UBound(levelgbArr, 2) 
                            %> <option value="<%=levelgbArr(0, ar) %>"<%if Cstr(Level)=Cstr(levelgbArr(0, ar)) then  %> selected<%end if  %> ><%=levelgbArr(1, ar) %></option><%
                        next
                    end if 
                    %>
				</select>
            </td>
        </tr>
		<tr> 
			<th scope="row"><label for="competition-name">선수명</label></th>
			<td> 
				<input type="text" id="userName" placeholder="선수명 조회"value="<%=userName %>"  onfocus="this.select();" onkeyup="mx_Sms.TableSearch(1);" > 
            </td>
			<th scope="row"><label for="competition-name">입금여부</label></th>
			<td> 
				<select id="PaymentType"  onchange="mx_Sms.TableSearch(1);">
                    <option value="">== 입금여부 ==</option>
                    <option value="N" <%if PaymentType="N" then  %> selected<%end if  %>>미입금</option>
                    <option value="Y"<%if PaymentType="Y" then  %> selected<%end if  %>>입금</option>
                </select>
            </td>

            <td>
                <div class="btn-list">
		            <a href="javascript:mx_Sms.TableSearch(1);" id="btnsearch" class="btn"  accesskey="i">조회(S)</a> 
	            </div>
            </td>
		</tr>   
	</tbody>
</table>
<%
db.Dispose
Set db = Nothing
%>