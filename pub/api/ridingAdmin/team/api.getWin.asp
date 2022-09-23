<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "TEAM") = "ok" then
		e_team = oJSONoutput.Get("TEAM")
	End If
	

	If hasown(oJSONoutput, "APPLYYN") = "ok" then
		e_applyyn = oJSONoutput.Get("APPLYYN")
	End If

	Set db = new clsDBHelper

	tablename = "tblTeamInfo "

	If e_applyyn = "Y" Then '허용한 상태라면

		Sql = "select team,teamnm,username from tblLeader where team = '"&e_team&"'"
		Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)

		If Not rs.EOF Then
			arrL = rs.GetRows()
		End If

		Sql = "select team,teamnm,username from tblplayer where team = '"&e_team&"'"
		Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)

		If Not rs.EOF Then
			arrP = rs.GetRows()
		End If

	Else

		Sql = "select apply_team,apply_teamnm,username from tblLeader where apply_team = '"&e_team&"'"
		Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)

		If Not rs.EOF Then
			arrL = rs.GetRows()
		End If

		Sql = "select apply_team,apply_teamnm,username from tblplayer where apply_team = '"&e_team&"'"
		Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)

		If Not rs.EOF Then
			arrP = rs.GetRows()
		End If
	
	End If

	'Call db.execSQLRs(SQL , null, ConStr)
	'Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>


<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">팀 정보</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">



            <div class="box-body">
			
<%'=sql%>

			<!-- 리스트 (지도자 , 선수 가져오기) -->
<%
	If IsArray(arrL) Then  '오전경기
		For ari = LBound(arrL, 2) To UBound(arrL, 2)

			l_team = arrL(0, ari)
			l_teamnm= arrL(1, ari)
			l_username= arrL(2, ari)
				
				Response.write "지도자 : " & l_username & "<br>"
		Next
	End if


	If IsArray(arrP) Then  '오전경기
		For ari = LBound(arrP, 2) To UBound(arrP, 2)

			l_team = arrP(0, ari)
			l_teamnm= arrP(1, ari)
			l_username= arrP(2, ari)

			Response.write "선수 : " & l_username & "<br>"
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