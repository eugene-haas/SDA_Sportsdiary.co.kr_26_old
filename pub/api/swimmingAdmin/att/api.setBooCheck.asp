<%
'request
		tidx = oJSONoutput.get("TIDX")
		team = oJSONoutput.get("TEAM")
    leaderidx = oJSONoutput.Get("LEADERIDX") '리더인덱스
'request

	Set db = new clsDBHelper

	'###################################################################


  'E2 F2 만 체크
  '단체 T 만 가져올것
  SQL = ";with chktbl as ( "
  SQL = SQL & " SELECT levelno,cdcnm,count(levelno) as cnt from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b "
  SQL = SQL & " ON a. seq = b.seq and b.delyn = 'N' "
  SQL = SQL & " WHERE itgubun = 'T' and (CDA ='E2' or (CDA = 'F2' and CDC <> '31')) and tidx="&tidx&" and a.leaderidx="&leaderidx&" and team='"&team&"' "
  SQL = SQL & " GROUP BY levelno,cdcnm) "

  SQL = SQL & " select count(state) from ( "
  SQL = SQL & " SELECT (case when right(cdcnm,1) = '팀' and cnt <4 then 'fail' when right(cdcnm,2) = '듀엣' and cnt < 2 then 'fail' else 'success' end) as state "
  SQL = SQL & " from chktbl) as a "
  SQL = SQL & " where state = 'fail' "

'Response.write sql
'Response.end

  
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  failcnt = rs(0)

  if Cdbl(failcnt) = 0 then
    Call oJSONoutput.Set("result", "0" )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
  else
    Call oJSONoutput.Set("result", "111" )
    Call oJSONoutput.Set("servermsg", "듀엣이나 팀의 기준인원이 부족합니다. 다시 설정해 주십시오." )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
  end if

	db.Dispose
	Set db = Nothing
%>

