<%
'######################
'부날짜추가 화면
'######################

	If hasown(oJSONoutput, "BTYPE") = "ok" then
		btype = oJSONoutput.BTYPE
	Else
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End	
	End If

	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper

	If idx <> "" Then
		sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
		sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,m_videoDate,h_videoDate,ip   ,e_videoDate,c_videoDate,d_videoDate,x_videoDate "
		SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where delYN = 'N' and GIDX = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		mvod = isNullDefault(rs("m_videoDate"),"")
		hvod = isNullDefault(rs("h_videoDate")	,"")

		evod = isNullDefault(rs("e_videoDate"),"")
		cvod = isNullDefault(rs("c_videoDate"),"")
		dvod = isNullDefault(rs("d_videoDate"),"")
		xvod = isNullDefault(rs("x_videoDate"),"")


		vodmode = true

		Select Case BTYPE
		Case "e"
			If evod = "" Then
				vodmode = False
			Else
				vods = evod
			End if
		Case "m"
			If mvod = "" Then
				vodmode = False
			Else
				vods = mvod
			End if
		Case "h"
			If hvod = "" Then
				vodmode = False
			Else
				vods = hvod
			End if
		Case "c"
			If cvod = "" Then
				vodmode = False
			Else
				vods = cvod
			End if
		Case "d"
			If dvod = "" Then
				vodmode = False
			Else
				vods = dvod
			End if
		Case "x"
			If xvod = "" Then
				vodmode = False
			Else
				vods = xvod
			End if
		End Select

'		If BTYPE = "m" Then
'			If mvod = "" Then
'				vodmode = False
'			Else
'				vods = mvod
'			End if
'		Else
'			If hvod = "" Then
'				vodmode = false
'			Else
'				vods = hvod
'			End if
'		End If

		 If idx <> "" And vodmode = true Then
			Call oJSONoutput.Set("voddate", vods ) 
		End If
	
	End if


	Call oJSONoutput.Set("result", "0" ) 
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"
%>



    <div class="modal-dialog modal-sm">
      <div class="modal-content">

		<!-- S: modal-header -->
		<div class="modal-header">
          <h2>날짜 추가하기</h2>
		  <a href="#" class="btn btn-close" data-dismiss="modal" >&times;</a>
        </div>
        <!-- E: modal-header -->

		<!-- S: modal-body -->
        <div class="modal-body">
          
		  <a class="btn btn-calendar hasDatepicker" >
            <input type="text" id="mscdate" onchange="mx.SetVodDate('mscul',this.value,'<%=btype%>')" placeholder="날짜선택" style="background-color:transparent;border:0px;color:#fff">
			<!-- <span class="txt">날짜선택</span> -->
            <span class="ic-deco">
              <i class="far fa-calendar-alt"></i>
            </span>
          </a>

          <!-- S: 날짜 추가 될 영역 -->
          <div class="date-list">
            <ul id="mscul">
            </ul>
          </div>
          <!-- E: 날짜 추가 될 영역 -->

		  

        </div>
        <!-- E: modal-body -->

	  </div>
    </div>

<%
	db.Dispose
	Set db = Nothing
%>