<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
  'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "DIDX") = "ok" then
		didx= oJSONoutput.DIDX
	End if

  'request 처리##############




	Set db = new clsDBHelper

	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx "

	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and gametitleidx =  '"&tidx&"' and CDA='D2' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		title = rs(3)
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2) 
		tidx = rs(4)
		gbidx = rs(5)
	End If


	'설정날짜
	SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & "  order by gamedate"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rss.EOF Then
		tmarr = rss.GetRows()
		last_gamedate= tmarr(1, UBound(tmarr, 2))
	End If

	If IsArray(tmarr) Then 
		For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
			
			idx = tmarr(0,ari)
			tm_selectflag = tmarr(4, ari)
			If ari = 0 Then
				start_gamedate = Replace(isNullDefault(tmarr(1, ari), ""),"/","-")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If
			
			If CStr(didx) = CStr(idx) Then
				dayno = ari + 1
				start_gamedate = Replace(isNullDefault(tmarr(1, ari), ""),"/","-")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If

		Next 
	End if


  '++++++++++++++++++++++++
  fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm "
  If start_gamedate = "" Then
	'날짜 생성전
  else

	'오전 오후 두개 가져오자.
	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0) order by gameno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (finalgamedate = '"&start_gamedate&"' and finalgameingS > 0)    order by gameno2 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR2 = rs.GetRows()
	End If

  End if


	weekarr = array("-", "일","월","화","수","목","금","토")


		'엑셀출력################
		Response.Buffer = True     
		Response.ContentType = "application/vnd.ms-excel"
		Response.CacheControl = "public"
		Response.AddHeader "Content-disposition","attachment;filename="&title & "("&lnm&")" & ".xls"
		'엑셀출력################
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>
      .tbl-list{width:700px;}
      .tbl-list__header{margin:88px 0 32px;display:block;width:100%;font-size:23px;font-weight:bold;text-align:center;line-height:1;}
      .tbl-list__con{display:flex;justify-content:space-between;width:100%;}

	  .tbl-list__con__tbl{width:345px;box-sizing:border-box;border-collapse: collapse;border-spacing:0;}
      .tbl-list__con__tbl thead tr:nth-child(2) th{font-weight:bold;}
      .tbl-list__con__tbl th,
      .tbl-list__con__tbl td{line-height:28px;font-size:14px;color:#000;font-weight:400;border:1px solid #000;text-align:center;}
      .tbl-list__con__tbl th:nth-child(1),
      .tbl-list__con__tbl td:nth-child(1){width:81px;}
      .tbl-list__con__tbl th:nth-child(2),
      .tbl-list__con__tbl td:nth-child(2){width:60px;}
      .tbl-list__con__tbl th:nth-child(4),
      .tbl-list__con__tbl td:nth-child(4){width:50px;}
    </style>
  </head>
  <body>


    <div class="tbl-list">
	  <div>&nbsp;</div>
	  <div class="tbl-list__header">제<%=dayno%>일 경영 경기순서 (<%=month(start_gamedate)%>월 <%=day(start_gamedate)%>일)</div>
	  <div>&nbsp;</div>

	  <div class="tbl-list__con">


		<table>
		<tr>
		<td style="width:700px;">

		<table class="tbl-list__con__tbl">
          <thead>
            <tr>
              <th>경기순서</th>
              <th>부 별</th>
              <th colspan="2">종 &nbsp;&nbsp;&nbsp; 목</th>
            </tr>
            <tr>
              <th colspan="2">오전 경기</th>
              <th colspan="2"><%=start_am%> AM</th>
            </tr>
          </thead>
          <tbody>
			<%
				weekarr = array("-", "일","월","화","수","목","금","토")
				
				If IsArray(arrR) Then 
				lastno = UBound(arrR, 2)
					For ari = LBound(arrR, 2) To UBound(arrR, 2)

						l_idx = arrR(0, ari)
						l_GbIDX = arrR(1, ari)
						l_ITgubun = arrR(2, ari)
						l_CDA = arrR(3, ari)
						l_CDANM = arrR(4, ari)
						l_CDB = arrR(5, ari)
						l_CDBNM = arrR(6, ari)
						l_CDC = arrR(7, ari)
						l_CDCNM = arrR(8, ari)
						l_SetBestScoreYN = arrR(9, ari)
						l_tryoutgamedate = arrR(10, ari)
						l_tryoutgamestarttime = arrR(11, ari)
						l_tryoutgameingS = arrR(12, ari)
						l_finalgamedate = arrR(13, ari)
						l_finalgamestarttime = arrR(14, ari)
						l_finalgameingS = arrR(15, ari)
						l_gameno = arrR(16, ari)
						l_joono = arrR(17, ari)
						l_week = weekarr(weekday(l_tryoutgamedate))

						l_gubun = arrR(20, ari)
						If l_gubun = "1" Then
						gubunstr = "예"
						Else
						gubunstr = "결"
						End if
				%>
						<tr>
						  <th><%=l_gameno%>-<%=l_joono%></th>
						  <td><%=shortBoo(l_CDBNM)%></td>
						  <td><%=l_CDCNM%></td>
						  <td><%=gubunstr%></td>
						</tr>	
				<%
					pre_gameno = r_a2
					Next
				End if
			%>
          </tbody>
        </table>

		</td>
		<td style="width:10px;">&nbsp;</td>
		<td>

		<table class="tbl-list__con__tbl" style="width:100%;">
          <thead>
            <tr>
              <th>경기순서</th>
              <th>부 별</th>
              <th colspan="2">종 &nbsp;&nbsp;&nbsp; 목</th>
            </tr>
            <tr>
              <th colspan="2">오후 경기</th>
              <th colspan="2"><%=start_pm%> PM</th>
            </tr>
          </thead>
          <tbody>

<%
	If IsArray(arrR2) Then 
	lastno = UBound(arrR2, 2)
		For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

			l_idx = arrR2(0, ari)
			l_GbIDX = arrR2(1, ari)
			l_ITgubun = arrR2(2, ari)
			l_CDA = arrR2(3, ari)
			l_CDANM = arrR2(4, ari)
			l_CDB = arrR2(5, ari)
			l_CDBNM = arrR2(6, ari)
			l_CDC = arrR2(7, ari)
			l_CDCNM = arrR2(8, ari)
			l_SetBestScoreYN = arrR2(9, ari)
			l_tryoutgamedate = arrR2(10, ari)
			l_tryoutgamestarttime = arrR2(11, ari)
			l_tryoutgameingS = arrR2(12, ari)
			l_finalgamedate = arrR2(13, ari)
			l_finalgamestarttime = arrR2(14, ari)
			l_finalgameingS = arrR2(15, ari)
			l_gameno = arrR2(16, ari)
			l_joono = arrR2(17, ari)

			l_gameno2 = arrR2(18, ari)
			l_joono2 = arrR2(19, ari)

			l_week = weekarr(weekday(l_finalgamedate))

			l_gubun = arrR2(21, ari)
			If l_gubun = "1" Then
			gubunstr = "예"
			Else
			gubunstr = "결"
			End if

	%>
			<tr>
              <th><%=l_gameno2%>-<%=l_joono2%></th>
              <td><%=shortBoo(l_CDBNM)%></td>
              <td><%=l_CDCNM%></td>
              <td><%=gubunstr%></td>
            </tr>	
	<%

		pre_gameno = r_a2
		Next
	End if
%>


          </tbody>
        </table>

		</td>
		</tr>
		</table>
  
	  
	  </div>
    </div>

  </body>
</html>



<%
	Call db.Dispose
	Set db = Nothing
%>