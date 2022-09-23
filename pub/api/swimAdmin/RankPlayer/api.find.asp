
<!-- #include virtual = "/pub/ajax/reqTennisRankPlayer.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request
    If hasown(oJSONoutput, "varStr") = "ok" then	 '입금일짜
	    varStr = oJSONoutput.varStr
    else
        varStr=""
    end if 
    If hasown(oJSONoutput, "gubun") = "ok" then	 '입금일짜
	    gubun = oJSONoutput.gubun
    else
        gubun=""
    end if  
      

	Set db = new clsDBHelper
        '그룹 정보
    SQL =  " select titleCode,titleGrade,hostTitle from dbo.sd_TennisTitleCode where delYN='N' group by  titleCode,titleGrade,hostTitle " 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
		titleCodearrRS = rs.GetRows()
	End if  

     
    if gubun ="title" then 
            SQL=" select a.GameTitleIDX,a.GameTitleName,a.titleCode,b.hostTitle,a.titleGrade,titlegubun " & _ 
                " from ( " & _ 
	            "     select GameTitleIDX,GameTitleName,titleCode,titleGrade,1 titlegubun  " & _ 
	            "     from sd_TennisTitle  " & _ 
	            "     where DelYN='N' and GameS <= GETDATE() and ViewState='Y' and  isnull(titleCode,'')<>''and isnull(titleGrade,'')<>'' and GameTitleName like '%"&varStr&"%'" & _ 
		        "         union all " & _ 
	            "     select titleIDX,titleName,titleCode,titleGrade ,2 titlegubun   " & _ 
	            "     from sd_TennisRPoint_log  " & _ 
	            "     where Gamedate<=GETDATE() " & _ 
	            "     and titleName like '%"&varStr&"%' " & _ 
                " ) a " & _ 
                " left join sd_TennisTitleCode b on a.titleCode = b.titleCode and a.titleGrade = b.titleGrade and b.delYN='N' " & _  
                " group by a.GameTitleIDX,a.GameTitleName,a.titleCode,b.hostTitle,a.titleGrade,titlegubun  "

            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
            rscnt =  rs.RecordCount
            ReDim JSONarr(rscnt-1)'
        
	            i = 0
                If Not rs.eof Then
	            Do Until rs.eof
	            Set rsarr = jsObject() 
		            rsarr("GameTitleIDX") =rs("GameTitleIDX")
		            rsarr("GameTitleName") =  trim(rs("GameTitleName") )
		            rsarr("titleCode") = rs("titleCode")
		            rsarr("titleCodeName") = rs("hostTitle")'findcode(titleCodearrRS,rs("titleCode") ,rs("titleGrade")) 
		            rsarr("titleGrade") = rs("titleGrade") 
		            rsarr("titleGradeName") = findGrade(rs("titleGrade")) 
		            rsarr("titlegubun") = rs("titlegubun")
                     
		            Set JSONarr(i) = rsarr
	            i = i + 1
	            rs.movenext
	            Loop
                end if 
                         
    elseif gubun ="player" then
          SQL=" select PlayerIDX,UserName,right(UserPhone,4)UserPhone,belongBoo,Team,TeamNm,Team2,Team2Nm " & _ 
              "   from tblPlayer " & _ 
              "   where SportsGb ='tennis' " & _ 
              "   and DelYN='N' " & _ 
              "   and UserName like '%"&varStr&"%'" 

           ' Response.Write SQL

            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
            rscnt =  rs.RecordCount
            ReDim JSONarr(rscnt-1)'
        
	            i = 0
                If Not rs.eof Then
	            Do Until rs.eof
	            Set rsarr = jsObject() 
		            rsarr("PlayerIDX") =rs("PlayerIDX")
		            rsarr("UserName") =  trim(rs("UserName") )
		            rsarr("UserPhone") = rs("UserPhone")
		            rsarr("belongBoo") = rs("belongBoo") 
		            rsarr("Team") = rs("Team") 
		            rsarr("TeamNm") = rs("TeamNm") 
		            rsarr("Team2") = rs("Team2") 
		            rsarr("Team2Nm") = rs("Team2Nm")  
                     
		            Set JSONarr(i) = rsarr
	            i = i + 1
	            rs.movenext
	            Loop
                end if 
                         


    end if 
     
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)
db.Dispose
Set db = Nothing
%>