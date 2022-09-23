<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'저장 (결제정보 임시저장)
'#############################################

	'request
	seq = oJSONoutput.get("SEQ")
	If isnumeric(seq) = False Then
		Response.end
	End If
	

	Set db = new clsDBHelper 

	strTableName = " tblTotalBoard  as a "
	strFieldName = "SEQ,TITLE,REGDATE,MODDATE,(select top 1 FILENAME from tblTotalBoard_File b where a.SEQ = b.TotalBoard_SEQ and b.delyn = 'N') as photo,url,target,sdate,edate,place,attsdate,attedate,  syear,smonth,hostname,subjectnm  "

	SQL = "select " & strfieldname & "  from " & strTableName & " where delyn = 'N'  and viewYN = 'Y'  and cate = 55 and seq = " & seq
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		title = rs("title")
		place = rs("place")
		atts = rs("attsdate")
		atte = rs("attedate")
		hostname = rs("hostname")
		subjectnm = rs("subjectnm")
		fileurl = isnulldefault(rs("photo"),"")
		If fileurl <> "" then
		downurl = CONST_UPHTTP&fileurl
		filename = LCase(Mid(fileurl, InStrRev(fileurl, "/") + 1))
		End if
	End if


	'참가신청가능여부
	If CDate(atts) < Date() And CDate(atte) >=  Date() Then
		att = true
	End if

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>

			<div class="competition_domestic__noti-box t_result">
              <h3><%=title%></h3>
              <ul class="clear">
                <li class="competition_domestic__noti-box__list">
                  <h4>장소</h4><div><span><%=place%></span></div>
                </li>
                <li class="competition_domestic__noti-box__list">
                  <h4>주최/주관</h4><div><span><%=hostname%></span></div>
                </li>
                <li class="competition_domestic__noti-box__list">
                  <h4>신청시작일</h4><div><span><%=atts%></span></div>
                </li>
                <li class="competition_domestic__noti-box__list">
                  <h4>신청종료일</h4><div><span><%=atte%></span></div>
                </li>
                <li class="competition_domestic__noti-box__list">
                  <h4>후원</h4><div><span><%=subjectnm%></span></div>
                </li>
                <li class="competition_domestic__noti-box__list t_file">
                  <h4>첨부파일</h4><div><span>

					<%If fileurl <> "" then%>
					<a href="<%=downurl%>"><%=filename%></a>
					<%End if%>
				  
				  </span></div>
                </li>
              </ul>
				<%If att = True then%>
				<button class="competition_domestic__noti-box__btn t_apply t_class" type="button" onclick="<%If login = True then%>mx.showAttForm(<%=seq%>)<%else%>alert('로그인 후 이용하여 주십시오.')<%End if%>">참가신청</button>
				<%else%>
				<button class="competition_domestic__noti-box__btn t_apply t_class" type="button" onclick="alert('신청이 마감되었습니다.')">참가신청</button>
				<%End if%>

				<button class="competition_domestic__noti-box__btn"  type="button" onclick="mx.goList();">목록</button>
            </div>