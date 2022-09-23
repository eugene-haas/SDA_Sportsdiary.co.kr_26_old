<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(request("key"))
'	strkey = fInject(request("key"))

	'strtp = "N"
	'strkey = "194"
	ViewCnt = "20"

	'조회조건 데이터
	Search_SportsGb   = fInject(Request("Search_SportsGb"))
	Search_Area       = fInject(Request("Search_Area"))
	Search_Sex        = fInject(Request("Search_Sex"))
	Search_TeamGb     = fInject(Request("Search_TeamGb"))
	Search_SchoolName = fInject(Request("Search_SchoolName"))
	Search_UserName   = fInject(Request("Search_UserName"))


	'정렬조건 데이터=======================================================================================================================
	order_Sports     = fInject(Request("order_Sports"))
	order_TeamGb     = fInject(Request("order_TeamGb"))
	order_Area       = fInject(Request("order_Area"))
	order_SchoolName = fInject(Request("order_SchoolName"))
	order_Sex        = fInject(Request("order_Sex"))
	order_PlayerName = fInject(Request("order_PlayerName"))
	order_PlayerIDX  = fInject(Request("order_PlayerIDX"))

	
	SearchFieldSQL = " Sportsdiary.dbo.FN_PubName(P.SportsGb)+Sportsdiary.dbo.FN_PubName(SL.TeamGb)+Sportsdiary.dbo.FN_PubName(SL.Sido)"
	SearchFieldSQL = SearchFieldSQL&"+SL.SchoolName+P.Sex+P.UserName+convert(varchar(50),P.PlayerIDX) AS NextKey "

	WhereFieldSQL = " Sportsdiary.dbo.FN_PubName(P.SportsGb)+Sportsdiary.dbo.FN_PubName(SL.TeamGb)+Sportsdiary.dbo.FN_PubName(SL.Sido)"
	WhereFieldSQL = WhereFieldSQL&"+SL.SchoolName+P.Sex+P.UserName+convert(varchar(50),P.PlayerIDX) "


	OrderSQL = " ORDER BY "
	OrderSQL = OrderSQL&" P.PlayerIDX "&order_PlayerIDX&","
	OrderSQL = OrderSQL&"P.UserName "&order_PlayerName&","
	OrderSQL = OrderSQL&" Sportsdiary.dbo.FN_PubName(P.SportsGb) "&order_Sports&","
	OrderSQL = OrderSQL&"Sportsdiary.dbo.FN_PubName(SL.TeamGb) "&order_TeamGb&","
	OrderSQL = OrderSQL&"Sportsdiary.dbo.FN_PubName(SL.Sido) "&order_Area&","
	OrderSQL = OrderSQL&"SL.SchoolName "&order_SchoolName&","
	OrderSQL = OrderSQL&"P.Sex "&order_Sex


	'정렬조건 데이터=======================================================================================================================
	WSQL = ""

	If Search_SportsGb <> "" Then 
		WSQL = WSQL&" AND P.SportsGb = '"&Search_SportsGb&"'"
	End If 

	If Search_Area <> "" Then 
		WSQL = WSQL&" AND SL.Sido = '"&Search_Area&"'"
	End If 

	If Search_Sex <> "" Then 
		WSQL = WSQL&" AND P.Sex = '"&Search_Sex&"'"
	End If 

	If Search_TeamGb <> "" Then 
		WSQL = WSQL&" AND SL.TeamGb = '"&Search_TeamGb&"'"
	End If 

	If Search_SchoolName <> "" Then 
		WSQL = WSQL&" AND SL.SchoolName Like '"&Search_SchoolName&"%'"
	End If 

	If Search_UserName <> "" Then 
		WSQL = WSQL&" AND P.UserName like '"&Search_UserName&"%'"
	End If 


	LSQL = "SELECT "
  LSQL = LSQL&" Top "&ViewCnt
	LSQL = LSQL&" P.PlayerIDX AS PlayerIDX "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(P.SportsGb) AS SportsName "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(SL.TeamGb) AS Part "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(SL.Sido)   AS Area "
	LSQL = LSQL&" ,SL.SchoolName AS SchoolName "
	LSQL = LSQL&" ,P.Sex AS Sex "
	LSQL = LSQL&" ,P.UserName AS UserName "
	LSQL = LSQL&" ,P.SportsGb+Convert(varchar(100),P.PlayerIDX) AS PlayerCode "
	'정렬조건을위한 키생성
	LSQL = LSQL&","&SearchFieldSQL
	LSQL = LSQL&" FROM tblPlayer P "
	LSQL = LSQL&" Join tblSchoolList SL "
	LSQL = LSQL&" ON P.NowSchIDX = SL.SchIDX "
'	LSQL = LSQL&" WHERE P.DelYN='N' AND SL.DelYN='N'"
	LSQL = LSQL&" WHERE P.DelYN='N'"

	LSQL = LSQL&WSQL




	If Trim(strkey) <> "" Then 		
		'strkey정렬
		LSQL = LSQL&" AND "&WhereFieldSQL&" < '" & strkey&"'"
	End If 
	
	LSQL = LSQL&OrderSQL

	'Response.Write LSQL
	'Response.End

	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(PlayerIDX) AS Cnt "
	CntSQL = CntSQL &" FROM tblPlayer P "
	CntSQL = CntSQL &" Join tblSchoolList SL "
	CntSQL = CntSQL &" ON P.NowSchIDX = SL.SchIDX "
'	CntSQL = CntSQL &" WHERE P.DelYN='N' AND SL.DelYN='N'"
	CntSQL = CntSQL &" WHERE P.DelYN='N'"
	CntSQL = CntSQL &WSQL

	'Response.Write LSQL
	'Response.End
	
'	Response.Write CntSQL
'	Response.End

	Dbopen()
		Set LRs = Dbcon.Execute(LSQL)
		Set CRs = Dbcon.Execute(CntSQL)
	Dbclose()
	

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
							<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("PlayerIDX")%></th>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("SportsName")%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("Part")%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("Area")%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("SchoolName")%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%If LRs("Sex") = "Man" Then %>남자<%Else%>여자<%End If%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("UserNAme")%></td>
							<td style="cursor:pointer;" onclick="input_data('<%=LRs("PlayerIDX")%>');"><%=LRs("PlayerCode")%></a></td>
							<td>
								<a href="javascript:view_profile('<%=LRs("PlayerIDX")%>')" class="btn-list">프로필 보기 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
							</td>
						</tr>
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("NextKey")
				'Response.Write strsetkey
				
			LRs.MoveNext
			intCnt = intCnt + 1
		Loop 

'		Response.End
%>


		ㅹ<%=strsetkey%>ㅹ<%=StrTp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
	End If 
%>
<% LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing
%>
