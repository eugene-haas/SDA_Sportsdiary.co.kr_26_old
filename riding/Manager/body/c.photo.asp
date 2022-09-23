<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
function codecheck(gubun)
  select case gubun
    case "F"
      codecheck = "국제"
    case Else
      codecheck = "국내"
  end select
end function


intPageNum = PN
intPageSize = 10

If chkBlank(F2) Then
  strWhere = " "
Else
  If InStr(F1, ",") > 0  Then
    F1 = Split(F1, ",")
    F2 = Split(F2, ",")
  End If

  If IsArray(F1) Then
    fieldarr = array("gameS","gameS","gameNa","gameTypeE","gameTypeA","gameTypeL","GameTitleName")
    F1_0 = F2(0)
    F1_1 = F2(1)
    F1_2 = F2(2)
    F1_3 = F2(3)
    F1_4 = F2(4)
    F1_5 = F2(5)
    F1_6 = F2(6)

    For i = 0 To ubound(fieldarr)
      Select Case i
      Case 0
        findyear = F2(i)
      Case 1
        If F2(i) = "" Then
          finddateS = finddateS & " and (convert(varchar(4),STT.GameS,120) =  '"& findyear &"') "
        Else
          finddateS = finddateS & " and (convert(varchar(7),STT.GameS,120) =  '"& findyear &"-"& addZero(F2(i)) &"') "
        End if
        strWhere = strWhere & finddateS

      Case 2
        If F2(i) <> "A" then
          strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
        End if
      Case 3,4,5
        If F2(i) <> "" then
          strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
        End If
      Case 6
          If F2(i) <> "" then
            strWhere = strWhere & " and "&fieldarr(i)&" like  '%"& F2(i) &"%' "
          End if
      End Select
      'Response.write fieldarr(i) & "<br>"
    next

  Else
    strWhere = " "
  End if
End if


sqlcount = "select "_
&" count(STT.GameTitleIDX) "_
&" from sd_TennisTitle STT "_
&" inner join sd_Tennis_Stadium_Sketch STSS on STT.GameTitleIDX = STSS.GameTitleIDX and STSS.Delyn = 'N' "_
&" where STT.DelYN = 'N' "& strWhere &" "


Set rscount = db.ExecSQLReturnRS(sqlcount , null, ConStr)
iTotalCount = rscount(0)
set rscount = Nothing

spage = iTotalCount - (intPageNum*intPageSize)
epage = spage + intPageSize

if iTotalCount > 0 then
  totalpages = int(iTotalCount / intPageSize) + 1
else
  totalpages = 0
end if

sql = "select ranks,GameTitleIDX,GameTitleName,gameNa,gameTypeE,gameTypeA,gameTypeL,UserName,regdate,ViewCnt,Idx from "_
&" (select "_
&" rank() OVER (ORDER BY STSS.idx) as ranks "_
&" ,STT.GameTitleIDX "_
&" ,STT.GameTitleName "_
&" ,STT.gameNa "_
&" ,STT.gameTypeE "_
&" ,STT.gameTypeA "_
&" ,STT.gameTypeL "_
&" ,STSS.UserName "_
&" ,replace(convert(varchar(10),STSS.Writeday,120),'-','.') as regdate "_
&" ,STSS.ViewCnt "_
&" ,STSS.idx "_
&" from sd_TennisTitle STT "_
&" inner join sd_Tennis_Stadium_Sketch STSS on STT.GameTitleIDX = STSS.GameTitleIDX and STSS.Delyn = 'N' "_
&" where STT.DelYN = 'N' "& strWhere &" "_
&" ) A "_
&" where ranks between "& spage+1 &" and "& epage &" "_
&" order by ranks desc"

list = null
Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
if not rs.eof then
  list = rs.GetRows()
end if
set rs = Nothing
%>
<div class="admin_content">
  <div class="page_title"><h1>현장스케치 <!-- (sd_TenisTitle) --></h1></div>
  <div class="info_serch">

    <!-- s: 정보 검색 -->
    <div class="info_serch">
      <!-- #include virtual = "/pub/html/riding/gamefindform.asp" -->
    </div>
    <!-- e: 정보 검색 -->
  </div>

  <hr />
  <!-- s: 리스트 버튼 -->
  <div class="btn-toolbar" role="toolbar" aria-label="btns">
    <div class="btn-group flr">
      <a href="javascript:location.href='./photoWrite.asp'" id="gdmake" class="btn btn-primary">등록</a><!-- mx.makeGoods() -->
    </div>
  </div>
  <!-- e: 리스트 버튼 -->


  <!-- s: 테이블 리스트 -->
  <div class="table-responsive">
    <table cellspacing="0" cellpadding="0" class="table table-hover">
      <thead>
        <tr>
          <th>No.</th>
          <th>대회명</th>
          <th>국제구분</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>조회수</th>
        </tr>
      </thead>
      <tbody id="contest"  class="gametitle">
<%
  if isnull(list) = false then
    for i = LBound(list,2) to ubound(list,2)
%>
        <tr id="titlelist_<%=list(0,i)%>" onclick="photoListGo('<%=list(1,i)%>','<%=list(10,i)%>','<%=intPageNum%>')" style="cursor:pointer;">
    			<td><span><%=list(0,i)%></span></td>
    			<td><span><%=list(2,i)%></span></td>
    			<td><span>
<%
          response.write codecheck(list(3,i))
          if list(4,i) = "Y" then response.write "/" & "전문"
          if list(5,i) = "Y" then response.write "/" & "생활"
          if list(6,i) = "Y" then response.write "/" & "유소년"
%>
          </span></td>
    			<td><span><%=list(7,i)%></span></td>
    			<td><span><%=list(8,i)%></span></td>
  				<td><span><%=list(9,i)%></span></td>
    		</tr>
<%
    Next
  end if
%>
      </tbody>
    </table>
  </div>
  <nav>
    <%
      jsonstr = JSON.stringify(oJSONoutput)
      Call userPagingT2 (totalpages, intPageSize, 1, "px.goPN", jsonstr )
    %>
  </nav>
</div>
<script type="text/javascript">
  function photoListGo(idx,sketch_idx,page){
    location.href = "./photoView.asp?page="+page+"&idx="+idx+"&sketch_idx="+sketch_idx;
  }
</script>
