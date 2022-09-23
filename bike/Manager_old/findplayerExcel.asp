<!-- #include virtual = "/pub/header.bike.asp" -->

<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%

Set db = new clsDBHelper

'request

REQ = chkReqMethod("p", "POST")
	If REQ <> "" then
	Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)
		stype = chkInt(oJSONoutput.st,1)
		ptype = chkInt(oJSONoutput.pt,1) '입금상태

        If hasown(oJSONoutput, "sv") = "ok" Then
			svalue = chkLength(chkStrRpl(oJSONoutput.sv, ""), 20)
		End if

        If hasown(oJSONoutput, "tidx") = "ok" then
			tidx = oJSONoutput.tidx
		Else
			tidx = 0
		End If

        If hasown(oJSONoutput, "gidx") = "ok" then
			gidx = oJSONoutput.gidx
		Else
			gidx = 1
		End if

		If hasown(oJSONoutput, "ridx") = "ok" then
			ridx = oJSONoutput.ridx
		Else
			ridx = 0
		End if

        If hasown(oJSONoutput, "excelkind") = "ok" then
            excelkind = oJSONoutput.excelkind
        Else
            excelkind = ""
        End if


	Else
		'findmode 전체검색
		page = chkInt(chkReqMethod("page", "GET"), 1)
		selecttype = "default"
        gidx = 1
        ptype = 1
	End if




' If excelkind = "default" Then
'     '신청자 정보 셀렉트 필드와 테이블은 공통
'     strTable = " sd_bikeRequest a"
' 	strTableSub = " INNER JOIN sd_bikeGame c ON a.gameIDX = c.gameIDX "
'     strField = " a.subType, a.PlayerIDX, a.UserName '선수이름', a.PaymentState '입금확인' , a.PaymentName '입금자', a.Paymentdate '입금확인날짜', a.attmoney '금액', a.Writeday '신청일' "
'     strField = strField & ", a.refundno '환불계좌번호', a.refundbnk '환불신청은행', a.refundattdate '환불신청날짜', a.refundstate '환불상태', a.refundupdate '환불날짜' "
'     strField = strField & ", ( SELECT GameTitleName FROM sd_bikeTitle WHERE titleIDX = a.titleIDX ) as '대회명' "
'     strField = strField & ", ( SELECT detailtitle FROM sd_bikelevel WHERE titleIDX = a.titleIDX AND levelIDX = a.levelno ) as '부명' "
' 	strField = strField & ", ( SELECT COUNT(groupno) FROM sd_bikeRequest WHERE groupno = a.groupno AND groupno <> 0 ) as requestCount "
'
'     strWhere = " a.DelYN = 'N' AND c.gubun in ( 0, 1 ) "
'
'     Select Case CDbl(ptype)
'         Case 2
'             strWhere = strWhere &  " AND PaymentState = 'N' "
'         Case 3
'             strWhere = strWhere &  " AND PaymentState = 'Y' "
'     End Select
'
'     '입금자명/선수명 검색
'     If svalue <> "" Then
'         Select Case CDbl(stype)
'         Case 1 '입금자
'             strWhere = strWhere &  " AND PaymentName like '%"&svalue&"%' "
'         Case 2 '선수
'             strWhere = strWhere &  " AND UserName like '%"&svalue&"%' "
'         End Select
'     End If
'
'     '대회선택
'     If tidx <> 0 Then
'         strWhere = strWhere & " AND titleIDX = "&tidx&" "
'     End If
'     '부서선택
'     If ridx > 0 Then
'         strWhere = strWhere & " AND levelno = "&ridx&" "
'     End If
'
'     '개인/단체 구분
'     If gidx = 2 Then
'         strWhere = strWhere & " AND groupno = 0 "
'         SQL = "SELECT "&strField&" FROM "&strTable&strTableSub&" WHERE "&strWhere&" "
'     ElseIf gidx = 1 Then
'         strWhere = strWhere & " AND a.groupno <> 0 "
'         strJoin = " (SELECT MAX(requestIDX) requestIDX, groupno FROM sd_bikeRequest WHERE groupno <> 0  GROUP BY  groupno) b ON a.requestIDX = b.requestIDX "
'         SQL = "SELECT  "&strField&" FROM "&strTable&strTableSub&" INNER JOIN "&strJoin&" WHERE "&strWhere
'     End If



If gidx = 1 Then

    strTable = " sd_bikeAttmember a "
    strTableSub1 = " INNER JOIN sd_bikeGame b ON a.gameidx = b.gameidx "
    strTableSub2 = " INNER JOIN sd_bikeLevel c ON b.levelno = c.levelIDX "
    strTableSub3 = " INNER JOIN sd_bikeTitle d ON c.titleIDX = d.titleIDX "
    strTableSub4 = " INNER JOIN tblMember e ON a.PlayerIDX = e.PlayerIDX "
    strTableSub5 = " INNER JOIN sd_member..tblMember f ON f.UserID = e.SD_UserID "
    strTable = strTable&strTableSub1&strTableSub2&strTableSub3&strTableSub4&strTableSub5
    strField = " a.userName AS '선수명', a.sex AS 성별, a.giftCode AS '사은품', c.detailtitle AS '부', a.pgrade AS '등급', d.gameTitleName AS '대회명', a.attmidx, a.gameidx, a.groupno, a.p_agree, f.Address"
    strField = strField & ", case ISNULL(a.p_addr, 'NULL') when 'NULL' Then 'N' Else 'Y' End AS SMS "
    strWhere = " b.DelYN = 'N' AND a.groupno <> 0 AND b.gubun in (0,1) "


    If tidx > 0 Then
        strWhere = strWhere & " AND d.titleIDX = "&tidx&" "
    End If

    '입금여부
    Select Case CDbl(ptype)
    '입금전
    Case 2
        strWhere = strWhere &  " AND b.gubun = 0 "
    '입금완료
    Case 3
        strWhere = strWhere &  " AND b.gubun = 1 "
    End Select

    SQL = " SELECT "&strField&" FROM "&strTable&" WHERE "&strWhere&" "

ElseIf gidx = 2 Then

    strTable = " sd_bikeAttmember a "
    strTableSub1 = " LEFT JOIN sd_bikeGame c ON a.gameIDX = c.gameIDX "
    strTableSub2 = " LEFT JOIN sd_bikeLevel d ON c.levelno = d.levelIDX "
    strTableSub3 = " LEFT JOIN sd_bikeTitle e ON d.titleIDX = e.titleIDX "
    strTable = strTable&strTableSub1&strTableSub2&strTableSub3

    strWhere = " a.groupno = 0 AND c.gubun in (0,1) "
    strGroup = " a.gameIDX, d.detailtitle , e.GameTitleName, a.teamtitle "
    strField = " a.gameIDX, a.teamtitle, REPLACE(REPLACE((STUFF((SELECT ',' + b.userName,b.sex as 's' FROM sd_bikeAttmember b WHERE (b.gameIdx = a.gameIdx) FOR XML PATH ('')),1,1,'')), '<s>', '('), '</s>' ,')') 'member' "
    strField = strField & " , STUFF((SELECT ',' + b.giftCode FROM sd_bikeAttmember b WHERE (b.gameIdx = a.gameIdx) FOR XML PATH ('')),1,1,'') '사은품' "
    strField = strField & " , STUFF((SELECT ',' + (case ISNULL(b.p_addr, 'NULL') when 'NULL' Then 'N' Else 'Y' End) FROM sd_bikeAttmember b WHERE (b.gameIdx = a.gameIdx) FOR XML PATH ('')),1,1,'') 'SMS' "
    strField = strField & " , STUFF((SELECT ',' + b.p_agree FROM sd_bikeAttmember b WHERE (b.gameIdx = a.gameIdx) FOR XML PATH ('')),1,1,'') '부모동의' "
    strField = strField & " , STUFF((SELECT ',' + g.Address FROM (select a.username,a.gameidx, a.playerIDX, d.Address  from sd_bikeAttMember a "
	strField = strField & "            LEFT JOIN sd_bikeGame b ON a.gameIDX = b.gameIDX "
	strField = strField & "		   	   LEFT JOIN tblMember c ON a.PlayerIDX = c.PlayerIDX "
	strField = strField & "			   LEFT JOIN SD_Member..tblMember d ON c.SD_UserID = d.UserID) g  WHERE (a.gameIdx = g.gameIdx) FOR XML PATH ('')),1,1,'') '주소'  "
    strField = strField & " , d.detailtitle AS '부', e.GameTitleName AS '대회명' "


    If tidx > 0 Then
        strWhere = strWhere & " AND c.titleIDX = "&tidx&" "
    End If

    '입금여부
    Select Case CDbl(ptype)
    '입금전
    Case 2
        strWhere = strWhere &  " AND c.gubun = 0 "
    '입금완료
    Case 3
        strWhere = strWhere &  " AND c.gubun = 1 "
    End Select

    SQL = " SELECT "&strField&" FROM "&strTable&strTableSub&" WHERE "&strWhere&" GROUP BY "&strGroup&""

End If


Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If excelkind = "download" Then
    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.CacheControl = "public"
    Response.AddHeader "Content-disposition","attachment;filename= 부참가정보_"&date()& ".xls"
End If


'##############################################
' 소스 뷰 경계
'##############################################
%>

<!DOCTYPE html>
<html>
<head>
<title>excel</title>
</head>
<body >
<%
Call rsDrow(rs)
 %>

</body>
</html>
