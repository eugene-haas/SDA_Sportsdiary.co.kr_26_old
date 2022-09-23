<%

'#############################################
'코트관리
'#############################################

idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
stateno =  oJSONoutput.StateNo '999 게임종료 모두 막음
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  예선 대진표</span>"

Set db = new clsDBHelper

SQL = " Select EntryCnt,attmembercnt,courtcnt,level,bigo,JooArea,JooDivision,joocnt,fee,fund from tblRGameLevel where DelYN = 'N' and  RGameLevelidx = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof then
  entrycnt = rs("entrycnt") '참가제한인원수
  attmembercnt = rs("attmembercnt") '참가신청자수
  courtcnt = rs("courtcnt") '코트수
  levelno = rs("level")
  bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
  bigo = Replace(bigo ,vbCr ,"\n")
  bigo = Replace(bigo ,vbLf ,"\n")
  JooArea = rs("JooArea")
  JooDivision = rs("JooDivision")
  joocnt = rs("joocnt")
  fee = rs("fee") '참가비
  fund = rs("fund") '기금
  acctotal = CDbl(fee) + CDbl(fund) '참가금액
  poptitle = poptitle & " - " & levelno
End if

'#############################################
Call oJSONoutput.Set("S3KEY", levelno )
Call oJSONoutput.Set("P1", 0 )
Call oJSONoutput.Set("POS", 0 )
Call oJSONoutput.Set("JONO", 0 )
Call oJSONoutput.Set("GAMEMEMBERIDX",0 )
Call oJSONoutput.Set("PLAYERIDX",0 )
Call oJSONoutput.Set("PLAYERIDXSub", 0 )
strjson = JSON.stringify(oJSONoutput)
'#############################################

If hasown(oJSONoutput, "CST") = "ok" then
	cst = oJSONoutput.CST
	Select Case cst
	Case "w"
		areaname = oJSONoutput.CTNAME
		SQL = "select count(*) from sd_TEnnisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and areaname = '"&areaname&"'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		no = CDbl(rs(0)) + 1
		ctname =  no

		SQL = "insert into sd_TEnnisCourt (no,gameTitleIDX,levelno,courtname,areaname) values ("&no&","&tidx&","&levelno&",'"&ctname&"','"&areaname&"')"
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update tblRGameLevel Set courtcnt = "&no&" where RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "e"
		ctname = oJSONoutput.CTNAME
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtname = '"&ctname&"' where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "d"
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtuse = case when courtuse ='Y' then 'N' else 'Y' end where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)

	Case "p" '완전삭제 관리자만 가능하게
		cidx = oJSONoutput.CIDX
		'사용중인코드라면 안됨.
		SQL = "select courtuse,courtstate from sd_TEnnisCourt where idx = " & cidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs(1) = "1" Then
			'사용중인 코트임 삭제 불가. (잠금 해제후 삭제) '상태변경되므로 그냥두자 한번더 누루겠지
			'msg = "&nbsp;<span style='color:red;font-size:10px;'>사용중인 코트입니다</span>"
		else
			SQL = "delete from  sd_TEnnisCourt where idx = " & cidx
			Call db.execSQLRs(SQL , null, ConStr)
		End if



	Case "r" '락잠금 해제 직접
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtstate = case when courtstate =1 then 0 else 1 end where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)
	End Select
End if



SQL = "Select idx,no,gameTitleIDX,levelno,courtname,courtuse,courtstate,areaname from sd_TEnnisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " order by areaname, no "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Call oJSONoutput.Set("CIDX", 0 )
Call oJSONoutput.Set("CST", "w" ) ' 상태(생성)
strjson = JSON.stringify(oJSONoutput)

%>


<header class="header clear">
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button">대회정보관리</button>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con"><%=title%></h1>
  <div class="header__side-con">
    <button class="header__side-con__btn header__btn-reset t_ico"  id="reloadbtn" onclick="mx.initCourt(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=stateno%>')">
      <img src="./Images/mobile_ico_reset.svg" alt="새로고침">
    </button>
  </div>
</header>

<div class="l_modal__con tryout-match">
  <div class="court__creat">
    <div class="court__creat__input-box clear">
      <h2><strong class="hide">코트명 생성</strong></h2>
      <input type="text" id="kcourtname" name="" value="<%=areaname%>" placeholder="코트명 입력">
      <button type="button" onclick='mx.manage_court(<%=strjson%>)' name="button">생성</button>
    </div>
  </div>
  <h2><strong class="hide">리스트 시작</strong></h2>
  <ul>
    <%
      Do Until rs.eof
      c_idx = rs("idx")
      c_no = rs("no")
      c_name = rs("courtname")
      c_use = rs("courtuse")
      c_state = rs("courtstate")
      c_area = rs("areaname")

      oJSONoutput.CIDX = c_idx
      oJSONoutput.CST = "e"
      e_strjson = JSON.stringify(oJSONoutput)
	  oJSONoutput.CST = "d"
      d_strjson = JSON.stringify(oJSONoutput)
      oJSONoutput.CST = "r" '락해제
      r_strjson = JSON.stringify(oJSONoutput)

      oJSONoutput.CST = "p" ' 
      p_strjson = JSON.stringify(oJSONoutput)	
	%>
    
	<%If c_state = "1" then %>
      <li class="court__list clear t_lock">
    <% elseif c_use = "N" then %>
      <li class="court__list clear t_disable">
    <% else %>
      <li class="court__list clear">
    <%End if%>

      <h3><%=c_area%><%'=msg%>
      <%If Cdbl(ADGRADE) > 600 then%>
		  <%If c_state = "1" then %>
		  <a href='javascript:alert("사용중인 코드입니다.")' class="btna">삭제</a>
		  <%else%>
		  <a href='javascript:if ( confirm("삭제 하시겠습니까?") ) {mx.manage_court(<%=p_strjson%>)}' class="btna">삭제</a>
		  <%End if%>
	  <%End if%>
	  </h3>



      <button type="button" name="button" onclick='javascript:mx.manage_court(<%=r_strjson%>)'>코트잠금</button>
      <div class="court__list__num clear">
        <input type="text" id="ct_<%=c_idx%>" value="<%=c_name%>"
          onfocus="$('#kcourtname').val('<%=c_area%>');"
        >
        <button type="button" name="button" onclick='javascript:mx.manage_court(<%=e_strjson%>)'>수정</button>
      </div>
      <button type="button" name="button" onclick='javascript:mx.manage_court(<%=d_strjson%>)' <%If c_state = "1" then %>disabled<% end if %>></button>
    </li>
    <%
      rs.movenext
      loop
    %>
  </ul>
</div>

<%
db.Dispose
Set db = Nothing
%>
