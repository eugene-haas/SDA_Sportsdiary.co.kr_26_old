<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX '종목인덱스
	End If
	If hasown(oJSONoutput, "STARTTYPE") = "ok" then
		starttype= oJSONoutput.STARTTYPE
	End If


	Set db = new clsDBHelper



	'본선... 오전이든 오후든....
	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	gametitlecode = " (select top 1 titlecode from sd_gametitle where gametitleidx = a.gametitleidx ) as titlecode "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx    ,gubunam,gubunpm,gameno,gameno2,sexno,cdc,cdb, " & gametitlecode
	SQL = "Select " & fld & " from tblRGameLevel as a where RGameLevelidx =  '"&idx&"'  and cda = 'D2' "


	'Response.write sql

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		gametitlename = rs(3)
		titledetail = rs(0) & " " & rs(1) & " " & rs(2) 
		cdbnm = rs(1)
		tidx = rs(4)
		gbidx = rs(5)
		gubunam = rs(6)
		gubunpm = rs(7)
		gameno = rs(8)
		gameno2 = rs(9)
		sexno = rs(10)
		cdc = rs(11)
		cdb = rs(12)
		titlecode = rs(13)

		If gubunam = "3" Then
			gno = gameno
		End if
		If gubunpm = "3" Then
			gno = gameno2
		End if

'Response.write starttype & "<br>"
'Response.write gubunam  & "<br>"
'Response.write gubunpm  & "<br>"
'Response.write gameno2  & "<br>"

		'####################
		'R01	대회유년
		'R02	대회초등
		'R03	대회중등
		'R04	대회고등
		'R05	대회대학
		'R06	대회일반

		'R07	한국기록
		'R08	일반-참가기록

	Function getRcode(rstr)
		If InStr(rstr, "유년") > 0 Then
			getRcode = "R01"
		ElseIf InStr(rstr, "초등") > 0 Then
			getRcode = "R02"
		ElseIf InStr(rstr, "중학") > 0 Then
			getRcode = "R03"
		ElseIf InStr(rstr, "고등") > 0 Then
			getRcode = "R04"
		ElseIf InStr(rstr, "대학") > 0 Then
			getRcode = "R05"
		ElseIf InStr(rstr, "일반") > 0 Then
			getRcode = "R06"
		End if
	End Function
	rcode = getRcode(cdbnm)


		'한국기록
			SQL = "select top 1 * from tblRecord  where rctype= 'R07' and cdc = '"&cdc&"' and Sex= '"&sexno&"' and delYN = 'N'  order by rcIDX desc "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

			'한국기록:양재훈(강원도청, 2019광주세계수영선수권대회, 2019) 00:22.26
			If not rs.eof Then
				rcdata = rs("gameresult")
				krcdata = Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
				krcstr = "한국기록:"&rs("username")&"("&rs("teamnm")&", "&rs("titlename")&", "&Left(rs("gamedate"),4)&") "&krcdata&""
			End if
			

		
		'대회기록
			SQL = "select top 1 * from tblRecord  where titlecode = '"&titlecode&"' and rctype= '"&rcode&"' and cdc = '"&cdc&"' and Sex= '"&sexno&"' and delYN = 'N' order by rcIDX desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		    '대회기록:길현중(목운초등학교, 2018MBC배전국수영대회(경영), 2018) 00:28.61
			If not rs.eof Then
				rcdata = rs("gameresult")
				grcdata = Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
				grcstr = "대회기록:"&rs("username")&"("&rs("teamnm")&", "&rs("titlename")&", "&Left(rs("gamedate"),4)&") "&grcdata&""
			End if

		'####################
	End If



	'엑셀출력################
	Response.Buffer = True     
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&gametitlename & "("&titledetail&")" & ".xls"
	'엑셀출력################



  '++++++++++++++++++++++++
  '레인수 가져오기
  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  raneCnt = rs(0) '레인수


  '@@@@@@@@@@@@@
  fld = " gameMemberIDX,gubun,gametime,gametimeend,place,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,tryoutgroupno,tryoutsortNo,tryoutstateno,tryoutresult,roundNo,SortNo,stateno,gameResult,Team,TeamNm,userClass,Sex,requestIDX     ,bestscore,bestOrder,bestCDBNM,bestidx,bestdate,besttitle,bestgamecode,bestArea,tryoutorder,sidonm "

  If starttype = "3" then
	 
	  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by tryoutgroupno,tryoutsortNo asc"
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  joocnt = 0
	  If Not rs.EOF Then
			arrR = rs.GetRows()
			attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
			joocnt = Ceil_a(attcnt / raneCnt) '조수
	  End If

  else	  
	  
	  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' and sortno > 0  order by roundno,sortno asc"
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  joocnt2 = 0
	  If Not rs.EOF Then
			arrR = rs.GetRows()
			attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
			joocnt = Ceil_a(attcnt / raneCnt) '조수
	  End If

  End if

  'rowspan 값 구하기 엑셀이 깨진다 정확하지 않으면
  SQL = "select tryoutgroupno, count(*),max(startType) from SD_gameMember where   delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' group by tryoutgroupno order by tryoutgroupno asc  " 'gubun = 1 예선 3 본선
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		Rcnt = rs.GetRows()
		startType = Rcnt(2, 0) '1 예선부터 시작 3 결승부터 시작
  End If

%>


<%'<html xmlns="http://www.w3.org/1999/xhtml">%>
<html lang="ko">
  <head>
  
    <meta charset="utf-8">
    <title></title>

	<style>
      .tbl-match{width:628px;}
      .tbl-match__con{margin:48px 0 0;width:100%;}
      .tbl-match__con span{display:block;width:100%;font-size:15px;font-weight:400px;text-align:right;line-height:24px;}

	  .tbl-match__con__tbl{width:628px;box-sizing:border-box;border-collapse:collapse;border-spacing:0;}
      .tbl-match__con__tbl caption{font-size:15px;font-weight:400px;text-align:left;line-height:24px;}
      .tbl-match__con__tbl th,
      .tbl-match__con__tbl td{line-height:22px;font-size:14px;color:#000;font-weight:400px;border:1 solid #000;text-align:center;}
      .tbl-match__con__tbl th:nth-child(1),
      .tbl-match__con__tbl td:nth-child(1){width:44px;}
      .tbl-match__con__tbl th:nth-child(2),
      .tbl-match__con__tbl td:nth-child(2){width:85px;}
      .tbl-match__con__tbl th:nth-child(3),
      .tbl-match__con__tbl td:nth-child(3),
      .tbl-match__con__tbl th:nth-child(8),
      .tbl-match__con__tbl td:nth-child(8){width:69px;}
      .tbl-match__con__tbl th:nth-child(5),
      .tbl-match__con__tbl td:nth-child(5){width:85px;}
      .tbl-match__con__tbl th:nth-child(6),
      .tbl-match__con__tbl td:nth-child(6),
      .tbl-match__con__tbl th:nth-child(7),
      .tbl-match__con__tbl td:nth-child(7){width:45px;}
    </style>
  </head>
  <body>

<%
	jno = 0
	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

			l_idx = arrR(0, ari)
			l_gubun= arrR(1, ari)
			l_gametime= arrR(2, ari)
			l_gametimeend= arrR(3, ari)
			l_place= arrR(4, ari)
			l_PlayerIDX= arrR(5, ari)
			l_userName= arrR(6, ari)
			l_gbIDX= arrR(7, ari)
			l_levelno= arrR(8, ari)
			l_CDA= arrR(9, ari)
			l_CDANM= arrR(10, ari)
			l_CDB= arrR(11, ari)
			l_CDBNM= arrR(12, ari)
			l_CDC= arrR(13, ari)
			l_CDCNM= arrR(14, ari)
			l_tryoutgroupno= arrR(15, ari) '예선본선 정보를 어떻게 넣을가....두개중 하나는 나오니 공통으로 묶어서 하나의 변수가지고 하자...그건 물어본뒤에 하는걸로
			l_tryoutsortNo= arrR(16, ari)
			l_tryoutstateno= arrR(17, ari)
			l_tryoutresult= arrR(18, ari)
			l_roundNo= arrR(19, ari)
			l_SortNo= arrR(20, ari)
			l_stateno= arrR(21, ari)
			l_gameResult= arrR(22, ari)
			l_Team= arrR(23, ari)
			l_TeamNm= arrR(24, ari)
			l_userClass= arrR(25, ari)
			l_Sex= arrR(26, ari)
			l_requestIDX= arrR(27, ari)
			l_bestscore= arrR(28, ari)
			l_bestOrder = arrR(29, ari)

			l_bestCDBNM= arrR(30, ari)
			l_bestidx = arrR(31, ari)
			l_bestdate = arrR(32, ari)
			l_besttitle= arrR(33, ari)
			l_bestgamecode= arrR(34, ari)
			l_bestArea = arrR(35, ari)
			l_tryoutorder = arrR(36, ari)
			l_sidonm = arrR(37,ari)


			If starttype = "1" Then
				l_tryoutgroupno = l_roundNo
				l_tryoutsortNo = l_SortNo

				'예선기록
				l_rcdata = l_tryoutresult
			End if
		%>

	<%If ari =  0 or prejoo <> l_tryoutgroupno Then%>
    <%If ari > 0 then%>
		  </tbody>
        </table>
      </div>
    </div>
	<%End if%>
	
	<%jno = jno + 1%>
	<div class="tbl-match"  >
      <div class="tbl-match__con">
        <div>&nbsp;</div>
		<div style="text-align:right;"><%=krcstr%></div>
        <div style="text-align:right;"><%=grcstr%></div>
        <table class="tbl-match__con__tbl">
          <caption><%=gno%>-<%=jno%> <%=l_CDBNM%> <%=l_CDCNM%> 결</caption>
          <thead>
            <tr>
              <th>레인</th>
              <th>성명</th>
              <th>시도</th>
              <th>소속</th>
              <th>출전기록</th>
              <th>순위</th>
              <th>기록</th>
              <th>비고</th>
            </tr>
          </thead>
          <tbody>
	<%End if%>


			<tr>
              <td><%=l_tryoutsortNo%></td>
              <th><%=l_username%></th>
              <td><%=l_sidonm%></td>
              <td><%=l_teamnm%> <%=l_userClass%></td>
              <td style="mso-number-format:'\@'"><%Call SetRC(l_rcdata)%></td><!-- 엑셀 숫자문자열 파일깨짐 방지 -->
              <td></td>
              <td></td>
              <td></td>
            </tr>


		<%
		prejoo = l_tryoutgroupno
		Next
	End if
%>

          </tbody>
        </table>
      </div>
    </div>


  </body>
</html>



<%
	Call db.Dispose
	Set db = Nothing
%>