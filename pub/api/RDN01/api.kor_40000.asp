<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%

'#############################################
'에디터창
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	SQL = " select username,Profile from  tblPlayer_korea  where delYN = 'N'   and seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		username = rs(0)
		Profile = htmldecode(rs(1))
	End if

	db.Dispose
	Set db = Nothing



 tempcontents = ""
 tempcontents = tempcontents & "<ul>"&vbCrLf
 tempcontents = tempcontents & "	<li class=""riding_athlete__con-record__list"">"&vbCrLf
 tempcontents = tempcontents & "		<h3>"&year(date)&"년</h3>"&vbCrLf
 tempcontents = tempcontents & "		<ul>"&vbCrLf
 tempcontents = tempcontents & "		<li class=""riding_athlete__con-record__list__list"">샘플 1 내용입력<em>기록</em><strong>순위</strong></li>"&vbCrLf
 tempcontents = tempcontents & "		<li class=""riding_athlete__con-record__list__list"">샘플 2 내용입력</li>"&vbCrLf
 tempcontents = tempcontents & "		</ul>"&vbCrLf
 tempcontents = tempcontents & "	</li>"&vbCrLf
 tempcontents = tempcontents & "</ul>"&vbCrLf

%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">


    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'>프로필등록 : <%=username%></h4>
    </div>
  <!-- 헤더 코트e -->

    <div class="modal-body">
				<div class="editor-box">
					<label for="radio_notice01" class="label_edit">텍스트등록</label>
					 <textarea id="editor1">
					 <%
					 if Profile <> "" and isnull(Profile) = false then
						response.write Profile
					 Else
						response.write tempcontents
					 end if
					 %>
					 </textarea>
				</div>
	</div>


    <div id="rtbtnarea" class="modal-footer">
  	  <a href="javascript:mx.editOK(<%=reqidx%>,'<%=SENDPRE%>')" class='btn btn-primary'>프로필등록</a>
    </div>



  </div>
</div>



