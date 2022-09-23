<%
'#############################################
' 대회 랭킹 취소 목록
'#############################################

'request
tidx = oJSONoutput.TIDX
gyear = oJSONoutput.GAMEYEAR
titlecode = oJSONoutput.TCODE

'업데이트 설정
If hasown(oJSONoutput, "TEAMGB") = "ok" then	 '입금일짜
	teamgb = oJSONoutput.TEAMGB
End If

sdate = gyear & "-01-01"
edate = CDbl(gyear) + 1 & "-01-01"





Set db = new clsDBHelper


'refundfield = ", b.recustnm as '취소이름',rebanknm as '취소은행',refund as '취소계좌',    '<a href=""javascript:mx.reFund('+CAST(RequestIDX AS varchar(10))+')"" class=""btn"">['+b.refundok +']환불</a>'  "
'leftjoinstr = " left join TB_RVAS_LIST as b ON a.RequestIDX = b.CUST_CD "



'SQL = "select RequestIDX as '번호',UserName as '신청인',UserPhone  as '전화',WriteDate as '신청일',P1_UserName as '선수1',P1_TeamNm as '팀1',P1_UserPhone as '전화1',P2_UserName as '선수2',P2_TeamNm as '2팀1',P2_UserPhone as '2전화' " & refundfield
'SQL = SQL & ",    '<a href=""javascript:mx.restorePlayer('+CAST(RequestIDX AS varchar(10))+')"" class=""btn"">복구</a>'   " &  " from tblGameRequest as a  " & leftjoinstr 
'SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.level = '"&levelno&"' and  a.delYN = 'Y' "
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


If CDbl(CMD) = CMD_SETRNKINFO And teamgb <> "" Then '사용함 안함으로 설정 변경
	SQL = "update sd_TennisRPoint_log Set ptuse  = case when ptuse = 'Y' then 'N' else 'Y' end where titleCode = "&titlecode&" and Teamgb = "&teamgb&" and titleIDX = "&tidx&" "
	Call db.execSQLRs(SQL , null, ConStr)
End if


fname = " max(titleName) as '대회명', teamGbName as '부명칭' ,count(*) as '명수',max(ptuse) as '사용여부' ,  "
fname = fname & " '<a href=""javascript:mx.setRnkInfo('+CAST(Max(titleCode) AS varchar(12))+' , '+CAST(titleIDX AS varchar(12))+' , '+CAST(teamgb AS varchar(12))+', "&gyear&")"" class=""btn"">변경</a>'"
SQL = "select "& fname &" from sd_TennisRPoint_log where titleCode = "&titlecode&" and gamedate >= '"&sdate&"' and gamedate < '"&edate&"' group by teamgb,teamgbname,titleIDX "

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'#############################################



%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=gyear%>년도 랭킹반영여부</h3>

  </div>
<!-- 헤더 코트e -->
<div class='modal-body '>
<div class="scroll_box" style="margin-top:5px;font-size:12px;">
	<%Call rsDrow(rs)%>


<%
If CDbl(CMD) = CMD_SETRNKINFO And teamgb <> "" Then '사요함 안함으로 설정 변경
	SQL = "select * from  sd_TennisRPoint_log where titleCode = "&titlecode&" and Teamgb = "&teamgb&" and titleIDX = "&tidx&" order by rankno asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Call rsDrow(rs)
End if

%>

</div>
</div>


<%
db.Dispose
Set db = Nothing
%>