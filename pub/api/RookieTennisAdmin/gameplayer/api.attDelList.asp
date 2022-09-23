<%
'#############################################

'#############################################

'request
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.KEY3

Set db = new clsDBHelper


refundfield = ", b.recustnm as '취소이름',rebanknm as '취소은행',refund as '취소계좌',    '<a href=""javascript:mx.reFund('+CAST(RequestIDX AS varchar(10))+')"" class=""btn"">['+b.refundok +']환불</a>'  "
leftjoinstr = " left join TB_RVAS_LIST as b ON    '"&Left(sitecode,2)&"' + cast(a.RequestIDX as varchar)  = b.CUST_CD "

'SQL = "select RequestIDX as '번호',UserName as '신청인',UserPhone  as '전화',txtMemo as '메모',PaymentDt as '입금일',PaymentNm as '입금자',PaymentType as '결제상태',WriteDate as '신청일',P1_UserName as '선수1',P1_TeamNm as '팀1',P1_TeamNm2 as '팀2',P1_UserPhone as '전화1',P2_UserName as '선수2',P2_TeamNm as '2팀1',P2_TeamNm2 as '2팀2',P2_UserPhone as '2전화' " & refundfield

SQL = "select RequestIDX as '번호',UserName as '신청인',UserPhone  as '전화',WriteDate as '신청일',P1_UserName as '선수1',P1_TeamNm as '팀1',P1_UserPhone as '전화1',P2_UserName as '선수2',P2_TeamNm as '2팀1',P2_UserPhone as '2전화' " & refundfield
SQL = SQL & ",    '<a href=""javascript:mx.restorePlayer('+CAST(RequestIDX AS varchar(10))+')"" class=""btn"">복구</a>'   " &  " from tblGameRequest as a  " & leftjoinstr
SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.level = '"&levelno&"' and  a.delYN = 'Y' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'#############################################


db.Dispose
Set db = Nothing
%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>참가신청삭제명단</h3>

  </div>
<!-- 헤더 코트e -->
<div class='modal-body '>
<div class="scroll_box" style="margin-top:5px;font-size:12px;">
	<%'=sql%>
	<%Call rsDrow(rs)%>
</div>
</div>
