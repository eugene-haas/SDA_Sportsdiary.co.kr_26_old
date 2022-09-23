<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	tidx = oJSONoutput.get("TIDX")
  reqtidx = tidx
	skey = oJSONoutput.get("SKEY") '관리자 지정 시작키 '-' 구분자가 있어야한다.
	'F1 = oJSONoutput.get("F1")
	'F2 = oJSONoutput.get("F2")

  if F1 = "" then
    F1 = "D2"
  end if



  'request 처리##############
  
'페이지 입력폼 상태 확인
hideno = "MN0212"
pageYN = getPageState( hideno, "상장" ,Cookies_aIDX , db)
%>
<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC': '<%=hideno%>'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

    		<div class="box-body" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/swimming/crapeform.asp" -->
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="row">
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<input type="text" calss="form-control" value="<%=SKEY%>" id="startkey">
										<a href='javascript:px.goSubmit({"F1":$("#F1").val(),"F2":$("#F2").val(),"TIDX":<%=reqtidx%>,"SKEY":$("#startkey").val()}, "<%=pagename%>")' id="btnsave" class="btn btn-primary">상장번호생성</a>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										<input type="text" calss="form-control" value="<%=LINECNT%>" id="linecnt">
										<a href="javascript:mx.print(<%=reqtidx%>,'<%=F1%>','<%=F2%>', $('#linecnt').val());" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 내용줄수 반영 인쇄</a>
								  </div>
							</div>
						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">

						<tr>
								<th><input type="checkbox" id="checkAll"  onclick="px.checkAll($(this))"></th>
								<th>상장번호</th>
								<th>세부종목</th>
								<th>종별</th>
								<th>이름</th>
								<th>소속팀</th>
								<th>순위</th>
								<th>기록</th>
								<th>상장종류</th>                
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

<%

if F2 <> "" then
  '상장번호 자동생성 상장테이블을 만들고 밀어넣자.
	SQL = "select titlecode from sd_gameTitle where gametitleidx = "&reqtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	

  SQL = ""
  SQL = SQL & "Select "
	SQL = SQL & " (case when max(first_key) is null then (select TOP 1  IDX from sd_gameMember_crape_key WHERE TITLECODE IS NULL) else '0' end) as updatekey   , "
	SQL = SQL & " (case when max(first_key) is null then (select TOP 1  CRAPE_KEY from sd_gameMember_crape_key WHERE TITLECODE IS NULL) else max(first_key) end) as titlekey  , "
	SQL = SQL & " (case when max(second_num) is null then 0 else max(second_num) end) as incno ,max(a.titlecode) as titlecode "

	'SQL = SQL & " (case when max(first_key) is null then (select TOP 1  CRAPE_KEY from sd_gameMember_crape_key WHERE TITLECODE IS NULL) else max(first_key) end) +  "
	'SQL = SQL & " (FORMAT( case when max(second_num) is null then 1 else max(second_num)+1 end ,'_0000')) "

	SQL = SQL & " from sd_gameTitle as a left join  sd_gameMember_crape_history as b on a.titlecode = b.titlecode  where  a.gametitleidx = " & reqtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	updatekey = rs(0)
	titlekey = rs(1)
	incno = rs(2)
	titlecode = rs(3)

	if updatekey > 0 then
		SQL = "update sd_gameMember_crape_key set titlecode = '"&titlecode&"' where idx = " & updatekey
		Call db.execSQLRs(SQL , null, ConStr)
	end if

	SQL = " insert into sd_gameMember_crape_history (gametitleidx,cda,cdb, titlecode, gamememberidx,first_key,second_num,gameorder,cdc ) "
	
	'SQL = SQL & " select * from "
	'SQL = SQL & " ( "
  SQL = SQL & "select '"&reqtidx&"'as tidx,'"&F1&"' as cd_a,'"&F2&"' as cd_b,titlecode, gamememberidx,first_key,((RANK() OVER (Order By cdc,gameorder)) + "&incno&") as second_num,gameorder,cdc from (" 'gamememberidx 단체인경우도 증가하려면
  SQL = SQL & "select "
  SQL = SQL & " '"&titlecode&"' as titlecode, a.gamememberidx, '"&titlekey&"' as first_key, b.partnerIDX,   "
	SQL = SQL & "(case when starttype = 3 then tryouttotalorder else gametotalorder end ) as gameorder ,a.cdc,c.seq as seq " 'seq로 추가할게 있나 확인
  SQL = SQL & " from sd_gameMember as a left join sd_gameMember_partner as b on a.gamememberidx = b.gamememberidx and b.delyn='N' "   'sd_gameMember_partner 단체는 대회중에 넣지 않으면 선수명을 구할수 없다.
  SQL = SQL & " left join sd_gameMember_crape_history as c on a.gameMemberIDX = c.gamememberidx "
	SQL = SQL & " where a.gametitleidx ="&reqtidx&" and a.cda= '"&F1&"' and a.cdb = '"&F2&"' and a.delyn = 'N' )  as A where gameorder < 4  and seq is null"
	'SQL = SQL & " ) as T "
	'SQL = SQL & "  order by cdc, gameorder "
	'response.write sql
	'response.end

	Call db.execSQLRs(SQL , null, ConStr)


'$$$$$$$$$$$$$$$$$$$$$$$$$
'관리자 생성 번호 만들어서 넣자.
'$$$$$$$$$$$$$$$$$$$$$$$$$
'skey
if instr(skey , "-") > 0 then
	skey = split(skey,"-")
	make_key = skey(0)
	make_num = Cdbl(skey(1)) - 1


	SQL = "Update A Set A.make_key = '"&make_key&"' , A.make_num = A.RowNum From ( Select make_key, make_num, ((RANK() OVER (Order By cdc,gameorder)) + "&make_num&")  as RowNum  from sd_gameMember_crape_history  where gametitleidx = "&reqtidx&" and cda = '"&F1&"' and cdb = '"&F2&"' and gubun = 1 ) as A "
	Call db.execSQLRs(SQL , null, ConStr)	
	'response.write sql
	'response.end		
end if





	'rcok2id <> 'N' 대회신, 한국신 체크 G1korsin G2korsin g1gamesin g2gamesin 
  SQL = ""
  SQL = SQL & "select * from ("

  SQL = SQL & "select "
  SQL = SQL & " (case when itgubun = 'I' then a.userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm, "
	SQL = SQL & " a.team,a.teamnm,starttype, "
  SQL = SQL & " (case when starttype = 3 then tryoutresult else gameResult end ) as gresult,"
  SQL = SQL & " (case when starttype = 3 then tryouttotalorder else gametotalorder end ) as gorder, "
  SQL = SQL & " ITgubun,a.CDA,CDANM,a.CDB,CDBNM,a.CDC,CDCNM,levelno,    "
  SQL = SQL & " a.gamememberidx , first_key , second_num , (first_key + '-' + FORMAT( second_num,'0000000000')) as crape_code , rcok2id, G1korsin, G2korsin, g1gamesin, g2gamesin,  "
	SQL = SQL & " (make_key + '-' + FORMAT( make_num,'0000')) as crape_makecode "	
  'SQL = SQL & " from sd_gameMember as a left join sd_gameMember_partner as b on a.gamememberidx = b.gamememberidx and b.delyn='N'  "
	SQL = SQL & " from sd_gameMember as a "
	SQL = SQL & " left join sd_gameMember_crape_history as c on a.gameMemberIDX = c.gamememberidx "
  SQL = SQL & " where a.gametitleidx ="&reqtidx&" and a.cda= '"&F1&"' and a.cdb = '"&F2&"' and a.delyn = 'N' )  as A where gorder < 4 order by cdc, gorder  "
  
  'response.write sql
  'response.end
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
  If Not rs.EOF Then
		arr = rs.GetRows()
	End If

end if

  'response.write sql
	'Call rsdrow(rs)
	'Response.end

	If IsArray(arr) Then 
		For ari = LBound(arr, 2) To UBound(arr, 2)
			l_usernm= arr(0, ari)			
			l_team= arr(1, ari)			      
			l_teamnm= arr(2, ari)	
			l_starttype= arr(3, ari)      

			l_gameresult= arr(4, ari)      
			l_gameorder= arr(5, ari)                  

      l_ITgubun= arr(6, ari)
			l_CDA= arr(7, ari)
			l_CDANM= arr(8, ari)
			l_CDB= arr(9, ari)
			l_CDBNM= arr(10, ari)
			l_CDC= arr(11, ari)
			l_CDCNM= arr(12, ari)
			l_levelno= arr(13, ari)
      l_idx = arr(14,ari)
      
			l_key = arr(15,ari)
      l_incno = arr(16,ari)
      l_code = arr(17,ari)
			l_makecode = arr(23, ari)									

			%>

        <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;" >
          <td>
					<input type="checkbox" id="chk_<%=l_idx%>" name="chk" value="<%=l_idx%>">
					</td>
          <td><%=l_makecode%></td>
          <td >(<%If l_ITgubun = "I" then%>개인<%else%>단체<%End if%>) <%=l_CDBNM%></td>
          <td ><%=l_CDCNM%></td>
          <td><%=l_usernm%></td>
          <td ><%=l_teamnm%></td>
          <td ><%=l_gameorder%></td>
          <td ><%Call SetRC(l_gameresult)%></td>                              
          <td>상장</td>
        </tr>  

      <%
		Next
	End if
%>


					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>

