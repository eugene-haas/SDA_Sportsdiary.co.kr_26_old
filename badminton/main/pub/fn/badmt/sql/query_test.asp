

Select * From tblGameTitle Where DelYN = 'N' And GameTitleName like '%테스트%'

Select * From tblGameLevel Where DelYN = 'N' And GameTitleIDX = 1805

Select * From tblGameLevelDtl Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'

Select * From tblTourney Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'
--Select * From tblTourneyTeam Where DelYN = 'N' And GameTitleIDX = 1805

Select * From tblTourneyGroup Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'
Select * From tblTourneyPlayer Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'


Select * From tblGameResult Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'
Select * From tblGameResultDtl Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'
Select * From tblGameOperate Where DelYN = 'N' And GameTitleIDX = 1805 And GameLevelDtlidx = '29218'


Select * From tblPubcode Where PubCode = 'B5010001'

UPDATE_tblGameOperate

FN_GameStatus