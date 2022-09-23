<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'참가종목 선택시 참가부 선택 목록
' > 호출 완료시 참가내역 호출
'#############################################

	'request
	tidx = oJSONoutput.get("TIDX")
	lidx = oJSONoutput.get("LEVELIDX")
	pteamgb = oJSONoutput.get("PTEAMGB")


	Set db = new clsDBHelper

	strTableName = "  tblRGameLevel "
	strfield = " RGameLevelidx,pubcode,pubName,gameno,GameTitleIDX,GbIDX,attdateS,attdateE,GameDay,GameTime,levelno,attmembercnt,fee,cfg "
	strSort = "  ORDER BY gameno asc, pubcode , RGameLevelidx Desc"
	strWhere = " GameTitleIDX = "&tidx&" and DelYN = 'N' and gameno = (select gameno from tblRGameLevel where RGameLevelidx = "&lidx&") "

	SQL = "Select "&strField&" from "&strTableName&" where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	' call rsdrow(rs)
	' response.end


	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>

<select id="attgameboo">
<%
 For i = LBound(arrR, 2) To UBound(arrR, 2)
 	s_lidx = arrR(0,i)
	if Cstr(lidx) = Cstr(s_lidx) Then
		startgameno = arrR(3,i)
	end if
 next

 For i = LBound(arrR, 2) To UBound(arrR, 2)
	s_pubcode = arrR(1, i)
	s_pubName = arrR(2, i)
	s_gameno = arrR(3, i)
	if Cstr(startgameno) = Cstr(s_gameno) then
		%><option value="<%=s_pubcode%>"><%=s_pubName%></option><%
	end if
  next
%>
</select>
