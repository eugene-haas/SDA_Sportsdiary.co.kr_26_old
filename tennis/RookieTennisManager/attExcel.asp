<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

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
tidx = chkInt(chkReqMethod("tidx", "GET"), 1)
levelno = chkInt(chkReqMethod("levelno", "GET"), 1)

	rankpointpass = false
	Whereteamgb  ="("& Left(levelno,5) & ")"

	SQL = "select a.gametitlename ,b.teamgbnm from sd_tennistitle as a inner join tblrgamelevel as b on a.gametitleidx = b.gametitleidx where a.gametitleidx = "  & tidx & " and b.level =  '"&levelno&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gtitle = rs(0)
	gboo = rs(1)


	Response.write gtitle & "("&gboo&")"


	'requestidx as '번호',paymentdt,
	If rankpointpass = false then
		rankq1 = "(select sum(getpoint)  from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = a.p1_playeridx and teamGb in "&Whereteamgb&" order by getpoint desc ) )  as '누적(15) 랭킹포인트1'"
		rankq2 = "(select sum(getpoint)  from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = a.p2_playeridx and teamGb in "&Whereteamgb&" order by getpoint desc ) )  as '누적(15) 랭킹포인트2'"
	Else
		rankq1 = "0 as '포인트1'"
		rankq2 = "0 as '포인트2'"
	End if

	'ISNULL(컬럼명 , '0' ) as test 
	paysql = " (   select top 1 '입금' from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)     ) as payok "

	mallp1 = "isnull ((select top 1 mallpoint + 3000  from sd_TennisRPoint_log where playeridx = a.P1_playeridx and  titleidx= a.gametitleidx and  teamgb = '"&Left(levelno,5)&"'  ) ,3000)  as '수령포인트1' " 
	mallp2 = "isnull ((select top 1 mallpoint + 3000  from sd_TennisRPoint_log where playeridx = a.P2_playeridx and  titleidx= a.gametitleidx and  teamgb = '"&Left(levelno,5)&"'  ) ,3000)  as '수령포인트2' " 

	prize1 = "(select case when sex = 1 then  '남 ' + size else '여 ' + size end  from sd_gamePrize where idx = a.P1_prizekey  )   as '상품1' " 
	prize2 = "(select case when sex = 1 then  '남 ' + size else '여 ' + size end  from sd_gamePrize where idx = a.P2_prizekey  )   as '상품2' " 


	phoneq = " ( left(userphone,3)+ '-'+ substring(userphone,4,4) + '-'+ substring(userphone,8,4) ) as '전화'  "
	phone1 = " ( left(P1_UserPhone,3)+ '-'+ substring(P1_UserPhone,4,4) + '-'+ substring(P1_UserPhone,8,4) ) as '선수1 전화번호'  "
	phone2 = " ( left(P2_UserPhone,3)+ '-'+ substring(P2_UserPhone,4,4) + '-'+ substring(P2_UserPhone,8,4) ) as '선수2 전화번호'  "

	field1 = "ROW_NUMBER() over(order by requestIDX asc) as no ,P1_ID,username as '신청인',"&phoneq&",txtMemo as '메모',paymentnm as '입금자',paymenttype as '입금',p1_username as '선수1' "
	field1 = field1 & " , CASE when p1_teamnm2 ='' then p1_teamnm ELSE  (p1_teamnm + ',' + p1_teamnm2) END as '클럽', "&phone1&","
	field2 = "P2_ID,P2_UserName as '선수2', CASE when P2_TeamNm2 ='' then P2_TeamNm else (P2_TeamNm +','+ P2_TeamNm2) end as '클럽'     ," & phone2 & "," & rankq1 & "," & rankq2 & ", " & prize1 & ", " & prize2  & ", " & mallp1 & ", " & mallp2 & ", " & paysql 
	
	SQL = "select "&field1&field2&"  from  tblGameRequest as a where GameTitleIDX = "&tidx&"  and level = '"&levelno&"' and DelYN = 'N' order by RequestIDX asc"

	
'Response.write sql 
'Response.end
			
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	



Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=참가신청_"&gtitle&"("&gboo&")"&date()& ".xls"


Call rsDrow(rs)
%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
