<%
 

  idx = oJSONoutput.IDX
  tidx = oJSONoutput.TitleIDX
  gamekey3 = oJSONoutput.S3KEY '게임종목 키

	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)
  endGroup = oJSONoutput.EndGroup
  jooAreaValue = oJSONoutput.JooAreaValue

  'Response.Write "idx : " & idx & "<BR>"
  'Response.Write "tidx : " & tidx & "<BR>"
  'Response.Write "gamekey3 : " & gamekey3 & "<BR>"
  'Response.Write "levelkey :" & levelkey & "<BR>"
  'Response.Write "gamekey3 : " & gamekey3 & "<BR>"
  'Response.Write "endGroup :" & endGroup & "<BR>"
  'Response.Write "jooAreaValue :" & jooAreaValue & "<BR>"
   
  Set db = new clsDBHelper
  SQL = " Select JooArea from tblRGameLevel  where DelYN = 'N' and  RGameLevelidx = " & idx
  'Response.write "</br> " & SQL
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    rJooArea = rs("JooArea")
  End if
 
  if(Cdbl(rJooArea) <> Cdbl(jooAreaValue)) then
    SQL = "UPDATE tblRGameLevel SET JooArea = '" & jooAreaValue & "' where  DelYN = 'N' and  RGameLevelidx = " & idx
    'Response.write "</br> " & SQL
    Call db.execSQLRs(SQL , null, ConStr)
  End if
 
  'Response.Write "rJooDivision :" & rJooDivision & "<BR>"
  'Response.end

  db.Dispose
	Set db = Nothing
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>