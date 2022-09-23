<%
'#############################################
' 심판재량으로 0점처리된것들을 나머지 점수준것들로 평균해서 넣어준다.
'#############################################
	'request
    midx = oJSONoutput.Get("MIDX")
    pidx = oJSONoutput.Get("PIDX")
    npidx = oJSONoutput.Get("NEWPIDX")

    Set db = new clsDBHelper

		'예외처리
    '체점이 완료되었는지 확인한다.
		'Call judgeExceptionRound(midx,roundno , db, ConStr, CDA) '체점완료여부

    lidxq = ",( select top 1 RGameLevelidx from tblRGameLevel where  gametitleidx = a.gametitleidx and gbidx = a.gbidx and delyn = 'N' )  as lidx " 
    leaderq = ",(select top 1 leaderidx from tblGameRequest_imsi where tidx = a.gametitleidx and playeridx = "&pidx&") as leaderidx "
    seqq = ",(select top 1 seq from tblGameRequest_imsi where tidx = a.gametitleidx and playeridx = "&pidx&") as imsiseq "    

    fld = " a.gametitleidx,a.requestidx " & lidxq & leaderq & seqq
    SQL = " Select "&fld&" from sd_gamemember as a inner join sd_gamemember_partner as b on a.gamememberidx = b.gamememberidx "
    SQL = SQL & " where a.delyn = 'N' and a.gamememberidx = " & midx & " and b.playeridx = " & pidx 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    tidx = rs(0)
    ridx = rs(1)
    lidx = rs(2)
    leaderidx = rs(3)
    imsiseq = rs(4)


    SQL = "select top 20 playeridx , kskey ,username, birthday,sex,sidocode,sido,team,teamnm,entertype,userclass,cdbnm from tblplayer "
    SQL = SQL & " where delyn='N' and entertype = 'E' and playeridx = " & npidx
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    
    playeridx = rs(0)
    kskey = rs(1)
    username = rs(2)
    birthday = rs(3)
    sex = rs(4)
    sidocode = rs(5)
    sido = rs(6)
    team = rs(7)
    teamnm = rs(8)
    entertype = rs(9)
    userclass = rs(10)
    cdbnm = rs(11)
    

  '바꿀테이블 sd_gamemember, sd_gamemember_partner , tblgamerequest, tblgamerequest_r, tblGameRequest_imsi
  'SQL = "update sd_gamemember Set "
  SQL = " update sd_gamemember_partner Set playeridx ="&npidx&",ksportsno='"&kskey&"',username='"&username&"' ,sex='"&sex&"',team='"&team&"',teamnm='"&teamnm&"',userclass='"&userclass&"',sido='"&sidocode&"'"
  SQL = SQL & " where delyn='N' and playeridx = "&pidx&" and gamememberidx = " & midx
  'SQL = "update tblgamerequest Set "
  SQL = SQL & " update tblgamerequest_r Set playeridx ="&npidx&",kskey='"&kskey&"',username='"&username&"' ,sex='"&sex&"',team='"&team&"',teamnm='"&teamnm&"',userclass='"&userclass&"' "
  SQL = SQL & " where delyn='N' and playeridx = "&pidx&" and RequestIDX = " & ridx
  Call db.execSQLRs(SQL , null, ConStr)


  
  '새로운 참가자가 있는지 확인해서 넣어주고....
   SQL = "select seq from tblGameRequest_imsi where username = '"&npidx&"' and tidx = " & tidx
   Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    if rs.eof then
      SQL = "SET NOCOUNT ON     "
      SQL = SQL & " insert Into tblGameRequest_imsi (tidx,kskey,playeridx,username,sex,team,teamnm,userclass,birthday,cdb,cdbnm,userphone,sido,sidonm, leaderidx ) "
      SQL = SQL & " Select "&tidx&",kskey,playeridx,username,sex,team,teamnm,userclass,birthday,cdb,cdbnm,userphone,sidocode,sido,'"&leaderidx&"' from tblPlayer  where playeridx = " & npidx
      SQL = SQL & " SELECT @@IDENTITY"
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
      imsi_seq = rs(0)

    else
      imsi_seq = rs(0)
    end if

    SQL = " update tblGameRequest_imsi_r Set seq = " & imsi_seq
    SQL = SQL & " where delyn='N' and seq = "&imsiseq&" and itgubun= 'T' and RgameLevelIDX = " & lidx
    Call db.execSQLRs(SQL , null, ConStr)

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


	Call oJSONoutput.Set("result", 0 )
  Call oJSONoutput.Set("LIDX", lidx )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
