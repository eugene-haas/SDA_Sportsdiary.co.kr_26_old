<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	tablename = "tblPopup"
	strFieldName = " title,url,target,sdate,edate,contents  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE viewyn = 'Y'  order by seq desc"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	If Not rs.eof Then
		e_title= rs(0)
		e_url= rs(1)
		e_target= rs(2)
		e_sdate= rs(3)
		e_edate= rs(4)
		e_contents = htmlDecode(rs(5))
		e_idx				= reqidx
	End if

	db.Dispose
	Set db = Nothing



			If e_idx <> "" then
				%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
			End If



%>


          <div class="l_modal">
			<input type= "hidden" id="popenddate" value="<%=Replace(e_edate,"-","/") & " 00:00:00"%>">
			<section class="m_search-horse">
              <h1 class="m_search-horse__header"></h1>
              <div class="m_search-horse__con"  style="height:520px;overflow:auto;">
                   <%=e_contents%>
              </div>

			  <div class="m_search-horse__btn-box clear">
               <input type="checkbox" id="oneday" value="1"> 하루동안 보지 않기  <a href="javascript:mx.oneDayClose('notipopup')" >닫기</a>
              </div>
            </section>
          </div>
