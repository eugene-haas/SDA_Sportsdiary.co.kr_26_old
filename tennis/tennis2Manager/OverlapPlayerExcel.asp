<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<head>
<title>excel</title>
</head>
<body >

<%
'request
 
 SQL = " select PlayerIDX 선수코드,	UserName 이름,left(UserPhone,3)+'-'+right(left(UserPhone,7),4)+'-'+right(UserPhone,4)	전화번호   " & _
     "  ,Team	팀1,TeamNm	팀명1,Team2	팀1,Team2Nm 팀명2	,asd 참가자	,fas 파트너참가,COUNT(idx)포인트갯수,''확인                 " & _                                                                               
      "  from (                                                                                                                               " & _
      "  select a.PlayerIDX,a.UserName,a.UserPhone,a.Team,a.TeamNm,a.Team2,a.Team2Nm,imsi1                                                    " & _
      "  ,(select COUNT(*) from tblGameRequest c  where a.PlayerIDX = c.P1_PlayerIDX and c.DelYN='N' and userName <>'운영자')asd              " & _
      "  ,(select COUNT(*) from tblGameRequest d  where a.PlayerIDX = d.P2_PlayerIDX and d.DelYN='N'and userName <>'운영자')	fas           " & _
      "  ,l.idx                                                                                                                               " & _
      "  from (                                                                                                                               " & _
	  "      select PlayerIDX,UserName,UserPhone,Team,TeamNm,Team2,Team2Nm,imsi1                                                              " & _
	  "      from tblPlayer                                                                                                                   " & _
	  "      where DelYN='N'                                                                                                                  " & _
	  "      and UserName in (select UserName from tblPlayer where DelYN='N' group by UserName having COUNT(*)>1 )                            " & _
	  "      )a                                                                                                                               " & _
      "  left join dbo.sd_TennisRPoint_log l                                                                                                  " & _
	  "      on a.PlayerIDX = l.PlayerIDX                                                                                                     " & _
	  "      and l.titleIDX <> 24                                                                                                             " & _
      "  )a                                                                                                                                   " & _
      "  group by PlayerIDX,	UserName	,UserPhone	,Team	,TeamNm	,Team2	,Team2Nm	,asd	,fas	,imsi1                            " & _
      "  order by a.UserName                                                                                                                  " 

 

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=중복  선수 정보 (이름기준)"&date()& ".xls"


Call rsDrow(rs)
%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
