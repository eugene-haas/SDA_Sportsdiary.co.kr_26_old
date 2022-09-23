<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameYear = fInject(Request("GameYear"))
SportsGb = fInject(Request("SportsGb"))
GameTitleIDX = fInject(Request("GameTitleIDX"))
TeamGb = fInject(Request("TeamGb"))
Sex = fInject(Request("Sex"))
Level = fInject(Request("Level"))
GroupGameGb = fInject(Request("GroupGameGb"))
GameType = fInject(Request("GameType"))
RGameLevelidx = fInject(Request("RGameLevelidx"))
EnterType = fInject(Request("EnterType"))
EnterScoreType = fInject(Request("EnterScoreType"))


GameTitleName = fInject(Request("GameTitleName"))
TeamGbNm = fInject(Request("TeamGbNm"))
LevelNm = fInject(Request("LevelNm"))
GroupGameGbNm = fInject(Request("GroupGameGbNm"))
 
 
Response.Write  "--GameYear : "&GameYear
Response.Write  "--SportsGb : "&SportsGb
Response.Write  "--GameTitleIDX : "&GameTitleIDX
Response.Write  "--TeamGb : "&TeamGb
Response.Write  "--Sex : "&Sex
Response.Write  "--Level : "&Level
Response.Write  "--GroupGameGb : "&GroupGameGb
Response.Write  "--GameType : "&GameType
Response.Write  "--RGameLevelidx : "&RGameLevelidx
Response.Write  "--EnterType : "&EnterType
Response.Write  "--EnterScoreType : "&EnterScoreType
Response.Write  "--GameTitleName : "&GameTitleName
Response.Write "<br />"
Response.Write  "<br />"

GSQL = " select* " & _ 
       " from tblPlayerResult " & _ 
       " where SportsGb='"&SportsGb&"'" & _ 
       " and DelYN='N'" & _ 
       " and GameTitleIDX='"&GameTitleIDX&"'" & _ 
       " and RGameLevelidx='"&RGameLevelidx&"'" & _ 
       " and TeamGb='"&TeamGb&"'" & _ 
       " and Sex='"&Sex&"'" & _ 
       " and Level='"&Level&"'" & _ 
       " and GroupGameGb='"&GroupGameGb&"'" & _ 
       " and GameType='"&GameType&"'" & _ 
       " order by NowRound "


GSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'"
       
Response.Write  "<br />"
Response.Write "--리스트"
Response.Write "<br />"
Response.Write GSQL
Response.Write "<br />"




 '출력정보

              '리스트 
              
              ''선수정보

            

              ''로그

              ''사인데이터


''점수
ScoreSQL="SELECT GameNum,GroupGameNum,BB.Left01 + BB.Plus_Left01 AS Left01, BB.Plus_Left02 AS Left02, BB.Left03, BB.Left04, BB.Left05, BB.Left06, BB.Left07, " & _
             " BB.Right01 + BB.Plus_Right01 AS Right01, BB.Plus_Right02 AS Right02, BB.Right03, BB.Right04, BB.Right05, BB.Right06, BB.Right07" & _
             " FROM" & _
             " (" & _
             " 	SELECT GameNum,GroupGameNum,Sum(Case AA.LJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Left01, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Left02, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Left03, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Left04, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Left05, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Left06, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Left07, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Right01, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Right02, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Right03, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Right04," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Right05," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Right06," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Right07," & _
             " 	0 as Plus_Left01," & _
             " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Left02," & _
             " 	0 as Plus_Right01," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Right02 "  & _
             " 	FROM " & _
             " 	( " & _
             " 		SELECT GameNum,GroupGameNum,COUNT(*) AS Jumsu, LJumsuGb , RJumsuGb " & _
             " 		FROM tblRGameResultDtl B " & _
             " 		WHERE B.RGameLevelidx='" & RGameLevelidx & "' " & _
 
             " 		AND B.DELYN='N'" & _
             " 		AND (LJumsuGb <> '' OR RJumsuGb <> '')" & _
             " 		GROUP BY GameNum,GroupGameNum,LJumsuGb, RJumsuGb" & _
             " 	) AA group by GameNum,GroupGameNum" & _
             " ) AS BB"       
             
    Response.Write  "<br />"
    Response.Write "--점수"
    Response.Write  "<br />"
    Response.Write ScoreSQL
    Response.Write "<br />"

    Response.Write  "<br /> 점수"

    scoreStr ="["
	Set scoreRs = Dbcon.Execute(ScoreSQL)	
    If Not(scoreRs.Eof Or scoreRs.Bof) Then 
    Do Until scoreRs.Eof 
        
       scoreStr = scoreStr & "{"
       scoreStr = scoreStr & "!GameNum@"& (scoreRs("GameNum"))  
       scoreStr = scoreStr & "!GroupGameNum@"& (scoreRs("GroupGameNum"))  
       
       scoreStr = scoreStr & "!Left01@"& (scoreRs("Left01")) 
       scoreStr = scoreStr & "!Left02@"& (scoreRs("Left02")) 
       scoreStr = scoreStr & "!Left03@"& (scoreRs("Left03")) 
       scoreStr = scoreStr & "!Left04@"& (scoreRs("Left04")) 
       scoreStr = scoreStr & "!Left05@"& (scoreRs("Left05")) 
       scoreStr = scoreStr & "!Left06@"& (scoreRs("Left06")) 
       scoreStr = scoreStr & "!Left07@"& (scoreRs("Left07")) 
       
       scoreStr = scoreStr & "!Right01@"& (scoreRs("Right01")) 
       scoreStr = scoreStr & "!Right02@"& (scoreRs("Right02")) 
       scoreStr = scoreStr & "!Right03@"& (scoreRs("Right03")) 
       scoreStr = scoreStr & "!Right04@"& (scoreRs("Right04")) 
       scoreStr = scoreStr & "!Right05@"& (scoreRs("Right05")) 
       scoreStr = scoreStr & "!Right06@"& (scoreRs("Right06")) 
       scoreStr = scoreStr & "!Right07@"& (scoreRs("Right07")) 
       scoreStr = scoreStr & "},"

 

    scoreRs.MoveNext
	Loop 
	End If 
    scoreStr = scoreStr & "]"


	Set GRs = Dbcon.Execute(GSQL)	
    If Not(GRs.Eof Or GRs.Bof) Then 
    Do Until GRs.Eof 
	

    %>

    <div> 리스트 데이타
    
    
    
    </div>


    <%
        
	GRs.MoveNext
	Loop 
	End If 
    GRs.Close
	SET GRs = Nothing

    scoreRs.Close
	SET scoreRs = Nothing
%>



 