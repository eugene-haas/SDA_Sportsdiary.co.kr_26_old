<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
'#############################################
'메인 뷰
'#############################################
	'request



  Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  function tagstatus(val,val2,val3)
    teamnametag = "["
    if val = "Y" then
      if val3 = CONST_TYPEA1 or val3 = CONST_TYPEA2 or val3 = CONST_TYPEA_1 then
        if val2 = "1" then
          teamnametag = "[1라운드/"
        elseif val2 = "2" then
          teamnametag = "[2라운드/"
        elseif val2 = "3" then
          teamnametag = "[결승/"
        else
          teamnametag = "[재경기"& (cint(val2)-3) &"/"
        end if
      end if
    else
      if val3 = CONST_TYPEA1 or val3 = CONST_TYPEA2 then
        if val2 = "1" then
          teamnametag = "["
        else
          teamnametag = "[재경기/"
        end if
      end if
    end if
    tagstatus = teamnametag
  end function

  if tidx <> "" then
    
	If tidx = DEBUGTIDX Then '테스트
	selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' "
	else
	selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' and stateno = 1"
	End if
    Set rsCheck = db.ExecSQLReturnRS(selectCheck , null, ConStr)

	'Call rsdrow(rscheck)
	'response.end
	
	if rsCheck.eof then
      response.write "{""jlist"": [{""status"": """",""title"": """"}]}"
      response.end
    end if
    set rsCheck = nothing

'        &" '[제'+convert(varchar(max),BB.gamenostr)+'경기] '+DD.TeamGbNm+' '+DD.levelNm+' '+DD.ridingclass+' '+DD.ridingclasshelp+' '+convert(varchar(max),AA.tryoutsortNo)+'번 '+AA.userName+'('+CC.userName+')' as titlename "_
    sql = "select "_

        &" '[제'+convert(varchar(max),BB.gamenostr)+'경기] '+DD.TeamGbNm+' '+DD.levelNm+' '+DD.ridingclass+' '+convert(varchar(max),AA.tryoutsortNo)+'번 '+AA.userName+'('+CC.userName+')' as titlename "_
        &" ,aa.[Round] "_
        &" ,(select kgame from sd_TennisTitle EE where AA.GameTitleIDX = EE.GameTitleIDX) as kgame "_
        &" ,dd.ridingclasshelp "_
        &" from sd_TennisMember AA "_
        &" inner join ( "_
        &" select GameTitleIDX,gamenostr,GbIDX from tblRGameLevel where DelYN = 'N' group by GameTitleIDX,gamenostr,GbIDX "_
        &" ) BB on AA.gamekey3 = BB.GbIDX and AA.GameTitleIDX = BB.GameTitleIDX "_
        &" LEFT JOIN sd_tennisMember_partner CC on AA.gameMemberIDX = CC.gameMemberIDX "_
        &" left join tblTeamGbInfo DD on BB.GbIDX = DD.TeamGbIDX "_
        &" where AA.DelYN='N' and DD.DelYN = 'N' and gamest = '2' and AA.GameTitleIDX = '"& tidx &"' order by newid()"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




    if not rs.eof Then
      response.write "{""jlist"": [{""status"": ""경기중"",""title"": """& replace(rs(0),"[",tagstatus(rs(2),rs(1),rs(3))) &"""}]}"
    else
      response.write "{""jlist"": [{""status"": """",""title"": """"}]}"
    end if
  else
    response.write "{""jlist"": [{""status"": """",""title"": """"}]}"
  end if
%>
