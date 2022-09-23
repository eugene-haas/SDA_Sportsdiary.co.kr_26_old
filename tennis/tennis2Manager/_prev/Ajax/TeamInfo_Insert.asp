<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
    SportsGb = fInject(Request("SportsGb"))
    Team = fInject(Request("Team"))
    TeamNm = fInject(Request("TeamNm"))
    Sido = fInject(Request("Sido"))
    EnterType = fInject(Request("EnterType"))
    PTeamGb = fInject(Request("PTeamGb"))
    Sex = fInject(Request("Sex"))
    ZipCode = fInject(Request("ZipCode"))
    Address = fInject(Request("Address"))
    AddrDtl = fInject(Request("AddrDtl"))
    TeamTel = fInject(Request("TeamTel"))
    TeamPass = fInject(Request("TeamPass"))
    DelYn = fInject(Request("DelYn"))
    Check = fInject(Request("Check"))


    if Check="N" then
  

        checkSql = "select* " & _ 
                " ,right(left('"&TeamNm&"',LEN('"&TeamNm&"')-1),len(left('"&TeamNm&"',LEN('"&TeamNm&"')-1))-1) searchTeamNm" & _ 
                " from tblTeamInfo " & _ 
                " where SportsGb='" &SportsGb&"' " & _ 
                " and TeamNm like '%'+right(left('"&TeamNm&"',LEN('"&TeamNm&"')-1),len(left('"&TeamNm&"',LEN('"&TeamNm&"')-1))-1)+'%' " & _ 
                " and sido='" &Sido&"'" 
         ' Response.Write   checkSql
         ' Response.End


	    Set LRs = Dbcon.Execute(checkSql)
	    Dbclose()

        If Not (LRs.Eof Or LRs.Bof) Then
		    Response.Write "true|"&SportsGb&"|"&LRs("searchTeamNm")
            '&SportsGb&"|"&LRs("searchTeamNm")&"|"&Sido&"|"
        else
            Response.Write "false"
	    end if

        LRs.Close
        Set LRs = Nothing
    else

    InsertSql ="exec Insert_TeamCode " & _ 
                   " '" & SportsGb &"'," & _ 
                   " '" & PTeamGb &"'," & _ 
                   " '" & Team &"'," & _ 
                   " '" & TeamNm &"'," & _ 
                   " '',''," & _ 
                   " '" & Sex &"'," & _ 
                   " '" & Sido &"'," & _ 
                   " '" & ZipCode &"'," & _ 
                   " '" & Address &"'," & _ 
                   " '" & AddrDtl &"'," & _ 
                   " '" & TeamTel &"'," & _ 
                   " '" & EnterType &"'," & _ 
                   " '" & TeamPass &"'," & _ 
                   " '" & DelYn &"'"



	Dbcon.Execute(InsertSql)
	Dbclose()

	Response.Write "TRUE"
	Response.End


    end if 
%>