<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
<%
'request
tidx = chkInt(chkReqMethod("tid", "GET"), 1)
Set db = new clsDBHelper

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = "Select GameS,titleCode,titleGrade,gametitlename from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		games = Left(rs("games"),10)
		titlecode = rs("titlecode")
		titlegrade = rs("titleGrade")
		gametitle = rs("gametitlename")
        titleGradeNm = findGrade(titlegrade)
	End if

	strTableName = "  tblRGameLevel "
	strFieldName = " max(fee),max(fund) "
	strWhere = " DelYN = 'N' and gameTitleIDX = " & tidx

	SQL = "SELECT " & strFieldName & " FROM  " & strTableName & " WHERE " & strWhere 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	fee = rs(0)
	fund = rs(1)
	groundfee = CDbl(fee) + 1000
	acctotal = CDbl(fee) + CDbl(fund)

	'실참가팀수 구하기 (예선
	field = " gamekey3,count(*)  "
	strWhere  = " delYN = 'N'  and gameTitleIDX = " & tidx & " and gubun in (0,1) group by gamekey3"
	SQL = " Select "& field &" from  sd_tennisMember where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

'	Call rsdrow(rs)					
'	Response.end
	
	If Not rs.EOF Then 
		arrCNT = rs.getrows()
	End If
	'실참가팀수 구하기 (예선


	boonm = " (select top 1 x.TeamGbNm + '/' + y.LevelNm  from tblRGameLevel as x inner join tblLevelInfo as y on x.Level = y.Level where x.GameTitleIDX = "&tidx&" and x.level = a.level) as boonm "
	field = " a.level,sum(b.TR_AMT) as totalatm," & boonm & ",count(*) as mcnt,b.ENTRY_IDNO ,a.AttFlag   , 0,0,0,0,0 , 0 ,max(p1_username) "
	strWhere  = " a.delYN = 'N'  and a.gameTitleIDX = " & tidx & " group by a.Level, b.ENTRY_IDNO,a.AttFlag  order by a.level asc"
	
	SQL = " Select "& field &" from  View_tblGameRequest as a left Join  TB_RVAS_LIST as b On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'부번호(levelno) , 총금액, 부명칭, 명수 , 코쿤 or null (입금형태) , 풀석플레그, 0,0,0,0,0,0
	'Call rsdrow(rs)					
	'Response.end

	If Not rs.EOF Then 
		arrRS = rs.getrows()
	End If
	Set rs = Nothing

	strWhere  = "   a.gameTitleIDX = " & tidx  '취소된것도 모두포함
'	strWhere  = "  a.DelYN = 'N' and a.gameTitleIDX = " & tidx 
	SQL = " Select sum(b.TR_AMT),count(*) as attcnt from  tblGameRequest as a INNER JOIN  TB_RVAS_LIST as b On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' and b.BANK_CD = '081'  where " & strWhere '가상계좌분만
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		atttotal = rs(0) '계좌입금총액
		attcnt = rs(1)

		fundtotalA = CDbl(fund) * CDbl(attcnt)

		If atttotal = "" Or isnull(atttotal) = true Then
		atttotal = 0
		feetotalA = 0
		else
		feetotalA = CDbl(atttotal) - CDbl(fundtotalA)
		End if

	Else
		atttotal = 0
		attcnt = 0
		fundtotal = 0
	End If
	

	strWhere  = "  a.DelYN = 'N' and  a.gameTitleIDX = " & tidx 
	SQL = " Select sum(b.TR_AMT),count(*) as attcnt from  View_tblGameRequest as a INNER JOIN  TB_RVAS_LIST as b On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' and BANK_CD = '000' where " & strWhere '현장입금분
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		groundtotal = rs(0) '총액
		groundcnt = rs(1)
		fundtotalB = CDbl(fund) * CDbl(groundcnt)

		If groundtotal = "" Or isnull(groundtotal) = true Then
		groundtotal = 0
		End If
		
		feetotalB = CDbl(groundtotal) - CDbl(fundtotalB)

	Else
		groundtotal = 0
		groundcnt = 0
		fundtotalB = 0
	End if

	fundtotal = CDbl(fundtotalA) + CDbl(fundtotalB)
	feetotal = CDbl(feetotalA) + CDbl(feetotalB)

'기본정보#####################################


'##############################################
' 소스 뷰 경계
'##############################################

	Response.Buffer = True     
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename=정산내역서_"&titleGradeNm&"_"&date()& ".xls"

	cssBG = "background-color: transparent;"
	css0 = "border-style: none solid solid none; border-color: black windowtext windowtext black;"
	cssA = "border-width: 0px 0.5pt 0.5pt 0px; " & css0 &cssBG
	cssB = "border-style: solid; border-color: windowtext black windowtext windowtext;"
	cssC = "border-width: 0.5pt 1pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black;"

	%>
	<!DOCTYPE html>
	<html>
	<head>
	  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	  <meta name="mobile-web-app-capable" content="yes">
	  <meta charset="utf-8">
	  <title><%=gametitle%></title>
	</head>

	<h2>
	<table width="792" style="width: 594pt; border-collapse: collapse;" border="0" cellspacing="0" cellpadding="0">

	<colgroup><col width="72" style="width: 54pt;" span="11">
	<tbody>
	<tr height="23" style="height: 17.25pt;">
		<td width="72" height="23" style="border: 0px black; width: 54pt; height: 17.25pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
		<td width="72" style="border: 0px black; width: 54pt; <%=cssBG%>"></td>
	</tr>


	<tr height="40" style="height: 30pt; mso-height-source: userset;">
		<td height="40" style="border: 0px black; height: 30pt; <%=cssBG%>"></td>
		<td style="border-width: 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="10">
		<font face="맑은 고딕" size="3"><b>대회별 참가비  정산내역서</b></font>
		</td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
		<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
		<td style="border-width: 1pt 0.5pt 0.5pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2">
		<font face="맑은 고딕" size="2">대<span style="mso-spacerun: yes;">&nbsp;&nbsp; </span>회<span style="mso-spacerun: yes;">&nbsp;&nbsp;</span>명</font></td>
		<td style="border-width: 1pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="5"><%=gametitle%></td>
		<td style="<%=cssA%>text-align:center;"><font face="맑은 고딕" size="2">대회등급</font></td>
		<td style="border-width: 1pt 1pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><%=titleGradeNm%></td>
	</tr>
		<tr height="23" style="height: 17.25pt;">
		<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
		<td style="border-width: 0.5pt 0.5pt 1pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">팀당 참가비</font></td>
		<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>text-align:center;"><font size="2"><font face="맑은 고딕">참가비<span style="mso-spacerun: yes;">&nbsp;</span></font></font></td>
		<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=FormatNumber(fee, 0)%></font></td>
		<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>text-align:center;"><font face="맑은 고딕" size="2">육성기금</font></td>
		<td style="border-width: 0px 0px 1pt; border-style: none none solid; border-color: black black windowtext; <%=cssBG%>"><font face="맑은 고딕" size="2"><%=FormatNumber(fund, 0)%></font></td>
		<td style="border-width: 0px 0.5pt 1pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;"><font face="맑은 고딕" size="2">합계</font></td>
		<td style="border-width: 0.5pt 1pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=FormatNumber(acctotal, 0)%></font></td>
	</tr>


<%
'#######################################################################################################
'참가팀수
'#######################################################################################################
%>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 1pt 1pt 0.5pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="10">
	<font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span><strong>1. 참 가 팀 수</strong></font></font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
		<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
		<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; border-style: solid; border-color: windowtext; <%=cssBG%>text-align:center;" rowspan="2" colspan="3">
		<font face="맑은 고딕" size="2">부<span style="mso-spacerun: yes;">&nbsp; </span>서</font></td>
		<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="2">
		<font face="맑은 고딕" size="2">예선편성</font></td>
		<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="2">
		<font face="맑은 고딕" size="2">불참</font></td>
		<td style="border-width: 0px 0.5pt 0px 0px; border-style: none solid none none; border-color: black windowtext black black; <%=cssBG%>text-align:center;">
		<font face="맑은 고딕" size="2">당<span style="mso-spacerun: yes;">&nbsp; </span>일</font></td>
		<td style="border-width: 0px 0.5pt 0.5pt; border-style: none solid solid; border-color: black windowtext; <%=cssBG%>text-align:center;" rowspan="2"><font face="맑은 고딕" size="2">현장입금</font></td>
		<td style="border-width: 0px 1pt 0.5pt 0.5pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;" rowspan="2"><font face="맑은 고딕" size="2">실참가</font></td>
		</tr>
		<tr height="22" style="height: 16.5pt;">
		<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
		<td style="<%=cssA%>"><font face="맑은 고딕" size="2">입금</font></td>
		<td style="<%=cssA%>"><font face="맑은 고딕" size="2">미입금</font></td>
		<td style="<%=cssA%>"><font face="맑은 고딕" size="2">입금</font></td>
		<td style="<%=cssA%>"><font face="맑은 고딕" size="2">미입금</font></td>
		<td style="<%=cssA%>"><font face="맑은 고딕" size="2">추가접수</font></td>
	</tr>

	<%
		sub valuein(ByVal levelno, ByVal mcnt , ByVal fieldno, ByVal money)
			Dim s, cklevelno
			For s = LBound(arrRS, 2) To UBound(arrRS, 2) 
				cklevelno = arrRS(0,s)
				If cklevelno = levelno Then
					arrRS(fieldno,s) = mcnt
					arrRS(11,s) = CDbl(arrRS(11,s)) + CDbl(money) '부별총금액
				End if
			next
		End sub

		inarr = array(0,0,0,0,0)
		
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				levelno = arrRS(0,ar)
				paywon = arrRS(1,ar)
				boonm = arrRS(2,ar)
				mcnt = arrRS(3,ar)
				egubun = arrRS(4,ar) 'KATA 현장입금 null 없슴, COOCON
				attflag = arrRS(5,ar) ' 참가 불출석

				If isnull(paywon) = True Then
					paywon = 0
				End If

				If attflag = "Y" Then '참가
					Select Case egubun
					Case "KATA"  '현장입금
						Call valuein(levelno, mcnt, 8, paywon)
					Case "COOCON" '가상계좌입금
						Call valuein(levelno, mcnt, 6, paywon)
					Case Else 'null 기타입금
						Call valuein(levelno, mcnt, 7, paywon)
					End Select
						'총합
					'inarr(0)= inarr(0) + CDbl(mcnt)
				Else
					Select Case egubun
					Case "COOCON" '가상계좌입금
						Call valuein(levelno, mcnt, 9, paywon)
					Case Else 'null 미입금
						Call valuein(levelno, mcnt, 10, paywon)
					End Select 				
				End if			
		Next
		End if


		i = 1
	'	inarr = array(0,0,0,0,0)
		totalarr = array(0,0,0,0,0,0)



		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				levelno = arrRS(0,ar)
				paywon = arrRS(1,ar)
				boonm = arrRS(2,ar)

				inarr(0) = arrRS(6,ar)
				inarr(1) = arrRS(7,ar)
				inarr(2) = arrRS(8,ar)
				attmcnt = CDbl(inarr(0)) + CDbl(inarr(2))
				inarr(3) = arrRS(9,ar)
				inarr(4) = arrRS(10,ar)			

				'각 명수====
				'참가자 입금			inarr(0)
				'참가자 미입금			inarr(1)
				'현장입금				inarr(2)
				'불참 입금				inarr(3)
				'불참 미입금			inarr(4)

			if i = 1 or prelevelno <> levelno Then
				'totalatt = CDbl(attmcnt)+CDbl(inarr(3))
				totalarr(0) = totalarr(0) + CDbl(attmcnt)
				totalarr(1) = totalarr(1) + CDbl(inarr(1))
				'totalarr(2) = totalarr(2) + CDbl(inarr(2))
				totalarr(3) = totalarr(3) + CDbl(inarr(3))
				totalarr(4) = totalarr(4) + CDbl(inarr(4))
				'totalarr(5) = totalarr(5) + CDbl(totalatt)
			%>
				<tr height="22" style="height: 16.5pt;">
					<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
					<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; border-style: solid; border-color: windowtext; <%=cssBG%>text-align:center;" colspan="3"><font face="맑은 고딕" size="2"><%=boonm%></font></td>
					<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=attmcnt%></font></td><!-- 편성입금 -->
					<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=inarr(1)%></font></td>
					<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=inarr(3)%></font></td><!-- 불참입금 -->
					<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=inarr(4)%></font></td>
					<td style="<%=cssA%>"><font face="맑은 고딕" size="2"> </font></td>
					<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=inarr(2)%></font></td><!-- 현장입금 -->

			<%
				If IsArray(arrCNT) Then
				For art = LBound(arrCNT, 2) To UBound(arrCNT, 2) 
						ss_levelno = arrCNT(0,art)

						If CDbl(ss_levelno) = CDbl(levelno)  Then '실참가
							ss_cnt = arrCNT(1,art)			
							totalatt = ss_cnt
							'Response.write totalatt & "<br>"
							totalarr(5) = CDbl(totalarr(5)) + CDbl(ss_cnt)
						End If
				Next
				End if
			%>					
					
					<td align="right" style="border-width: 0px 1pt 0.5pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalatt%></font></td>		
				</tr>
			<%
			inarr = array(0,0,0,0,0)
			End If
		
			prelevelno = levelno
			i = i + 1
		Next
			%></tr><%
		End If 
	%>
	<tr height="23" style="height: 17.25pt;">
		<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
		<td style="border-width: 0.5pt 0.5pt 1pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="3">
		<font face="맑은 고딕" size="2">합<span style="mso-spacerun: yes;">&nbsp; </span>계</font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(0)%></font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(1)%></font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(3)%></font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(4)%></font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"> </font></td>
		<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(2)%></font></td>
		<td align="right" style="border-width: 0px 1pt 0.5pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalarr(5)%></font></td>
	</tr>



<%
'#######################################################################################################
'정산내역
'#######################################################################################################
%>

<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 1pt 1pt 0.5pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="10"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span><strong>2. 계 좌 입 금 내 역</strong></font></font></td>
</tr>
<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2">
	<font face="맑은 고딕" size="2">부<span style="mso-spacerun: yes;">&nbsp; </span>서</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">총입금액</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">참가팀분</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">취소팀분</font></td>
	<td style="<%=cssC%> <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">차<span style="mso-spacerun: yes;">&nbsp; </span>액</font></td>
</tr>

<%

	
	'각각
	boonm = " (select top 1 x.TeamGbNm + '/' + y.LevelNm  from tblRGameLevel as x inner join tblLevelInfo as y on x.Level = y.Level where x.GameTitleIDX = "&tidx&" and x.level = a.level) as boonm "
	field = " a.level,sum(b.TR_AMT) as totalatm," & boonm & ",a.delYN "
	strWhere  = "  a.gameTitleIDX = " & tidx & " group by a.Level,a.delYN  "
	SQL = " Select "& field &" from  tblGameRequest as a inner Join  TB_RVAS_LIST as b On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' where " & strWhere

	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rst.EOF Then 
		arrRST = rst.getrows()
	End If

	'전체
	SQL = "select t.level, sum(t.totalatm), t.boonm from ("& SQL &") as t group by t.level,t.boonm order by t.level asc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rss)
'Response.end

	If Not rss.EOF Then 
		arrRS = rss.getrows()
	End If
	Set rss = Nothing




	i = 1
	boototal = 0
	gametotal = 0
	prelevelno = 0
	att_m_total = 0
	cancelmoney_total = 0
	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

			levelno = arrRS(0,ar)
			boototal = arrRS(1,ar)			
			boonm = arrRS(2,ar)
			'delyn = arrRS(3,ar)


		if i = 1 or prelevelno <> levelno Then

		gametotal = gametotal + CDbl(boototal)
		%>
			<tr height="22" style="height: 16.5pt;">
				<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
				<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2"><%=boonm%></font></td>
				<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=boototal%></font></td>

<%
	If IsArray(arrRST) Then
	For art = LBound(arrRST, 2) To UBound(arrRST, 2) 
			s_levelno = arrRST(0,art)
			s_boototal = arrRST(1,art)			
			s_delyn = arrRST(3,art)

			If s_levelno = levelno And s_delyn = "N" Then '실참가자분
				att_m = s_boototal
				att_m_total = CDbl(att_m_total) + CDbl(att_m)
			End If
			If s_levelno = levelno And s_delyn = "Y" Then '취소분
				cancelmoney = s_boototal
				cancelmoney_total = CDbl(cancelmoney_total) + CDbl(cancelmoney)
			End if			
	Next
	End if

%>

				<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=att_m%></font></td>
				<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=cancelmoney%></font></td>

				<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"> </font></td>
			</tr>
		<%
		boototal = 0
		End If
		prelevelno = levelno
		i = i + 1
	Next
	End If 
%>





<tr height="23" style="height: 17.25pt;">
<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
<td style="border-width: 0.5pt 0.5pt 1pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2">
<font face="맑은 고딕" size="2">합<span style="mso-spacerun: yes;">&nbsp; </span>계</font></td>
<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=gametotal%></font></td>
<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=att_m_total%></font></td>
<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"><%=cancelmoney_total%></font></td>
<td style="border-width: 0.5pt 1pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"> </font></td>
</tr>

<%
'#######################################################################################################
'정산내역
'#######################################################################################################
SQL = "select SUM(TR_AMT) as atm from TB_RVAS_LIST  as a inner join tblGameRequest as b on a.CUST_CD = b.RequestIDX where b.GameTitleIDX =" & tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If rs.eof Then
	atttotal_money = 0
Else
	atttotal_money = rs("atm")
End if

%>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0px 1pt 0.5pt; border-style: none solid solid; border-color: black black windowtext windowtext; <%=cssBG%>text-align:center;" colspan="10">
	<font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span><strong>3. 정 산 내 역</strong></font></font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="2">
	<font face="맑은 고딕" size="2">계좌입금총액</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="6">
	<font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>text-align:center;" colspan="2">
	<font face="맑은 고딕" size="2"><%=FormatNumber(atttotal_money, 0)%></font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 1pt; border-style: solid; border-color: windowtext; <%=cssBG%>text-align:center;" rowspan="7" colspan="2"><font face="맑은 고딕" size="2">차 감 내 역</font></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span>1. 유소년기금</font></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(fundtotal, 0)%></font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;&nbsp; </span>1)실참가팀분</font></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(attcnt, 0)%></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(fee, 0)%></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(atttotal, 0)%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;&nbsp; </span>2)현장입금추가분</font></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=groundcnt%></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(groundfee, 0)%></font></font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"><%'=FormatNumber(groundtotal, 0)%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span>2. 대회연회비</font></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td align="right" style="<%=cssA%>"><font face="맑은 고딕" size="2"> </font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span>3. 선지급액</font></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border: 0.5pt solid windowtext; <%=cssBG%>text-align:center;" colspan="2"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span>4. 기타</font></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">차감액합계</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>" colspan="4"><font face="맑은 고딕" size="2">　</font></td>
	<td style="<%=cssC%> <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"> </font></td>
	</tr>
	<tr height="23" style="height: 17.25pt;">
	<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
	<td style="border-width: 0.5pt 0.5pt 1pt 1pt; border-style: solid; border-color: windowtext; <%=cssBG%>text-align:center;" colspan="2"><font face="맑은 고딕" size="2">정 산 지 급 액</font></td>
	<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>" colspan="6"><font size="2"><font face="맑은 고딕">
	<span style="mso-spacerun: yes;">&nbsp;</span>계좌입금총액 - 차감액합계</font></font></td>
	<td style="border-width: 0.5pt 1pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="2"><font face="맑은 고딕" size="2"> </font></td>
	</tr>
	<tr height="23" style="height: 17.25pt;">
	<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
	<td style="border-width: 1pt 0px; border-style: solid none; border-color: windowtext black; <%=cssBG%>" colspan="10"><font face="맑은 고딕" size="2">　</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 1pt 1pt 0.5pt; <%=cssB%> <%=cssBG%>text-align:center;" colspan="10"><font size="2"><font face="맑은 고딕"><span style="mso-spacerun: yes;">&nbsp;</span>
	<strong>4. 취 소 팀 환 불 명 단</strong></font></font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0px 0.5pt 0.5pt 1pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;" rowspan="2"><font face="맑은 고딕" size="2">부서</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="2">
	<font face="맑은 고딕" size="2">선수1</font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext windowtext windowtext black; <%=cssBG%>text-align:center;" colspan="2">
	<font face="맑은 고딕" size="2">선수2</font></td>
	<td style="border-width: 0px 0.5pt 0.5pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;" rowspan="2"><font face="맑은 고딕" size="2">환불액</font></td>
	<td style="border-width: 0.5pt; border-style: solid; border-color: windowtext black black windowtext; <%=cssBG%>text-align:center;" rowspan="2" colspan="3"><font face="맑은 고딕" size="2">환불계좌</font></td>
	<td style="border-width: 0px 1pt 0.5pt 0.5pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;" rowspan="2"><font face="맑은 고딕" size="2">취소일시</font></td>
	</tr>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="<%=cssA%>text-align:center;"><font face="맑은 고딕" size="2">성명</font></td>
	<td style="<%=cssA%>text-align:center;"><font face="맑은 고딕" size="2">연락처</font></td>
	<td style="<%=cssA%>text-align:center;"><font face="맑은 고딕" size="2">성명</font></td>
	<td style="<%=cssA%>text-align:center;"><font face="맑은 고딕" size="2">연락처</font></td>
	</tr>

<%
'#######################################################################################################
'취소내역 쿼리
'#######################################################################################################
	boo = "(select top 1 x.TeamGbNm + '/' + y.LevelNm  from tblRGameLevel as x inner join tblLevelInfo as y on x.Level = y.Level where x.GameTitleIDX = "&tidx&" and x.level = a.level) as boo "
	field = " ,p1_username, p1_userphone,p2_username,p2_userphone, tr_amt, recustnm,rebanknm, refund,refunddate "
	'SQL = "select "&boo& field &" from tblgamerequest as a inner join tb_rvas_list as b ON a.requestIDX = b.cust_cd and recustnm <> '' where a.gametitleidx = '"&tidx&"'  order by a.level"
	SQL = "select "&boo& field &" from tb_rvas_list as b left join tblgamerequest as a ON a.requestIDX = b.cust_cd and a.delYN = 'Y' where a.gametitleidx = '"&tidx&"'    order by a.level"
	'Response.write sql
'SQL = SQL & " from tblGameRequest as a left Join TB_RVAS_LIST as b  On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' "
'SQL = SQL & "  where a.gameTitleIDX = 65 and delyn = 'Y'  and b.TR_AMT >0 "
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	%>

	<%
	i = 0 
	totalrefund = 0
	Do Until rs.eof%>
	<tr height="22" style="height: 16.5pt;">
	<td height="22" style="border: 0px black; height: 16.5pt; <%=cssBG%>"></td>
	<td style="border-width: 0px 0.5pt 0.5pt 1pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>"><font face="맑은 고딕" size="2"><%=rs("boo")%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=rs("p1_username")%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">&nbsp;<%=rs("p1_userphone")%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=rs("p2_username")%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2">&nbsp;<%=rs("p2_userphone")%></font></td>
	<td style="<%=cssA%>"><font face="맑은 고딕" size="2"><%=FormatNumber(rs("tr_amt"),0)%></font></td>
	<td style="border-width: 0.5pt 0.5pt 0.5pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="3"><font face="맑은 고딕" size="2">(<%=rs("rebanknm")%>:<%=rs("recustnm")%>)<%=f_dec(rs("refund"))%></font></td>
	<td style="border-width: 0px 1pt 0.5pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=Left(rs("refunddate"),10)%></font></td>
	</tr>
	<%
	i = i + 1
	totalrefund = CDbl(totalrefund) + CDbl(rs("tr_amt"))
	rs.movenext
	loop
	%>

	<tr height="23" style="height: 17.25pt;">
	<td height="23" style="border: 0px black; height: 17.25pt; <%=cssBG%>"></td>
	<td style="border-width: 0px 0.5pt 1pt 1pt; border-style: none solid solid; border-color: black windowtext windowtext; <%=cssBG%>text-align:center;">
	<font face="맑은 고딕" size="2">합<span style="mso-spacerun: yes;">&nbsp;</span>계</font></td>
	<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=i%></font></td>
	<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2">　</font></td>
	<td style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2">　</font></td>
	<td align="right" style="border-width: 0px 0.5pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2"><%=totalrefund%> </font></td>
	<td style="border-width: 0.5pt 0.5pt 1pt 0px; border-style: solid solid solid none; border-color: windowtext black; <%=cssBG%>" colspan="3"><font face="맑은 고딕" size="2">　</font></td>
	<td style="border-width: 0px 1pt 1pt 0px; <%=css0%> <%=cssBG%>"><font face="맑은 고딕" size="2">　</font></td>
	</tr><font face="굴림" size="3"> </font></tbody></table></h2><strong>
	</strong>	



<%
'SQL ="Select a.p1_username,a.level,b.TR_AMT, (select top 1 x.TeamGbNm + '/' + y.LevelNm from tblRGameLevel as x inner join tblLevelInfo as y on x.Level = y.Level where x.GameTitleIDX = 65 and x.level = a.level) as boonm "
'SQL = SQL & " ,a.delYN,b.recustnm,b.rebanknm,b.refund,b.refunddate,b.vacct_no  "
'SQL = SQL & " from tblGameRequest as a left Join TB_RVAS_LIST as b  On a.RequestIDX = b.CUST_CD and b.STAT_CD = '0' "
'SQL = SQL & "  where a.gameTitleIDX = 65 and delyn = 'Y'  and b.TR_AMT >0 "
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsdrow(rs)
%>



</body>
</html>

<%
db.Dispose
Set db = Nothing
%>




