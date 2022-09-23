<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

    '##############################################
    ' 소스 뷰 경계
    '##############################################
%>


<%
  'idx = oJSONoutput.IDX
  'tidx = oJSONoutput.TitleIDX
  'title = oJSONoutput.Title
  'teamnm = oJSONoutput.TeamNM
  'areanm = oJSONoutput.AreaNM

  idx = 2108
  tidx = 73
  title = "2017 Song 배 전국 테니스 대회"
  teamnm = "개나리부"
  areanm = "대구"

  Set db = new clsDBHelper

  SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
  'Response.write "</br> " & SQL
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    entrycnt = rs("entrycnt") '참가제한인원수
    attmembercnt = rs("attmembercnt") '참가신청자수
    courtcnt = rs("courtcnt") '코트수
    levelno = rs("level")
    poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
  End if

  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "
  
  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0  and a.gubun in ( 0, 1) "
  strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '조별
  strAfield = " tryoutgroupno, tryoutsortno, gamememberIDX "
  strfield = strAfield

  SQL = "select " & strfield & " from  " & strtable & " as a " 
  SQL = SQL & "where " & strwhere & strsort

  Response.write "</br> " & SQL
  'response.end
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then 
    arrRS = rs.getrows()
  End If
    
    If IsArray(arrRS) Then
        For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
        
        Next  
    END IF
  db.Dispose
  Set db = Nothing
%>