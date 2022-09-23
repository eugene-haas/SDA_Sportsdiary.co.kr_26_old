<%
'#############################################

'넌도 종목관리 수정 정보 불러오기

'DB SD_Riding 
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblTeamGbInfo 

'#############################################
	'request
	reqidx = oJSONoutput.IDX


	Set db = new clsDBHelper

	strTableName = " tblLimitAtt "
	strFieldName = "  seq,gubun,chkyear,Teamgbnm,  chkHkind   ,chkClass,updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass,writedate "
	strWhere = " seq =  " & reqidx

	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere 
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	Dim rsdic
	Set rsdic = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
	if rs.eof Then
		arrList = ""
	Else
		For i = 0 To Rs.Fields.Count - 1
			rsdic.Add LCase(Rs.Fields(i).name), i 
		Next
		arrList = rs.getrows()
	end if
	set rs = Nothing


	If IsArray(arrList) Then
	For ar = LBound(arrList, 2) To UBound(arrList, 2)
		'dic 소문자로
		e_idx= arrList(rsdic.Item("seq"), ar)
		e_gubun= arrList(rsdic.Item("gubun"), ar)
		e_chkyear= arrList(rsdic.Item("chkyear"), ar)
		e_Teamgbnm= arrList(rsdic.Item("teamgbnm"), ar)
		e_chkHkind   = arrList(rsdic.Item("chkhkind"), ar)
		e_chkClass= arrList(rsdic.Item("chkclass"), ar)
		e_updown= arrList(rsdic.Item("updown"), ar)
		e_zeropointcnt= arrList(rsdic.Item("zeropointcnt"), ar)
		e_chkandor= arrList(rsdic.Item("chkandor"), ar)
		e_prizecnt= arrList(rsdic.Item("prizecnt"), ar)

		e_attokYN= arrList(rsdic.Item("attokyn"), ar)
		e_limitchkClass= arrList(rsdic.Item("limitchkclass"), ar)
		e_limitTeamgbnm= arrList(rsdic.Item("limitteamgbnm"), ar)

		e_H1 = Left(e_chkHkind,1)
		e_H2 = Mid(e_chkHkind,2,1)
		e_H3 = Mid(e_chkHkind,3,1)

	
	Next
	End If
	Set rsdic = Nothing
	

	%><!-- #include virtual = "/pub/html/riding/limitedform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
