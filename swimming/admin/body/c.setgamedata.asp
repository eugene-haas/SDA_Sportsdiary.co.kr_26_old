<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
'with cte_gameLv As (
'	Select * From (
'		select ROW_NUMBER() Over(Partition By GameTitleIdx Order By RGameLevelIdx) As Idx, 
'		* from tblRgameLevel where DelYN = 'N' And CDA = 'D2' ) As AA Where Idx = 1
')
'
'--select * From cte_gameLv Where Idx = 1
'
'select Lv.CDA, Lv.CDANM, * from sd_gametitle As T
'	Inner Join cte_gameLv As Lv On T.GameTitleIDX = Lv.GameTitleIdx 
'where T.delyn = 'N' 


	'뒤에서 왔을때 체크되는값
	If hasown(oJSONoutput, "CDA") = "ok" then
		F1 =  oJSONoutput.CDA '대분류 코드 D2 경영
	End If
	If hasown(oJSONoutput, "YY") = "ok" then
		F2 =  oJSONoutput.YY
	End If
	'뒤에서 왔을때 체크되는값



	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle as a "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임

	'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수

	setmember = "(select count(*) from sd_gameMember where gametitleidx = a.gametitleidx) as setmember "
	setbase = "(select count(*) from tblGameRequest_TEMP where gametitleidx = a.gametitleidx) as setbase "
	attcnt = " (select count(*) from tblGameRequest as x left join tblGameRequest_r  as y ON x.requestidx = y.requestidx  where x.delyn='N' and x.gametitleidx  = a.gametitleidx ) as attcnt "
	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo, "	 & attcnt & ",exlfile" & ", " & setbase& ", " & setmember

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	strWhere = " DelYN = 'N'   and   entertype = '01' "


	If CDbl(ADGRADE) > 500 then
		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10

	Else
		SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & " and GameE >= getdate() -30 " & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if





'페이지 입력폼 상태 확인
'pageYN = getPageState( "MN0101", "대회정보관리" ,Cookies_aIDX , db)
%>
<%'View ####################################################################################################%>

	  <div class="box-body" id="gameinput_area">

	  </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <!-- <div class="box-header">
              <h3 class="box-title">Hover Data Table</h3>
            </div> -->
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>NO</th>
								<th>년도</th>
								<th>대회명</th>
								<th>신청기간</th>
								<th>진행상태</th>
								<th>참가(명)</th>
								<th>업로드</th>
								<th>기본설정</th>
								<th>참가에넣기</th>
								<th>리셋</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					Do Until rs.eof

						l_gubun = rs(0)
						l_kgame = rs(1)
						Select Case l_kgame 
						Case "03" : l_kgame = "통합"
						Case "01" : l_kgame = "전문"
						Case "02" : l_kgame = "생활"
						End Select 
						l_GameArea = rs(2)
						l_hostname = rs(3)
						l_subjectnm = rs(4)
						l_afternm = rs(5)
						l_sponnm = rs(6)
						l_GameTitleName = rs(7)
						l_summaryURL = rs(8)
						l_gameSize = rs(9) '규모
						l_ranecnt = rs(10)
						l_titleCode = rs(11)
						l_attmoney = rs(12)
						l_chkdates = CDate(rs(13))
						l_chkdatee = CDate(rs(14))
						l_GameS = Replace(rs(13),"-","/") & " - "
						l_GameE = Replace(rs(14),"-","/")

						l_atts = Replace(Left(rs(15),11),"-","/") & Left(setTimeFormat(CDate(rs(15))),5)  & " - "
						l_atte = Replace(Left(rs(16),11),"-","/") & Left(setTimeFormat(CDate(rs(16))),5)
						l_checkatte = CDate(rs(16))
						l_GameType = rs(17)
						Select Case l_GameType 
						Case "01" : l_GameType = "명칭"
						Case "02" : l_GameType = "승인"
						Case "09" : l_GameType = "기타"
						End Select 

						l_EnterType = rs(18)
						l_attTypeA = rs(19)
						l_attTypeB = rs(20)
						l_attTypeC = rs(21)
						l_attTypeD = rs(22)
						l_teamLimit = rs(23)
						l_attgameCnt = rs(24)
						l_idx = rs(25)

						l_ViewState = rs(26) 
						l_ViewStateM = rs(27) 
						l_ViewYN = rs(28) 
						l_MatchYN = rs(29) 
						l_stateNo = rs(30) 
						l_attcnt = rs(31)


						l_exlfile = isNullDefault(rs(32),"")
						l_setbase = rs(33)
						l_setmember = rs(34)

					 %><!-- #include virtual = "/pub/html/swimming/list.setgamedata.asp" --><%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>




		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>




		<!-- s: 콘텐츠 끝 -->


