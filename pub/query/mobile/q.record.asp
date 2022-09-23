<%
  ovrrnkstr = " RANK() OVER (Order By sum(a.getpoint) desc ,sum(a.wincnt) desc,sum(a.windiff) desc,sum(a.ptdiff) desc) as orderno "
  sortstr = " group by a.playerIDX order by 1 desc, 2 desc, 3 desc, 4 desc "
  '외부에서 바로 가기로 올경우를 대비해서
  Select Case teamgb 
  case "20101" '원스타 여
	  
'	  boostr = "여자부★ (1스타)"
'	  twostar = " a.teamgb = '20102' and a.upgrade = 1 " '승급후 데이터
'	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
'	  SQL = "select top 100 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&", "&ovrrnkstr&" from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
'	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"'  and b.stateno <> '1'  " & sortstr

	  ptsumstr = " sum( case when a.getpoint > ISNULL(c.getpoint,0) then a.getpoint else ISNULL(c.getpoint,0) end )  "
	  ovrrnkstr = " RANK() OVER (Order By "&ptsumstr&" desc ,sum(a.wincnt) desc,sum(a.windiff) desc,sum(a.ptdiff) desc) as orderno "

	  boostr = "여자부★ (1스타)"
	  twostar = " a.teamgb = '20102' and (a.upgrade = 1  or a.in2to1 = 1 )  " '승급후 데이터
	  
'	  in2to1 = " a.teamgb = '20104' and a.in2to1 = 1 " '원스타가 투스타에 출전한 테이터

	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "

	  SQL = "select top 100       "&ptsumstr&"             ,sum(a.wincnt),sum(a.windiff),sum(a.ptdiff),     max(a.username),a.playerIDX,"&teamStr&", "&ovrrnkstr
	  SQL = SQL & "  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "

	  SQL = SQL & " left join sd_TennisRPoint_log as c " 
	  SQL = SQL & " ON a.titleIDX = c.titleIDX  and (c.teamGb = '20102' and a.PlayerIDX = c.PlayerIDX)  " 

	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&") ) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and b.stateno <> '1'  " & sortstr



  case "20104" '원스타 남
  
'	  boostr = "남자부★ (1스타)"
'	  twostar = " a.teamgb = '20104' and a.upgrade = 1 " '승급후 데이터
'	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
'	  
'	  SQL = "select top 100 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&", "&ovrrnkstr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
'	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and b.stateno <> '1'  " & sortstr

	  ptsumstr = " sum( case when a.getpoint > ISNULL(c.getpoint,0) then a.getpoint else ISNULL(c.getpoint,0) end )  "
	  ovrrnkstr = " RANK() OVER (Order By "&ptsumstr&" desc ,sum(a.wincnt) desc,sum(a.windiff) desc,sum(a.ptdiff) desc) as orderno "

	  boostr = "남자부★ (1스타)"
	  twostar = " a.teamgb = '20105' and( a.upgrade = 1  or a.in2to1 = 1  )  " '승급후 데이터
	  
'	  in2to1 = " a.teamgb = '20104' and a.in2to1 = 1 " '원스타가 투스타에 출전한 테이터

	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "

	  SQL = "select top 100       "&ptsumstr&"             ,sum(a.wincnt),sum(a.windiff),sum(a.ptdiff),     max(a.username),a.playerIDX,"&teamStr&", "&ovrrnkstr
	  SQL = SQL & "  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "

	  SQL = SQL & " left join sd_TennisRPoint_log as c " 
	  SQL = SQL & " ON a.titleIDX = c.titleIDX  and (c.teamGb = '20105' and a.PlayerIDX = c.PlayerIDX)  " 

	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&") ) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and b.stateno <> '1'  " & sortstr



  Case "20102","20105"
	  If teamgb = "20102" Then
	  boostr = "여자부★★ (2스타)"
	  else
	  boostr = "남자부★★ (2스타)"
	  End if
	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
	  SQL = "select top 100 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&", "&ovrrnkstr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
	  SQL = SQL & " where a.teamGb= '"&teamgb&"' and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and b.stateno <> '1'  and  not ( a.upgrade = 0 and   a.in2to1 = 1 )      " & sortstr 
'	  SQL = SQL & " and  not ( a.upgrade = 0 and   a.in2to1 = 1 )   "
	  Case "20102","20105"
  End Select
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



'####################################################################################################
%>