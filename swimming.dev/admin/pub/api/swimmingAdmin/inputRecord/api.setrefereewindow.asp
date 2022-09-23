<%
'#############################################
' 구간기록 모달창 리스트
'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" Then 'tblRGameLevel.RGameLevelidx
		lidx = oJSONoutput.LIDX
	End If

	If hasown(oJSONoutput, "AMPM") = "ok" Then
		ampm = oJSONoutput.AMPM
	End If

	If hasown(oJSONoutput, "GUBUN") = "ok" Then
		gubun = oJSONoutput.GUBUN '예선 결승 구분값 1, 3
	End If

	If hasown(oJSONoutput, "SORT") = "ok" Then
		fldsort = oJSONoutput.SORT
	End If

	'경기번호는

	Set db = new clsDBHelper




'
'	'자기정보 AM
'	If ampm = "am" Then
'		fld = "RgameLevelidx,gametitleidx, gubunam,tryoutgamedate,tryoutgamestarttime,gameno,tryoutgameingS,gbidx,cda,cdc  " '52부터
'
'		gnostr = " gameno "
'		tmstr = " tryoutgamestarttime "
'		gubunstr = " gubunam "
'		dtstr = " tryoutgamedate "
'	Else
'		fld = "RgameLevelidx,gametitleidx, gubunpm,finalgamedate,finalgamestarttime,gameno2,finalgameingS,gbidx,cda,cdc   "
'
'		gnostr = " gameno2 "
'		tmstr = " finalgamestarttime "
'		gubunstr = " gubunpm "
'		dtstr = " finalgamedate "
'	End if
'
'	fldb = "b."& Replace(fld,",",",b.")
'
'	  SQL = "Select "&fld&" from tblRGameLevel where RgameLevelidx = " & lidx
'	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	  If Not rs.EOF Then
'			arrI = rs.GetRows()
'	  End If
'
'	'Call getrowsdrow(arrI)
'
'
'	If IsArray(arrI) Then
'		For ari = LBound(arrI, 2) To UBound(arrI, 2)
'			tidx =  arrI(1,ari)
'			'gubun = arrI(2,ari) '예선 결승 1,3
'			sexno = arrI(2,ari)
'			gamedate = arrI(3,ari) '경기일자
'			starttim = arrI(4,ari) '시작시간
'			gno = arrI(5, ari) '경기번호
'			gameing = arrI(6, ari) '내경기시간
'			gbidx = arrI(7,ari)
'			cda = arrI(8,ari) '종목코드
'			chk_cdc  = arrI(9,ari)
'		Next
'	End if
'
'
'	Select Case cda
'	Case "E2" '다이빙
'		'Response.write chk_cdc
'		#include virtual = "/pub/api/swimmingAdmin/inputRecord/api.gamelist_E2.asp" 
'		Response.End
'	Case "F2" '아티스틱
'		'Response.write chk_cdc
'		 #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.gamelist_F2.asp" 
'		Response.end
'	Case "D2"
'	End  Select
'
'
'
'
'
'
'  '레인수 가져오기
'  SQL = "select ranecnt,gametitlename,titlecode from sd_gametitle where gametitleidx = " & tidx
'  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'  raneCnt = rs(0) '레인수
'  gametitlename = rs(1)
'  titlecode = rs(2)
'
'  'startType 가져오기 (시작이 예선인지 결승인지 1, 3)
'  SQL = "Select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "
'  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'  starttype = rs(0)
'
'
'	'G1firstRC				'(예선/본선) as a 첫주자기록 (단체)
'	'G2firstRC				'(본선) as b 첫주자기록 (단체)
'
'	'G1korSin				'a 한국신기록
'	'G1gameSin				'a 대회신기록
'	'G1firstmemberSin		'a 첫주자신기록(단체)
'
'	'G2KorSin				'b 한국신기록
'	'G2gameSin				'b 대회신기록
'	'G2firstmemberSin		'b 첫주자신기록 (단체)
'
'  patnercntfld = " ,(select count(*) from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and delyn = 'N'  and odrno < 5 ) as ptncnt "
'  addfld = " ,G1firstRC,G1korSin,G1gameSin,G1firstmemberSin,G2firstRC,G2KorSin,G2gameSin,G2firstmemberSin "
'
'  fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea,a.startType,		a.ksportsno,a.kno,a.sidonm   ,a.tryouttotalorder,a.tryoutOrder,a.gameOrder "
'
'  fld = fld & "," & fldb & addfld  & patnercntfld   '53번부터 cda, cdc 추가 해서 2개 밀었음..
'
'
'   ' a.tryoutsortno > 0 and a.sortno > 0 레인번호가 설정된 값만 가져오자
'  tbl = " SD_gameMember as a inner join tblRGameLevel as b	 ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N' and b.delYN = 'N' "
'
'  'SQL = SQL & " case when a.tryoutgroupno = 0 then a.RoundNo else a.tryoutgroupno end asc,case when a.tryoutgroupno = 0 then a.SortNo else a.tryoutsortno end asc "
'  '예선 본선구분 #####################
'
'
'
'  If gubun = "1"  Then '예선 (starttype)
'	SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and a.starttype = 1 and  a.tryoutsortno > 0 and b.RgameLevelidx = "&lidx&"  order by "
'
'	'여기 상황에 따라서 잘불러야한다.
'	If fldsort = "" then
'	SQL = SQL & " a.tryoutgroupno asc, a.tryoutsortno asc "
'	Else
'	SQL = SQL & " a.tryoutgroupno asc, a.tryoutOrder asc "
'	End if
'
'
'  Else '결승
'
'	If starttype = "1" Then '예선부터 시작한 결승
'		SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and  a.starttype =1 and a.sortno > 0  and b.RgameLevelidx = "&lidx&" order by "
'
'	  '여기 상황에 따라서 잘불러야한다.
'	  If fldsort = "" then
'	  SQL = SQL & " a.RoundNo asc, a.SortNo asc "
'	  Else
'	  SQL = SQL & " a.RoundNo asc, a.gameOrder asc "
'	  End if
'
'	Else '바로 결승
'
'		SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and a.starttype = 3 and  a.tryoutsortno > 0 and b.RgameLevelidx = "&lidx&"  order by "
'		If fldsort = "" then
'		SQL = SQL & " a.tryoutgroupno asc, a.tryoutsortno asc "
'		Else
'		SQL = SQL & " a.tryoutgroupno asc, a.tryoutOrder asc "
'		End if
'
'	End if
'
'  End If
''SQLPrint = SQL & "--"
'  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'  '예선 본선구분 #####################
'	'Response.write sql
'	'Call rsdrow(rs)
'	'Response.end
'
'	If Not rs.EOF Then
'		arrR = rs.GetRows()
'		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
'		joocnt = Ceil_a(attcnt / raneCnt) '조수
'		startType = arrR(36, 0) '1 예선부터 시작 3 결승부터 시작
'
'		boonmstr = arrR(12,0)
'		kindstr = arrR(14,0)
'		cdcstr =  arrR(13,0)
'
'		If startType = "1" Then
'			startstr = "예선경기"
'		Else
'			startstr = "결승경기"
'		End if
'	End If
'
'
'	'사유코드 가져오기#####################
'	  SQL = "select code,codeNm from tblCode  where gubun = 2 and CDA = '"&cda&"' and delyn = 'N'  order by sortno asc"
'	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	  If Not rs.EOF Then
'			arrC = rs.GetRows()
'	  End if
'	'사유코드 가져오기#####################
'
'
'
'
'  '구간기록 코드가져오기
'  '구간 필드 만들기
'
'	  sectionwhere = " a.delyn = 'N' and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "
'	  SQL = "select b.* from sd_gameMember as a inner join sd_gameMember_sectionRecord as b on a.gameMemberIDX = b.gameMemberidx and b.AMPM = '"&Ucase(ampm)&"' and b.delyn='N' where " & sectionwhere
'	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	  If Not rs.EOF Then
'		arrSec = rs.GetRows()
'	  End if
'
'
''한국기록
'	SQL = "select top 1 * from tblRecord  where rctype= 'R07' and cdc = '"&cdcstr&"' and Sex= '"&sexno&"' and delYN = 'N'  order by rcIDX desc "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	'한국기록:양재훈(강원도청, 2019광주세계수영선수권대회, 2019) 00:22.26
'	If not rs.eof Then
'		rcdata = rs("gameresult")
'		krcdata = Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
'		krcstr = "한국기록:"&rs("username")&"("&rs("teamnm")&", "&rs("titlename")&", "&Left(rs("gamedate"),4)&") "&krcdata&""
'	End if
'
'
'	Function getRcode(rstr)
'		If InStr(rstr, "유년") > 0 Then
'			getRcode = "R01"
'		ElseIf InStr(rstr, "초등") > 0 Then
'			getRcode = "R02"
'		ElseIf InStr(rstr, "중학") > 0 Then
'			getRcode = "R03"
'		ElseIf InStr(rstr, "고등") > 0  Then
'			getRcode = "R04"
'		ElseIf InStr(rstr, "대학") > 0 Then
'			getRcode = "R05"
'		ElseIf InStr(rstr, "일반") > 0 Then
'			getRcode = "R06"
'		End if
'	End Function
'	rcode = getRcode(boonmstr)
'
'
''대회기록
'	SQL = "select top 1 * from tblRecord  where titlecode = '"&titlecode&"' and rctype= '"&rcode&"' and cdc = '"&cdcstr&"' and Sex= '"&sexno&"' and delYN = 'N' order by rcIDX desc"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'
'	'대회기록:길현중(목운초등학교, 2018MBC배전국수영대회(경영), 2018) 00:28.61
'	If not rs.eof Then
'		rcdata = rs("gameresult")
'		grcdata = Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
'		grcstr = "대회기록:"&rs("username")&"("&rs("teamnm")&", "&rs("titlename")&", "&Left(rs("gamedate"),4)&") "&grcdata&""
'	End if
'
'
'
'
'
'		
'		If isarray(arrR) = True then
'		For ari = LBound(arrR, 2) To UBound(arrR, 2)
'			If ari = 0 then
'			del_midx = arrR(0, ari) 'midx
'			Else
'			del_midx = del_midx  & "," &  arrR(0, ari) 'midx
'			end if
'		Next 
'		End If


%>


<div class="modal-dialog modal-xl">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		  <h4 class="modal-title" id="myModalLabel"><span>대회 진행 심판 배정</span></h4>
		</div>
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

		<div class="modal-body">




			<div class="row">
				<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
					  <div class="form-group">

						<div class="input-group date">
							 <input type="text" id="F2" placeholder="심판명검색" value="" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'players.asp')}">
							<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'players.asp')">
							  <i class="fa fa-fw fa-search"></i>
							</div>
						</div>

						<div>
							심판1<br>
							심판2<br>
							심판3<br>
							심판3<br>
							심판3<br>
						</div>

					  </div>
				</div>
			</div>







			<div id="Modaltestbody" >
            <div class="box-body" style="overflow-x:hidden;" id="swtable">



		<div style="width:50%;float:left;">
			<table border="0" style="width:100%;">
			<tr>
				<td style="padding:5px;background:#D9D9D9;"><%=gametitlename%></td>
			</tr>
			</table>
		</div>

		<div style="width:50%;float:left;">
			<table border="0" style="width:100%;">
			<tr>
				<td style="padding:5px;background:#D9D9D9;"><%=krcstr%></td>
			</tr>
			<tr>
				<td  style="padding:5px;"><%=grcstr%></td>
			</tr>
			</table>
		</div>

		  <table id="swtable_<%=lidx%>" class="table table-bordered table-hover" >

				<thead class="bg-light-blue-active color-palette">
						<tr>
							<th>번호</th>
							<th>심판명</th>
							<th>삭제</th>
							<th style="background:white;"></th>
							<th>번호</th>
							<th>심판명</th>
							<th>삭제</th>

						</tr>
					</thead>
					
					<tbody id="contest"  class="gametitle">
						<%
							If isArray(arrR) then
								For ari = LBound(arrR, 2) To UBound(arrR, 2)

									l_midx = arrR(0, ari) 'midx
								Next
							End if
						%>
					</tbody>

			</table>


            </div>





		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

	</div>
</div>
</div>
</div>





<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
