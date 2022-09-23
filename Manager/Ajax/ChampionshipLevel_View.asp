<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	'strtp = "N"
	'strkey = "194"
	ViewCnt = "50"

	'조회조건 데이터
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))
	Search_TeamGb       = fInject(Request("Search_TeamGb"))


	WSQL = ""

	If Search_GameTitleIDX <> "" Then 
		WSQL = WSQL&" AND GameTitleIDX = '"&Search_GameTitleIDX&"'"
	End If 

	If Search_GroupGameGb <> "" Then 
		WSQL = WSQL&" AND GroupGameGb = '"&Search_GroupGameGb&"'"
	End If 

	If Search_TeamGb <> "" Then 
		WSQL = WSQL&" AND TeamGb = '"&Search_TeamGb&"'"
	End If 
	'Response.Write WSQL&"<br>"
	'Response.End

	LSQL = "SELECT "
  LSQL = LSQL&" Top "&ViewCnt
	LSQL = LSQL&" RGameLevelIDX"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_GameTitleName(GameTitleIDX) AS GameTitleName "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamGbNm('judo',TeamGb) AS TeamGbNm "
	LSQL = LSQL&" ,TeamGb"
	LSQL = LSQL&" ,Sex "
	LSQL = LSQL&" ,Level "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_LevelNm('judo',TeamGb,Level) AS LevelNm "
	LSQL = LSQL&" ,GameType"
	LSQL = LSQL&" ,GameTitleIDX"
	LSQL = LSQL&" ,GroupGameGb "
	LSQL = LSQL&" ,TotRound "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameLevel "
	LSQL = LSQL&" WHERE DelYN='N'"


	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND RGameLevelIDX < " & strkey
	End If 
	LSQL = LSQL&WSQL

	LSQL = LSQL&" ORDER BY RGameLevelIDX DESC "	



	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(RGameLevelIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblRGameLevel "
	CntSQL = CntSQL &" WHERE DelYN='N'"
	CntSQL = CntSQL &WSQL

	'Response.Write LSQL&"<br>"
	'Response.End
	'Response.Write CntSQL
	'Response.End

	Dbopen()
		Set LRs = Dbcon.Execute(LSQL)
		Set CRs = Dbcon.Execute(CntSQL)

	

	'다음조회 데이타는 행을 변경한다
	If Strtp = "N" Then 
	End If 

%>
<%
	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
		Response.End
	Else 
%>
	<%
		intCnt = 0

		Do Until LRs.Eof 
			'참가자 조회
			


			'개인전 참가자 조회 
			If LRs("GroupGameGb") = "sd040001" Then 
				PlayerCntSQL = "SELECT Count(RPlayerMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRPlayerMaster WHERE SportsGb='judo' AND Level='"&LRs("Level")&"' AND GroupGameGb ='sd040001' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND DelYN='N'"
				
				Set PlayerCntRs = Dbcon.Execute(PlayerCntSQL)
				'Response.Write PlayerCntSQL
				'Response.End

				MatchCntSQL = "SELECT Count(RPlayerIDX) AS Cnt FROM SportsDiary.dbo.tblRPlayer WHERE SportsGb='judo' AND Level='"&LRs("Level")&"' AND GroupGameGb ='sd040001' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND DelYN='N'"
				'Response.Write MatchCntSQL
				'Response.End
				Set MatchCntRs = Dbcon.Execute(MatchCntSQL)				

			Else
				'단체전 참가자 학교
				PlayerCntSQL = "SELECT Count(RGameGroupSchoolMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRGameGroupSchoolMaster WHERE SportsGb = 'judo'  AND Sex ='"&LRs("Sex")&"' AND GroupGameGb ='sd040002' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND TeamGb ='"&LRs("TeamGb")&"' AND DelYN='N'"
				'Response.Write LRs("TeamGb")&"<br>"
				'Response.Write PlayerCntSQL
				'Response.End
				Set PlayerCntRs = Dbcon.Execute(PlayerCntSQL)

				MatchCntSQL = "SELECT Count(RGameGroupSchoolIDX) AS Cnt FROM SportsDiary.dbo.tblRGameGroupSchool WHERE SportsGb = 'judo'  AND Sex ='"&LRs("Sex")&"' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND TeamGb ='"&LRs("TeamGb")&"' AND DelYN='N'"
				'Response.Write MatchCntSQL
				'Response.End
				Set MatchCntRs = Dbcon.Execute(MatchCntSQL)

			End If
	%>
	<tr>
		<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("RGameLevelIDX")%></th>
		<td class="left" style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("GameTitleName")%></td>
		<%
			If MatchCntRs("Cnt") > 0 Then 
		%>
		<td><a href="javascript:match_view('<%=LRs("GameTitleIDX")%>','<%=LRs("TeamGb")%>','<%=LRs("Level")%>','<%=LRs("GroupGameGb")%>','<%=LRs("TotRound")%>','<%=MatchCntRs("Cnt")%>','<%=LRs("GameType")%>');" class="btn-list">대진표보기</a></td>
		<%
			Else 
		%>
		<td><a href="javascript:alert('대진표 추첨전인 체급입니다.');" class="btn-list">추첨전</a></td>
		<%
			End If 
		%>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("GroupGameGbName")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("TeamGbNM")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%If LRs("Sex") = "Man" Then %>남자<%Else%>여자<%End If%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("LevelNm")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=LRs("TotRound")%>강</td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>','<%=LRs("Level")%>','<%=LRs("RGameLevelIDX")%>');"><%=PlayerCntRs("Cnt")%></td>
		<td>
			<select onChange="Change_GameType(this.value);">
				<option value="<%=LRs("RGameLevelIDX")%>,sd043002" <%If LRs("GameType") ="sd043002" Then%>selected<%End If%>>토너먼트</option>
				<option value="<%=LRs("RGameLevelIDX")%>,sd043001" <%If LRs("GameType") ="sd043001" Then%>selected<%End If%>>리그</option>
				<option value="<%=LRs("RGameLevelIDX")%>,sd043003" <%If LRs("GameType") ="sd043003" Then%>selected<%End If%>>리그>토너먼트</option>
			</select>
		</td>
		<%
			If LRs("GroupGameGb") = "sd040001" Then 
		%>
		<td><a href="javascript:view_player('<%=LRs("RGameLevelIDX")%>')" class="btn-list">출전선수관리 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
		<%
			Else 
		%>
		<td><a href="javascript:view_player('<%=LRs("RGameLevelIDX")%>')" class="btn-list">출전소속관리 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
		<%
			End If 
		%>
	</tr>
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("RGameLevelIDX")
				PlayerCntRs.Close
				Set PlayerCntRs = Nothing 
			 LRs.MoveNext
			intCnt = intCnt + 1
		Loop 
%>
		ㅹ<%=encode(strsetkey,0)%>ㅹ<%=StrTp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
	End If 
%>
<% LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing

	Dbclose()
%>
