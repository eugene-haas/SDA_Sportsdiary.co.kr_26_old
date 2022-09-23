<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
	'request
	If hasown(oJSONoutput, "SEQ") = "ok" then
		reqseq = oJSONoutput.Get("SEQ")
		If isnumeric(reqseq) = False Then
			Response.end
		End if
	End if

	If hasown(oJSONoutput, "CHKNO") = "ok" then
		chkno = oJSONoutput.Get("CHKNO")
	End If


	Set db = new clsDBHelper

	tablename = "tbltotalBoard_shortcourseMember"
	strFieldName = " webseq,playeridx,userid,username,writedate  "

	Sql = "SELECT " & strFieldName & "  from " & tablename &  " WHERE SEQ = " & reqseq
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

'Response.write sql

	db.Dispose
	Set db = Nothing


%>
<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">참가신청목록</button></h4>
    </div>

    <div class="modal-body">
      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">

            <div class="box-body" style="overflow:scroll; height:400px;">

			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_WSEQ = arrR(0, ari)
				l_PIDX = arrR(1, ari)
				l_UID = arrR(2, ari)
				l_UNM = arrR(3, ari)
				l_WDATE = arrR(4, ari)

					Response.write l_unm & " (" &l_uid& ") " & l_wdate & "<br>"
			
			
				Next
			End if
			%>



            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>
      </div>
    </div>

  </div>
</div>

