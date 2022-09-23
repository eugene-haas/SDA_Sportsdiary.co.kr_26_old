<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, field, memberIdx

hostIdx = fInject(Request("hostIdx"))
memberIdx = fInject(Request("memberIdx"))
field = fInject(Request("field"))
If hostIdx = "" Then
  Response.End
End If


' 대회정보 + 버스신청 가능여부를 불러온다.
' 버스신청버튼 활성 조건
' 1. 버스에 남은 좌석이 0 이상(BusState)
' 2. 대회에 신청한 기록이 있는지 확인후 결제완료한 신청이 0개이상
' 3. 팀원으로 참가한 신청내역 확인후 결제여부 확인
SQL =       " SELECT a.TitleIdx, a.TitleName, b.SidoNm, a.StartDate, a.EndDate "
SQL = SQL & "      , c.HostName, d.GameAreaName, a.AddressZip, a.Address, a.AddressDetail, a.ApplyStart, a.ApplyEnd, a.ApplyOpenYN "
SQL = SQL & "      , a.CalendarOpenYN, a.MatchTableOpenYN, a.Summary, a.TitleRule, a.EventRule, a.WriteDate "
SQL = SQL & " FROM tblBikeTitle a  "
SQL = SQL & " LEFT JOIN tblSidoInfo b ON a.Sido = b.Sido  "
SQL = SQL & " LEFT JOIN tblBikeHostCode c ON a.HostIdx = c.HostIdx  "
SQL = SQL & " LEFT JOIN tblBikeGameArea d ON a.GameAreaIdx = d.GameAreaIdx  "
' SQL = SQL & " WHERE a.HostIdx = "& hostIdx &" AND a.DelYN = 'N' AND a.OpenYN = 'Y' "
SQL = SQL & " WHERE a.HostIdx = "& hostIdx &" AND a.DelYN = 'N' "
SQL = SQL & " ORDER BY a.ApplyStart DESC "


Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRs = rs.getRows()
End If


If IsArray(arrRs) Then
  jsonStr = "{""titleList"": ["
  For i = 0 To Ubound(arrRs, 2)
    titleIdx         = arrRs(0, i)
    title            = arrRs(1, i)
    place            = arrRs(2, i)
    startDate        = arrRs(3, i)
    endDate          = arrRs(4, i)
    applyStart       = arrRs(10, i)
    applyEnd         = arrRs(11, i)
    applyOpenYN      = arrRs(12, i)
    busStatus        = GetBusApplyAvailable(db, titleIdx, memberIdx)

    jsonStr = jsonStr & "{""titleIdx"": "& titleIdx &", ""title"": """& title &""", ""place"": """& place &""", ""startDate"": """& startDate &""" "
    jsonStr = jsonStr & ", ""endDate"": """& endDate &""", ""busStatus"": """& busStatus &""", ""applyStart"": """& applyStart &""" "
    jsonStr = jsonStr & ", ""applyEnd"": """& applyEnd &""", ""applyOpenYN"": """& ApplyOpenYN &""" } "
    If i <> Ubound(arrRs, 2) Then
      jsonStr = jsonStr & ", "
    End If
  Next
  jsonStr = jsonStr & "]}"
End If

Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
