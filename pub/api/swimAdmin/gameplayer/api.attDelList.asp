<%
'#############################################

'#############################################

'request
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.KEY3

Set db = new clsDBHelper


refundfield = ", b.recustnm as '취소이름',rebanknm as '취소은행',refund as '취소계좌',    '<a href=""javascript:mx.reFund('+CAST(RequestIDX AS varchar(10))+')"" class=""btn btn-primary"">['+b.refundok +']환불</a>'  "
leftjoinstr = " left join SD_RookieTennis.dbo.TB_RVAS_LIST as b ON     '"&Left(sitecode,2)&"' + cast(a.RequestIDX as varchar) = b.CUST_CD "


SQL = "select RequestIDX as '번호',UserName as '신청인',UserPhone  as '전화',WriteDate as '신청일',P1_UserName as '선수',P1_TeamNm as '단체',P1_UserPhone as '전화' " & refundfield
SQL = SQL & ",    '<a href=""javascript:mx.restorePlayer('+CAST(RequestIDX AS varchar(10))+')"" class=""btn btn-primary"">복구</a>'   " &  " from tblGameRequest as a  " & leftjoinstr
SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.level = '"&levelno&"' and  a.delYN = 'Y' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'#############################################


db.Dispose
Set db = Nothing
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'>참가신청삭제명단</h4>
    </div>

    <div class='modal-body'>
      <div class="table-box">

      	<%'=sql%>
      	<%Call rsDrow(rs)%>

      </div>
    </div>

    <div class="modal-footer">
      <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">닫기</button>
    </div>

  </div>
</div>
