<!-- #include virtual = "/pub/header.swimAdmin.asp" -->

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
'tidx = chkInt(chkReqMethod("tidx", "GET"), 1)
'levelno = chkInt(chkReqMethod("levelno", "GET"), 1)

tidx = 41
levelno = 20101001


	rankpointpass = false
	Select Case CDbl(Left(levelno,5))
	Case 20109,20108  '가족부,혼합복식 이벤트성 포인트인것
		rankpointpass = true
	Case 20106,20105,20107 '오픈부, 왕중왕부 지도자부
		Whereteamgb  = " (20106,20105,20107) "
	Case 20103 '베테랑부
		Whereteamgb  = "(" & Left(levelno,5)& ")"
	Case Else '개나리, 국화부,신인부
		Whereteamgb  ="("& Left(levelno,5) & ")"
	End Select 


	SQL = "select a.gametitlename ,b.teamgbnm from sd_tennistitle as a inner join tblrgamelevel as b on a.gametitleidx = b.gametitleidx where a.gametitleidx = "  & tidx & " and b.level =  '"&levelno&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gtitle = rs(0)
	gboo = rs(1)


	Response.write gtitle & "("&gboo&")"


	'requestidx as '번호',paymentdt,
	If rankpointpass = false then
	rankq1 = "(select sum(getpoint)  from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = a.p1_playeridx and teamGb in "&Whereteamgb&" order by getpoint desc ) )  as '포인트1'"
	rankq2 = "(select sum(getpoint)  from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = a.p2_playeridx and teamGb in "&Whereteamgb&" order by getpoint desc ) )  as '포인트2'"
	Else
	rankq1 = "0 as '포인트1'"
	rankq2 = "0 as '포인트2'"
	End if

'	phoneq = " ( left(userphone,3)+ '-'+ substring(userphone,4,4) + '-'+ substring(userphone,8,4) ) as '전화'  "
'	phone1 = " ( left(P1_UserPhone,3)+ '-'+ substring(P1_UserPhone,4,4) + '-'+ substring(P1_UserPhone,8,4) ) as '선수1 전화번호'  "
'	phone2 = " ( left(P2_UserPhone,3)+ '-'+ substring(P2_UserPhone,4,4) + '-'+ substring(P2_UserPhone,8,4) ) as '선수2 전화번호'  "
'
'	field1 = "ROW_NUMBER() over(order by requestIDX desc) as no ,username as '신청인',"&phoneq&",txtMemo as '메모',paymentnm as '입금자',paymenttype as '입금',p1_username as '선수1' "
'	field1 = field1 & " , CASE when p1_teamnm2 ='' then p1_teamnm ELSE  (p1_teamnm + ',' + p1_teamnm2) END as '클럽', "&phone1&","
'	field2 = "P2_UserName as '선수2', CASE when P2_TeamNm2 ='' then P2_TeamNm else (P2_TeamNm +','+ P2_TeamNm2) end as '클럽'     ," & phone2 & "," & rankq1 & "," & rankq2 
	


	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "

	strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0  and a.gubun in ( 0, 1) and a.DelYN = 'N' "
	strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별
	strAfield = " a.playerIDX, b.PlayerIDX, a.userName, b.userName "
	strfield = strAfield  

	SQL = "select " & strfield & " from  " & strtable & " as a " 
	SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
	SQL = SQL & "where " & strwhere & strsort



	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
	arrRS = rs.getrows()
	End If
	Set rs = Nothing
	
	'######################

	field1 = " p1_username as '선수1'  "
	field2 = ", p2_username as '선수2'  "

	SQL = "select "&field1&field2&"  from  tblGameRequest as a where GameTitleIDX = "&tidx&"  and level = '"&levelno&"' and DelYN = 'N'  order by requestIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	%>

	<table border="1">
	<%
	Do Until rs.eof 
		p1 = rs(0)
		p2 = rs(1)

		If IsArray(arrRS) Then
			For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
				p1idx	= arrT(0, ar)
			Next
		End if

		'p3 = rs(2)
		'p4 = rs(3)
	%>
		<tr>
			<td><%=p1%></td>
			<td><%=p2%></td>
			<td><%=p3%></td>
			<td><%=p4%></td>
		</tr>
	<%
	rs.movenext
	loop





'Response.Buffer = True     
'Response.ContentType = "application/vnd.ms-excel"
'Response.CacheControl = "public"
'Response.AddHeader "Content-disposition","attachment;filename=참가신청_"&gtitle&"("&gboo&")"&date()& ".xls"





'Call rsDrow(rs)
%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
