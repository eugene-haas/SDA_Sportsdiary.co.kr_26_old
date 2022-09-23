<%
'#############################################

'예선 코트 배정 정보 변경

'#############################################
 'request
	idx = oJSONoutput.IDX 'resultIDX  결과 인덱스 
	tidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	gubun = oJSONoutput.GN '0예선

	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)


	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	courtno = oJSONoutput.setCourtNo 

	Set db = new clsDBHelper

	'본선 1라운드가 완료 중이면 순위 변경이 안된다.
	SQL = "select Count(*) as Cnt from sd_TennisMember "
	SQL = SQL & " where gubun in ( 3, 4) and GameTitleIDX = "&tidx&" and gamekey3 =  " & levelkey & " and Round >= 1 and DelYN = 'N'"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	IsReady = rs(0)
    
 
    SQL=    " Select resultIDX , gameMemberIDX" & _ 
            " from sd_TennisResult   a " & _ 
            " 	inner join sd_TennisMember b " & _ 
            " 		on (a.gameMemberIDX1 = b.gameMemberIDX or a.gameMemberIDX2 = b.gameMemberIDX) " & _ 
            " 		and a.GameTitleIDX = '"&tidx&"' " & _ 
            " 		and a.Level = '"&levelkey&"' " & _ 
            " 		and a.tryoutgroupno=b.tryoutgroupno " & _ 
            " 		and a.tryoutgroupno='"&jono&"' " & _ 
            " 		and isnull(b.Round,0)='"&gubun&"' " & _ 
            " 		and a.delYN='N' " & _ 
            " 		and b.delYN='N' " & _ 
            " group by resultIDX,gameMemberIDX "

     Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	 If Not rs.EOF Then
		 useRS = rs.GetRows()
	 End If


    resultIDXwhereIN=""
    gameMemberIDXwhereIN=""
    If IsArray(useRS) Then
        For uC = LBound(useRS, 2) To UBound(useRS, 2) 
            if resultIDXwhereIN="" then 
                resultIDXwhereIN =  useRS(0, uC)
                gameMemberIDXwhereIN =  useRS(1, uC)
            else
                resultIDXwhereIN = resultIDXwhereIN &" , " & useRS(0, uC)
                gameMemberIDXwhereIN = gameMemberIDXwhereIN &" , " & useRS(1, uC)
            end if 
        next
    end if 


    '업데이트
    updateSQL=""
    if courtno = 0 then 
        updateSQL= "update  sd_TennisResult set courtno ='"&courtno&"' ,stateno='1'  where  resultIDX in ("&resultIDXwhereIN&") and isnull(winResult,'')='' "
    elseif courtno=999 then
        updateSQL=""
    else
        updateSQL= "update  sd_TennisResult set courtno ='"&courtno&"' ,stateno='2'  where  resultIDX in ("&resultIDXwhereIN&") and isnull(winResult,'')='' "
    end if 

    
	IF Cint(IsReady) > 0 Then
		'타입 석어서 보내기
		Call oJSONoutput.Set("result", 5 )
    else
	    Call oJSONoutput.Set("result", 0 )

        if updateSQL<>"" then 
	        Call oJSONoutput.Set("result", 999 )
	        'Call oJSONoutput.Set("SqlQuery", updateSQL & "   ; " &SQL& " ;")

            
             if resultIDXwhereIN <>"" then 
                 Call db.execSQLRs(updateSQL , null, ConStr)	 
                 updateSQL=""
                 updateSQL= "update  sd_TennisMember set courtno ='"&courtno&"'   where  gameMemberIDX in ("&gameMemberIDXwhereIN&") "
                 if gameMemberIDXwhereIN <> "" then 
                    Call db.execSQLRs(updateSQL , null, ConStr)	
                 end if 
             end if 
        end if 
	End IF


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
    
	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>