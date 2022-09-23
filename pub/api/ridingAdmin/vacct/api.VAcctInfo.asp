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

	SQL = "Select VACCT_NO,STAT_CD,CUST_NM,TR_AMT,IN_BANK_CD,IN_NAME,ENTRY_DATE from SD_RookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '" & Left(sitecode,2) & idx & "' " '결제처리정보가 있다면
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
	  VACCT_NO = rs("VACCT_NO") '가상계좌
	  STAT_CD = rs("STAT_CD") '0 입금완료 1 입금취소 
	  CUST_NM = rs("CUST_NM") '계좌 소유 고객명
	  TR_AMT = rs("TR_AMT") '입금금액
	  IN_BANK_CD = rs("IN_BANK_CD") '입금은행코드
	  IN_NAME = rs("IN_NAME") '입금자명
	  ENTRY_DATE = rs("ENTRY_DATE") '입금일시
	End If
	
    db.Dispose
    Set db = Nothing
%>



  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=idx%>:<%=CUST_NM%>의 가상계좌 <%=VACCT_NO%></h3>
  </div>

	  <div class="modal-body" id="Modaltestbody">
			<table class="sch-table">
				<tbody>
				  <tr>
			  <colgroup>
				<col width="*">
			  </colgroup>              
				<td id = "player1">
				  <span> 계좌소유자명 : <%=CUST_NM%></span>
				  <br><br>
				  <span> 은행 : </span><span>KEB하나은행</span>
				  <br><br>
				  <span> 가상계좌 : </span><span><%=VACCT_NO%></span>
				  <br><br>
				  <span> 입금자명 : </span><span><%=IN_NAME%></span>
				</td>

				<td id="player2">
				  <span> 입금자명 : <%=IN_NAME%></span>
				  <br><br>
				  <span> 입금은행코드 : </span><span><%=IN_BANK_CD%></span>
				  <br><br>
				  <span> 입금금액 : </span><span><%=TR_AMT%>원</span>
				  <br><br>
				  <span> 입금일시 : </span><span><%=ENTRY_DATE%></span>
				</td>

				</tbody>
			  </table>

	  </div>

	  <div class="modal-footer" style="text-align:center;">
		<button class="btn" data-dismiss="modal" aria-hidden="true" style="width:100%;height:100%;">닫기</button>
	  </div>




