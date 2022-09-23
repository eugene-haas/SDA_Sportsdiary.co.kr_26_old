<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

eventApplyIdx     = fInject(Request("eventApplyIdx"))
mode              = fInject(Request("mode")) ' all 전체취소, member 팀원취소
teamMemberDel     = fInject(Request("teamMemberDel")) '삭제 팀원 리스트
cancelYN          = fInject(Request("cancelYN")) '가상계좌 발급 이후 취소시 cancelYN 파라미터를 y로 업데이트

If eventApplyIdx = "" Or mode = "" Then
  Response.End
End If


' db 처리 시작
on error resume next
db.BeginTrans()

Call DeleteTeamInfo(db, eventApplyIdx, mode, teamMemberDel, cancelYN)

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true}"
End If

' api를 직접 호출해서 session이 비어있는경우
Set db = nothing
Set rs = nothing
Response.Write jsonStr
Response.End
%>
