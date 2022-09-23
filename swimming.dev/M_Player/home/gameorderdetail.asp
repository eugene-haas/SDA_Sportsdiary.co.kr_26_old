<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%=CONST_HTMLVER%>
<%
	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "TIDX") = "ok" then
			tidx = fInject(oJSONoutput.TIDX)
		End if
		If hasown(oJSONoutput, "LNO") = "ok" then
			levelno = fInject(oJSONoutput.LNO)
		End If
		If hasown(oJSONoutput, "LIDX") = "ok" then
			lidx = fInject(oJSONoutput.LIDX)
		End if	
		If hasown(oJSONoutput, "JOONO") = "ok" Then '예선 조번호
			joo = fInject(oJSONoutput.JOONO)
		End if	
		If hasown(oJSONoutput, "TABNO") = "ok" Then '오전 오후 1,3
			tabno = fInject(oJSONoutput.TABNO)
		Else
			tabno = "1"
		End if	
		If hasown(oJSONoutput, "DD") = "ok" Then 
			gamedate = fInject(oJSONoutput.DD)
		End if	
	End if

	If tabno = "4" Then
		tabno = "1"
		orgtabno = "4"
	End If
	If tabno = "6" Then
		tabno = "3"
		orgtabno = "6"
	End If


	If isnumeric(tidx) = false Then
		Response.end
	End if

		SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			title = rs(0)
			gameS = rs(1)
			gameE = rs(2)
			gamearea = rs(3)
		End if


'		starttypeq = "(select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = a.gametitleidx and levelno = a.levelno ) "
'		fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2, b.cd_booNm_short, b.orderby,resultopenAMYN,resultopenPMYN,gameno,gameno2, " &starttypeq
'		strWhere = " a.RGameLevelidx = "&lidx&" and b.cd_type = 2 and a.delyn= 'N'  "
'
'		SQL = "Select top 1 " & fld & " from tblRGameLevel as a inner join tblTeamGbInfo as b on a.cdb = b.cd_boo and b.delyn = 'N' where " & strWhere

		starttypeq = "(select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = a.gametitleidx and levelno = a.levelno ) "
		fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2,resultopenAMYN,resultopenPMYN,gameno,gameno2, " &starttypeq
		strWhere = " a.RGameLevelidx = "&lidx&"  and a.delyn= 'N'  "

		SQL = "Select top 1 " & fld & " from tblRGameLevel as a where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If Not rs.EOF Then
			fr = rs.GetRows()

			If IsArray(fr) Then 
				'오전경기에서 예선찾기
					gubunam = fr(12,0)
					gubunpm = fr(13,0)
					'starttype = fr(22,0)
					starttype = fr(20,0)
					CDCNM =  fr(10,0)
					'CDBNMS = fr(16,0)
					CDBNMS = fr(10,0)

					If tabno = "1" Then '오전경기
						fldtype = "tryout"

						joono = fr(14,ari)
						openRC = fr(16, 0)
						gameno = fr(18,0)
						joocnt = fr(14,0)

						If gubunam = "1" Then
							'openRC = fr(18, 0)
							'gameno = fr(20,0)
							ampm = "am"
							tabstr = "예선"
						Else
							tabstr = "결승"
						End If
					
					Else '오후경기
						If starttype = "3" Then
						fldtype = "tryout"
						Else
						fldtype = "final"
						End if



						'오후경기에서 예선찾기
						'If joono = "" then
						joono = fr(15,0)
						openRC = fr(17, 0)
						gameno = fr(19,0)
						joocnt = fr(15,0)
						ampm = "pm"

						If gubunpm = "3" Then
							'openRC = fr(19, 0)
							'gameno = fr(21,0)
							tabstr = "결승"
						Else
							tabstr = "예선"
						End If
						'End If					 
					End if


			End if			
		End If


		If fldtype = "tryout" Then
			'tblRGameLevel.resultopenAMYN '오픈여부
			fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "
			fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryoutorder,tryoutresult,tryouttotalorder "
			SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutgroupno = '"&joo&"' and tryoutsortno > 0 order by tryoutsortno asc"
		
		Else
			'starttype 에 따라서
			'tblRGameLevel.resultopenPMYN
			fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "
			fld = " sortno,"&fldnm&",sidonm,teamnm,userClass,gameorder,gameresult,gameorder " '결선에 올라온 팀은 하나이다 결승으로 시작된건 3으로 시작된건 위에서 나온다 여긴 gametotalorder는 안쓴다 음 기억을 더듬어서 써둠. 확실한걸까
			SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and roundno = '"&joo&"' and sortno > 0  order by sortno asc"
		End if
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If rs.eof Then
			rseofmsg = "레인이 베정 되지 않았습니다."
			'레인베정이 되지 않았습니다.
		Else
			arr = rs.GetRows()
		End if			


	selectval = lidx &"_"& levelno



	weekarr = array("-", "일","월","화","수","목","금","토")
%>


<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->

    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/default.css">
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/Player_home.info.css">
	<link rel="stylesheet" href="/css/sw_home.style.min.css?9"> 
	<script src="/js/sw.home.js?1"></script>



	<link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>

    <script type="text/javascript">
    // group의 버튼의 가로사이즈 총합을 ul의 가로사이즈로 설정
    $(document).ready(function(){
      var liWidth = $('.match-info__list-group__btns').outerWidth() + 10,
      liLength = $('.match-info__list-group li').length;
      $('.match-info__list-group').css({
        width: liWidth * liLength - 10
      });
    });
    </script>
</head>


<body <%=CONST_BODY%>>

<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id = "tidx" value="<%=tidx%>">







	<%h1str = "선수/결과"%>
	<!-- #include virtual = "/home/include/header.home.asp" -->

    <!-- s 메인 영역 -->
      <div class="l_main">

		<section class="l_main__contents"> 
          <div class="list-pro"style=" padding-top:20px;">



			  <h2 class="match-info-tit">
				  <span class="match-info-tit__date"><%=gamedate%> (<%=weekarr(weekday(gamedate))%>)</span><br>
				  <p class="match-info-tit__con clear">
					<span class="match-info-tit__con__span" id="spanNumMatchRecord"><%=gameno%>-<%=joocnt%></span>
					<span class="match-info-tit__con__span" id="spanGenderMatchRecord"><%=CDBNMS%></span>
					<span class="match-info-tit__con__span" id="spanTypeMatchRecord"><%=CDCNM%> [<%=tabstr%>]</span>
				    <button type="button" onclick="javascript:history.back();" style="float:right;" class="list-pro__search__btn">목록보기</button>
				  </p>


			  </h2>











		<div class="list-pro__search clear" style="padding-top:0px;">
		  
		  <div class="list-pro__search__selc-box" style="margin:0px;width:100%;">


		<span id="sw_gametable">


			<div class="match-info__list-box">
				<ul class="match-info__list-group clear">
				  <!-- s_on = button 파란색으로 -->
				<%For i = 1 To joono%>
					<li <%If i  = CDbl(joo) then%>class="s_on"<%End if%>><button class="match-info__list-group__btns" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i%>,<%=orgtabno%>)"><%=i%>조</button></li>
				<%next%>
				</ul>
				<%If rseofmsg <> "" then%>
				<br><%=rseofmsg%>
				<%End if%>
			</div>


			<%'##########################%>
			<div class="match-info-con" id="'sw_searchboo">
			<div class="match-info-con__tab-box">
			  <h3 class="hide">선수보기 표</h3>

			  <table class="match-info-con__tab-box__con">
				<thead class="match-info-con__tab-box__con__thead">
				  <tr>
					<th>레인</th>
					<th>선수명</th>
					<th>시도</th>
					<th>소속</th>
					<th>기록</th>
					<th>총 순위</th>
<!-- 					<th>총 순위</th> -->
				  </tr>
				</thead>
				<tbody class="match-info-con__tab-box__con__tbody">
				  <!-- s_highlight = 1,2위 꾸며줌 -->
				  <!-- s_yellow = 이름 노란색으로 -->
					<%
							If IsArray(arr) Then 
								For ari = LBound(arr, 2) To UBound(arr, 2)

									l_rane = arr(0, ari) 'idx
									l_nm = arr(1, ari)
									l_sidonm= arr(2, ari)
									l_teamnm= arr(3, ari)
									l_class = arr(4, ari)
									
									l_order= arr(5, ari)
									l_rc = arr(6, ari)
									l_totalorder = arr(7,ari)

									%>
								  <tr>
									<td>﻿<%=l_rane%></td>
									<td><span><%=l_nm%></span></td>
									<td><%=l_sidonm%></td>
									<td><%=shortNm(l_teamnm)%></td>
									<td><%If openRC = "Y" then%><%Call SetRC(l_rc)%><%else%>-<%End if%></td>
									<td><%If openRC = "Y" then%><%=l_totalorder%><%else%>-<%End if%></td>
<!-- 									<td><span>-</span></td> -->
								  </tr>
									<%
								Next 
							End if
					%>
				</tbody>
			  </table>
			</div>
			</div>
			<%'##########################%>



		</span>

		
		
		
		  </div>		
		</div>













			



          </div>
        </section>
      </div>
    <!-- e 메인 영역 -->


  </body>


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>




