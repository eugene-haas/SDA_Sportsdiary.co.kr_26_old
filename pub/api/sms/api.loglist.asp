<!-- #include virtual = "/pub/api/sms/reqAjaxSms.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
'#############################################
' 랭크 포인트 조회
'#############################################


    '타입 석어서 보내기
'    Call oJSONoutput.Set("result", "0" ) 
'  	strjson = JSON.stringify(oJSONoutput)
'	Response.Write strjson
'	Response.write "`##`"


	'request
	pageno = 1
'	If hasown(oJSONoutput, "PAGENO") = "ok" then
		pageno = oJSONoutput.PAGENO
'	End If

	'사이트코드 (관리자생성, 메뉴관리)
	'스타몰 관리자 SITECODE = SDA01
	Select Case LCase(URL_HOST)
	Case "rtadmin.sportsdiary.co.kr","rt.sportsdiary.co.kr" : sitecode = "RTN01"
	Case "swadmin.sportsdiary.co.kr","sw.sportsdiary.co.kr" : sitecode = "SWN01"
	Case "ridingadmin.sportsdiary.co.kr","riding.sportsdiary.co.kr" : sitecode = "RDN01"
	Case "bikeadmin.sportsdiary.co.kr","bike.sportsdiary.co.kr" : sitecode = "BIKE01"
	Case "adm.sportsdiary.co.kr": sitecode = "ADN99"
	Case Else
	'"/cfg/cfg.pub.asp 에서 사이트 코드를 먼저 설정해주세요"
		sitecode = "TENNIS01"	
	End Select



	Set db = new clsDBHelper
	
	If sitecode = "" then
	SQL = "select top 1000 b.userName,b.teamNm,a.sAddrs, left(a.sConts,35)+ '..', a.sResult  from SD_Tennis.dbo.t_send as a left join tblplayer as b on a.sAddrs = b.userPhone where a.sAddrs <>'' and b.delyn = 'N' and b.userPhone <>'010' and sitecode is null  order by nRegID desc"
	Else
	SQL = "select top 1000 b.userName,b.teamNm,a.sAddrs, left(a.sConts,35)+ '..', a.sResult  from SD_Tennis.dbo.t_send as a left join tblplayer as b on a.sAddrs = b.userPhone where a.sAddrs <>'' and b.delyn = 'N' and b.userPhone <>'010' and sitecode = '"&sitecode&"'  order by nRegID desc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'>최근 100개만 표시 (전화번호가 중복되지 않도록 010인 선수들의 번호를 정상으로 바꾸어 주시기 바랍니다.) <font color="red">선수전화번호가 등록되지 않은경우 제거</font></h3>
</div> 	
<div id="orderinfo" style="width:98%;margin:auto;height:500px;overflow:auto;border: 1px solid #73AD21;">
<%Call rsDrow(rs)%>
</div>

<%'Call userPagingScript (intTotalPage, 10, pageno, "mx.reqInfoChange" )%>






<%
  db.Dispose
  Set db = Nothing
%>
