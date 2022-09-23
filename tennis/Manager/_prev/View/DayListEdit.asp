<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDX = fInject(Request("GameTitleIDX")) '"54" '
	GameDay =  fInject(Request("GameDay")) '"2017-05-27"
	MatCnt  = fInject(Request("MatCnt")) '"2"
	MatNum  = fInject(Request("MatNum")) '"1"
	


	GameTitleIDX = "60"
	If GameDay = "" Then
		GameDay      = "20170811"
	End IF
	MatCnt       = "4"
'Response.Write GameTitleIDX&"<br>"
'Response.Write GameDay&"<br>"
'Response.Write MatCnt&"<br>"
'Response.Write MatNum&"<br>"
'Response.End


	

	'대회순서초기화여부
	ResetYN = fInject(Request("ResetYN"))
	If ResetYN = "" Then
		ResetYN = "N"		
	End If 


	If ResetYN = "Y" Then 
		'RSQL = "Update Sportsdiary.dbo.tblPlayerResult SET TurnNum='' WHERE GameTitleIDX='"&GameTitleIDX&"' AND GameDay='"&GameDay&"'"
		'Dbcon.Execute(RSQL)
	End If 


	If MatNum = "" Then 
		MatNum = "1"
	End If 


%>
<script type="text/javascript">
function chk_Mat(objmat){
	f.submit();
}

function chk_frm(){
	var f = document.frm;
	f.submit();
}

function input_turn(playerreusltidx,turnnum){
	if(turnnum!=""){
		var strAjaxUrl = "/Manager/Ajax/TurnNum_Update.asp";
		$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',			
				data: { 
					PlayerResultIDX : playerreusltidx,
					TurnNum          : turnnum 
				},		
				success: function(retDATA) {

					if(retDATA){
						if(retDATA=="false"){
							alert("순서입력중 문제가 발생하였습니다.");						
						}
					}
				}, error: function(xhr, status, error){						
					if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
						return;
					}	
				}
			});		
	}
		
}

function input_mat(playerreusltidx,matnum){
	//alert(playerreusltidx)
	//alert(matnum)
	var strAjaxUrl = "/Manager/Ajax/MatNum_Update.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				PlayerResultIDX : playerreusltidx,
				MatNum          : matnum 
			},		
			success: function(retDATA) {

				if(retDATA){
					if(retDATA=="false"){
						alert("매트변경중 문제가 발생하였습니다.");						
					}
				}
			}, error: function(xhr, status, error){						
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});		
	

}
</script>
<form name="frm" id="frm" method="post">
<input type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX%>">
<input type="hidden" name="GameDay" id="GameDay" value="<%=GameDay%>">
<input type="hidden" name="MatCnt" id="MatCnt" value="<%=MatCnt%>">
<input type="hidden" name="MatNum" id="MatNum" value="<%=MatNum%>">
</form>


<table>
	<tr>
		
<%
	For x=1 To MatCnt
%>
	<td valign="top">
<%	

	LSQL = "select DT.MatNum AS MatNum "
	LSQL = LSQL&" ,isnull(PR.StadiumNumber,'0') AS StadiumNumber"
	LSQL = LSQL&" ,PR.NowRound AS NowRound"
	LSQL = LSQL&" ,PR.NowRoundNm AS NowRoundNm"
	LSQL = LSQL&" ,DT.TeamGbNM AS TeamGbNM"
	LSQL = LSQL&" ,DT.LevelNm As LevelNm"
	LSQL = LSQL&" ,Convert(int,PR.GameNum) AS GameNum"
	LSQL = LSQL&" ,Convert(int,PR.GroupGameNum) AS GroupGameNum"
	LSQL = LSQL&" ,PR.PlayerResultIDX AS PlayerResultIDX"
	LSQL = LSQL&" ,DT.GameTypeNm AS GameTypeNm"
	LSQL = LSQL&" ,ISNULL(PR.TurnNum,'') AS TurnNum " 
	LSQL = LSQL&" ,PR.RGameLevelIDX AS RGameLevelIDX "
	LSQL = LSQL&" ,ISNULL(Sportsdiary.dbo.Fn_PlayerName(PR.LPlayerIDX),'') As LPlayerNm "
	LSQL = LSQL&" ,ISNULL(Sportsdiary.dbo.Fn_PlayerName(PR.RPlayerIDX),'') As RPlayerNm "
	LSQL = LSQL&" ,ISNULL(Sportsdiary.dbo.Fn_TeamNm2('judo',PR.LTeam),'') As LTeamNm "
	LSQL = LSQL&" ,ISNULL(Sportsdiary.dbo.Fn_TeamNm2('judo',PR.RTeam),'') As RTeamNm "
	LSQL = LSQL&" ,PR.GroupGameGb AS GroupGameGb"
	LSQL = LSQL&" FROM Sportsdiary.dbo.tblDayList_Temp DT Join tblPlayerResult PR "
	LSQL = LSQL&" on DT.GameTitleIDX=PR.GameTitleIDX AND DT.RGameLevelIDX=PR.RGameLevelIDX "
	LSQL = LSQL&" 	AND DT.GameDay = Replace(PR.GameDay,'-','') "
	LSQL = LSQL&" 	WHERE "
	LSQL = LSQL&" 	DT.MatNum='"&x&"'"
	LSQL = LSQL&"   AND PR.DelYN='N'"
	LSQL = LSQL&" 	AND DT.gametitleidx='"&GameTitleIDX&"' and Replace(DT.GameDay,'-','')='"&GameDay&"' "
	'	LSQL = LSQL&" AND PR.NowRoundNM='결승'"
	'	LSQL = LSQL&" 	AND (PR.NowRoundNM<>'결승' AND PR.NowRoundNM<>'준결승') "
	'LSQL = LSQL&" 	AND (PR.Sex = 'WoMan' and ( PR.NowRoundNM='준결승')) "
	'LSQL = LSQL&" 	AND (PR.Sex = 'Man' and (PR.NowRoundNM='결승' or PR.NowRoundNM='준결승') )"
	
	LSQL = LSQL&"   AND (PR.GroupGameGb = 'sd040001' OR (PR.GroupGameGb = 'sd040002' AND (ISNULL(PR.LPlayerIDX,'') = '' AND ISNULL(PR.RPlayerIDX,'') = '' ))) "
	LSQL = LSQL&" AND (ISNULL(PR.RResult,'') <> 'sd019006' AND ISNULL(PR.LResult,'') <> 'sd019006' AND ISNULL(PR.RResult,'') <> 'sd019021' AND ISNULL(PR.LResult,'') <> 'sd019021' AND ISNULL(PR.RResult,'') <> 'sd019022' AND ISNULL(PR.LResult,'') <> 'sd019022' AND ISNULL(PR.RResult,'') <> 'sd019012' AND ISNULL(PR.LResult,'') <> 'sd019012')"
	''LSQL = LSQL&" 	order by MatNum,PR.NowRound desc ,GameCnt DESC,GameNum ASC "
	
	'LSQL = LSQL&" order by PR.Stadiumnumber,PR.TurnNum ASC "
	LSQL = LSQL& " ORDER BY PR.StadiumNumber, PR.TurnNum, PR.Level, CONVERT(int, PR.GameNum)"


	Set LRs = Dbcon.Execute(LSQL)
  If Not(LRs.Eof Or LRs.Bof) Then 
%>
	<table class="table-list" style="border:1px solid red;">
		<tr>
			<!--<td>매트번호</td>-->
			<td>강수</td>
			<td>종별</td>
			<td>체급</td>
			<td>경기번호</td>
			<!--<td>시스템번호</td>-->
			<!--<td>경기형태</td>-->
			<td>좌측선수 VS 우측선수</td>

			<td>순서</td>
			<td>매트</td>
		
		</tr>
		<%
			i = 1
			Do Until LRs.Eof 
				If LRs("GroupGameGb") = "sd040001" Then
					GameNum = LRs("GameNum")
				Else
					GameNum = LRs("GroupGameNum")
				End If 
		%>
		<tr>
			<!--<td><%=LRs("StadiumNumber")%>매트</td>-->
			<td><%=LRs("NowRoundNm")%></td>
			<td><%=LRs("TeamGbNM")%></td>
			<td><%=LRs("LevelNm")%></td>
			<td><%=GameNum%></td>
			<!--<td><%=LRs("PlayerResultIDX")%></td>-->
			<!--<td><%=LRs("GameTypeNm")%></td>-->
			<%

				LPlayerNm = LRs("LPlayerNm")
				LTeamNm   = LRs("LTeamNm")

				If LPlayerNm = "" And LTeamNm = "" Then 

					CSQL = "select count(distinct(NowRound)) AS Cnt FROM tblPlayerResult WHERE GameTitleIDX='"&GametitleIDX&"' AND RGameLevelidx='"&LRs("RGameLevelIDX")&"'"
					Set CntRs = Dbcon.Execute(CSQL)
					
					'Response.Write CSQL
					'Repsonse.End
					LCnt = Clng(CntRs("Cnt")) - Clng(LRs("NowRound"))


					LPlayerSQL = "SELECT Top 1 "

					
						If LCnt = "1" Then 
							LPlayerSQL = LPlayerSQL&" LGame1R AS GameNum "
						ElseIf LCnt = "2" Then 
							LPlayerSQL = LPlayerSQL&" LGame2R AS GameNum "
						ElseIf LCnt = "3" Then 
							LPlayerSQL = LPlayerSQL&" LGame3R AS GameNum "
						ElseIf LCnt = "4" Then 
							LPlayerSQL = LPlayerSQL&" LGame4R AS GameNum "
						ElseIf LCnt = "5" Then 
							LPlayerSQL = LPlayerSQL&" LGame5R AS GameNum "
						ElseIf LCnt = "6" Then 
							LPlayerSQL = LPlayerSQL&" LGame6R AS GameNum "
						ElseIf LCnt = "7" Then 
							LPlayerSQL = LPlayerSQL&" LGame7R AS GameNum "
						Else 
							LPlayerSQL = LPlayerSQL&" LGame1R AS GameNum "
						End If 
					
					LPlayerSQL = LPlayerSQL&" FROM tblPlayerResult "

					LPlayerSQL = LPlayerSQL&" WHERE GameTitleIDX='"&GametitleIDX&"' AND RGameLevelidx='"&LRs("RGameLevelIDX")&"'"

					If LRs("GroupGameGb") = "sd040001" Then 
						LPlayerSQL = LPlayerSQL&" AND (LGame1R = '"&LRs("GameNum")&"' or LGame2R = '"&LRs("GameNum")&"' or LGame3R = '"&LRs("GameNum")&"' or LGame4R = '"&LRs("GameNum")&"' or LGame5R = '"&LRs("GameNum")&"' or LGame6R = '"&LRs("GameNum")&"' or LGame7R = '"&LRs("GameNum")&"' )"					
						LPlayerSQL = LPlayerSQL&" AND (RGame1R = '"&LRs("GameNum")&"' or RGame2R = '"&LRs("GameNum")&"' or RGame3R = '"&LRs("GameNum")&"' or RGame4R = '"&LRs("GameNum")&"' or RGame5R = '"&LRs("GameNum")&"' or RGame6R = '"&LRs("GameNum")&"' or RGame6R = '"&LRs("GameNum")&"' ) "
					Else
						LPlayerSQL = LPlayerSQL&" AND (LGame1R = '"&LRs("GroupGameNum")&"' or LGame2R = '"&LRs("GroupGameNum")&"' or LGame3R = '"&LRs("GroupGameNum")&"' or LGame4R = '"&LRs("GroupGameNum")&"' or LGame5R = '"&LRs("GroupGameNum")&"' or LGame6R = '"&LRs("GroupGameNum")&"' or LGame7R = '"&LRs("GroupGameNum")&"' )"					
						LPlayerSQL = LPlayerSQL&" AND (RGame1R = '"&LRs("GroupGameNum")&"' or RGame2R = '"&LRs("GroupGameNum")&"' or RGame3R = '"&LRs("GroupGameNum")&"' or RGame4R = '"&LRs("GroupGameNum")&"' or RGame5R = '"&LRs("GroupGameNum")&"' or RGame6R = '"&LRs("GroupGameNum")&"' or RGame6R = '"&LRs("GroupGameNum")&"' ) "
					End If 


					LPlayerSQL = LPlayerSQL&" ORDER BY GameNum ASC"
					If LRs("PlayerResultIDX") = "88480" Then 
						'Response.Write LRs("RGameLevelIDX")&LPlayerSQL
						'Response.End
					End If 

					Set LPRS = Dbcon.Execute(LPlayerSQL)
					If Not (LPRS.Eof Or LPRS.Bof) Then 
						LPlayerNm = LPRS("GameNum")&"번승자"
					End If 
				End If 


				RPlayerNm = LRs("RPlayerNm")
				RTeamNm = LRs("RTeamNm")


				If RPlayerNm = "" And RTeamNm  = "" Then 
					CSQL = "select count(distinct(NowRound)) AS Cnt FROM tblPlayerResult WHERE GameTitleIDX='"&GametitleIDX&"' AND RGameLevelidx='"&LRs("RGameLevelIDX")&"'"
					Set CntRs = Dbcon.Execute(CSQL)
					
					'Response.Write CSQL
					'Repsonse.End
					RCnt = CInt(CntRs("Cnt")) - CInt(LRs("NowRound"))


					RPlayerSQL = "SELECT Top 1 "
					If RCnt = "1" Then 
						RPlayerSQL = RPlayerSQL&" LGame1R AS GameNum "
					ElseIf LCnt = "2" Then 
						RPlayerSQL = RPlayerSQL&" LGame2R AS GameNum "
					ElseIf RCnt = "3" Then 
						RPlayerSQL = RPlayerSQL&" LGame3R AS GameNum "
					ElseIf RCnt = "4" Then 
						RPlayerSQL = RPlayerSQL&" LGame4R AS GameNum "
					ElseIf RCnt = "5" Then 
						RPlayerSQL = RPlayerSQL&" LGame5R AS GameNum "
					ElseIf RCnt = "6" Then 
						RPlayerSQL = RPlayerSQL&" LGame6R AS GameNum "
					ElseIf RCnt = "7" Then 
						RPlayerSQL = RPlayerSQL&" LGame7R AS GameNum "
					Else 
						RPlayerSQL = RPlayerSQL&" LGame1R AS GameNum "
					End If 

					RPlayerSQL = RPlayerSQL&" FROM tblPlayerResult "
					
					RPlayerSQL = RPlayerSQL&" WHERE GameTitleIDX='"&GametitleIDX&"' AND RGameLevelidx='"&LRs("RGameLevelIDX")&"'"
					 

				

					If LRs("GroupGameGb") = "sd040001" Then  
						RPlayerSQL = RPlayerSQL&" AND (LGame1R = '"&LRs("GameNum")&"' or LGame2R = '"&LRs("GameNum")&"' or LGame3R = '"&LRs("GameNum")&"' or LGame4R = '"&LRs("GameNum")&"' or LGame5R = '"&LRs("GameNum")&"' or LGame6R = '"&LRs("GameNum")&"' or LGame7R = '"&LRs("GameNum")&"' )"					
						RPlayerSQL = RPlayerSQL&" AND (RGame1R = '"&LRs("GameNum")&"' or RGame2R = '"&LRs("GameNum")&"' or RGame3R = '"&LRs("GameNum")&"' or RGame4R = '"&LRs("GameNum")&"' or RGame5R = '"&LRs("GameNum")&"' or RGame6R = '"&LRs("GameNum")&"' or RGame6R = '"&LRs("GameNum")&"' ) "
					Else
						RPlayerSQL = RPlayerSQL&" AND (LGame1R = '"&LRs("GroupGameNum")&"' or LGame2R = '"&LRs("GroupGameNum")&"' or LGame3R = '"&LRs("GroupGameNum")&"' or LGame4R = '"&LRs("GroupGameNum")&"' or LGame5R = '"&LRs("GroupGameNum")&"' or LGame6R = '"&LRs("GroupGameNum")&"' or LGame7R = '"&LRs("GroupGameNum")&"' )"					
						RPlayerSQL = RPlayerSQL&" AND (RGame1R = '"&LRs("GroupGameNum")&"' or RGame2R = '"&LRs("GroupGameNum")&"' or RGame3R = '"&LRs("GroupGameNum")&"' or RGame4R = '"&LRs("GroupGameNum")&"' or RGame5R = '"&LRs("GroupGameNum")&"' or RGame6R = '"&LRs("GroupGameNum")&"' or RGame6R = '"&LRs("GroupGameNum")&"' ) "
					End If 
					RPlayerSQL = RPlayerSQL&" ORDER BY GameNum DESC"	
					'Response.Write LPlayerSQL
					'Response.End
					If LRs("PlayerResultIDX") = "88480" Then 
						'Response.Write LRs("RGameLevelIDX")&RPlayerSQL
						'Response.End
					End If 

					Set RPRS = Dbcon.Execute(RPlayerSQL)
					If Not (RPRS.Eof Or RPRS.Bof) Then 
						RPlayerNm = RPRS("GameNum")&"번승자"
					End If 
				End If 
			%>
			<%If LRs("GroupGameGb") = "sd040001" Then  %>
			<td><%=LPlayerNm%> VS <font color="blue"><%=RPlayerNm%></font></td>
			<%else%>
			<td><%=LTeamNm%> VS <font color="blue"><%=RTeamNm%></font></td>
			<%End If %>
			<%
				If LRs("TurnNum") = "0" Then 
					TurnNum = ""
				Else
					TurnNum = LRs("TurnNum")
				End If 

				UpSQL = "Update Sportsdiary.dbo.tblPlayerResult Set StadiumNumber='"&LRs("MatNum")&"' WHERE PlayerResultIDX='"&LRs("PlayerResultIDX")&"'"
				'Dbcon.Execute(UpSQL)
			%>

			<td><input type="text" name="TurnNum<%=i%>" id="TurnNum<%=i%>" value="<%=TurnNum%>" onKeyUp="input_turn('<%=LRs("PlayerResultIDX")%>',this.value)" style="width:60px"></td>
			
			<td>

			<select name="sel_mat<%=i%>" id="sel_mat<%=i%>" onChange="input_mat('<%=LRs("PlayerResultIDX")%>',this.value)">
				<option value="">=매트=</option>
				<%
					For k=1 To MatCnt
				%>
				<option value="<%=k%>" <%If CStr(k) = CStr(LRs("StadiumNumber")) Then%>selected<%End If%>><%=k%>매트</option>
				<%
					Next					
				%>
			</select>
			
			</td>

		</tr>
		<%	
				LPlayerNm = ""
				RPlayerNm = ""
				i = i + 1
				LRs.MoveNext
			Loop 
		%>
	</table>
<%
	End If 
%>
	</td>
<%
	Next	
%>
<table>
	<tr>
		<td colspan="5" align="center"><input type="button" value="적용" onclick="chk_frm();"></td>
	</tr>
</table>