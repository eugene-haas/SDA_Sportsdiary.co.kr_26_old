<%
'request
	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End If	

	If hasown(oJSONoutput, "LVLIDX") = "ok" then
		levelIDX = oJSONoutput.LVLIDX
	End If	

	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If

	If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
		chkgame = oJSONoutput.chkgame
	End If

	If hasown(oJSONoutput, "adult") = "ok" Then '성인미성인 Y N 부모 동의 문자 발송여부
		adult = oJSONoutput.adult
	End if	
	If hasown(oJSONoutput, "agree") = "ok" Then 
		agree = oJSONoutput.agree
	End if	


	If hasown(oJSONoutput, "groupno") = "ok" Then 
		groupno = oJSONoutput.groupno
	End If	
'request



	Set db = new clsDBHelper

	'##################
	'대회 및 종목 정보
	'##################


	strSort = "  order by b.groupno,a.gameday desc"

	strWhere = "   a.DelYN = 'N' and b.PlayerIDX = " & cbike_pidx  & " and  a.titleIDX = "&tidx & " and c.requestIDX = " & ridx

	tablename = " sd_bikeLevel as a INNER JOIN v_bikeGame_attm as b ON a .titleIDX = b.titleIDX and a.levelIDX = b.levelno "
	tablename = tablename & " INNER JOIN sd_bikeRequest as c ON b.ridx = c.requestIDX "

	strFieldName = "a.titleIDX,a.levelIDX,a.detailtitle,a.gameday,a.booNM,b.gameidx,b.attmidx,b.playeridx,b.gubun,b.groupno,b.myagree,b.myadult,b.p_agree,b.teamtitle,b.pgrade "
	strFieldName = strFieldName & ",c.paymentstate,c.paymentname,c.attmoney,b.playeridx,c.playeridx as reqpidx,c.requestIDX "
	'strFieldName = "*"

	SQL = "Select " & strFieldName & " from "&tablename&" where " & strWhere  & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	attmember = "N"
	If Not rs.eof then

		paymentname = rs("paymentname")
		levelIDX = rs("levelIDX")
		gameidx = rs("gameidx")
		groupno = rs("groupno")

		pidx = rs("playeridx")
		reqpidx = rs("reqpidx")

		If CDbl(pidx) = CDbl(reqpidx) Then
			attmember = "Y"
		End if
	End if

	
	'정보구하기
		fieldstr = "a.GameTitleName,a.GameS,a.GameE,a.GameRcvDateS,a.GameRcvDateE,b.levelno,b.detailtitle,b.gameday,a.entertype,b.sex,b.booNM,b.subtitle "
		SQL = "SELECT TOP 1 "&fieldstr&"  FROM sd_bikeTitle as a INNER JOIN sd_bikeLevel as b ON a.titleIDX = b.titleIDX  where a.titleIDX = " & tidx & " and b.levelIDX = " & levelIDX & " and b.delYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			title = rs("GameTitleName")
			games = Replace(rs("games"),"-",".")
			gamee = Replace(rs("gamee"),"-",".")
			GameRcvDateS = Replace(rs("GameRcvDateS"),"-",".")
			GameRcvDateE = rs("GameRcvDateE")
			detailTitle = rs("detailtitle")
			entertype = rs("entertype")
			If entertype = "E" Then
				enterstr  = "엘리트"
			Else
				enterstr = "생활체육"
			End If
			booNM = rs("booNM")
			subtitle = left(rs("subtitle"),2)
		End If
	'정보구하기

	
	'타입 석어서 보내기
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"



	db.Dispose
	Set db = Nothing
%>

  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">[<%=enterstr%>] <%=title%></h4>
      </div>
      <div class="modal-body">
        <!-- S: player-name -->
        <div class="player-name">
          <span class="txt"><%=booNM%></span>
          <i class="fas fa-chevron-right"></i>
          <span class="txt"><%=subtitle%></span>
          <i class="fas fa-chevron-right"></i>
          <span class="txt"><%=detailTitle%></span>
          <i class="fas fa-chevron-right"></i>
        </div>
        <!-- E: player-name -->

	<%
		' 0 '진행중 (동의또는 결제전)
		' 1 ?결제 확정 눌러준 상태
		' 2 '취소 (환불요청상태)
	%>	
		
		<!-- S: c-btn-box -->
        <div class="c-btn-box">
          <a href='javascript:mx.go(<%=strjson%>, "request_competition_detail.asp")'>
            <i class="fas fa-search"></i>
            <span>상세보기</span>
          </a>

		  <%If CDbl(gubun) < 2 then%>        
			  <%If Cdate(GameRcvDateE) >= Date()  And groupno = "0" Then '환불가능상태라면.%>

			  <%
				Call oJSONoutput.Set("mode", "E" ) '수정상태로 ...
				editstrjson = JSON.stringify(oJSONoutput)			  
			  %>	
			  <a href='javascript:mx.go(<%=editstrjson%>, "request_competition_detail.asp")'>
				<i class="fas fa-exchange-alt"></i>
				<span>팀원변경</span>
			  </a>
			  <%End if%>
		  <%End if%>


<%If abc = "123123" then%>
		  <%If Cdate(GameRcvDateE) >= Date() Then '환불가능상태라면%>                 
		  <a href='javascript:mx.go(<%=strjson%> , "/bike/M_Player/request/payment.asp")' >
            <i class="fas fa-times"></i>
            <span>신청취소</span>
          </a>
		  <%End if%>
<%End if%>



		</div>

        <!-- E: c-btn-box -->

      </div>
      <div class="modal-footer">

	  <!-- <div class="btn-list">
        <a href="#">
          <i></i>
          <span>전화문의</span>
        </a>
        <a href="#">
          <i></i>
          <span>1:1문의</span>
        </a>
      </div> -->


      <div class="esc-btn">
        <a href="#" data-dismiss="modal">닫기</a>
      </div>
      </div>
    </div>
  </div>