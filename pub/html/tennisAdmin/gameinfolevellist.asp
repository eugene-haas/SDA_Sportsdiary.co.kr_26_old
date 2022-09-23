
<%If CDbl(ADGRADE) > 500 then%>
  <tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>" >
    <td  onclick="mx.input_edit(<%=idx%>)"><%=idx%></td>
    <td  onclick="mx.input_edit(<%=idx%>)"><%=boo%></td>
    <td  onclick="mx.input_edit(<%=idx%>)" style="text-align:left;padding-left:10px;"><%=teamgbnm%><%If LevelNm <> "" then%>(<%=LevelNm%>)<%End if%>&nbsp;<span style="color:red;"><%=chk1%></span></td>  
    </td>   
    <td style="text-align:left;padding-left:10px;">

	<%If LevelNm = "최종라운드" then%>
        <a href="javascript:mx.setLastRound(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=levelgb%>')" class="btn_a btn_func btn_final_round" style="background:orange;">최종라운드생성</a>
		<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" <%If 	lastroundmethod = "1" then%>style="border-color:red;"<%End if%>>리그</a>
        <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func"  <%If 	lastroundmethod = "2" then%>style="border-color:red;"<%End if%>>본선</a>
    <%else%>
	    <a href="javascript:mx.goplayer(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">신청목록</a>        
        <a href="javascript:sd.setGame(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func btn_final_round"  <%If  setrnkpt = "Y" then%><%End if%>>랭킹포인트적용</a>
        <%If  setrnkpt = "Y" then%>
			  <%If isnumeric(joocnt) = False then%>
					<a href="javascript:alert('예선 조수가 입력되어있지 않습니다.');mx.input_edit(<%=idx%>);"" class='btn_a btn_func'>예선</a>
			  <%else%>
					<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >예선</a>
			  <%End if%>
			  <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func" >본선</a>
			  &nbsp;<a href="./tournexcel.asp?idx=<%=idx%>&tidx=<%=titleidx%>" ><img src="/images/favicon/excel.png" style="margin-bottom:-5px;"></a>
			  &nbsp;<a href="./lgexcel.asp?lno=<%=levelgb%>&tidx=<%=titleidx%>" ><img src="/images/favicon/excel.png" style="margin-bottom:-5px;"></a>
        <%End if%>
    <%End if%>
    </td>

    <td>
	<input type="hidden" id="h_jc_<%=idx%>" value="<%=joocnt%>">
	<input type="number" min="2" id="jc_<%=idx%>" value="<%=joocnt%>" style="width:50px;height:30px;" onblur="mx.updateJoocnt(this,<%=levelgb%>)">
	</td>
    
    <td >
      <label class="switch" style="margin-bottom:-8px;" title="신청 (사용자 참가신청)" onclick="mx.attCheck(<%=idx%>,1,'<%=cfg%>')">
      <input type="checkbox" id="attins_<%=idx%>"  value="Y" <%If chk2= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
      <label class="switch" style="margin-bottom:-8px;" title="수정 (사용자 참가신청)" onclick="mx.attCheck(<%=idx%>,2,'<%=cfg%>')">
      <input type="checkbox" id="attedit_<%=idx%>"  value="Y" <%If chk3= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
      <label class="switch" style="margin-bottom:-8px;" title="삭제 (사용자 참가신청)" onclick="mx.attCheck(<%=idx%>,3,'<%=cfg%>')">
      <input type="checkbox" id="attdel_<%=idx%>"  value="Y" <%If chk4= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
    </td>

    <td  onclick="mx.input_edit(<%=idx%>)"><%=courtcnt%></td>
    <td  onclick="mx.input_edit(<%=idx%>)"><%=entrycnt%></td>
    <td  onclick="mx.input_edit(<%=idx%>)"><%=attcnt%></td>
    
    <%If LevelNm = "최종라운드" then%>
		<td   style="text-align:left;padding-left:10px;"><%'=endround  라운드 최종강수 1명 또는 2명까지만%><%'=titlegrade 대회등급번호%>
		  <a href="javascript:mx.goplayer(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">리그등록</a>
		  <%If Cdbl(endround) < 3 then%>
		  <%If CDbl(titlegrade) < 7 then%>
			  <a href="javascript:sd.contestResult(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func btn_final_round">대회결과처리</a>        

		  
			  <%If request("test") = "t" Then '테스트%>
				  <a href="javascript:sd.contestResultTest(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func btn_final_round">대회결과처리Test</a>    
			  <%End if%>				  
		  
		  <%End if%>
		  <%End if%>
		</td>
    <%else%>
		<td  style="text-align:left;padding-left:10px;">
		  <a href="javascript:mx.goplayer(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">신청목록</a>
		  <% '동일부가 두개이상 있다면 그리지 말것....
		  sqlstr = "select RGameLevelIdx from tblRGameLevel where gametitleidx = " &titleidx& " and teamgb = '" & teamgb  & "' and right(Level,3) = '007' and delYN = 'N'"
		  Set rss = db.ExecSQLReturnRS(sqlstr , null, ConStr)
		  %>
		  <%If rss.eof then%>
			   <%If  setrnkpt = "Y" then%>
			   <%If chk2= "N" and chk3= "N" And chk4="N" then%>
			  <a href="javascript:sd.contestResult(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func btn_final_round">대회결과처리</a>    
			  <%End if%>
			  <%End if%>
		  <%End if%>
		</td>
    <%End if%>
  </tr>
  

<%else'#######################################################################################################################%>


  <tr class="gametitle"  id="titlelist_<%=idx%>" >
    <td  ><%=idx%></td>
    <td   style="text-align:left;padding-left:10px;"><%=teamgbnm%><%If LevelNm <> "" then%>(<%=LevelNm%>)<%End if%>&nbsp;<span style="color:red;"><%=chk1%></span></td>  
    </td>   
    <td>
    <%If LevelNm = "최종라운드" then%>
        <a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func">리그</a>
        <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">토너먼트</a>
        <a href="javascript:mx.setLastRound(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=levelgb%>')" class="btn_a btn_func btn_final_round">최종라운드생성</a>
    <%else%>

		<%If  setrnkpt = "Y" then%>
          <%If isnumeric(joocnt) = False then%>
			<a href="javascript:alert('예선 조수가 입력되어있지 않습니다.');mx.input_edit(<%=idx%>);"" class='btn_a btn_func'>1 대회 준비</a>            
			<a href="javascript:alert('예선 조수가 입력되어있지 않습니다.');mx.input_edit(<%=idx%>);"" class='btn_a btn_func'>2 예선 진행</a>
          <%else%>
            <a href="javascript:mx.leaguepre(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >1 대회 준비</a>
			<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >2 예선 진행</a>
          <%End if%>

		  <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func" >3 본선 진행</a>
         <a href="javascript:mx.writeNotice(<%=idx%>)"  class="btn_a btn_func">4 공지사항</a>
        <%End if%>
    <%End if%>
    </td>
    <td><%=joocnt%></td>
    <td><%=courtcnt%></td>
  </tr>
<%End if%>

