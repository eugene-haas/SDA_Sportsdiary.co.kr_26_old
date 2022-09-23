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
			  <!-- #include virtual = "/pub/html/swimming/crapeformG.asp" -->
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
										<a href="javascript:mx.print2(<%=reqtidx%>,'<%=F1%>','<%=F2%>', $('#linecnt').val());" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 내용줄수 반영 인쇄</a>
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
								<th>종별</th>
								<th>소속팀</th>
								<th>점수</th>                
								<th>순위</th>
								<th>상장종류</th>                
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

<%

if F2 <> "" then

  '$$$$$$$$$$$$$$$$$$$$$$$$$
  '관리자 생성 번호 만들어서 넣자.
  '$$$$$$$$$$$$$$$$$$$$$$$$$
  'skey
  if instr(skey , "-") > 0 then
    skey = split(skey,"-")
    make_key = skey(0)
    make_num = Cdbl(skey(1)) - 1

    '단체인지 구분할 필드가 피요하겠네 gubun = 2
    SQL = "Update A Set A.make_key = '"&make_key&"' , A.make_num = A.RowNum From ( Select make_key, make_num, ((RANK() OVER (Order By gameorder )) + "&make_num&")  as RowNum "
    SQL = SQL & " from sd_gameMember_crape_history  where gametitleidx = "&reqtidx&" and cda = '"&F1&"' and cdb = '"&F2&"' and gubun = 2 ) as A "
    Call db.execSQLRs(SQL , null, ConStr)	
    'response.write sql
    'response.end		
  end if



  SQL = "select * from sd_gameMember where  gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0  and itgubun = 'T' " 
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  if rs.eof Then
          '우선 팀의 점수가 계산될수 있도록 점수를 업데이트 시키자.
          '일딴 순위부터 업데이트 해보자....
          SQL = "update sd_gameMember Set recordorder = isNull((case when starttype = 3 then tryouttotalorder else gametotalorder end ),0) where  gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' "
          Call db.execSQLRs(SQL , null, ConStr)
          
          '6등 뒤는 0으로 
          SQL = "update sd_gameMember Set recordorder = 0 where  gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 6 " 
          Call db.execSQLRs(SQL , null, ConStr)  

          point = array(0,7,5,4,3,2,1,0,0,0,0,0,0)
          pointsum = 0
          SQL = "select cdc,recordorder,cnt from (select  cdc,recordorder,count(*) as cnt from sd_gameMember where gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 group by cdc,recordorder ) AS a where cnt > 1"
          Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
          
          SQL = ""
          do until rs.eof 
            cdc = rs(0)
            startorder = rs(1)
            cnt = rs(2)

            for x = startorder to startorder + cnt
              pointsum = Cdbl(pointsum + point(x))
            Next
              savepint = formatnumber( pointsum / cnt, 1)

              SQL = SQL & "update sd_gameMember set teamscore = " & savepint & " where gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and cdc = '"&cdc&"' and recordorder = " & startorder
          rs.movenext
          loop
          if SQL <> "" then
            Call db.execSQLRs(SQL , null, ConStr)  
          end if

          '개인전 단체전 일괄 점수 부여
          SQL = "update sd_gameMember Set teamscore = (case when  recordorder = 1 then (7 - recordorder) + 1 else (7 - recordorder) end) where  gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 and recordorder < 7  and teamscore =0 "
          Call db.execSQLRs(SQL , null, ConStr)

          '단체점 점수 * 2
          SQL = "update sd_gameMember Set teamscore = teamscore * 2 where  gametitleidx ="&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and itgubun = 'T' " 
          Call db.execSQLRs(SQL , null, ConStr) 
end if 


  SQL = ""
  SQL = SQL & " Select a.*, b.first_key,b.second_num,b.make_key,b.make_num ,(make_key + '-' + FORMAT( make_num,'0000')) as crape_makecode from "
  SQL = SQL & " (select top 4 cdbnm, teamnm, sum(teamscore) as totalscore, (RANK() OVER (Order By sum(teamscore)  desc  )) as tc ,max(gamememberidx) as gidx "
  SQL = SQL & " from sd_gameMember where gametitleidx = "&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 group by cdb,cdbnm,team,teamnm order by sum(teamscore) desc) as a inner join sd_gameMember_crape_history as b on a.gidx = b.gamememberidx "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  if rs.eof then  
  
          '상장번호 자동생성 상장테이블을 만들고 밀어넣자.
          SQL = ""
          SQL = SQL & "Select "
          SQL = SQL & " (case when max(first_key) is null then (select TOP 1  IDX from sd_gameMember_crape_key WHERE TITLECODE IS NULL) else '0' end) as updatekey   , "
          SQL = SQL & " (case when max(first_key) is null then (select TOP 1  CRAPE_KEY from sd_gameMember_crape_key WHERE TITLECODE IS NULL) else max(first_key) end) as titlekey  , "
          SQL = SQL & " (case when max(second_num) is null then 0 else max(second_num) end) as incno ,max(a.titlecode) as titlecode "

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


          SQL = " insert into sd_gameMember_crape_history (gametitleidx,cda,cdb, titlecode, gamememberidx,first_key,second_num,gameorder,cdc, gubun ) "
          
          SQL = SQL & " select top 4 "&reqtidx&", 'D2',cdb,'"&titlecode&"',max(gamememberidx), '"&titlekey&"' , (RANK() OVER (Order By sum(teamscore)  desc  )  + "&incno&"),  (RANK() OVER (Order By sum(teamscore)  desc  )) ,'' ,2 "
          SQL = SQL & " from sd_gameMember where gametitleidx = "&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 group by cdb,cdbnm,team,teamnm order by sum(teamscore) desc "
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

          '단체인지 구분할 필드가 피요하겠네 gubun = 2
          SQL = "Update A Set A.make_key = '"&make_key&"' , A.make_num = A.RowNum From ( Select make_key, make_num, ((RANK() OVER (Order By gameorder )) + "&make_num&")  as RowNum "
          SQL = SQL & " from sd_gameMember_crape_history  where gametitleidx = "&reqtidx&" and cda = '"&F1&"' and cdb = '"&F2&"' and gubun = 2 ) as A "
          Call db.execSQLRs(SQL , null, ConStr)	
          'response.write sql
          'response.end		
        end if
  

        SQL = ""
        SQL = SQL & " Select a.*, b.first_key,b.second_num,b.make_key,b.make_num ,(b.make_key + '-' + FORMAT( make_num,'0000')) as crape_makecode            from "
        SQL = SQL & " (select top 4 cdbnm, teamnm, sum(teamscore) as totalscore, (RANK() OVER (Order By sum(teamscore)  desc  )) as tc ,max(gamememberidx) as gidx "
        SQL = SQL & " from sd_gameMember where gametitleidx = "&reqtidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 group by cdb,cdbnm,team,teamnm order by sum(teamscore) desc) as a inner join sd_gameMember_crape_history as b on a.gidx = b.gamememberidx "
        'response.write sql
        'response.end
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  end if

  If Not rs.EOF Then
		arr = rs.GetRows()
	End If

end if

  'response.write sql
	'Call rsdrow(rs)
	'Response.end

	If IsArray(arr) Then 
		For ari = LBound(arr, 2) To UBound(arr, 2)
			l_cdbnm= arr(0, ari)			
			l_teamnm= arr(1, ari)			      
			l_totalscore= arr(2, ari)	
			l_rank= arr(3, ari)   
			l_idx= arr(4, ari)      

      l_first_key= arr(5, ari)
      l_second_num= arr(6, ari)  
      l_make_key= arr(7, ari)
      l_make_num   = arr(8, ari)
      l_makecode = arr(9,ari)
			%>

        <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;" >
          <td>
					<input type="checkbox" id="chk_<%=l_idx%>" name="chk" value="<%=l_idx%>">
					</td>
          <td><%=l_makecode%></td>
          <td><%=l_cdbnm%></td>
          <td ><%=l_teamnm%></td>
          <td ><%=l_totalscore%></td>
          <td><%=l_rank%></td>
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

