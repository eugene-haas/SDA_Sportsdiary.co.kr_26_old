<%
'StateNo  게임 종료등 999

	idx = oJSONoutput.IDX 'tblRGameLevel idx

	If hasown(oJSONoutput, "GAMEMEMBERIDX") = "ok" then
		GAMEMEMBERIDX = oJSONoutput.GAMEMEMBERIDX
		tidx = oJSONoutput.TitleIDX 
		title = oJSONoutput.Title
		teamnm = oJSONoutput.TeamNM
		areanm = oJSONoutput.AreaNM
		stateNo = oJSONoutput.StateNo
		S3KEY = oJSONoutput.S3KEY
		P1 = oJSONoutput.P1
		JONO = oJSONoutput.JONO
		PLAYERIDX = oJSONoutput.PLAYERIDX
		PLAYERIDXSub = oJSONoutput.PLAYERIDXSub
		EndGroup = oJSONoutput.EndGroup
	Else
		GAMEMEMBERIDX = -1	
	End if 

	If hasown(oJSONoutput, "POS") = "ok" then
		pos = oJSONoutput.pos
	End if 




  '타입 석어서 보내기
  Call oJSONoutput.Set("result", "0" )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"


    Set db = new clsDBHelper

	SQL = "Select VACCT_NO, PAY_AMT,CUST_CD,CUST_NM,USER_NM from SD_RookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '" & Left(sitecode,2) &  idx & "' " '결제처리정보가 있다면
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'	SQL = "Select VACCT_NO,STAT_CD,CUST_NM,TR_AMT,IN_BANK_CD,IN_NAME,ENTRY_DATE from TB_RVAS_LIST where CUST_CD = '" & idx & "' " '결제처리정보가 있다면
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
	  VACCT_NO = rs("VACCT_NO") '가상계좌
	  PAY_AMT = rs("PAY_AMT") '입금금액
	  CUST_NM = rs("USER_NM") '계좌 소유 고객명  //CUST_NM 한국테니스진흥회
	  CUST_CD = rs("CUST_CD") '신청자 키
	End If

	qtitle = " (select top 1 gametitlename from sd_tennisTitle where gametitleidx = a.gametitleidx ) as gametitle "
	SQL = "Select  "&qtitle&",gametitleidx,level,userName,userphone,p1_username,p1_userphone,p2_username,p2_userphone from tblGameRequest as a where RequestIDX = '" & idx & "' " '결제처리정보가 있다면
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
	  gametitle = rs("gametitle")
	  uname = rs("userName")
	  uphone = rs("userphone")
	  p1name = rs("p1_userName")
	  p1phone = rs("p1_userphone")
	  p2name = rs("p2_userName")
	  p2phone = rs("p2_userphone")
	End If


    db.Dispose
    Set db = Nothing
%>



  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=idx%>:<%=CUST_NM%>의 가상계좌 문자발송</h3>
  </div>

	  <div class="modal-body" id="Modaltestbody">
			<table class="sch-table">
				<tbody>
				  <tr>
			  <colgroup>
				<col width="*">
			  </colgroup>              
				<td id = "player1">
				  <span> 대회 : </span><span><%=gametitle%></span>
				  <br><br>
				  <span> 계좌소유자명 : <%=CUST_NM%></span>
				  <br><br>
				  <span> 은행 : </span><span>KEB하나은행</span>
				  <br><br>
				  <span> 가상계좌 : </span><span><%=VACCT_NO%></span>
				</td>


<input type="hidden" id = "gtitle" value="<%=gametitle%>">
<input type="hidden" id = "accno" value="<%=VACCT_NO%>">
<input type="hidden" id = "payamt" value="<%=PAY_AMT%>">
<input type="hidden" id = "uname"  value="<%=uname%>">
<input type="hidden" id = "uphone" value="<%=uphone%>">
<input type="hidden" id = "p1name"  value="<%=p1name%>">
<input type="hidden" id = "p1phone" value="<%=p1phone%>">
<input type="hidden" id = "p2name"  value="<%=p2name%>">
<input type="hidden" id = "p2phone" value="<%=p2phone%>">

				<td id="player2">
				  <span> 신청자 : <%=uname%>:<%=uphone%> <a href="javascript:mx.vacctsend(1)" class="btn">문자발송</a></span>
				  <br><br>
				  <span> 선수1 : </span><span><%=p1name%>:<%=p1phone%> <%If p1phone <> "" then%><a href="javascript:mx.vacctsend(2)"  class="btn">문자발송</a><%End if%></span>
				  <br><br>
				  <span> 선수2 : </span><span><%=p2name%>:<%=p2phone%> <%If p2phone <> "" then%><a href="javascript:mx.vacctsend(3)"  class="btn">문자발송</a><%End if%></span>
				  <br><br>
				  <span> &nbsp; </span><span>&nbsp;</span>
				</td>

				</tbody>
			  </table>

	  </div>

	  <div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	  </div>





