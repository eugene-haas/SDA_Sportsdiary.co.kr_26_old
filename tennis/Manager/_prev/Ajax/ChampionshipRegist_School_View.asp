<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	ViewCnt = "100"


	strtp =  fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	Search_RGameLevelIDX   = fInject(Request("Search_RGameLevelIDX"))
	Search_GameTitleName   = fInject(Request("Search_GameTitleName"))
	Search_GroupGameGbName = fInject(Request("Search_GroupGameGbName"))
	Search_TeamGbName      = fInject(Request("Search_TeamGbName"))
	Search_SexName         = fInject(Request("Search_SexName"))
	Search_LevelName       = fInject(Request("Search_LevelName"))
	'조회조건 데이터
	Search_GroupGameGb = fInject(Request("Search_GroupGameGb"))

	Search_Team      = fInject(Request("Search_Team"))
	Search_PlayerName  = fInject(Request("Search_PlayerName"))



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
	


	If Search_PlayerName <> "" Then 
		WSQL = WSQL&" AND UserName like  '%"&Search_PlayerName&"%'"
	End If 




		'tblRPlayerMaster
		LSQL = "SELECT "
		LSQL = LSQL&" Top "&ViewCnt
		LSQL = LSQL&" RPlayerMasterIDX AS IDX"
		LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamCodeReturnTeamNm('"&Request.Cookies("SportsGb")&"',Team) AS TeamNm "					
		LSQL = LSQL&" ,Sportsdiary.dbo.FN_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) AS TeamGbNm "			
		LSQL = LSQL&" ,Sex "
		LSQL = LSQL&" ,Sportsdiary.dbo.FN_LevelNm('"&Request.Cookies("SportsGb")&"',TeamGb,Level) AS LevelName "			
		LSQL = LSQL&" ,UserName "
		LSQL = LSQL&" ,Team "		
		LSQL = LSQL&" ,TeamGb"
		LSQL = LSQL&" ,Level"
		LSQL = LSQL&" ,Isnull((select top 1 principal from tblGameRequest  where GameTitleIDX=GameTitleIDX  and GroupGameGb='"&SportsCode&"040002' and PlayerCode=playerIDX  and DelYN='N' order by WriteDate desc ),'') AS principal"
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster"
		LSQL = LSQL&" WHERE DelYN='N'"
		LSQL = LSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
		LSQL = LSQL&" AND Team = '"&Search_Team&"'"
		LSQL = LSQL&WSQL
		If Trim(strkey) <> "" Then 
			LSQL = LSQL&" AND RPlayerMasterIDX < " & strkey
		End If 
			LSQL = LSQL&" ORDER BY IDX DESC "

	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(RPlayerMasterIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblRPlayerMaster "
	CntSQL = CntSQL&" WHERE DelYN='N'"
	CntSQL = CntSQL&" AND RGameLevelIDX='"&Search_RGameLevelIDX&"'"
	CntSQL = CntSQL&" AND Team = '"&Search_Team&"'"
	CntSQL = CntSQL &WSQL


'Response.Write LSQL
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
	Else 
%>
<%
		intCnt = 0

		Do Until LRs.Eof 
%>

<tr>
	<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=LRs("IDX")%></th>
	<td class="left"  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=Search_GameTitleName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=Search_GroupGameGbName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=LRs("TeamGbNm")%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=Search_SexName%></td>
	<td  style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=LRs("TeamNm")%></td>
	<td   style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=LRs("LevelName")%></td>
	<td   style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>')"><%=LRs("UserName")%></td>	
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
