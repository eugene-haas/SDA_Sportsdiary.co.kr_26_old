<%
	If hasown(oJSONoutput, "PN") = "ok" Then 
		PN = chkStrRpl(oJSONoutput.PN,"")
	End If	

	If hasown(oJSONoutput, "SEQ") = "ok" Then 
		seq = chkStrRpl(oJSONoutput.SEQ,"")
	Else
		seq = ""
	End If	



	Set db = new clsDBHelper

	If seq = "" Or seq = "0" Then
		cssclassNm = "write"
		btntxt = "등록"
		btnimgtxt = "이미지등록"
		editmode = "write"
	Else
		cssclassNm = "view"
		btntxt = "수정"
		btnimgtxt = "이미지추가"
		editmode = "edit"

		titleq = "(select gameTitleName from sd_bikeTitle where titleIDX = a.titleIDX) as titleNm " 
		subtitleq = "(select detailtitle from sd_bikeLevel where levelIDX = a.levelno) as levelNm "
		strFieldName = titleq &"," &subtitleq& ", seq,tid,title,contents,pid,ip,readnum,writeday,num,ref,re_step,re_level,tailcnt,filename,pubshow,topshow, titleIDX,levelno " 
		strTableName = "  sd_bikeBoard as a "
		strWhere = " pubshow = '1' and tid = '"&tid&"' "
		SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		tidx = rs("titleidx")
		levelno = rs("levelno")
		title = rs("title")
		writeday = rs("writeday")
		readnum = rs("readnum")

		'이미지정보
		'종목
		SQL = "Select idx,filename,thumbnail from sd_bikeBoard_c where seq = " & seq
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrI = rs.GetRows()
		End If	

	
		'종목
		SQL = "Select levelIDX,detailtitle,sex,booNM from sd_bikeLevel where delYN = 'N' and titleIDX = '"&tidx&"' order by sex, booNM"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrB = rs.GetRows()
		End If	
	End If
	'########################################


	SQL = "Select gameyear  from sd_bikeTitle where delYN = 'N' group by gameyear order by 1 desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrY = rs.GetRows()
	End If

	If GY = "" Then
		GY = year(date)
	End if
	'그룹/종목
	SQL = "Select titleIDX,gameTitleName from sd_bikeTitle where delYN = 'N' and gameyear = '"&GY&"' order by titleidx desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If
	
%>
		
		<form method="post"  name="fileform" action="/pub/up/imgUpload.asp" ENCTYPE="multipart/form-data"> <!-- target="_hiddenFrame" -->
		<input type="hidden" name="tid" id="tid" value="<%=tid%>">
		<input type="hidden" name="p" id="p">

		<%If seq <> "" and seq <> "0" then%>
		  <input type="hidden" name="seq" id="seq" value="<%=seq%>">
		<%End if%>


        <!-- S: player_video_write -->
        <div class="player_video_<%=cssclassNm%>" id="gameinput_area">
          <!-- S: box-shadow -->
          <div class="box-shadow">
            <!-- S: table-box -->
            <div class="table-box basic-<%=cssclassNm%>">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <th>대회명</th>
                  <td id="wyear">
					<select name = "sgameYear" id="sgameYear"  class="sl_search w_50" onchange="mx.selectYear('B',<%=page%>);">
					  <%
					  If IsArray(arrY) Then
						  For ar = LBound(arrY, 2) To UBound(arrY, 2)
							  s_gameyear = arrY(0, ar)
							  %><option value="<%=s_gameyear%>" <%If CStr(GY) = s_gameyear then%>selected<%End if%>><%=s_gameyear%></option><%
						  i = i + 1
						  Next
					  End if
					  %>
					</select>

					<select name="sgametitle"  id="sgametitle"  class="sl_search" onchange="mx.SelectTitle('B',<%=page%>)">
					<option value="">=대회선택=</option>
					  <%
					  If IsArray(arrRS) Then
						  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
							  gtitleIDX = arrRS(0, ar)
							  gtitleName = arrRS(1, ar)
							  %><option value="<%=gtitleIDX%>" <%If CStr(gtitleIDX) = CStr(tidx) then%>selected<%End if%>><%=gtitleName%></option><%
						  i = i + 1
						  Next
					  End if
					  %>
					</select>
                  </td>
                </tr>

                <tr>
                  <th>종목</th>
                  <td id="wlevel">
					  <select name="slevelno" id="slevelno"  class="sl_search">
						  <option value="">=종목선택=</option>
							  <%
							  If IsArray(arrB) Then
								  %><option value="0">연습시간</option><%
								  For ar = LBound(arrB, 2) To UBound(arrB, 2)
									  glevelno = arrB(0, ar)
									  gsubtitle = arrB(1, ar)
									  gbooNM = arrB(2, ar)
									  %><option value="<%=glevelno%>" <%If CStr(glevelno) = levelno then%>selected<%End if%>><%=gsubtitle%>[<%=gbooNM%>] </option><%
								  i = i + 1
								  Next
							  End if
							  %>
					  </select>
                  </td>
                </tr>


				<tr>
                  <th>제목</th>
                  <td>
                      <input type="text" placeholder="제목을 입력하세요" class="in-style-1" id="title" name="title" maxlength="100" value="<%=title%>">
                  </td>
                </tr>
                <tr>
                  <th>워터마크</th>
                  <td>
						<select id="watermark_yn" name="watermark_yn" >
						<option value="Y" selected>포함</option>
						<option value="N">미포함</option>
						</select>
                  </td>
                </tr>
                <tr>
                  <th><%=btnimgtxt%></th>
                  <td>
					<input multiple="multiple"  type="file" name="iFile" id="iFile_1" class="in-file"  /><!-- (다중파일 선택가능) -->
                  </td>
                </tr>


<%If editmode = "edit" Then%>
				<tr>
                  <th>작성일</th>
                  <td>
                    <span><%=writeday%></span>
                  </td>
                </tr>
                <tr>
                  <th>조회수</th>
                  <td>
                    <span><%=readnum%></span>
                  </td>
                </tr>
                <tr>
                  <th>
				  <div class="delet-btn">
				  <!-- <a href="javascript:mx.checkbox(document.fileform.scimg)" class="white-btn">전체선택</a> -->
				  <a href="javascript:mx.checkAll()" class="white-btn">전체선택</a>
				  </div>
				  </th>
                  <td>
                    
<%If editmode = "edit" Then%>
              <div class="delet-btn">
                <a href='javascript:mx.imgDel(document.fileform.scimg,<%=JSON.stringify(oJSONoutput)%>)' class="black-btn">선택삭제</a>
              </div>
<%End if%>

                  </td>
                </tr>
		<%
		  If IsArray(arrI) Then
			  For ar = LBound(arrI, 2) To UBound(arrI, 2)
			  tmbidx = arrI(0, ar)
			  oimg = arrI(1,ar)
			  tmb = arrI(2, ar)
		%>
				<tr>
                  <th><input type="checkbox" class="in-check" id="tmb_<%=tmbidx%>" name="scimg" value="<%=tmbidx%>">&nbsp;IMG</i>-<%=ar+1%></th>
                  <td>
                    <label class="lable-img">
                      <img src="<%=UPTMBURL%><%=tmb%>" class="list-thumbnail" alt="">
                      <!-- <input type="checkbox" class="in-check" id="tmb_<%=tmbidx%>" name="scimg" value="1"> -->
                    </lable>

					<!-- <p><a href="javascript:window.open('<%=UPURL%><%=oimg%>')"><%=UPURL%><%=oimg%></a></p>  -->
                  </td>
                </tr>
		<%
				Next
			End if
		%>
<%End if%>
              </table>

<%If editmode = "edit" Then%>
              <!-- <div class="delet-btn">
                <a href="#" class="black-btn">선택삭제</a>
              </div> -->
<%End if%>


            </div>
            <!-- E: table-box -->
          </div>
          <!-- E: box-shadow -->

		  <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="javascript:mx.bbsList();" class="white-btn">목록</a>
            <!-- <a href="#" class="white-btn">취소</a> -->

			<%If editmode = "edit" Then%>
                <!-- <a href='javascript:mx.deleteBBS(<%=JSON.stringify(oJSONoutput)%>)' class="red-btn">삭제</a> --><!-- 막아둠....삭제방지 -->
			<%End if%>			
			
			
			<a href='javascript:mx.fsubmit(<%=JSON.stringify(oJSONoutput)%>);' class="blue-btn"><%=btntxt%></a>
          </div>
          <!-- E: bt-btn-box -->
        </div>
        <!-- E: player_video_write -->

		</form>

<%
	db.Dispose
	Set db = Nothing
%>