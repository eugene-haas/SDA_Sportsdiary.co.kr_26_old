<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	dim PlayerIDX		: PlayerIDX 	= decode(request.Cookies("PlayerIDX"), 0)
	dim Type_Action		: Type_Action 	= fInject(request("Type_Action"))		'처리 액션

	dim TraiFistCd	 	: TraiFistCd 	= fInject(request("TraiFistCd"))		'훈련종류 종목 대분류
	dim TraiMidIDX		: TraiMidIDX 	= fInject(request("TraiMidIDX"))		'수정할 중분류IDX	
	dim TrainNm		    : TrainNm 	    = ReplaceTagText(fInject(request("TrainNm")))		'추가할 중분류 명

   ' Type_Action="DEL"
   ' TraiFistCd="TA"
   ' TraiMidIDX="465"
   ' TrainNm="ddd"

	IF PlayerIDX = "" Then	
        Response.Write "false"	
        Response.End
    end if
    
	CSearch_Action =" AND DelYN='N' "
    IF Type_Action = "DEL" Then
		CSearch_Action =" AND DelYN='Y' "
	End IF

	'훈련종목 대분류
	IF TraiFistCd <> "" Then
		CSearch_FistCd = " AND TraiFistCd='"&TraiFistCd&"' "
	End IF
	
	'사용자 훈련종목 조회
	IF PlayerIDX <> "" Then
		CSearch_plyer = " AND PlayerIDX='"&PlayerIDX&"' "
	End IF	
	
	IF TraiMidIDX <> "" Then
		CSearch_IDX = " AND TraiMidIDX='"&TraiMidIDX&"' "
	End IF	
	
	IF TrainNm <> "" Then
		CSearch_NM = " AND TraiMIdNm='"&TrainNm&"' "
	End IF	

	'조회 

	LSQL = LSQL & "		SELECT TraiMidIDX "
	LSQL = LSQL & "			,TraiFistCd "
	LSQL = LSQL & "			,TraiMidCd "
	LSQL = LSQL & "			,TraiMIdNm "
	LSQL = LSQL & "			,OrderBy "
	LSQL = LSQL & "			,PlayerIDX ,DelYN"
	LSQL = LSQL & "		FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo] "
	LSQL = LSQL & "		WHERE SportsGb='"&SportsGb&"'  "
    LSQL = LSQL &       CSearch_Action 
    LSQL = LSQL &       CSearch_FistCd 
    LSQL = LSQL &       CSearch_plyer 
    LSQL = LSQL &       CSearch_IDX 
    LSQL = LSQL &       CSearch_NM
	
	retext =  "["
    SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 				
	    Do Until LRs.Eof 
        retext = retext&"{"
			retext = retext&"""TraiMidIDX"": """&LRs("TraiMidIDX") &""","
			retext = retext&"""TraiFistCd"": """&LRs("TraiFistCd") &""","
			retext = retext&"""TraiMidCd"": """&LRs("TraiMidCd") &"""," 
			retext = retext&"""TraiMIdNm"": """&LRs("TraiMIdNm") &"""," 
			retext = retext&"""OrderBy"": """&LRs("OrderBy") &""","
			retext = retext&"""PlayerIDX"": """&LRs("PlayerIDX") &""","
			retext = retext&"""DelYN"": """&LRs("DelYN") &"""," 
			retext = retext&"""Action"": """&Type_Action &"""," 
			retext = retext&"""LSQL"": """&LSQL &"""," 
          retext = retext&"},"
        LRs.MoveNext
	    Loop 
	End If 
    
		LRs.Close
	SET LRs = Nothing		

	DBClose()

	retext = Mid(retext, 1, len(retext) - 1)
	retext = retext&"]"
	
	Response.Write retext

%>