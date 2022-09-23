<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<form name="frm" method="post">

		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회정보 > 대회신청 정보 > 부목록정보 > 예선전</strong>
				</h3>
			</div>

		</div>
		</form>


<%
'#############################################
'대진표 리그 화면 준비 


'group by로 선수 목록정보를 확인한다. > 0 예선준비 1 예선시작 2본선준비 3 본선시작 4 본선완료 

'리그이므로
' if gubun > 0 then
  ' 조별 예선 대진표를 보여준다. ( 승패결정과, 출석 체크할수 있는 기능이 있다) 코트지정 ( tennisMember에 사전에 사용할 코트를 지정할수 있어야 하나?)
'else
  ' 예선 대진표를 추첨할수 있는 화면을 보여준다.
  ' 대회 참가 선수 목록을 가져온다. (gubun = 0)
  ' 선수가 부족한 만큼 부전승자를 만든다. ( 이건 토너먼트에서) 부족한 경우 mod 3 =0 이아닌경우 어떻게 ?? 부족합니다 어쩌구 저쩌구....
  ' mode 3 = 0 으로 만들었다 소팅순서 업데이트 해주자. 
'end if

'#############################################
'request
idx = "8"
tidx = "9"



poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"



Set db = new clsDBHelper



  SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	'SQL = " SELECT '1' AS EntryCnt,'1' AS attmembercnt,'1' AS courtcnt,'1' AS level "
  'Response.write "</br> " & SQL
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




  If Not rs.eof then
    entrycnt = rs("entrycnt") '참가제한인원수
    attmembercnt = rs("attmembercnt") '참가신청자수
    courtcnt = rs("courtcnt") '코트수
    levelno = rs("level")

    poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
  End If
  



'#############################################

  '추가 참여자서 설정된경우 기존 설정을 바꾸지 않도록 한다.
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "

  strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (0, 1)  and DelYN = 'N' "
  SQL = "select top 1  max(tryoutgroupno) as maxgno,COUNT(*) as gcnt from "&strtable&" where "&strWhere&" group by tryoutgroupno order by 1 desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



  int_tryoutgroupno = 1
  int_tryoutsortNo = 1
  If Not rs.eof Then
    maxgno = rs("maxgno")

    If Cdbl(maxgno) > 0 Then
      int_tryoutgroupno = rs("maxgno") '설정된 마지막조
      int_tryoutsortNo = rs("gcnt") '마지막조 참가팀 번호

      If CDbl(int_tryoutsortNo) = 3 Then
        int_tryoutgroupno = CDbl(int_tryoutgroupno) + 1
        int_tryoutsortNo = 1
      Else
        int_tryoutsortNo = CDbl(int_tryoutsortNo) + 1
      End if
    End if

  End if

  'Response.Write "</br> int_tryoutgroupno : " & int_tryoutgroupno
  'Response.Write "</br> int_tryoutsortNo : " & int_tryoutsortNo


  SQL = "SELECT gameMemberIDX , userName FROM  " &strtable&   " where " & strWhere & " and tryoutgroupno = 0 ORDER BY gameMemberIDX ASC"
  'Response.write "</br> " & SQL
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  Do Until rs.EOF 
    strSql = "UPDATE " &  strtable & " SET "
    strSql = strSql & " tryoutgroupno = '" & int_tryoutgroupno & "',"
    strSql = strSql & " tryoutsortNo = '" & int_tryoutsortNo & "'"
    strSql = strSql & " WHERE gameMemberIDX = " & rs("gameMemberIDX")
	Call db.execSQLRs(strSql , null, ConStr)
    If int_tryoutsortNo MOD 3 = 0 Then
      int_tryoutsortNo = 1
      int_tryoutgroupno = int_tryoutgroupno + 1
    Else
      int_tryoutsortNo = int_tryoutsortNo + 1
    End If
    rs.movenext
  Loop
  Set rs = Nothing

  '참가자 목록 ==================================================
  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0  and a.gubun in ( 0, 1) "
  strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별
  strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint "
  strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint, a.rankpoint + b.rankpoint as totalPointWithPartner, a.AttFlag, c.PaymentType as PaymentFlag, a.GiftFlag, a.gameMemberIDX, a.PlayerIDX as PlayerIDX, b.PlayerIDX as PatnerPlayerIDX, a.gubun,t_rank, a.areaChanging, A.SeedFlag"
  strfield = strAfield &  ", " & strBfield 

  SQL = "select " & strfield & " from  " & strtable & " as a " 
  'SQL = SQL & joinstr & " JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
  'SQL = SQL & joinstr & " JOIN " & strtablesub2 & " as c ON a.PlayerIDX = c.P1_PlayerIDX and b.PlayerIDX = c.P2_PlayerIDX "
  SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
  SQL = SQL & " LEFT JOIN " & strtablesub2 & " as c ON a.PlayerIDX = c.P1_PlayerIDX and b.PlayerIDX = c.P2_PlayerIDX "
  
  SQL = SQL & " WHERE " & strwhere & strsort

  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  Response.write "</br> " & joinstr
  If Not rs.EOF Then 
    arrRS = rs.getrows()
  End If




'#############################################
%>

<%
  strjson = JSON.stringify(oJSONoutput)		
%>

<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button><h3 id='myModalLabel'><%=poptitle%></h3></div>

<div class='modal-body'>

<table border="1" width="100%" class="table-list" id="gametable">
<thead>
<th>조</th>
<th>시드</th>
<th>1</th>
<th>2</th>
<th>3</th>
<th>경기입력</th>
</thead>

<%
%>

<%
If IsArray(arrRS) Then

  endgroup = arrRs(0,UBound(arrRS, 2))

  '편성 완료 존재 여부
  DiffGubunYN = "N"
  
  For i = 1 To endgroup
  'Response.write "i : " & i & "</br>"
%>
  <tr>
    <td><%=i%></td>
<%
  tdcnt = 0
  '각 조의 1팀,2팀 존재여부
  jRowExitYN1 = "N"
  jRowExitYN2 = "N"
  
  For j = 1 To 3
  'Response.write "j : " & j & "</br>"
    c= 0
    chkdata = "N"
	  chkrank = "N"   
    For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
    c= c + 1
     'Response.write "c : " & c & "</br>"
     '$$
      gno =     arrRS(0,ar)
      sortno =    arrRS(1,ar)
      p1idx =     arrRS(2,ar)
      p1name =    arrRS(3,ar)
      p1team1 =   arrRS(4,ar)
      p1team2 =   arrRS(5,ar)
      p1rpoint =    arrRS(6,ar)
      p2idx =     arrRS(7,ar)
      p2name =    arrRS(8,ar)
      p2team1 =   arrRS(9,ar)
      p2team2 =   arrRS(10,ar)
      p2rpoint =  arrRS(11,ar)
      rpointsum = arrRS(12,ar)
      rAttFlag = arrRS(13,ar)
      rPaymentFlag = arrRS(14,ar)
      rGiftFlag = arrRS(15,ar)
      rGameMemberIDX = arrRS(16,ar)
      rPlayerIDX = arrRS(17,ar)
      rPlayerIDXSUB = arrRS(18,ar)
      gubun = arrRS(19,ar)
      t_rank = arrRS(20,ar)
      rareaChanging = arrRS(21,ar)
      rSeedFlag = arrRS(22,ar)
     
  '$$
      If sortno = j And gno = i Then
        chkdata = "Y"
        tdcnt = CDbl(tdcnt) + 1
		    chkgubun = gubun	
      %>

      <% 
        '같은 조에 1번 2번 선수가 있어야 편성완료가 된다.
        IF( j = "1") Then
          jRowExitYN1 = "Y"
        ELSEIF ( j = "2" ) Then
          jRowExitYN2 = "Y"
        End If

        IF(gubun = "1")  Then
          DiffGubunYN="Y"
        END IF

      %>

			<%If j = 1 Then%>
				<td><input type="checkbox"  name="seedFlag" id="SeedFlag<%=i%>" onchange="mx.update_seed('<%=arrRS(16,ar)%>',this.checked);" value="Y" <%If arrRS(22,ar) = "Y" Then%>checked<%End If%>></td>
			<%End If%>

     	<td style='border: 1px solid #000;'>
        <div        
		  <%If CDbl(gubun) = LEAGUESET  then%>
          <% IF rareaChanging = "Y" then %>
            style='border: 1px solid #73AD21; width:100%; background-color: #f7dbdc;'
          <% Else %>
              style='border: 1px solid #73AD21; width:100%;height:100%;'
          <% END IF %>

          onClick='mx.changeSelectArea(<%=rGameMemberIDX%>,this,<%=i%>,<%=j%>,<%=strjson%>)'
		  <%else%>
			    style='background:#FFFAE0; width:100%;' 
		  <%End if%>
		      id='drag_<%=gno%>_<%=sortno%>'>
        <div>
        
      <!-- Rounded switch -->
       
       <%
					Set oJSONoutput = JSON.Parse("{}")

          Call oJSONoutput.Set("GAMEMEMBERIDX",0 )
          Call oJSONoutput.Set("PLAYERIDX",0 )
          Call oJSONoutput.Set("PLAYERIDXSub", 0 )
          oJSONoutput.GAMEMEMBERIDX = rGameMemberIDX
          oJSONoutput.PLAYERIDX = rPlayerIDX
          oJSONoutput.PLAYERIDXSUB = rPlayerIDXSUB
					strjson = JSON.stringify(oJSONoutput)		
       %>
        <span >출석</span>
        <label class="switch">
          <input type="checkbox"  name="attCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"att",this);' <% if( rAttFlag = "Y") Then%> checked <%END IF%> >
          <span class="slider round"></span>
        </label>
        
        <span >입금</span>
        <label class="switch">
          <input type="checkbox"  name="paymentCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"payment",this);'  <% if( rPaymentFlag = "Y") Then%> checked <%END IF%>>
          <span class="slider round"></span>
        </label>
        
        <span >사은품</span>
        <label class="switch" >
          <input type="checkbox"  name="giftCheckBox"  class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"gift",this);' <% if( rGiftFlag = "Y") Then%> checked <%END IF%>>
          <span class="slider round"></span>
        </label>
    
        <!--<a href="#" class="btn btn-warning">출석</a>-->
        <!--<a href="#" class="btn btn-primary">입금</a>-->
        <!--<a href="#" class="btn btn-success">사은품</a>-->
        </div>
        <%If CDbl(t_rank) > 0 Then
   		chkrank = "Y"
		%>
		<span style="color:red;"><%=t_rank%>위</span>
		<%End if%>
		<%=p1name%> & <%=p2name%> <input type="text" style="width:50px" id="tryout_rpoint" onblur="mx.update_rpoint('<%=p1idx%>',this.value);" value="<%=rpointsum%>">
      </td>
      <%
      End If
 

    Next
 
    If chkdata = "N" Then
      tdcnt = CDbl(tdcnt) + 1
    %>
    
      
    <%If CDbl(chkgubun) = LEAGUESET then%>
			<%If j = 1 Then%>
				<td></td>
			<%End If%>
      <td style='border: 1px solid #000;'>
      <div style='border: 1px solid #73AD21; width:100%;height:100%;' 
        onClick='mx.changeSelectArea(0,this,<%=i%>,<%=j%>,<%=strjson%>)'
        id='drag_<%=i%>_<%=j%>'>빈칸_<%=i%>_<%=j%></div></td>
    <%ELSE%>
      <td style='border: 1px solid #000;background:#FFFAE0;' >
        <div style='border: 1px solid #73AD21; width:100%;height:100%;' id='drag_<%=i%>_<%=j%>'>빈칸_<%=i%>_<%=j%></div></td>
    <%END IF%>
      
    <%
    End If

      If tdcnt = 3 Then
        Call oJSONoutput.Set("JONO", i )

				Call oJSONoutput.Set("CMD", "30009" )
 		    Call oJSONoutput.Set("S3KEY", levelno )
       	Call oJSONoutput.Set("GUBUN", chkgubun )
        Call oJSONoutput.Set("ExitYN1", jRowExitYN1  )
        Call oJSONoutput.Set("ExitYN2", jRowExitYN2  )
        strjson = JSON.stringify(oJSONoutput)
        '완료 resulttable에 생성여부를 확인한 후 완료를 해제할 수 있다.
      %>
	  
	  <td>


	  <%If CDbl(chkgubun) = LEAGUESET then%>
		  <a href='javascript:mx.SetJoo(<%=strjson%>)' class="btn_a">편성완료</a>&nbsp;
		  <a href='javascript:alert("<%=i%>조의 편성을 완료 후 실행해 주십시오.")' class="btn_a">입력</a>
	  <%Else%>
		  <%If chkrank = "Y" then%>
		  <a href='javascript:alert("승패가 결정되어 토너먼트에 진출되어 재편성 할 수 없습니다.")' class="btn_a">재편성</a>&nbsp;
		  <%else%>
		  <a href='javascript:mx.SetJoo(<%=strjson%>)' class="btn_a">재편성</a>&nbsp;
		  <%End if%>
		  <a href='javascript:mx.leagueJoo(<%=strjson%>)' class="btn_a">입력</a>
	  <%End if%>
	  </td><%
      End if
  Next
%>
  </tr> 
<%
  Next

End If
%>

</table>
</div>

<input type="hidden" id="diffGubun" value="<%=DiffGubunYN%>">

<!-- #include virtual = "/pub/api/tennisAdmin/gametable/inc.leaguebtn.asp" --><%

db.Dispose
Set db = Nothing
%>

