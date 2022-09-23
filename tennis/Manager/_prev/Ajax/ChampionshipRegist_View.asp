<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	ViewCnt = "50"


	strtp =  fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	Search_RGameLevelIDX   = fInject(Request("Search_RGameLevelIDX"))
	Search_GameTitleName   = fInject(Request("Search_GameTitleName"))
	Search_GroupGameGbName = fInject(Request("Search_GroupGameGbName"))
	Search_TeamGbName      = fInject(Request("Search_TeamGbName"))
	Search_TeamGb          = fInject(Request("Search_TeamGb"))
	Search_SexName         = fInject(Request("Search_SexName"))
	Search_LevelName       = fInject(Request("Search_LevelName"))
	'조회조건 데이터
	Search_GroupGameGb = fInject(Request("Search_GroupGameGb"))	
	Search_SchoolName  = fInject(Request("Search_SchoolName"))
	Search_PlayerName  = fInject(Request("Search_PlayerName"))
	GameTitleIDX       = fInject(Request("GameTitleIDX"))


'	strtp = "F" 'fInject(request("tp"))
'	strkey = "" 'fInject(decode(request("key"),0))
'	Search_GameTitleName   = "토너먼트테스트" 'fInject(Request("Search_GameTitleName"))
'	Search_GroupGameGbName = "개인전" 'fInject(Request("Search_GroupGameGbName"))
'	Search_TeamGbName      = "초등부" 'fInject(Request("Search_TeamGbName"))
'	Search_SexName         = "남자" 'fInject(Request("Search_SexName"))
'	Search_LevelName       = "-36kg" 'fInject(Request("Search_LevelName"))
	'조회조건 데이터
'	Search_GroupGameGb = "sd040001" 'fInject(Request("Search_GroupGameGb"))
'	Search_SchoolName  = fInject(Request("Search_SchoolName"))
'	Search_PlayerName  = fInject(Request("Search_PlayerName"))





	WSQL = ""
	

	If Search_SchoolName <> "" Then 
		WSQL = WSQL&" AND SportsDiary.dbo.FN_TeamNm('"&Request.Cookies("SportsGb")&"','"&Search_TeamGb&"',Team) like  '%"&Search_SchoolName&"%'"
	End If 

	If Search_PlayerName <> "" Then 
		WSQL = WSQL&" AND UserName like  '%"&Search_PlayerName&"%'"
	End If 



	'개인전일때 
	If Search_GroupGameGb = SportsCode&"040001" Then 
		'tblRPlayerMaster
		LSQL = "SELECT "
		LSQL = LSQL&" Top "&ViewCnt
		LSQL = LSQL&" RPlayerMasterIDX AS IDX"
		LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamCodeReturnTeamNm('"&Request.Cookies("SportsGb")&"',Team) AS TeamNm "			
		LSQL = LSQL&" ,Sportsdiary.dbo.FN_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) AS TeamGbNm "			
		LSQL = LSQL&" ,Sex "
		LSQL = LSQL&" ,Sportsdiary.dbo.FN_LevelNm('"&Request.Cookies("SportsGb")&"',TeamGb,Level) AS LevelName "			
		LSQL = LSQL&" ,UserName "
		LSQL = LSQL&" ,SchIDX "		
		LSQL = LSQL&" ,GameTitleIDX "		
		LSQL = LSQL&" ,TeamGb "		
		LSQL = LSQL&" ,Team "
		LSQL = LSQL&" ,TeamDtl"
		LSQL = LSQL&" ,CASE WHEN TeamDtl = '0' THEN '' Else TeamDtl END TeamDtlNM"
		LSQL = LSQL&" ,Level "		
		LSQL = LSQL&" ,PlayerIDX "			
		LSQL = LSQL&" ,Isnull((select top 1 principal from tblGameRequest  where GameTitleIDX='"&GameTitleIDX&"'   and PlayerCode=playerIDX  and DelYN='N' and principal<>'' order by WriteDate desc ),'') AS principal"
		LSQL = LSQL&" ,ISNull(BallNum,'') AS BallNum "
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "

		LSQL = LSQL&" WHERE DelYN='N'"
		LSQL = LSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
		LSQL = LSQL&WSQL
		If Trim(strkey) <> "" Then 
			LSQL = LSQL&" AND RPlayerMasterIDX < " & strkey
		End If 
			LSQL = LSQL&" ORDER BY IDX DESC "
'Response.WRite LSQL
'Response.End
	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(RPlayerMasterIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblRPlayerMaster "
	CntSQL = CntSQL&" WHERE DelYN='N'"
	CntSQL = CntSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
	CntSQL = CntSQL &WSQL


	Else
	'단체전일때
		'tblRGameGroupSchoolMaster
		LSQL = "SELECT "
		LSQL = LSQL&" Top "&ViewCnt
		LSQL = LSQL&" RGameGroupSchoolMasterIDX AS IDX "
		LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamCodeReturnTeamNm('"&Request.Cookies("SportsGb")&"',Team) AS TeamNm "			
		LSQL = LSQL&" ,Sportsdiary.dbo.FN_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) AS TeamGbNm "			
		LSQL = LSQL&" ,Sex "
		LSQL = LSQL&" ,SchIDX "
		LSQL = LSQL&" ,GameTitleIDX "		
		LSQL = LSQL&" ,TeamGb "		
		LSQL = LSQL&" ,Team"
		LSQL = LSQL&" ,TeamDtl"
		LSQL = LSQL&" ,CASE WHEN TeamDtl = '0' THEN '' Else TeamDtl END TeamDtlNM"
		LSQL = LSQL&" ,'' AS BallNum "
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster"
		LSQL = LSQL&" WHERE DelYN='N'"
		LSQL = LSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
		LSQL = LSQL&WSQL
		If Trim(strkey) <> "" Then 
			LSQL = LSQL&" AND RGameGroupSchoolMasterIDX < " & strkey
		End If 
			LSQL = LSQL&" ORDER BY IDX DESC "

'Response.Write LSQL
'Response.End

		CntSQL = "SELECT "
		CntSQL = CntSQL &" Count(RGameGroupSchoolMasterIDX) AS Cnt "
		CntSQL = CntSQL &" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster "
		CntSQL = CntSQL&" WHERE DelYN='N'"
		CntSQL = CntSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
		CntSQL = CntSQL &WSQL
	End If 



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
	Else 
%>
<%
		intCnt = 0

		Do Until LRs.Eof 
%>

<tr>
	<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=LRs("IDX")%></th>
	<td class="left"  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=Search_GameTitleName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=Search_GroupGameGbName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=LRs("TeamGbNm")%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=Search_SexName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=LRs("TeamNm") & LRs("TeamDtlNM")%></td>
	<%
		If Search_GroupGameGb = SportsCode&"040001" Then 
	%>
	
	<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=LRs("LevelName")%></td>
	<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>','<%=Search_GroupGameGb%>')"><%=LRs("UserName")%></td>
		<%
			If LRs("principal") = "" Then 
		%>
		<td></td>
		<%
			Else 
		%>
		<td><a href="javascript:down_data('<%=LRs("principal")%>')" class="btn-list">확인서 </a></td>
		<%
			End If 
		%>
	<%
		Else 
			PlayerCntSQL = "SELECT Count(RplayerMasterIDX) AS Cnt"
			PlayerCntSQL = PlayerCntSQL & " FROM SportsDiary.dbo.tblRPlayerMaster"
			PlayerCntSQL = PlayerCntSQL & " WHERE RGameLevelIDX='"&Search_RGameLevelIDX&"' AND "
			PlayerCntSQL = PlayerCntSQL & "Team='"&LRs("Team")&"' AND TEamDtl = '" & LRs("TeamDtl") & "' AND GroupGameGb='"&SportsCode&"040002' AND DelYN='N'"
			'Response.Write PlayerCntSQL
			'Response.End
			Set PlayerCntRs = Dbcon.Execute(PlayerCntSQL)
			'Response.Write PlayerCntSQL
			'Response.End

	%>
	<td><%=PlayerCntRs("Cnt")%></td>
	<td><a href="javascript:view_player('<%=Search_RGameLevelIDX%>','<%=LRs("Team")%>','<%=LRs("TeamDtl")%>')" class="btn-list">출전선수관리 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
	<%
		End If 
	%>
	<%
		If Search_GroupGameGb = SportsCode&"040001" Then 

			Chk_Medal = "SELECT TitleResult, GameRanking "
			Chk_Medal = Chk_Medal&" FROM tblGameScore "
			Chk_Medal = Chk_Medal&" WHERE DelYN='N' "
			Chk_Medal = Chk_Medal&" AND RgameLevelIDX='"&Search_RGameLevelIDX&"'"
			Chk_Medal = Chk_Medal&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
			Chk_Medal = Chk_Medal&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
			Chk_Medal = Chk_Medal&" AND Sex='"&LRs("Sex")&"'"
			Chk_Medal = Chk_Medal&" AND TeamGb='"&LRs("TeamGb")&"'"
			Chk_Medal = Chk_Medal&" AND Level='"&LRs("Level")&"'"

			Chk_Medal = Chk_Medal&" AND PlayerIDX='"&LRs("PlayerIDX")&"'"
			Chk_Medal = Chk_Medal&" AND GroupGameGb='"&SportsCode&"040001'"
			Chk_Medal = Chk_Medal&" AND Team='"&LRs("Team")&"'"

			Set CRs2 = Dbcon.Execute(Chk_Medal)
			Medal_Code = ""
			If Not(CRs2.Eof Or CRs2.Bof) Then 
				Medal_Code = CRs2("TitleResult") + CRs2("GameRanking")
			Else
				Medal_Code = ""
			End If 
			CRs2.Close
			Set CRs2 = Nothing
		ElseIf Search_GroupGameGb = SportsCode&"040002" Then 
			Chk_Medal = "SELECT TitleResult, GameRanking "
			Chk_Medal = Chk_Medal&" FROM tblGameScore "
			Chk_Medal = Chk_Medal&" WHERE DelYN='N' "
			Chk_Medal = Chk_Medal&" AND RgameLevelIDX='"&Search_RGameLevelIDX&"'"
			Chk_Medal = Chk_Medal&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
			Chk_Medal = Chk_Medal&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
			Chk_Medal = Chk_Medal&" AND Sex='"&LRs("Sex")&"'"
			Chk_Medal = Chk_Medal&" AND TeamGb='"&LRs("TeamGb")&"'"
			Chk_Medal = Chk_Medal&" AND GroupGameGb='"&SportsCode&"040002'"
			Chk_Medal = Chk_Medal&" AND Team='"&LRs("Team")&"'"
'			Response.Write Chk_Medal
'			Response.End
			Set CRs2 = Dbcon.Execute(Chk_Medal)
				Medal_Code = ""
			If Not(CRs2.Eof Or CRs2.Bof) Then 
				Medal_Code = CRs2("TitleResult") + CRs2("GameRanking")
			Else
				Medal_Code = ""
			End If 
			CRs2.Close
			Set CRs2 = Nothing
		End If 
	%>
	<td>
		<select name="medal<%=intCnt%>" id="medal<%=intCnt%>" onChange="change_medal(this.value,'<%=LRs("IDX")%>','<%=Search_GroupGameGb%>');">
			<option value="">==선택==</option>
			<option value="<%=SportsCode%>0340011" <%If SportsCode&"0340011" = Medal_Code Then %> selected <%End If%>>==금메달==</option>
			<option value="<%=SportsCode%>0340022" <%If SportsCode&"0340022" = Medal_Code Then %> selected <%End If%>>==은메달==</option>		
			<option value="<%=SportsCode%>0340033" <%If SportsCode&"0340033" = Medal_Code Then %> selected <%End If%>>==좌동메달==</option>
			<option value="<%=SportsCode%>0340034" <%If SportsCode&"0340034" = Medal_Code Then %> selected <%End If%>>==우동메달==</option>
		</select>
	</td>
	<%
		If SportsCode = "wr" Then 
	%>
	<td><input type="text" name="BallNum<%=intCnt%>" value="<%=LRs("BallNum")%>" onKeyUp="input_ballnum('<%=Search_RGameLevelIDX%>','<%=LRs("PlayerIDX")%>',this.value)"></td>
	<%
		End If 
	%>
</tr>			
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("IDX")
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
