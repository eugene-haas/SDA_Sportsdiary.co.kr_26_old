<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%

Set db = new clsDBHelper

SQL = "SELECT gameyear FROM sd_bikeTitle WHERE delYN = 'N' GROUP BY gameyear ORDER BY gameyear DESC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
    arrY = rs.GetRows()
End If

If GY = "" Then
    GY = year(date)
End if

tid = 2

'그룹/종목
SQL = "SELECT titleIDX,gameTitleName FROM sd_bikeTitle WHERE delYN = 'N' AND gameyear = '"&GY&"' ORDER BY titleidx DESC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
  arrRS = rs.GetRows()
End If


If tidx <> "" then
  SQL = "Select levelIDX,detailtitle,sex,booNM from sd_bikeLevel where delYN = 'N' and titleIDX = '"&tidx&"' order by sex, booNM"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
  	arrB = rs.GetRows()
  End If
End if


'strSort = "  order by topshow desc,ref desc, re_step"
'strSortR = "  order by topshow,ref, re_step desc"
strSort = "  order by topshow desc,seq desc"
strSortR = "  order by topshow,seq"


titleq = "(select gameTitleName from sd_bikeTitle where titleIDX = a.titleIDX) as titleNm "
subtitleq = "(select detailtitle from sd_bikeLevel where levelIDX = a.levelno) as levelNm "
strFieldName = titleq &"," &subtitleq& ", seq,tid,title,contents,pid,ip,readnum,writeday,num,ref,re_step,re_level,tailcnt,filename,pubshow,topshow, levelno " '& titleq '&  "," & subtitleq
intPageNum = page
intPageSize = 10

strTableName = "  sd_bikeBoard as a "
strWhere = " pubshow in ('0', '1') and tid = '"&tid&"' "

If tidx <> "" And levelno <> ""  Then
  If levelno = "" Then
    strWhere = strWhere & " and titleIDX = " & tidx
  Else
    strWhere = strWhere & " and titleIDX = " & tidx & " and levelno = " & levelno
  End if
End if

Dim intTotalCnt, intTotalPage
Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
block_size = 10

%>

<%'View ####################################################################################################%>
	<!-- S: 정보 검색 -->
    <div class="box-shadow">
    	<div class="search-box-1" id="gamefind_area">
    		<!-- #include virtual = "/pub/html/bike/board/video/searchform.asp" -->
    	</div>
    </div>
	<!-- E: 정보 검색 -->

    <!-- S: apply_info -->
    <div class="player_video">

    	<!-- S: 전체 페이지 -->
        <div class="all-list-number">
        	<div class="l-txt">
                전체<span class="red-font font-bold"><%=intTotalCnt%></span>건
        	</div>
        </div>
    	<!-- E: 전체 페이지 -->

    	<!-- S: 테이블 리스트 -->
    	<div class="table-box basic-table-box">
    		<table cellspacing="0" cellpadding="0">
          <%
            i = 1
            Do  until  rs.EOF Or i > int(intPageSize)
            tid = rs("tid")
            seq = rs("seq")
            id = rs("pid")
            fulldate = rs("writeday")
            writeday = left(fulldate,10)
            readnum = rs("readnum")
            num = rs("num")
            tailcnt = rs("tailcnt")

            re_level = rs("re_level")
            title = rs("title")
            pubshow = rs("pubshow")
            topshow = rs("topshow")
            titleNm = Replace(rs("titleNm"),Chr(34),"")
            levelNm = rs("levelNm")
            If isNull(levelNm) = true Then
              levelNm = "연습시간"
            End if
          %>
          <% If i = 1 Then %>
      			<tr>
              <th><input type="checkbox" id="showb" value="1" onclick="mx.chk('showb','showflag')" <%If pubshow = "1" then%>checked<%End if%>></th>
              <th>대회명</th>
              <th>종목명</th>
              <th>영상 제목</th>
              <th>영상 등록수</th>
              <th>작성일</th>
              <th>조회수</th>
              <th>보기</th>
      			</tr>
          <% End If %>
            <tr>
              <td><span><input type="checkbox" name="showflag" value="<%=seq%>" <%If pubshow = "1" then%>checked<%End if%>></span></td>
              <td title="<%=titleNm%>"><span><%=Left(titleNm,10)%>..</span></td>
              <td><span><%=levelNm%></span></td>
              <td><span><%=title%></span></td>
              <td><span><%=tailcnt%></span></td>
              <td><span><%=writeday%></span></td>
              <td><span><%=readnum%></span></td>
              <td>
                <% oJSONoutput.SEQ = seq %>
                <a href="javascript:mx.bbsEditor('edit', <%=seq%>, <%=tailcnt%>);" class="white-btn">상세보기</a>
              </td>
            </tr>
            <%
              i = i + 1
              rs.movenext
              Loop
              Set rs = Nothing
            %>
    		</table>
            <div class="bt-btn-box txt-right">
              <a href='javascript:mx.pubShow(<%=reqjson%>);' class="white-btn">앱노출</a>
              <a href="javascript:mx.bbsEditor('write');" class="blue-btn">등록</a>
            </div>
    	</div>
    </div>
    <!-- E: apply_info -->




<%
  Call userPaginglinkBike (intTotalPage, 10, page, "mx.goPageBBS" )
%>
<!-- #include virtual = "/pub/html/bike/modal.asp" -->
