<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'조회조건 데이터
    Search_tp       = fInject(request("tp"))
    Search_SportsGb = fInject(request("Search_SportsGb"))
    Search_Area     = fInject(request("Search_Area"))
    Search_Entertype= fInject(request("Search_Entertype"))
    Search_PTeamGb   = fInject(request("Search_PTeamGb"))
    Search_TeamNm   = fInject(request("Search_TeamNm"))
    Search_NumF   = fInject(request("Search_NumF"))
    Search_NumT   = fInject(request("Search_NumT"))
    Search_Seq   = fInject(request("Search_Seq"))
    

    if Search_tp="C" then 
       LSQL ="select count(*) cnt" & _
            " 		from tblTeamInfo a  " & _
            " 		where DelYN='N' "
    
        if  Search_SportsGb <>"" then 
             LSQL = LSQL& " and SportsGb='"&Search_SportsGb&"' "
        end if 
        if  Search_Area <>"" then   
             LSQL = LSQL& " and sido='"&Search_Area&"' "
        end if 
        if  Search_Entertype <>"" then 
             LSQL = LSQL& " and EnterType='"&Search_Entertype&"' "
        end if 
        if  Search_PTeamGb <>"" then 
             LSQL = LSQL& " and PTeamGb='"&Search_PTeamGb&"' "
        end if 
        if  Search_TeamNm <>"" then 
             LSQL = LSQL& " and TeamNm like '%"&Search_TeamNm&"%' "
        end if 

	    Dbopen()
	    Set LRs = Dbcon.Execute(LSQL)
	    Dbclose()
	    
        cnt =0

	    If Not (LRs.Eof Or LRs.Bof) Then
		    Do Until LRs.Eof 
               
             cnt = LRs("cnt")

		    LRs.MoveNext
		    Loop 
	    End If

        Response.Write cnt

    else

        LSQL =" select a.* , isnull(b.MemberCount,0)MemberCount" & _
                " from ( " & _
                " 		select ROW_NUMBER()over(order by SportsGb,Sido,EnterType desc,TeamNm) num" & _
                " 		,TeamIDX,SportsGb,PTeamGb,Team,TeamNm " & _
                " 		,case when Sex='1' then '남' when Sex='2' then '여' else '혼합' end Sex " & _
                " 		,Sportsdiary.dbo.FN_SidoName(Sido,SportsGb)Sido,ZipCode,Address,AddrDtl " & _
                " 		,TeamTel,TeamRegDt,TeamEdDt,EnterType,TeamLoginPwd,SvcStartDt,SvcEndDt,NowRegYN " & _
                " 		from tblTeamInfo a  " & _
                " 		where DelYN='N' "
    
        if  Search_SportsGb <>"" then 
             LSQL = LSQL& " and SportsGb='"&Search_SportsGb&"' "
        end if 
        if  Search_Area <>"" then   
             LSQL = LSQL& " and sido='"&Search_Area&"' "
        end if 
        if  Search_Entertype <>"" then 
             LSQL = LSQL& " and EnterType='"&Search_Entertype&"' "
        end if 
        if  Search_PTeamGb <>"" then 
             LSQL = LSQL& " and PTeamGb='"&Search_PTeamGb&"' "
        end if 
        if  Search_TeamNm <>"" then 
             LSQL = LSQL& " and TeamNm like '%"&Search_TeamNm&"%' "
        end if 

        LSQL = LSQL& " ) a "
        LSQL = LSQL& " left join ("
        LSQL = LSQL& "  select b.Team,COUNT(b.MemberIDX)MemberCount "
        LSQL = LSQL& "   from tblTeamInfo a  "
        LSQL = LSQL& "     inner join tblMember b "
        LSQL = LSQL& "        on a.SportsGb = b.SportsType "
        LSQL = LSQL& "        and a.Team = b.Team "
        LSQL = LSQL& "       and b.DelYN='N' "
        LSQL = LSQL& "  group by b.Team	 "	
        LSQL = LSQL& "  ) b on a.team = b.team"
        LSQL = LSQL& "  where num between "&Search_NumF&" and "&Search_NumT
         
	    Dbopen()
	    Set LRs = Dbcon.Execute(LSQL)
	    Dbclose()
	
	    If LRs.Eof Or LRs.Bof Then 
		    %>
            <tr>
                <td colspan=11>데이터 없음.</td>
            </tr>
            <%
	    Else 
	        retext =  "["
		    intCnt = 0
		    Do Until LRs.Eof 
            %>
            <tr onclick="input_data(<%=LRs("TeamIDX") %>)">
                <td><%=LRs("num") %></td>
                <!--<td><%=LRs("TeamIDX") %></td>-->
                <td><%=LRs("SportsGb") %></td>
                <td><%=LRs("EnterType") %></td>
                <td><%=LRs("Sido") %></td>
                <td><%=LRs("Team") %></td>
                <td><%=LRs("TeamNm") %></td>
                <td><%=LRs("Sex") %></td>
                <td><%=LRs("TeamTel") %></td>
                <td><%=LRs("ZipCode") %></td>
                <td><%=LRs("Address") %></td>
                <td><%=LRs("AddrDtl") %></td>
                <td><%=LRs("MemberCount") %></td>
            </tr>
            <%
		    LRs.MoveNext
		    intCnt = intCnt + 1
		    Loop 
	    End If
    
    end if
    LRs.Close
   Set LRs = Nothing
%>
