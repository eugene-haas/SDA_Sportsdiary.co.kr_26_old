<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'강수
	totcnt = 64
	playercnt = 36

	'부전승 경기수 구함
	If totcnt <> playercnt Then 
		'부전승경기수
		unearnedcnt = totcnt - playercnt

		If unearnedcnt > 1 Then 
			
		Else

		End If 
	End If 

	'한쪽에 나와야하는 플레이어수
	halfcnt = totcnt/2

	'우측시작번호
	RightStartNum = halfcnt + 1


	If halfcnt > 1 Then 
		LeftTrCnt = halfcnt/2
	Else
		LeftTrCnt = 1
	End If 
	

	'Response.Write halfcnt
	
%>
<script>
function aa(obj,obj2){
	if(document.getElementById("sel_playeridx").value!=""){
		obj.value = document.getElementById("sel_playername").value;		
		document.getElementById(obj2).value = document.getElementById("sel_playeridx").value;		
	  document.getElementById("sel_playername").value = "";
	  document.getElementById("sel_playeridx").value = "";
		chk_num()
	}
}

function chk_player(obj,obj2){
	document.getElementById("sel_playername").value = obj;
	document.getElementById("sel_playeridx").value = obj2;
}

//pair_check
function chk_num(){
	var pair_cnt = 0
	for(i=1;i<=64;i++){
		result = i % 2
		if(result == 1){
			x = (i+1)
			if(document.getElementById("data"+i).value!="" && document.getElementById("data"+x).value!=""){
				pair_cnt = pair_cnt + 1
				alert(pair_cnt);
			}

		}
	}
	//32강 2라운드경기번호
}
</script>
<meta charset="utf-8">
<form name="frm" method="post">
<input type="text" name="sel_playeridx" id="sel_playeridx">
<input type="text" name="sel_playername" id="sel_playername">
<table width="1000px" border="1">
	<tr>
		<td valign="top">
			<!--Lefe Player Input Area S-->
			<table width="100%">
				<!--왼쪽 한개조-->
				<%
					PlayerNum = 1
					For i =1 To halfcnt/2
				%>
				<tr>
					<td><%=PlayerNum%>.<input type="text" name="data<%=PlayerNum%>" id="data<%=PlayerNum%>" style="width:150px;" onclick="aa(this,'hidden_data<%=PlayerNum%>');"></td>
					<input type="hidden" name="hidden_data<%=PlayerNum%>" id="hidden_data<%=PlayerNum%>" />
				</tr>
				<%
					PlayerNum = PlayerNum + 1
				%>
				<tr>
					<td><%=PlayerNum%>.<input type="text" name="data<%=PlayerNum%>" id="data<%=PlayerNum%>" style="width:150px;" onclick="aa(this,'hidden_data<%=PlayerNum%>');"></td>
					<input type="hidden" name="hidden_data<%=PlayerNum%>" id="hidden_data<%=PlayerNum%>" />
				</tr>
				<tr>
					<td colspan="2" height="20px"></td>
				</tr>
				<%
						PlayerNum = PlayerNum + 1
					Next
				%>
				<!--왼쪽 한개조-->
				
			</table>
			<!--Lefe Player Input Area E-->
		</td>
		<td width="400px" valign="top">
		<!--Player List S-->
		<%
			gametitleidx = "20"
			LevelCode    = "lv007002"

			PSQL = "select RGameLevelIDX from tblRGameLevel where gametitleidx='"&gametitleidx&"' and level='lv007002'"
			Set PRs = Dbcon.Execute(PSQL)
			If Not(PRs.Eof Or PRs.Bof) Then 
				RGemLevelIDX = PRs("RGameLevelIDX")
			End If 
		%>
		<table  border="1">			
			<tr>
				<td>idx</td>
				<td>선수명</td>
				<td>소속</td>
			</tr>
			<%
				If RGemLevelIDX <> "" Then 
					LSQL = "select PlayerIDX,UserName,SportsDiary.dbo.FN_SchoolName(SchIDX) AS SchName from tblrplayermaster  where gametitleidx='"&gametitleidx&"' and RgameLevelIDX='"&RGemLevelIDX&"' Order By UserName"

					Set LRs = Dbcon.Execute(LSQL)

					If Not (LRs.Eof Or LRs.Bof) Then 
						Do Until LRs.Eof 
			%>
						<tr onclick="chk_player('<%=LRs("UserName")%>','<%=LRs("PlayerIDX")%>')">
							<td><%=LRs("PlayerIDX")%></td>
							<td><%=LRs("UserName")%></td>
							<td><%=LRs("SchName")%></td>
						</tr>
			<%
							LRs.MoveNext
						Loop 
					End If 
				End If 
			%>
		</table>
		<!--Player List E-->
		</td>
		<td valign="top">
		<!--Right Player Input Area S-->
			<table>
				<!--오른쪽 한개조-->
				<%
					For i =1 To halfcnt/2
				%>
				<tr>
					<td><%=PlayerNum%>.<input type="text" name="data<%=PlayerNum%>" id="data<%=PlayerNum%>" style="width:150px;" onclick="aa(this,'hidden_data<%=PlayerNum%>');"></td>
					<input type="hidden" name="hidden_data<%=PlayerNum%>" id="hidden_data<%=PlayerNum%>" />
				</tr>
				<%
					PlayerNum = PlayerNum + 1
				%>
				<tr>
					<td><%=PlayerNum%>.<input type="text" name="data<%=PlayerNum%>" id="data<%=PlayerNum%>" style="width:150px;" onclick="aa(this,'hidden_data<%=PlayerNum%>');"></td>
					<input type="hidden" name="hidden_data<%=PlayerNum%>" id="hidden_data<%=PlayerNum%>" />
				</tr>
				<!--공백-->
				<tr>
					<td colspan="2" height="20px"></td>
				</tr>
				<!--공백-->				
				<%
						PlayerNum = PlayerNum + 1
					Next
				%>
				<!--오른쪽 한개조-->

				<!--오른쪽 한개조-->
			</table>
			<!--Right Player Input Area E-->
		</td>
	</tr>
</table>
</form>