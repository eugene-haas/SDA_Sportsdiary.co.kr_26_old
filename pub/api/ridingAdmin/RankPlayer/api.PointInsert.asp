
<!-- #include virtual = "/pub/ajax/riding/reqTennisRankPlayer.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request
	Set db = new clsDBHelper
      
       
    If hasown(oJSONoutput, "i_groupcode") = "ok" then	 
	    i_groupcode = oJSONoutput.i_groupcode
    else
        i_groupcode=""
    end if    
    If hasown(oJSONoutput, "i_groupgrade") = "ok" then	 
	    i_groupgrade = oJSONoutput.i_groupgrade
    else
        i_groupgrade=""
    end if   
    If hasown(oJSONoutput, "i_titlename") = "ok" then	 
	    i_titlename = oJSONoutput.i_titlename
    else
        i_titlename=""
    end if   
    If hasown(oJSONoutput, "i_titleidx") = "ok" then	 
	    i_titleidx = oJSONoutput.i_titleidx
    else
        i_titleidx=""
    end if   
    If hasown(oJSONoutput, "i_teamGb") = "ok" then	 
	    i_teamGb = oJSONoutput.i_teamGb
    else
        i_teamGb=""
    end if   
    If hasown(oJSONoutput, "i_teamGbName") = "ok" then	 
	    i_teamGbName = oJSONoutput.i_teamGbName
    else
        i_teamGbName=""
    end if   
    If hasown(oJSONoutput, "i_rank") = "ok" then	 
	    i_rank = oJSONoutput.i_rank
    else
        i_rank=""
    end if   
    If hasown(oJSONoutput, "i_playername") = "ok" then	 
	    i_playername = oJSONoutput.i_playername
    else
        i_playername=""
    end if   
    If hasown(oJSONoutput, "i_playeridx") = "ok" then	 
	    i_playeridx = oJSONoutput.i_playeridx
    else
        i_playeridx=""
    end if   
    If hasown(oJSONoutput, "i_point") = "ok" then	 
	    i_point = oJSONoutput.i_point
    else
        i_point=""
    end if  
    If hasown(oJSONoutput, "i_titlegubun") = "ok" then	 
	    i_titlegubun = oJSONoutput.i_titlegubun
    else
        i_titlegubun=""
    end if  
         
    if i_titlegubun ="1" then
    'sd 등록 대회


    elseif i_titlegubun ="2" then
    'sd 비등록 대회 이력에서 조회
        SQL="select top 1 Gamedate from sd_TennisRPoint_log where titleName like '%"&i_titlename&"%' and teamGbName like '%"&i_teamGbName&"%' group by Gamedate" 
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        
		If rs.eof Then
			SQL="select top 1 games from sd_tennisTitle where gametitleidx = " & i_titleidx
			Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)
			i_Gamedate =  rst("games")
		else
		i_Gamedate =  rs("Gamedate")
		End if
    else
        i_Gamedate=""
    end if

'    if i_titlename <> "" and i_teamGbName <> "" and i_Gamedate = "" then 
'        SQL="select top 1 Gamedate from sd_TennisRPoint_log where titleName like '%"&i_titlename&"%' and teamGbName like '%"&i_teamGbName&"%' group by Gamedate" 
'        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'        i_Gamedate =  rs("Gamedate")
'    end if 
   
    if i_groupcode <>"" and i_titleidx <> "" and i_teamGb <> "" and i_playeridx<>"" and i_point<>""and i_rank<>"" then
     '업데이트  
        SQL="select * from sd_TennisRPoint_log where titleName like '%"&i_titlename&"%' and teamGbName like '%"&i_teamGbName&"%' and PlayerIDX ='"&i_playeridx&"'" 
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        If Not rs.EOF Then 
            Call oJSONoutput.Set("result", "3" ) 
            Call oJSONoutput.Set("msg", "해당 대회 랭킹 포인트가 있습니다. 확인 하시고 다시 등록 해주시기 바랍니다." ) 
        else
            SQL = "INSERT INTO sd_TennisRPoint_log (PlayerIDX,userName,getpoint,rankno,titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,writeday,ptuse) VALUES "  
            insertvalue= "("
            insertvalue= insertvalue &"'"&i_playeridx&"'," 
            insertvalue= insertvalue &"'"&i_playername&"'," 
            insertvalue= insertvalue &"'"&i_point&"'," 
            insertvalue= insertvalue &"'"&i_rank&"'," 
            insertvalue= insertvalue &"'"&i_groupgrade&"'," 
            insertvalue= insertvalue &"'"&i_groupcode&"'," 
            insertvalue= insertvalue &"'"&i_titleidx&"'," 
            insertvalue= insertvalue &"'"&i_titlename&"'," 
            insertvalue= insertvalue &"'"&i_teamGb&"'," 
            insertvalue= insertvalue &"'"&i_teamGbName&"'," 
            insertvalue= insertvalue &"'"&i_Gamedate&"'," 
            insertvalue= insertvalue &"getdate(),'Y'" 
            insertvalue= insertvalue &")" 
            SQL = SQL & insertvalue

            Call db.execSQLRs(Sql , null, ConStr)
        '타입 석어서 보내기
            Call oJSONoutput.Set("result", "4" )  
            Call oJSONoutput.Set("msg",i_titlename+" 대회 ["+i_teamGbName+"] : "+ i_playername+"  랭킹 등록이 완료 되었습니다." ) 
        end if 
    else
        Call oJSONoutput.Set("result", "3" ) 
        Call oJSONoutput.Set("msg", "랭킹 등록 오류 입니다. 확인 바랍니다." ) 
    end if 

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	 
db.Dispose
Set db = Nothing
%>