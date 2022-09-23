<%
'#############################################
'메인 뷰
'#############################################
	'request

  Set db = new clsDBHelper

			  chkip = Request.ServerVariables("REMOTE_ADDR")
			
			  If chkip = "112.187.195.132" Then
				testwhere = " where AA.DelYN = 'N' and ViewState = 'Y'  "
				'testwhere = " where AA.gametitleidx = '45' and AA.DelYN = 'N' and ViewState = 'Y' "
			  Else
				testwhere = " where AA.DelYN = 'N' and ViewState = 'Y'  "
			  End if


  sqlGameDate = "select top 4 *  "_
              &" from  "_
              &" (select "_
              &" AA.GameTitleIDX, "_
              &" AA.GameTitleName, "_
              &" convert(varchar(10),AA.GameS,120) as GameS, "_
              &" convert(varchar(10),AA.GameE,120) as GameE, "_
              &" AA.GameArea, "_
              &" (select count(a.idx) from sd_Tennis_Stadium_Sketch a where AA.GameTitleIDX = a.GameTitleIDX) as photo,  "_
              &" (select count(b.seq) from sd_RidingBoard b where AA.GameTitleIDX = b.titleIDX) as video, "_
              &" (select top 1 f.attdateS from tblRGameLevel f where f.GameTitleIDX = aa.GameTitleIDX order by f.attdateS asc) as attsdate, "_
              &" (select top 1 f.attdateE from tblRGameLevel f where f.GameTitleIDX = aa.GameTitleIDX order by f.attdateE desc) as attedate, "_
              &" (case when datediff(day,getdate(),GameS ) <= 0 and  datediff(day,getdate(),GameE ) >= 0 then 0 else 1 end) as gameflag, "_
              &" (case when datediff(day,getdate(),GameE ) < 0 then 1 else 0 end) as flag2, "_
              &" (case when (select count(gameno) from tblRGameLevel where DelYN = 'N' and GameTitleIDX = AA.GameTitleIDX and (getdate() > attdateS and getdate() < attdateE)) > 0 then 0 else 1 end) attflag2 "_
              &" from sd_TennisTitle AA  "_


			  & testwhere _


			  &" group by AA.GameTitleIDX, AA.GameTitleName, AA.GameS, AA.GameE, AA.GameArea, AA.ViewYN, AA.stateNo "_
              &" ) table1 "_
              &" order by flag2,attflag2,gameflag, ABS(datediff(day,getdate(),GameS ))"


'Response.write sqlGameDate



  sqlGameVideo = "select top 2 AA.GameTitleIDX, BB.gameno, DD.idx, AA.GameTitleName, DD.title, AA.GameYear, DD.filename, DD.Thumbnail, DD.readnum, "_
                &" EE.TeamGbNm, EE.PTeamGbNm, EE.levelNm "_
                &"  from sd_TennisTitle AA "_
                &" inner join  "_
                &" 	( select GameTitleIDX ,gameno ,gbidx  "_
                &" 	from tblRGameLevel where DelYN = 'N' "_
                &" 	group by GameTitleIDX,gameno,gbidx "_
                &" 	) BB on AA.GameTitleIDX = BB.GameTitleIDX "_
                &" inner join sd_RidingBoard CC on AA.GameTitleIDX = CC.titleIDX and BB.gameno = CC.levelNo "_
                &" left join sd_RidingBoard_c DD on CC.seq = DD.seq "_
                &" left join tblTeamGbInfo EE on BB.GbIDX = EE.TeamGbIDX "_
                &" where AA.DelYN = 'N' "_
                &" order by GameTitleIDX desc,idx desc"


  sqlphoto = "select top 2 Photo,GameTitleIDX,idx from(  "_
            &" select rank() OVER (ORDER BY b.idx) as ranks,a.GameTitleIDX,Photo,b.idx  "_
            &" from sd_Tennis_Stadium_Sketch a left join sd_Tennis_Stadium_Sketch_Photo b on a.Idx = b.Sketch_idx and b.delyn = 'N'  "_
            &" left join sd_TennisTitle c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N'  "_
            &" where a.delyn = 'N' and c.GameTitleIDX is not null and b.idx is not null ) f  order by ranks desc"

  Set rsGameDate = db.ExecSQLReturnRS(sqlGameDate , null, ConStr)
  GameDateJson = ""
  if not rsGameDate.eof Then
    do until rsGameDate.eof
      statusFlag = ""
      statusText = ""
'      if rsGameDate("ViewYN") = "Y" Then
        if rsGameDate("attflag2") = "0" then
          statusFlag = "s_apply"
          statusText = "신청중"
        Else
          if datediff("d",rsGameDate("GameS"),date()) < 0 Then
            statusFlag = "s_dday"
            statusText = "D-"& datediff("d",date(),rsGameDate("GameS"))
          Elseif rsGameDate("gameflag") = 0 then
            statusFlag = "s_ing"
            statusText = "경기중"
          Else
            statusFlag = "s_end"
            statusText = "경기종료"
          end if
        end if
'      Else
'        if datediff("d",rsGameDate("GameS"),date()) < 0 Then
'          statusFlag = "s_dday"
'          statusText = "D-"& datediff("d",date(),rsGameDate("GameS"))
'        Elseif datediff("d",rsGameDate("GameS"),date()) >= 0 and datediff("d",rsGameDate("GameE"),date()) <= 0 then
'          statusFlag = "s_ing"
'          statusText = "경기중"
'        Else
'          statusFlag = "s_end"
'          statusText = "경기종료"
'        end if
'      end if
      GameDateJson = GameDateJson & ",{""poplink"": ""1"",""class"": """& statusFlag &""",""status"":"""& statusText &""",""title"": """& rsGameDate("GameTitleName") &""",""dday"": """& replace(rsGameDate("GameS"),"-",".") &""",""id"": """& rsGameDate("GameTitleIDX") &"""}"
      rsGameDate.movenext
    loop
  end If
  

  '테스트용 리스트
  If chkip = DEBUGIP Then
  GameDateJson = GameDateJson & ",{""poplink"": ""1"",""class"": ""s_end"",""status"":""테스트"",""title"": ""테스트대회"",""dday"": ""2019.11.26"",""id"": """&DEBUGTIDX&"""}"
  End if


  Set rsGameVideo = db.ExecSQLReturnRS(sqlGameVideo , null, ConStr)
  GameVideoJson = ""
  if not rsGameVideo.eof Then
    do until rsGameVideo.eof
      if isnull(rsGameVideo("Thumbnail")) = false then
        GameVideoJson = GameVideoJson & ",{""url"":"""& rsGameVideo("idx") &""",""movieimg"":"""& rsGameVideo("Thumbnail") &""",""title"":"""& rsGameVideo("title") &"""}"
      end if
      rsGameVideo.movenext
    loop
  end if

  Set rsphoto = db.ExecSQLReturnRS(sqlphoto , null, ConStr)
  PhotoJson = ""
  If Not rsphoto.eof Then
    do until rsphoto.eof
      PhotoJson = PhotoJson & ",{""url"":"""& rsphoto("GameTitleIDX") &""",""img"":""http://Upload.sportsdiary.co.kr/sportsdiary"& rsphoto("Photo") &""",""photono"":"""& rsphoto("idx") &"""}"
      rsphoto.movenext
    loop
  end if

  if GameDateJson <> "" Then
    GameDateJson = """gameinfo"": ["& mid(GameDateJson,2) &"],"
  Else
    GameDateJson = """gameinfo"": ""nodata"","
  end if

  if GameVideoJson <> "" Then
    GameVideoJson = """gamevideo"": ["& mid(GameVideoJson,2) &"],"
  Else
    GameVideoJson = """gamevideo"": ""nodata"","
  end if

  if PhotoJson <> "" Then
    PhotoJson = """fieldsketch"": ["& mid(PhotoJson,2) &"]"
  Else
    PhotoJson = """fieldsketch"": ""nodata"""
  end if

  Response.Write "{""jlist"":[{"& GameDateJson & GameVideoJson & PhotoJson &"}]}"
%>
