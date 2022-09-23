<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	SQL = "Select gameyear  from sd_bikeTitle where delYN = 'N' group by gameyear order by 1 desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrY = rs.GetRows()
	End If

	If GY = "" Then
		GY = year(date)
	End If
	
	If TID = "" Then
		tid = 1
	End if

	'그룹/종목
	SQL = "Select titleIDX,gameTitleName from sd_bikeTitle where delYN = 'N' and gameyear = '"&GY&"' order by titleidx desc"
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
	
	
	
	'search
'	If chkBlank(search_word) Then
'		strWhere = " tid = 0 "
'	Else
'		strWhere = " tid = " & tid
'		page_params = "&search_word="&search_word
'	End if
%>
<%'View ####################################################################################################%>
        <div class="sub-content" id="bbseditor"></div>

        <!-- S: sub-content -->
		<div class="sub-content" id="bbslist">


			<!-- s: 정보 검색 -->
				<div class="box-shadow" id="gamefind_area">
					<!-- #include virtual = "/pub/html/bike/form.gameSearch.asp" -->
				</div>
			<!-- e: 정보 검색 -->



            <!-- S: competition_management -->
            <div class="player_video">


          <div class="all-list-number">
            <span class="l-txt">
              전체<span class="red-font font-bold"><%=intTotalCnt%></span>건
            </span>
          </div>



    				<!-- <div class="t-btn-box"> -->
						<!-- <a href='javascript:mx.bbsEditor(cmd = mx.CMD_W + <%=tid%>,<%=reqjson%>,<%=page%>);' class="navy-btn" id="btnsave"  accesskey="i">글쓰기<span>(I)</span></a> -->
    					<!-- <a href="#" class="navy-btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
    					<a href="#" class="white-btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a> -->
    				<!-- </div> -->




    			<!-- s: 테이블 리스트 -->
    				<div class="table-box basic-table-box">
						
						<table cellspacing="0" cellpadding="0">

        						<%
									i=1
									Do  until  rs.EOF  Or  i  > int(intPageSize)
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
									<%If i = 1 then%>
									<tr>
										<!-- <th>번호</th> -->
										<th><input type="checkbox" id="showb" value="1" onclick="mx.chk('showb','showflag')" <%If pubshow = "1" then%>checked<%End if%>></th>
										<th>대회명</th>
										<th>종목명</th>
										<th>제목</th>
										<th>이미지등록수</th>
										<th>작성일</th>
										<th>조회수</th>
										<th>보기</th>
									</tr>
									<%End if%>

									  <tr>
										<!-- <td><span><%=num%></span></td> -->
										<td><span><input type="checkbox" name="showflag" value="<%=seq%>" <%If pubshow = "1" then%>checked<%End if%>></span></td>
										<td title="<%=titleNm%>"><span><%=Left(titleNm,10)%>..</span></td>
										<td><span><%=levelNm%></span></td>
										<td><span><%=title%></span></td>
										<td><span><%=tailcnt%></span></td>
										<td><span><%=writeday%></span></td>
										<td><span><%=readnum%></span></td>
										<td>
											  <%
												oJSONoutput.SEQ = seq
											  %>
											  <a href='javascript:mx.bbsEditor(cmd = mx.CMD_W + <%=tid%>,<%=JSON.stringify(oJSONoutput)%>,<%=page%>);' class="white-btn">상세보기</a>
										</td>
									  </tr>										
									
									<%
        						  i = i + 1
								  rs.movenext
        						  Loop
        						  Set rs = Nothing
        						%>
    					</table>
    				</div>
    			<!-- e: 테이블 리스트 -->

				<div class="bt-btn-box txt-right">
					<a href='javascript:mx.pubShow(<%=reqjson%>);' class="white-btn">앱노출</a>

					<a href='javascript:mx.bbsEditor(cmd = mx.CMD_W + <%=tid%>,<%=reqjson%>,<%=page%>);' class="blue-btn">등록</a>
				</div>

    			<!-- s: 더보기 버튼 -->
				<div class="paging">
    				<%
    					Call userPaginglinkBike (intTotalPage, 10, page, "mx.goPageBBS" )
    				%>
    			</div>
    			<!-- e: 더보기 버튼 -->

            </div>
            <!-- E: competition_management -->
		</div>
		<!-- s: sub-content -->