<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
    keyNm = fInject(request("keyNm"))
    
	'조회조건 데이터
    Search_tp       = fInject(request("Search_tp"))
    Search_SportsGb = fInject(request("Search_SportsGb"))
    Search_Area     = fInject(request("Search_Area"))
    Search_Entertype= fInject(request("Search_Entertype"))
    Search_PTeamGb   = fInject(request("Search_PTeamGb"))
    Search_TeamNm   = fInject(request("Search_TeamNm"))
    Search_NumF   = fInject(request("Search_NumF"))
    Search_NumT   = fInject(request("Search_NumT"))

    if  Search_SportsGb ="" then 
        Search_SportsGb ="judo"
    end if 
    
    if  Search_Entertype ="" then 
        Search_Entertype ="E"
    end if 

    
    if  Search_Area ="" then 
        Search_Area =""
    end if 

    if strtp = "F" then
    
    LSQL =" select '종목' keyNm,PubCode code,PubName name,case when PubCode='"&Search_SportsGb&"' then 'Y' else 'N' end chek from tblPubCode  where DelYN='N' and PPubCode='sd000' " 
    LSQL =LSQL&"  union all " 
    LSQL =LSQL&"  select '지역' keyNm,Sido code,SidoNm name ,case when Sido='"&Search_Area&"' then 'Y' else 'N' end chek from tblSidoInfo where SportsGb='"&Search_SportsGb&"' and DelYN='N' " 
    LSQL =LSQL&"  union all " 
    LSQL =LSQL&"  select '타입' keyNm,'E' code,'엘리트'name ,case when 'E'='"&Search_Entertype&"' then 'Y' else 'N' end chek   " 
    LSQL =LSQL&"  union all " 
    LSQL =LSQL&"  select '타입' keyNm,'A'code,'아마추어'name,case when 'A'='"&Search_Entertype&"' then 'Y' else 'N' end chek   " 
    LSQL =LSQL&"  union all " 
    LSQL =LSQL&"  select '타입' keyNm,'K'code,'국가대표' name,case when 'K'='"&Search_Entertype&"' then 'Y' else 'N' end chek   " 
    LSQL =LSQL&"  union all " 
    LSQL =LSQL&"  select '종별' keyNm,PTeamGb code,case when PTeamGb='89' then '생활체육' else PTeamGbNm  end name,case when PTeamGb='"&Search_PTeamGb&"' then 'Y' else 'N' end chek from tblTeamGbInfo where DelYN='N' and SportsGb='"&Search_SportsGb&"' and EnterType='"&Search_Entertype&"' group by PTeamGb,case when PTeamGb='89' then '생활체육' else PTeamGbNm  end"

	Dbopen()
	 Set LRs = Dbcon.Execute(LSQL)
	Dbclose()
	
    

	        If LRs.Eof Or LRs.Bof Then 
		        Response.Write "null"
	        Else 
	            retext =  "["
		        intCnt = 0
		        Do Until LRs.Eof 

                retext = retext&"{"
		        retext = retext&"""keyNm"": """&LRs("keyNm") &""","
                retext = retext&"""code"": """&LRs("code") &""","
                retext = retext&"""name"": """&LRs("name") &""","
                retext = retext&"""chek"": """&LRs("chek") &""""
                retext = retext&"},"

		        LRs.MoveNext
		        intCnt = intCnt + 1
		        Loop 

        
	        retext = Mid(retext, 1, len(retext) - 1)
	        retext = retext&"]"
	
	        Response.Write retext

	        End If
    
    else
        if keyNm ="종목" then 
          LSQL =" select '종목' keyNm,PubCode code,PubName name,case when PubCode='"&Search_SportsGb&"' then 'Y' else 'N' end chek from tblPubCode  where DelYN='N' and PPubCode='sd000' "
        elseif keyNm ="지역" then 
          LSQL = " select '지역' keyNm,Sido code,SidoNm name ,case when Sido='"&Search_Area&"' then 'Y' else 'N' end chek from tblSidoInfo where SportsGb='"&Search_SportsGb&"' and DelYN='N' "
        elseif keyNm ="타입" then 
          LSQL = " select '타입' keyNm,'E' code,'엘리트'name ,case when 'E'='"&Search_Entertype&"' then 'Y' else 'N' end chek   "& _ 
                " union all "& _ 
                " select '타입' keyNm,'A'code,'아마추어'name,case when 'A'='"&Search_Entertype&"' then 'Y' else 'N' end chek   "& _ 
                " union all "& _    
                " select '타입' keyNm,'K'code,'국가대표' name,case when 'K'='"&Search_Entertype&"' then 'Y' else 'N' end chek   "
        elseif keyNm ="종별" then 
         LSQL = " select '종별' keyNm,PTeamGb code,case when PTeamGb='89' then '생활체육' else PTeamGbNm  end name,case when PTeamGb='"&Search_PTeamGb&"' then 'Y' else 'N' end chek from tblTeamGbInfo where DelYN='N' and SportsGb='"&Search_SportsGb&"' and EnterType='"&Search_Entertype&"' group by PTeamGb,case when PTeamGb='89' then '생활체육' else PTeamGbNm  end order by PTeamGb"
        end if

	    Dbopen()
	    Set LRs = Dbcon.Execute(LSQL)
	    Dbclose()

	    If LRs.Eof Or LRs.Bof Then 
		    Response.Write "null"
	    Else 
	        retext =  "["
		    intCnt = 0
		    Do Until LRs.Eof 

            retext = retext&"{"
		    retext = retext&"""keyNm"": """&LRs("keyNm") &""","
            retext = retext&"""code"": """&LRs("code") &""","
            retext = retext&"""name"": """&LRs("name") &""","
            retext = retext&"""chek"": """&LRs("chek") &""""
            retext = retext&"},"

		    LRs.MoveNext
		    intCnt = intCnt + 1
		    Loop 

        
	    retext = Mid(retext, 1, len(retext) - 1)
	    retext = retext&"]"
	
	    Response.Write retext

	    End If
    
    end if
    
     
    LRs.Close
   Set LRs = Nothing
%>
